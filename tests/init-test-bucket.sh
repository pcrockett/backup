#!/usr/bin/env bash
set -Eeuo pipefail

THIS_SCRIPT="$(readlink -f "${0}")"

init() {
    TESTS_DIR="$(dirname "${THIS_SCRIPT}")"
    COMPOSE_FILE="${TESTS_DIR}/docker-compose.yml"
    MINIO_INSTANCE_NAME="${MINIO_INSTANCE_NAME:-testinstance}"
    MINIO_ROOT_USER="${MINIO_ROOT_USER:-testuser}"
    MINIO_ROOT_PASSWORD="${MINIO_ROOT_PASSWORD:-testpassword}"
    MINIO_BUCKET_NAME="${MINIO_BUCKET_NAME:-testbucket}"
}

compose_cmd() {
    docker compose --file "${COMPOSE_FILE}" "${@}"
}

minio_cmd() {
    compose_cmd exec --workdir /data --no-TTY minio "${@}"
}

setup_alias() {
    if minio_cmd mc alias list "${MINIO_INSTANCE_NAME}" &> /dev/null; then
        return 0
    else
        minio_cmd mc alias set \
            "${MINIO_INSTANCE_NAME}" http://localhost:9000 "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}" \
            > /dev/null
    fi
}

remove_bucket() {
    # removes the bucket if it exists, and does nothing otherwise
    minio_cmd test ! -d "${MINIO_BUCKET_NAME}" \
        || minio_cmd mc rb --force "${MINIO_INSTANCE_NAME}/${MINIO_BUCKET_NAME}"
}

create_bucket() {
    minio_cmd mc mb "${MINIO_INSTANCE_NAME}/${MINIO_BUCKET_NAME}"
}

main() {
    init
    setup_alias
    remove_bucket
    create_bucket
}

main "${@}"
