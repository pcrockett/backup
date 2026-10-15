#!/usr/bin/env bash
set -Eeuo pipefail

init() {
  MINIO_INSTANCE_NAME="${MINIO_INSTANCE_NAME:-testinstance}"
  MINIO_INSTANCE_URL="${MINIO_INSTANCE_URL:-http://localhost:9000}"
  MINIO_TEST_ACCESS_KEY="${MINIO_TEST_ACCESS_KEY:-testaccesskey}"
  MINIO_TEST_SECRET_KEY="${MINIO_TEST_SECRET_KEY:-testsecretkey}"
  MINIO_BUCKET_NAME="${MINIO_BUCKET_NAME:-testbucket}"
  MINIO_DATA_DIR="${MINIO_DATA_DIR:-/data}"

  cd "${MINIO_DATA_DIR}"
}

setup_alias() {
  if [ "$(rc alias list --json | jq --raw-output '.aliases.[].name')" == "${MINIO_INSTANCE_NAME}" ]; then
    return 0
  else
    rc alias set \
      "${MINIO_INSTANCE_NAME}" "${MINIO_INSTANCE_URL}" "${MINIO_TEST_ACCESS_KEY}" "${MINIO_TEST_SECRET_KEY}" \
      >/dev/null
  fi
}

remove_bucket() {
  # removes the bucket if it exists, and does nothing otherwise
  test ! -d "${MINIO_BUCKET_NAME}" \
    || rc rb --force "${MINIO_INSTANCE_NAME}/${MINIO_BUCKET_NAME}"
}

create_bucket() {
  rc mb "${MINIO_INSTANCE_NAME}/${MINIO_BUCKET_NAME}"
}

main() {
  init
  setup_alias
  remove_bucket
  create_bucket
}

main "${@}"
