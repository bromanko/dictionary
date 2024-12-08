import argv
import dictionary/router
import dictionary/web
import gleam/erlang/process
import gleam/io
import mist
import wisp
import wisp/wisp_mist

const usage = "Usage:
  gleam run server
"

pub fn main() -> Nil {
  case argv.load().arguments {
    ["server"] -> server()
    _ -> io.println(usage)
  }
}

fn server() {
  wisp.configure_logger()

  let assert Ok(priv) = wisp.priv_directory("dictionary")
  let static_directory = priv <> "/static"

  // We don't use any signing in this application so the secret key can be
  // generated anew each time
  let secret_key_base = wisp.random_string(64)

  // Initialisation that is run per-request
  let make_context = fn() { web.Context(static_directory: static_directory) }

  // Start the web server
  let assert Ok(_) =
    router.handle_request(_, make_context)
    |> wisp_mist.handler(secret_key_base)
    |> mist.new
    |> mist.port(3000)
    |> mist.start_http

  // Put the main process to sleep while the web server handles traffic
  process.sleep_forever()
}
