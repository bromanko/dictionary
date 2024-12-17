import gleam/int
import gleam/option.{type Option}
import gleam/result
import wisp

pub type Config {
  Config(server: ServerConfig)
}

pub type ServerConfig {
  ServerConfig(port: Int, static_directory: String)
}

pub type ConfigError {
  PortParseError
}

fn make_static_directory() -> String {
  let assert Ok(priv) = wisp.priv_directory("dictionary")
  priv <> "/static"
}

pub fn parse_config(port port: Option(String)) -> Result(Config, ConfigError) {
  port
  |> option.unwrap("3000")
  |> int.parse
  |> result.map_error(fn(_) { PortParseError })
  |> result.map(fn(p) {
    Config(server: ServerConfig(
      port: p,
      static_directory: make_static_directory(),
    ))
  })
}
