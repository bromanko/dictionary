import gleam/string_tree.{type StringTree}
import lustre/attribute.{attribute}
import lustre/element.{type Element, text}
import lustre/element/html.{
  body, div, h1, head, html, link, main, meta, p, title,
}

pub fn home() -> StringTree {
  div([], [
    h1([], [text("bromanko's dictionary")]),
    p([], [text("Welcome to my dictionary! It's great to have you")]),
  ])
  |> layout
}

pub fn layout(content: Element(Nil)) -> StringTree {
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
