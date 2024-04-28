# shellcheck shell=bash

read_config

RESTIC_EXCLUDE_FILE="$(mktemp)"
RESTIC_PASSWORD_FILE="$(mktemp)"
cleanup() {
    rm -f "${RESTIC_EXCLUDE_FILE}" "${RESTIC_PASSWORD_FILE}"
}
trap 'cleanup' SIGINT SIGTERM EXIT

for pattern in "${EXCLUDE[@]}"
do
    echo "${pattern}"
done > "${RESTIC_EXCLUDE_FILE}"

echo "${RESTIC_E2EE_PASSWORD}" > "${RESTIC_PASSWORD_FILE}"
export RESTIC_PASSWORD_FILE

restic --verbose backup \
    --exclude-caches \
    --exclude-if-present ".nobackup" \
    --exclude-file "${RESTIC_EXCLUDE_FILE}" \
    "${BACKUP_PATHS[@]}"
