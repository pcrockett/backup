# shellcheck shell=bash

read_config

RESTIC_PASSWORD_FILE="$(mktemp)"
cleanup() {
    rm -f "${RESTIC_PASSWORD_FILE}"
}
trap 'cleanup' SIGINT SIGTERM EXIT

echo "${RESTIC_E2EE_PASSWORD}" > "${RESTIC_PASSWORD_FILE}"
export RESTIC_PASSWORD_FILE

restic init
