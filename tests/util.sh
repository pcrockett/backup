# shellcheck shell=bash

setup() {
    set -Eeuo pipefail
    local repo_dir
    repo_dir="$(readlink -f "${PWD}")"
    export BACKUP_COMPOSE_FILE="${repo_dir}/tests/docker-compose.yml"
    TEST_CWD="$(mktemp --directory --tmpdir=/tmp bats-test.XXXXXX)"
    TEST_HOME="$(mktemp --directory --tmpdir=/tmp bats-home.XXXXXX)"
    TEST_BIN="${TEST_HOME}/.local/bin"
    mkdir -p "${TEST_BIN}"
    cp tests/init-test-bucket.sh "${TEST_BIN}"
    cp .tool-versions "${TEST_CWD}"
    cd "${TEST_CWD}"
    PATH="${TEST_BIN}:${PATH}"
    export HOME="${TEST_HOME}"
    export MINIO_INSTANCE_URL="${MINIO_INSTANCE_URL:-http://localhost:9000}"
    export MINIO_ROOT_USER="${MINIO_ROOT_USER:-testuser}"
    export MINIO_ROOT_PASSWORD="${MINIO_ROOT_PASSWORD:-testpassword}"
    export MINIO_BUCKET_NAME="${MINIO_BUCKET_NAME:-testbucket}"
    init-test-bucket.sh
}

teardown() {
    rm -rf "${TEST_CWD}"
    rm -rf "${TEST_HOME}"
}

fail() {
    echo "${*}"
    exit 1
}

# shellcheck disable=SC2034  # this function returns data via variables
capture_output() {
    local stderr_file stdout_file
    stderr_file="$(mktemp)"
    stdout_file="$(mktemp)"
    capture_exit_code "${@}" \
        > "${stdout_file}" \
        2> "${stderr_file}"
    TEST_STDOUT="$(cat "${stdout_file}")"
    TEST_STDERR="$(cat "${stderr_file}")"
    rm -f "${stdout_file}" "${stderr_file}"
}

# shellcheck disable=SC2034  # this function returns data via variables
capture_exit_code() {
    if "${@}"; then
        TEST_EXIT_CODE=0
    else
        TEST_EXIT_CODE=$?
    fi
}

assert_exit_code() {
    test "${TEST_EXIT_CODE}" -eq "${1}" \
        || fail "Expected exit code ${1}; got ${TEST_EXIT_CODE}"
}

assert_stdout() {
    if ! [[ "${TEST_STDOUT}" =~ ${1} ]]; then
        printf "******STDOUT:******\n%s\n*******************\n" "${TEST_STDOUT}"
        printf "*****EXPECTED:*****\n%s\n*******************\n" "${1}"
        fail "stdout didn't match expected."
    fi
}

assert_no_stdout() {
    if [ "${TEST_STDOUT}" != "" ]; then
        printf "******STDOUT:******\n%s\n*******************\n" "${TEST_STDOUT}"
        fail "stdout is expected to be empty."
    fi
}

assert_stderr() {
    if ! [[ "${TEST_STDERR}" =~ ${1} ]]; then
        printf "******STDERR:******\n%s\n*******************\n" "${TEST_STDERR}"
        printf "*****EXPECTED:*****\n%s\n*******************\n" "${1}"
        fail "stderr didn't match expected."
    fi
}

assert_no_stderr() {
    if [ "${TEST_STDERR}" != "" ]; then
        printf "******STDERR:******\n%s\n*******************\n" "${TEST_STDERR}"
        fail "stderr is expected to be empty."
    fi
}
