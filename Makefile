all: build lint # test
.PHONY: all

build: backup
.PHONY: build

lint: backup
	shellcheck ./backup src/*.sh # tests/*.sh tests/*.bats
.PHONY: lint

# test: backup
# 	bats tests
# .PHONY: test

install: backup
	cp backup ~/.local/bin
.PHONY: install

backup: settings.yml src/bashly.yml src/*.sh src/lib/*.sh
	bashly generate

src/bashly.yml: src/bashly.cue
	cue export --out yaml src/bashly.cue > src/bashly.yml
