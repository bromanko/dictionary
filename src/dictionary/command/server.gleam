import clip
import clip/help
import dictionary/config
import dictionary/router
import dictionary/web
import envoy
import gleam/erlang/process
import gleam/io
import gleam/option
import mist
import wisp
import wisp/wisp_mist

fn parse_config() -> Result(config.Config, config.ConfigError) {
  config.parse_config(
    port: envoy.get("DICTIONARY_PORT") |> option.from_result,
    db_path: envoy.get("DICTIONARY_DB_PATH") |> option.from_result,
    log_queries: envoy.get("DICTIONARY_LOG_QUERIES") |> option.from_result,
  )
  |> io.debug
}

pub fn command() -> clip.Command(Nil) {
  // This is a workaround for the fact that clip.command wants to have
  // an option or flag provided to it.
  // Rather, we use apply directly and pass a dummy command to it.
  clip.apply(
    clip.command(fn(_) {
      wisp.configure_logger()

      let assert Ok(config) = parse_config()

      // We don't use any signing in this application so the secret key can be
      // generated anew each time
      let secret_key_base = wisp.random_string(64)

      // Initialisation that is run per-request
      let make_context = fn() { web.Context(cfg: config) }

      // Start the web server
      let assert Ok(_) =
        router.handle_request(_, make_context)
        |> wisp_mist.handler(secret_key_base)
        |> mist.new
        |> mist.port(config.server.port)
        |> mist.start_http

      // Put the main process to sleep while the web server handles traffic
      process.sleep_forever()
    }),
    clip.return(Nil),
  )
  |> clip.help(help.simple("server", "Start the web server"))
}
