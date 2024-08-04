# shellcheck shell=bash
# shellcheck disable=SC2154

read_config

exclude_file="$(temp_file)"
lines "${EXCLUDE[@]}" > "${exclude_file}"

configure_and_run() {
    local dest="${1}"
    configure_restic "${dest}"

    restic --verbose backup \
        --exclude-caches \
        --exclude-if-present ".nobackup" \
        --exclude-file "${exclude_file}" \
        "${BACKUP_PATHS[@]}"
}

backup_local() {
    mount_device_by_uuid "${LOCAL_FILESYSTEM_UUID}"
    unmount_on_exit "${LOCAL_FILESYSTEM_UUID}"
    configure_and_run local
}

backup_remote() {
    configure_and_run remote
}

case "${args[--dest]:-}" in
    local)
        backup_local
    ;;
    remote)
        backup_remote
    ;;
    *)
        # no destination specified; run both.
        backup_local
        backup_remote
    ;;
esac
