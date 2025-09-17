all: ci
.PHONY: all

build: backup
.PHONY: build

lint: backup
	pre-commit run --all-files --color always
.PHONY: lint

tagref:
	tagref
.PHONY: tagref

format: backup
	pre-commit run shfmt --all-files
	cue fmt ./src/bashly.cue
.PHONY: format

test: backup minio-start
	bats --verbose-run --print-output-on-failure ./tests
.PHONY: test

ci: devenv
	rm -f backup
	COPY_ARTIFACTS=1 ./bin/devenv-run.sh make build format lint tagref test
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

prepare-release:
	./bin/prepare-release.sh
.PHONY: prepare-release

release-pr:
	gh pr create --title "chore(release): prepare $(shell git cliff --bumped-version)" --body "Version bump and changelog update"
.PHONY: release-pr

release:
	gh workflow run release.yml
.PHONY: release

backup: settings.yml src/bashly.yml src/*.sh src/lib/*.sh .tool-versions
	bashly generate
	sed --in-place 's|\[tag:|[ref:|g' backup

src/bashly.yml: src/bashly.cue
	cue fmt src/bashly.cue
	cue export --out yaml src/bashly.cue > src/bashly.yml
