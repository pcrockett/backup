#!/usr/bin/env bash
set -euo pipefail

MAIN_BRANCH=main
ORIGIN_NAME=origin

panic() {
  echo "FATAL: $*" >&2
  exit 1
}

ensure_working_dir_clean() {
  test "$(git status --porcelain)" = "" || panic "Working copy is dirty. Commit or stash first."
}

init() {
  if [ "${GITHUB_TOKEN:-}" = "" ]; then
    # if we're running in CI, we may have this via the GH_TOKEN env variable
    export GITHUB_TOKEN="${GH_TOKEN:-}"
  fi

  git fetch --tags "${ORIGIN_NAME}"
  test "$(git branch --show-current)" = "${MAIN_BRANCH}" || panic "Must be on ${MAIN_BRANCH}."
  ensure_working_dir_clean
  test \
    "$(git rev-parse "${MAIN_BRANCH}")" = "$(git rev-parse "${ORIGIN_NAME}/${MAIN_BRANCH}")" ||
    panic "${MAIN_BRANCH} is not up-to-date with ${ORIGIN_NAME}."
}

main() {
  init
  make ci
  BACKUP_VERSION="$(./backup --version)"
  TAG_NAME="v${BACKUP_VERSION}"

  # ensure backup script version agrees with conventional commits
  test "${TAG_NAME}" = "$(git cliff --bumped-version)" ||
    panic "\`./backup --version\` reports ${TAG_NAME}, should be $(git cliff --bumped-version)."

  # ensure CHANGELOG.md has all correct entries
  git cliff --tag "${TAG_NAME}" >CHANGELOG.md # shouldn't produce any new changes in CHANGELOG
  ensure_working_dir_clean

  git tag "${TAG_NAME}"
  git push "${ORIGIN_NAME}" "${TAG_NAME}"
  gh release create "${TAG_NAME}" \
    --latest \
    --generate-notes \
    --fail-on-no-commits \
    --verify-tag
  gh release upload "${TAG_NAME}" ./backup
  exit $?
}

main
