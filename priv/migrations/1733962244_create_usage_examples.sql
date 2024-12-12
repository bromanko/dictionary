-- Create Usage Examples
CREATE TABLE usage_examples (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    definition_id INTEGER NOT NULL,
    example TEXT NOT NULL,
    FOREIGN KEY (definition_id) REFERENCES definitions (id)
)
