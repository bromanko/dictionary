import gleam/int
import gleam/option.{type Option}
import gleam/result

pub type ServerConfig {
  ServerConfig(port: Int)
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
  |> result.map(ServerConfig)
}

pub type Config {
  Config(server_config: ServerConfig)
}

pub type Context {
  Context(static_directory: String)
}
