import dictionary/error
import dictionary/web.{type Context}
import dictionary/web/page
import gleam/http/request
import gleam/result
import wisp.{type Request, type Response}

pub fn handle_request(
  request: Request,
  make_context: fn() -> Context,
) -> Response {
  let context = make_context()
  use request <- middleware(request, context)

  case request.path_segments(request) {
    [] -> home(request, context)
    _ -> wisp.redirect(to: "/")
  }
}

pub fn middleware(
  req: Request,
  ctx: Context,
  handle_request: fn(Request) -> Response,
) -> Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  use <- wisp.serve_static(
    req,
    under: "/static",
    from: ctx.cfg.server.static_directory,
  )

  handle_request(req)
}

fn home(_request: Request, ctx: Context) -> Response {
  page.home(ctx)
  |> result.map(wisp.html_response(_, 200))
  |> result.map_error(error.debug_log)
  |> result.unwrap(wisp.internal_server_error())
}
