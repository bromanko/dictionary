import cake/adapter/sqlite
import cake/join as j
import cake/select as s
import cake/where as w
import dictionary/config.{type DatabaseConfig}
import dictionary/error
import dictionary/models
import gleam/result
import sqlight.{type Connection}

pub fn get_conn(config: DatabaseConfig, callback: fn(Connection) -> a) -> a {
  sqlite.with_connection(config.path, callback)
}

fn get_words_query() {
  s.new()
  |> s.selects([s.col("words.id"), s.col("words.word")])
  |> s.from_table("words")
  |> s.join(j.inner(
    with: j.table("definitions"),
    on: w.col("words.id") |> w.eq(w.col("definitions.word_id")),
    alias: "Get all words",
  ))
  |> s.order_by_asc("words.word")
  |> s.to_query()
}

pub fn get_words(conn: Connection) -> Result(List(models.Word), error.Error) {
  get_words_query()
  |> sqlite.run_read_query(models.decode_word(), conn)
  |> result.map_error(error.DataStoreError)
}
