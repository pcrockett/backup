# shellcheck shell=bash

read_config

exclude_file="$(temp_file)"
lines "${EXCLUDE[@]}" > "${exclude_file}"

restic --verbose backup \
    --exclude-caches \
    --exclude-if-present ".nobackup" \
    --exclude-file "${exclude_file}" \
    "${BACKUP_PATHS[@]}"
