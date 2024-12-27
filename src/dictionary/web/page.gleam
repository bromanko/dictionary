import dictionary/data_store
import dictionary/error
import dictionary/models
import dictionary/web.{type Context}
import dictionary/web/layout
import gleam/list
import gleam/result
import gleam/string_tree.{type StringTree}
import lustre/element.{type Element, text}
import lustre/element/html.{div, h1, h2, li, p, ul}

fn word_list(words: List(models.Word)) -> Element(Nil) {
  div([], [
    h2([], [text("Words")]),
    ul(
      [],
      words
        |> list.map(fn(word) { li([], [text(word.word)]) }),
    ),
  ])
}

pub fn home(ctx: Context) -> Result(StringTree, error.Error) {
  use conn <- data_store.get_conn(ctx.cfg.database)
  data_store.get_words(conn)
  |> result.map(fn(words) {
    div([], [
      h1([], [text("bromanko's dictionary")]),
      p([], [text("Welcome to my dictionary! It's great to have you")]),
      word_list(words),
    ])
    |> layout.default
  })
}
