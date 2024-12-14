.PHONY: run migration schema migrate

run:
	watchexec \
    	--restart \
    	--clear \
    	--exts gleam \
    	--watch src/ \
        --shell zsh \
        --stop-signal SIGKILL \
        -- gleam run server

migration:
	@read -p "Enter migration description: " description; \
	gleam run -m feather -- new "$$description"

schema:
	gleam run -m feather -- schema

migrate:
	@read -p "Enter path to database file: " db_path; \
	gleam run migrate "$$db_path"
