.PHONY: help
help:
	@echo "Usage: make [target]"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


SRC_CSS = src/css/app.css
DEST_CSS = priv/static/app.css

.PHONY: clean
	@rm -f $(DEST_CSS)

.PHONY: run
run: css ## Run the server
	watchexec \
    	--restart \
    	--clear \
    	--exts gleam \
    	--watch src/ \
        --shell zsh \
        --stop-signal SIGKILL \
        -- gleam run server

css: $(DEST_CSS) ## Generate CSS

$(DEST_CSS): $(SRC_CSS) $(wildcard src/dictionary/web/*.gleam)
	gleam run -m tailwind/run

.PHONY: migration
migration: ## Create a new migration
	@read -p "Enter migration description: " description; \
	gleam run -m feather -- new "$$description"

.PHONY: schema
schema: ## Generate a schema
	gleam run -m feather -- schema

.PHONY: migrate
migrate: ## Run migrations
	@read -p "Enter path to database file: " db_path; \
	gleam run migrate "$$db_path"
