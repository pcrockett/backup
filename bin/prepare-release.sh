#!/usr/bin/env bash
set -Eeuo pipefail

# does several things:
#
# 1. create release branch
# 2. version bump
# 3. update changelog according to conventional commits
# 4. shows git diff
#
# dependencies:
#
# * git
# * git-cliff
# * GNU coreutils
#

init() {
  MAIN_BRANCH=main
  BASHLY_CONFIG="./src/bashly.yml"
  BUMPED_TAG="$(git cliff --bumped-version)"
  # strip the leading `v` from the tag name:
  BUMPED_VERSION="$(echo "${BUMPED_TAG}" | cut --characters 2-)"
}

panic() {
  echo "FATAL: $*" >&2
  exit 1
}

create_branch() {
  test "$(git branch --show-current)" = "${MAIN_BRANCH}" || panic "Must be on ${MAIN_BRANCH}."
  git sw -c "release/${BUMPED_TAG}"
}

update_version_setting() {
  new_version="${1}"
  version_pattern='^version:[[:space:]]*.*$'
  version_replacement="version: ${new_version}"
  sed --in-place --expression "s/${version_pattern}/${version_replacement}/" "${BASHLY_CONFIG}"
}

main() {
  init
  create_branch
  update_version_setting "${BUMPED_VERSION}"
  git cliff --tag "${BUMPED_TAG}" >CHANGELOG.md
  git diff
}

main
