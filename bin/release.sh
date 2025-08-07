#!/usr/bin/env bash
set -euo pipefail

MAIN_BRANCH=main
ORIGIN_NAME=origin

panic() {
  echo "FATAL: $*" >&2
  exit 1
}

init() {
  git fetch --tags "${ORIGIN_NAME}"
  test "$(git branch --show-current)" = "${MAIN_BRANCH}" || panic "Must be on main branch."
  test "$(git status --porcelain)" = "" || panic "Working copy is dirty. Commit or stash first."
  test \
    "$(git rev-parse "${MAIN_BRANCH}")" = "$(git rev-parse "${ORIGIN_NAME}/${MAIN_BRANCH}")" \
    || panic "main branch is not up-to-date with ${ORIGIN_NAME}."
}

main() {
  init
  make ci
  BACKUP_VERSION="$(./backup --version)"
  TAG_NAME="v${BACKUP_VERSION}"
  git tag "${TAG_NAME}"
  git push "${ORIGIN_NAME}" "${TAG_NAME}"
  gh release create "${TAG_NAME}" \
    --latest \
    --generate-notes \
    --draft \
    --fail-on-no-commits \
    --verify-tag
  gh release upload "${TAG_NAME}" ./backup
  exit $?
}

main
