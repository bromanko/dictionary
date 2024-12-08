import gleam/int
import gleam/option.{type Option}
import gleam/result
import wisp

pub type ServerConfig {
  ServerConfig(port: Int, static_directory: String)
}

pub type ServerConfigError {
  PortParseError
}

pub fn parse_server_config(
  port port: Option(String),
) -> Result(ServerConfig, ServerConfigError) {
  port
  |> option.unwrap("3000")
  |> int.parse
  |> result.map_error(fn(_) { PortParseError })
  |> result.map(fn(p) {
    ServerConfig(port: p, static_directory: make_static_directory())
  })
}

fn make_static_directory() -> String {
  let assert Ok(priv) = wisp.priv_directory("dictionary")
  priv <> "/static"
}

pub type Config {
  Config(server_config: ServerConfig)
}

pub type Context {
  Context(static_directory: String)
}
