import argv
import dictionary/router
import dictionary/web
import envoy
import feather
import feather/migrate
import gleam/erlang
import gleam/erlang/process
import gleam/io
import gleam/option
import gleam/result
import mist
import wisp
import wisp/wisp_mist

const usage = "Usage:
  gleam run migrate <db_path>
  gleam run server
"

pub fn main() -> Nil {
  case argv.load().arguments {
    ["migrate", db_path] -> migrate(db_path)
    ["server"] -> server()
    _ -> io.println(usage)
  }
}

fn migrate(db_path: String) -> Nil {
  io.println("Migrating database... ")
  let assert Ok(priv_dir) = erlang.priv_directory("dictionary")
  let assert Ok(migrations) =
    { priv_dir <> "/migrations" } |> migrate.get_migrations
  let assert Ok(_) =
    feather.Config(..feather.default_config(), file: db_path)
    |> feather.connect
    |> result.map(fn(conn) { migrate.migrate(migrations, on: conn) })
  io.println("Done")
}

fn server() {
  wisp.configure_logger()

  let assert Ok(server_config) =
    web.parse_server_config(
      port: envoy.get("DICTIONARY_PORT") |> option.from_result,
    )

  // We don't use any signing in this application so the secret key can be
  // generated anew each time
  let secret_key_base = wisp.random_string(64)

  // Initialisation that is run per-request
  let make_context = fn() {
    web.Context(static_directory: server_config.static_directory)
  }

  // Start the web server
  let assert Ok(_) =
    router.handle_request(_, make_context)
    |> wisp_mist.handler(secret_key_base)
    |> mist.new
    |> mist.port(server_config.port)
    |> mist.start_http

  // Put the main process to sleep while the web server handles traffic
  process.sleep_forever()
}
