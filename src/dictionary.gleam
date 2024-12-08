import argv
import envoy
import gleam/io
import gleam/result

pub fn main() -> Nil {
  case argv.load().arguments {
    ["get", name] -> get(name)
    _ -> io.println("Usage: dictionary get <name>")
  }
}

fn get(name: String) -> Nil {
  let value = envoy.get(name) |> result.unwrap("")
  io.println(format_pair(name, value))
}

fn format_pair(key: String, value: String) -> String {
  key <> ": " <> value
}
