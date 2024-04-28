# shellcheck shell=bash

read_config

exclude_file="$(temp_file)"
password_file="$(temp_file)"

lines "${EXCLUDE[@]}" > "${exclude_file}"
echo "${RESTIC_E2EE_PASSWORD}" > "${password_file}"

RESTIC_PASSWORD_FILE="${password_file}" restic --verbose backup \
    --exclude-caches \
    --exclude-if-present ".nobackup" \
    --exclude-file "${exclude_file}" \
    "${BACKUP_PATHS[@]}"
