CREATE TABLE storch_migrations (id integer, applied integer);

CREATE TABLE words (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    word TEXT NOT NULL,
    language TEXT NOT NULL
);

CREATE TABLE sqlite_sequence(name,seq);

CREATE TABLE definitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    word_id INTEGER NOT NULL,
    part_of_speech TEXT NOT NULL,
    definition TEXT NOT NULL,
    FOREIGN KEY (word_id) REFERENCES words (id)
);

CREATE TABLE usage_examples (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    definition_id INTEGER NOT NULL,
    example TEXT NOT NULL,
    FOREIGN KEY (definition_id) REFERENCES definitions (id)
);

CREATE TABLE synonyms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    word_id INTEGER NOT NULL,
    synonym TEXT NOT NULL,
    FOREIGN KEY (word_id) REFERENCES words (id)
);

CREATE TABLE antonyms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    word_id INTEGER NOT NULL,
    antonym TEXT NOT NULL,
    FOREIGN KEY (word_id) REFERENCES words (id)
);

