import clip
import clip/help
import clip/opt
import feather
import feather/migrate
import gleam/erlang
import gleam/io
import gleam/result

pub fn command() -> clip.Command(Nil) {
  clip.command({
    use db_path <- clip.parameter

    io.println("Migrating database... ")

    let assert Ok(priv_dir) = erlang.priv_directory("dictionary")
    let assert Ok(migrations) =
      { priv_dir <> "/migrations" } |> migrate.get_migrations
    let assert Ok(_) =
      feather.Config(..feather.default_config(), file: db_path)
      |> feather.connect
      |> result.map(fn(conn) { migrate.migrate(migrations, on: conn) })

    io.println("Done")
  })
  |> clip.opt(opt.new("db_path") |> opt.help("Path to database file"))
  |> clip.help(help.simple("migrate", "Run database migrations"))
}
