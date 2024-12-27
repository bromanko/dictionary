import lustre/attribute.{attribute, class, name, type_}
import lustre/element
import lustre/element/html.{input}

pub fn text(
  id id: String,
  label label: String,
  placeholder placeholder: String,
) -> List(element.Element(Nil)) {
  [
    html.label(
      [class("block text-gray-700 text-sm font-medium"), attribute.for(id)],
      [element.text(label)],
    ),
    input([
      type_("text"),
      attribute.id(id),
      name(id),
      attribute.placeholder(placeholder),
      class(
        "mt-2 w-full p-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:outline-none",
      ),
    ]),
  ]
}
