#!/usr/bin/env bash
set -Eeuo pipefail

THIS_SCRIPT="$(readlink -f "${0}")"

init() {
    TESTS_DIR="$(dirname "${THIS_SCRIPT}")"
    REPO_DIR="$(dirname "${TESTS_DIR}")"
    COMPOSE_FILE="${BACKUP_COMPOSE_FILE:-${REPO_DIR}/compose.yml}"
    MINIO_INSTANCE_NAME="${MINIO_INSTANCE_NAME:-testinstance}"
    MINIO_INSTANCE_URL="${MINIO_INSTANCE_URL:-http://localhost:9000}"
    MINIO_ROOT_USER="${MINIO_ROOT_USER:-adminuser}"
    MINIO_ROOT_PASSWORD="${MINIO_ROOT_PASSWORD:-adminpassword}"
    MINIO_TEST_USER="${MINIO_TEST_USER:-testuser}"
    MINIO_TEST_PASSWORD="${MINIO_TEST_PASSWORD:-testpassword}"
    MINIO_TEST_ACCESS_KEY="${MINIO_TEST_ACCESS_KEY:-testaccesskey}"
    MINIO_TEST_SECRET_KEY="${MINIO_TEST_SECRET_KEY:-testsecretkey}"
    MINIO_BUCKET_NAME="${MINIO_BUCKET_NAME:-testbucket}"
    MINIO_DATA_DIR="${MINIO_DATA_DIR:-/data}"
}

compose_cmd() {
    docker compose --file "${COMPOSE_FILE}" "${@}"
}

minio_cmd() {
    if command -v mc &> /dev/null; then
        # we already have minio in our environment
        # (ex: we are running inside a docker container already with mc installed)
        # (used in CI)
        pushd "${MINIO_DATA_DIR}" &> /dev/null
        if "${@}"; then
            result=0
        else
            result=1
        fi
        popd &> /dev/null
        return ${result}
    else
        # we're running on a host somewhere that is running minio via docker compose
        # (used during local development)
        compose_cmd exec --workdir "${MINIO_DATA_DIR}" --no-TTY minio "${@}"
    fi
}

setup_alias() {
    if minio_cmd mc alias list "${MINIO_INSTANCE_NAME}" &> /dev/null; then
        return 0
    else
        minio_cmd mc alias set \
            "${MINIO_INSTANCE_NAME}" "${MINIO_INSTANCE_URL}" "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}" \
            > /dev/null
    fi
}

setup_user() {
    if minio_cmd mc admin user info "${MINIO_INSTANCE_NAME}" "${MINIO_TEST_USER}" &> /dev/null; then
        return 0
    else
        minio_cmd mc admin user add "${MINIO_INSTANCE_NAME}" "${MINIO_TEST_USER}" "${MINIO_TEST_PASSWORD}"
    fi
}

setup_accesskey() {
    if minio_cmd mc admin user svcacct info "${MINIO_INSTANCE_NAME}" "${MINIO_TEST_ACCESS_KEY}" &> /dev/null; then
        return 0
    else
        minio_cmd mc admin user svcacct add "${MINIO_INSTANCE_NAME}" "${MINIO_TEST_USER}" \
            --access-key "${MINIO_TEST_ACCESS_KEY}" \
            --secret-key "${MINIO_TEST_SECRET_KEY}"
    fi
}

setup_policy() {
    if minio_cmd mc admin policy entities "${MINIO_INSTANCE_NAME}" --user "${MINIO_TEST_USER}" | grep readwrite &> /dev/null; then
        return 0
    else
        minio_cmd mc admin policy attach "${MINIO_INSTANCE_NAME}" readwrite --user "${MINIO_TEST_USER}"
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
    setup_user
    setup_accesskey
    setup_policy
    remove_bucket
    create_bucket
}

main "${@}"
