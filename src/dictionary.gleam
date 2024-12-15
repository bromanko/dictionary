import argv
import clip
import clip/help
import dictionary/command/migrate
import dictionary/command/server
import gleam/io

fn command() {
  clip.subcommands([
    #("migrate", migrate.command()),
    #("server", server.command()),
  ])
}

pub fn main() -> Nil {
  let result =
    command()
    |> clip.help(help.simple("dictionary", "The dictionary command line tool"))
    |> clip.run(argv.load().arguments)

  case result {
    Error(e) -> io.println_error(e)
    _ -> Nil
  }
}
