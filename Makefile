.PHONY: run

run:
	watchexec \
    	--restart \
    	--clear \
    	--exts gleam \
    	--watch src/ \
        --shell zsh \
        --stop-signal SIGKILL \
        -- gleam run server
