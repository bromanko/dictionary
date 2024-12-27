import dictionary/data_store
import dictionary/error
import dictionary/models
import dictionary/web.{type Context}
import dictionary/web/input
import dictionary/web/layout
import gleam/list
import gleam/result
import gleam/string_tree.{type StringTree}
import lustre/attribute.{class, id}
import lustre/element.{type Element, text}
import lustre/element/html.{div, h2, li, ul}

fn word_list(words: List(models.Word)) -> Element(Nil) {
  div([], [
    h2(
      [
        class(
          "text-xl font-semibold text-gray-800 border-b border-gray-300 pb-1 mb-4",
        ),
      ],
      [text("A")],
    ),
    ul(
      [class("space-y-6")],
      words
        |> list.map(fn(word) { li([], [text(word.word)]) }),
    ),
  ])
}

pub fn home(ctx: Context) -> Result(StringTree, error.Error) {
  use conn <- data_store.get_conn(ctx.cfg.database)
  data_store.get_words(conn)
  |> result.map(fn(words) {
    div(
      [class("mb-6")],
      list.append(
        input.text("search", "Search for a word:", "Enter a word..."),
        [div([id("word-list"), class("mt-6")], [word_list(words)])],
      ),
    )
    |> layout.default
  })
}
