import clip
import clip/flag
import clip/help
import clip/opt
import dictionary/router
import dictionary/web
import envoy
import gleam/erlang/process
import gleam/io
import gleam/option
import mist
import wisp
import wisp/wisp_mist

pub fn command() -> clip.Command(Nil) {
  // This is a workaround for the fact that clip.command wants to have
  // an option or flag provided to it.
  // Rather, we use apply directly and pass a dummy command to it.
  clip.apply(
    clip.command(fn(_) {
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
    }),
    clip.return(Nil),
  )
  |> clip.help(help.simple("server", "Start the web server"))
}
