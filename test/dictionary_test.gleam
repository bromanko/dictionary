import dictionary/internal
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn format_pair_test() {
  let key = "key"
  let value = "value"
  internal.format_pair(key, value) |> should.equal("key: value")
}
