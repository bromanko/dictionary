import gleam/string_tree.{type StringTree}
import lustre/attribute.{attribute, class}
import lustre/element.{type Element, text}
import lustre/element/html.{
  body, h1, head, header, html, link, main, meta, title,
}

pub fn default(content: Element(Nil)) -> StringTree {
  html([attribute("lang", "en")], [
    head([], [
      meta([attribute("charset", "utf-8")]),
      meta([
        attribute.name("viewport"),
        attribute("content", "width=device-width, initial-scale=1"),
      ]),
      title([], "bromanko's dictionary"),
      link([attribute.rel("stylesheet"), attribute.href("/static/app.css")]),
    ]),
    body([class("bg-gray-100 font-sans")], [
      header([class("bg-white shadow p-4")], [
        h1([class("text-2xl font-bold text-center text-gray-800")], [
          text("bromanko's dictionary"),
        ]),
      ]),
      main([class("max-w-3xl mx-auto mt-8 p-4 bg-white shadow rounded")], [
        content,
      ]),
    ]),
  ])
  |> element.to_string_builder
  |> string_tree.prepend("<!DOCTYPE html>")
}
