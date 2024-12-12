-- Create Definitions
CREATE TABLE definitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    word_id INTEGER NOT NULL,
    part_of_speech TEXT NOT NULL,
    definition TEXT NOT NULL,
    FOREIGN KEY (word_id) REFERENCES words (id)
)
