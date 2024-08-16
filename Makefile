all: build lint test
.PHONY: all

build: backup
.PHONY: build

lint: backup
	shellcheck ./backup src/*.sh src/lib/*.sh tests/*.sh tests/*.bats
.PHONY: lint

ci:
	rm -f backup
	docker build --tag backup-ci .
	docker run --name backup-ci-temp backup-ci make build lint
	docker cp backup-ci-temp:/app/backup .
	docker cp backup-ci-temp:/app/src/bashly.yml ./src/
	docker container rm --force backup-ci-temp
.PHONY: ci

test: backup compose_up
	bats --print-output-on-failure ./tests
.PHONY: test

install: backup
	cp backup ~/.local/bin
.PHONY: install

install_global: backup
	sudo install backup /usr/local/bin/
.PHONY: install_global

compose_up:
	docker compose up --wait
.PHONY: compose_up

compose_down:
	docker compose down
.PHONY: compose_down

backup: settings.yml src/bashly.yml src/*.sh src/lib/*.sh .tool-versions
	bashly generate
	sed --in-place 's|\[tag:|[ref:|g' backup

src/bashly.yml: src/bashly.cue
	cue fmt src/bashly.cue
	cue export --out yaml src/bashly.cue > src/bashly.yml
