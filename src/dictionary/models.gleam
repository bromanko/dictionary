import gleam/dynamic.{type Dynamic}

pub type Word {
  Word(id: Int, word: String)
}

pub fn decode_word() -> fn(Dynamic) -> Result(Word, List(dynamic.DecodeError)) {
  dynamic.decode2(
    Word,
    dynamic.element(0, dynamic.int),
    dynamic.element(1, dynamic.string),
  )
}
