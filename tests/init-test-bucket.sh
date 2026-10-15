#!/usr/bin/env bash
set -Eeuo pipefail

init() {
  RUSTFS_INSTANCE_NAME="${RUSTFS_INSTANCE_NAME:-testinstance}"
  RUSTFS_INSTANCE_URL="${RUSTFS_INSTANCE_URL:-http://localhost:9000}"
  RUSTFS_ACCESS_KEY="${RUSTFS_ACCESS_KEY:-testaccesskey}"
  RUSTFS_SECRET_KEY="${RUSTFS_SECRET_KEY:-testsecretkey}"
  RUSTFS_BUCKET_NAME="${RUSTFS_BUCKET_NAME:-testbucket}"
  RUSTFS_DATA_DIR="${RUSTFS_DATA_DIR:-/data}"

  cd "${RUSTFS_DATA_DIR}"
}

setup_alias() {
  if [ "$(rc alias list --json | jq --raw-output '.aliases.[].name')" == "${RUSTFS_INSTANCE_NAME}" ]; then
    return 0
  else
    rc alias set \
      "${RUSTFS_INSTANCE_NAME}" "${RUSTFS_INSTANCE_URL}" "${RUSTFS_ACCESS_KEY}" "${RUSTFS_SECRET_KEY}" \
      >/dev/null
  fi
}

remove_bucket() {
  # removes the bucket if it exists, and does nothing otherwise
  test ! -d "${RUSTFS_BUCKET_NAME}" \
    || rc rb --force "${RUSTFS_INSTANCE_NAME}/${RUSTFS_BUCKET_NAME}"
}

create_bucket() {
  rc mb "${RUSTFS_INSTANCE_NAME}/${RUSTFS_BUCKET_NAME}"
}

main() {
  init
  setup_alias
  remove_bucket
  create_bucket
}

main "$@"
