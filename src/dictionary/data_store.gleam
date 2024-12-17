import cake/adapter/sqlite
import cake/join as j
import cake/select as s
import cake/where as w
import dictionary/config.{type DatabaseConfig}
import dictionary/error
import dictionary/models
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
  |> sqlite.run_read_query(models.decode_word(), conn)
  |> sqlite.run_read_query(models.decode_word(), conn.conn)
  |> result.map_error(error.DataStoreError)
}
