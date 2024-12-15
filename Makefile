.PHONY: help
help:
	@echo "Usage: make [target]"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: run
run: ## Run the server
	watchexec \
    	--restart \
    	--clear \
    	--exts gleam \
    	--watch src/ \
        --shell zsh \
        --stop-signal SIGKILL \
        -- gleam run server

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
