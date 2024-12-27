import cake.{type ReadQuery}
import cake/adapter/sqlite
import cake/join as j
import cake/param.{
  type Param, BoolParam, FloatParam, IntParam, NullParam, StringParam,
}
import cake/select as s
import cake/where as w
import dictionary/config.{type DatabaseConfig}
import dictionary/error
import dictionary/models
import gleam/dynamic.{type DecodeError, type Dynamic}
import gleam/io
import gleam/list
import gleam/result
import sqlight

pub type LogQueryOption {
  Disabled
  Logger(fn(String) -> String)
}

pub type Connection {
  Connection(conn: sqlight.Connection, log_query: LogQueryOption)
}

pub fn get_conn(config: DatabaseConfig, callback: fn(Connection) -> a) -> a {
  let log_query = case config.log_queries {
    False -> Disabled
    True -> Logger(io.debug)
  }
  use conn <- sqlite.with_connection(config.path)
  callback(Connection(conn, log_query))
}

fn cake_param_to_client_param(param param: Param) -> sqlight.Value {
  case param {
    BoolParam(param) -> sqlight.bool(param)
    FloatParam(param) -> sqlight.float(param)
    IntParam(param) -> sqlight.int(param)
    StringParam(param) -> sqlight.text(param)
    NullParam -> sqlight.null()
  }
}

fn run_read_query(
  query query: ReadQuery,
  decoder decoder: fn(Dynamic) -> Result(a, List(DecodeError)),
  db_connection db_connection: Connection,
) -> Result(List(a), sqlight.Error) {
  let prepared_statement = query |> sqlite.read_query_to_prepared_statement
  let sql_string = prepared_statement |> cake.get_sql

  case db_connection.log_query {
    Disabled -> Nil
    Logger(logger) -> logger(sql_string) |> fn(_) { Nil }
  }

  let db_params =
    prepared_statement
    |> cake.get_params
    |> list.map(with: cake_param_to_client_param)

  sql_string
  |> sqlight.query(on: db_connection.conn, with: db_params, expecting: decoder)
}

fn get_words_query() {
  s.new()
  |> s.selects([s.col("words.id"), s.col("words.word")])
  |> s.from_table("words")
  |> s.join(j.inner(
    with: j.table("definitions"),
    on: w.col("words.id") |> w.eq(w.col("definitions.word_id")),
    alias: "definitions",
  ))
  |> s.order_by_asc("words.word")
  |> s.to_query()
}

pub fn get_words(conn: Connection) -> Result(List(models.Word), error.Error) {
  get_words_query()
  |> run_read_query(models.decode_word(), conn)
  |> result.map_error(error.DataStoreError)
}
