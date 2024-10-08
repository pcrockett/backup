# shellcheck shell=bash

setup() {
    set -Eeuo pipefail
    TEST_ENV_DIR="$(mktemp --directory --tmpdir=/tmp bats-test.XXXXXX)"
    TEST_CWD="${TEST_ENV_DIR}/workdir"
    TEST_HOME="${TEST_ENV_DIR}/home"
    TEST_BIN="${TEST_HOME}/.local/bin"
    mkdir -p "${TEST_BIN}" "${TEST_CWD}"
    cp backup "${TEST_BIN}"
    cp tests/init-test-bucket.sh "${TEST_BIN}"
    cp .tool-versions "${TEST_CWD}"

    export MINIO_INSTANCE_URL="${MINIO_INSTANCE_URL:-http://localhost:9000}"
    export MINIO_TEST_ACCESS_KEY="${MINIO_TEST_ACCESS_KEY:-testaccesskey}"
    export MINIO_TEST_SECRET_KEY="${MINIO_TEST_SECRET_KEY:-testsecretkey}"
    export MINIO_BUCKET_NAME="${MINIO_BUCKET_NAME:-testbucket}"

    TEST_CONFIG_DIR="/etc/backup"
    mkdir --parent "${TEST_CONFIG_DIR}"
    cat > "${TEST_CONFIG_DIR}/config.sh" <<EOF
AWS_ACCESS_KEY_ID="${MINIO_TEST_ACCESS_KEY}"
AWS_SECRET_ACCESS_KEY="${MINIO_TEST_SECRET_KEY}"
S3_REPOSITORY_URL="s3:${MINIO_INSTANCE_URL}/${MINIO_BUCKET_NAME}"
RESTIC_E2EE_PASSWORD="testpassword"

BACKUP_PATHS=(
    "\${HOME}"
)

EXCLUDE=()
EOF

    cd "${TEST_CWD}"
    PATH="${TEST_BIN}:${PATH}"
    export HOME="${TEST_HOME}"
    export XDG_CONFIG_HOME="${TEST_HOME}/.config"
    export XDG_STATE_HOME="${TEST_HOME}/.local/state"
    init-test-bucket.sh \
        > "${TEST_ENV_DIR}/init-bucket-output" \
        2>&1
}

teardown() {
    pkill restic || true  # clean up background restic processes from failed tests
    if [ "${BACKUP_DEBUG:-}" == "" ]; then
        rm -rf "${TEST_ENV_DIR}"
    fi
}

fail() {
    echo "${*}"
    exit 1
}

# shellcheck disable=SC2034  # this function returns data via variables
capture_output() {
    local stderr_file stdout_file
    stderr_file="${TEST_ENV_DIR}/stderr"
    stdout_file="${TEST_ENV_DIR}/stdout"
    capture_exit_code "${@}" \
        > "${stdout_file}" \
        2> "${stderr_file}"
    TEST_STDOUT="$(cat "${stdout_file}")"
    TEST_STDERR="$(cat "${stderr_file}")"
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
