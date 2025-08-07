ALL_SCRIPTS = ./backup src/*.sh src/lib/*.sh tests/*.sh tests/*.bats bin/*.sh

all: ci
.PHONY: all

build: backup
.PHONY: build

lint: backup
	shellcheck $(ALL_SCRIPTS)
.PHONY: lint

format: backup
	shfmt --indent 2 --case-indent --write $(ALL_SCRIPTS)
.PHONY: format

test: backup minio-start
	bats --verbose-run --print-output-on-failure ./tests
.PHONY: test

ci: devenv
	rm -f backup release-please-config.json
	COPY_ARTIFACTS=1 ./bin/devenv-run.sh make build format lint test release-please-config.json
.PHONY: ci

devenv:
	docker build \
		--build-arg "GITHUB_TOKEN=${GITHUB_TOKEN}" \
		--tag backup-ci .
.PHONY: devenv

devenv-build: devenv
	rm -f backup
	COPY_ARTIFACTS=1 ./bin/devenv-run.sh make build
.PHONY: devenv-build

devenv-test: devenv
	./bin/devenv-run.sh make test
.PHONY: devenv-test

devenv-shell: devenv
	DOCKER_ARGS="--interactive --tty" ./bin/devenv-run.sh /bin/bash
.PHONY: devenv-shell

pull:
	grep --only-matching --perl-regexp '(?<=FROM )\S*/\S*(?= AS)' Dockerfile \
		| xargs -L 1 docker pull
.PHONY: pull

install: backup
	sudo install backup /usr/local/bin/
.PHONY: install

minio-start:
	./tests/minio-start.sh
.PHONY: minio-start

minio-stop:
	./tests/minio-stop.sh
.PHONY: minio-stop

release:
	./bin/release.sh
.PHONY: release

changelog:
	git cliff --tag "$(shell git cliff --bumped-version)" > CHANGELOG.md
.PHONY: changelog

backup: settings.yml src/bashly.yml src/*.sh src/lib/*.sh .tool-versions
	bashly generate
	sed --in-place 's|\[tag:|[ref:|g' backup

src/bashly.yml: src/bashly.cue
	cue fmt src/bashly.cue
	cue export --out yaml src/bashly.cue > src/bashly.yml

release-please-config.json: release-please-config.cue
	cue fmt release-please-config.cue
	cue export --out json release-please-config.cue > release-please-config.json
