# shellcheck shell=bash
# shellcheck disable=SC2154

read_config
configure_restic "${args[--dest]}"

if [ "${args[--dest]}" == "local" ]; then
    mount_device_by_uuid "${LOCAL_FILESYSTEM_UUID}"
    unmount_on_exit "${LOCAL_FILESYSTEM_UUID}"
fi

exclude_file="$(temp_file)"
lines "${EXCLUDE[@]}" > "${exclude_file}"

restic --verbose backup \
    --exclude-caches \
    --exclude-if-present ".nobackup" \
    --exclude-file "${exclude_file}" \
    "${BACKUP_PATHS[@]}"
