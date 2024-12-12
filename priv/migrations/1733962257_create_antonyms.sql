-- Create Antonyms
CREATE TABLE antonyms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    word_id INTEGER NOT NULL,
    antonym TEXT NOT NULL,
    FOREIGN KEY (word_id) REFERENCES words (id)
)
