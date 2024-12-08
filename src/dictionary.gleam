import argv
import dictionary/internal
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
  |> internal.format_pair(name)
  |> io.println
}
