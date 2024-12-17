import sqlight

pub type Error {
  DataStoreError(sqlight.Error)
}
