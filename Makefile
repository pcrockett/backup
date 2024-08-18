all: build lint test
.PHONY: all

build: backup release-please-config.json
.PHONY: build

lint: backup
	shellcheck ./backup src/*.sh src/lib/*.sh tests/*.sh tests/*.bats
.PHONY: lint

test: backup minio-start
	bats --print-output-on-failure ./tests
.PHONY: test

devenv:
	docker build --tag backup-ci .
.PHONY: devenv

ci: devenv
	rm -f backup
	docker container rm --force backup-ci-temp
	docker run \
		--env MINIO_ROOT_USER=adminuser \
		--env MINIO_ROOT_PASSWORD=adminpassword \
		--device /dev/fuse \
		--cap-add SYS_ADMIN \
		--security-opt apparmor:unconfined \
		--name backup-ci-temp \
		backup-ci make build lint test
	docker cp backup-ci-temp:/app/backup .
	docker cp backup-ci-temp:/app/release-please-config.json .
	docker container rm --force backup-ci-temp
.PHONY: ci

install: backup
	cp backup ~/.local/bin
.PHONY: install

install_global: backup
	sudo install backup /usr/local/bin/
.PHONY: install_global

minio-start:
	./tests/minio-start.sh
.PHONY: minio-start

minio-stop:
	./tests/minio-stop.sh
.PHONY: minio-stop

backup: settings.yml src/bashly.yml src/*.sh src/lib/*.sh .tool-versions
	bashly generate
	sed --in-place 's|\[tag:|[ref:|g' backup

src/bashly.yml: src/bashly.cue
	cue fmt src/bashly.cue
	cue export --out yaml src/bashly.cue > src/bashly.yml

release-please-config.json: release-please-config.cue
	cue fmt release-please-config.cue
	cue export --out json release-please-config.cue > release-please-config.json
