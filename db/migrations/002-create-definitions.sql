CREATE TABLE definitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    word_id INTEGER NOT NULL,
    definition TEXT NOT NULL,
    FOREIGN KEY (word_id) REFERENCES words(id)
)
