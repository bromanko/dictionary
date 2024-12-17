import gleam/string
import sqlight
import wisp

pub type Error {
  DataStoreError(sqlight.Error)
}

fn log_sqlight_error(error: sqlight.Error) -> Nil {
  error
  |> string.inspect
  |> wisp.log_warning
}

fn log_error(error: Error) -> Nil {
  case error {
    DataStoreError(error) -> {
      wisp.log_warning("DataStore error")
      log_sqlight_error(error)
    }
  }
}

pub fn debug_log(error: Error) {
  log_error(error)
  error
}
