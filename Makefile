all: build lint test
.PHONY: all

build: backup
.PHONY: build

lint: backup
	shellcheck ./backup src/*.sh src/lib/*.sh tests/*.sh tests/*.bats
.PHONY: lint

test: backup compose_up
	bats --print-output-on-failure ./tests
.PHONY: test

install: backup
	cp backup ~/.local/bin
.PHONY: install

install_global: backup
	sudo install backup /usr/local/bin/
.PHONY: install_global

compose_up: tests/docker-compose.yml
	docker compose --file tests/docker-compose.yml up --wait
.PHONY: compose_up

compose_down: tests/docker-compose.yml
	docker compose --file tests/docker-compose.yml down
.PHONY: compose_down

backup: settings.yml src/bashly.yml src/*.sh src/lib/*.sh .tool-versions
	bashly generate
	sed --in-place 's|\[tag:|[ref:|g' backup

src/bashly.yml: src/bashly.cue
	cue fmt src/bashly.cue
	cue export --out yaml src/bashly.cue > src/bashly.yml

tests/docker-compose.yml: tests/docker-compose.cue
	cue export --out yaml tests/docker-compose.cue > tests/docker-compose.yml
