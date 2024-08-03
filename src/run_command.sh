# shellcheck shell=bash
# shellcheck disable=SC2154

read_config
configure_restic "${args[--dest]}"

exclude_file="$(temp_file)"
lines "${EXCLUDE[@]}" > "${exclude_file}"

restic --verbose backup \
    --exclude-caches \
    --exclude-if-present ".nobackup" \
    --exclude-file "${exclude_file}" \
    "${BACKUP_PATHS[@]}"
