CREATE TABLE synonyms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    word_id INTEGER NOT NULL,
    synonyms TEXT NOT NULL,
    FOREIGN KEY (word_id) REFERENCES words(id)
)
