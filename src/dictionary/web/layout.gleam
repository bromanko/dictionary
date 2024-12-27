import gleam/string_tree.{type StringTree}
import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html.{body, head, html, link, main, meta, title}

pub fn default(content: Element(Nil)) -> StringTree {
  html([attribute("lang", "en")], [
    head([], [
      meta([attribute("charset", "utf-8")]),
      meta([
        attribute.name("viewport"),
        attribute("content", "width=device-width, initial-scale=1"),
      ]),
      title([], "bromanko's dictionary"),
      link([attribute.rel("stylesheet"), attribute.href("/static/styles.css")]),
    ]),
    body([], [main([], [content])]),
  ])
  |> element.to_string_builder
  |> string_tree.prepend("<!DOCTYPE html>")
}
