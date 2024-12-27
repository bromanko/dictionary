import dictionary/data_store
import dictionary/error
import dictionary/models
import dictionary/web.{type Context}
import dictionary/web/input
import dictionary/web/layout
import gleam/dict
import gleam/list
import gleam/order
import gleam/result
import gleam/string
import gleam/string_tree.{type StringTree}
import lustre/attribute.{class, id}
import lustre/element.{type Element, text}
import lustre/element/html.{div, h2, li, span, ul}

fn word_list(words: List(models.Word)) -> List(Element(Nil)) {
  let grouped_words =
    words
    |> list.group(fn(word) { string.slice(word.word, 0, 1) })

  let letters = grouped_words |> dict.keys |> list.sort(by: string.compare)

  letters
  |> list.map(fn(letter) {
    div([class("mt-6")], [
      h2(
        [
          class(
            "text-xl font-semibold text-gray-800 border-b border-gray-300 pb-1 mb-4",
          ),
        ],
        [text(string.uppercase(letter))],
      ),
      ul(
        [class("space-y-6")],
        dict.get(grouped_words, letter)
          |> result.unwrap([])
          |> list.map(fn(word) {
            li([], [
              div([class("text-lg font-bold text-gray-900")], [text(word.word)]),
              div([class("mt-1")], [
                div([class("text-med text-gray-500")], [text("noun or verb")]),
                div([class("mt-2 ml-4")], [
                  div([class("text-sm text-gray-900")], [
                    text("throw or hurl forcefully"),
                    span([class("italic text-gray-500 ml-2")], [
                      text("Used in a sentence"),
                    ]),
                  ]),
                ]),
              ]),
            ])
          }),
      ),
    ])
  })
}

pub fn home(ctx: Context) -> Result(StringTree, error.Error) {
  use conn <- data_store.get_conn(ctx.cfg.database)
  data_store.get_words(conn)
  |> result.map(fn(words) {
    div(
      [class("mb-6")],
      list.append(
        input.text("search", "Search for a word:", "Enter a word..."),
        [div([id("word-list"), class("")], word_list(words))],
      ),
    )
    |> layout.default
  })
}
