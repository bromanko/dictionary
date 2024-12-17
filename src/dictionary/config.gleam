import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/result
import wisp

pub type Config {
  Config(server: ServerConfig, database: DatabaseConfig)
}

pub type ServerConfig {
  ServerConfig(port: Int, static_directory: String)
}

pub type DatabaseConfig {
  DatabaseConfig(path: String)
}

pub type ConfigError {
  PortParseError
  DbPathParseError
}

fn make_static_directory() -> String {
  // todo: pass in the priv directory
  let assert Ok(priv) = wisp.priv_directory("dictionary")
  priv <> "/static"
}

fn parse_port(port: Option(String)) -> Result(Int, ConfigError) {
  port
  |> option.unwrap("3000")
  |> int.parse
  |> result.map_error(fn(_) { PortParseError })
}

fn parse_db_path(db_path: Option(String)) -> Result(String, ConfigError) {
  case db_path {
    None -> Error(DbPathParseError)
    Some(path) -> Ok(path)
  }
}

pub fn parse_config(
  port port: Option(String),
  db_path db_path: Option(String),
) -> Result(Config, ConfigError) {
  use port <- result.try(parse_port(port))
  use db_path <- result.try(parse_db_path(db_path))

  Config(
    server: ServerConfig(port: port, static_directory: make_static_directory()),
    database: DatabaseConfig(path: db_path),
  )
  |> Ok
}
