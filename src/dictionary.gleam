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
  name
  |> envoy.get
  |> result.unwrap("")
  |> format_pair(name)
  |> io.println
}

fn format_pair(key: String, value: String) -> String {
  key <> ": " <> value
}
