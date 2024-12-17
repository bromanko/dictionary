import gleam/dynamic.{type Dynamic}

pub type Word {
  Word(id: Int, word: String)
}

pub fn decode_word() -> fn(Dynamic) -> Result(Word, List(dynamic.DecodeError)) {
  dynamic.decode2(
    Word,
    dynamic.field("id", dynamic.int),
    dynamic.field("word", dynamic.string),
  )
}
