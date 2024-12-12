.PHONY: run migration schema

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
