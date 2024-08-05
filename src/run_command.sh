# shellcheck shell=bash
# shellcheck disable=SC2154

config:read

exclude_file="$(util:temp_file)"
util:lines "${EXCLUDE[@]}" > "${exclude_file}"

configure_and_run() {
    local dest="${1}"
    config:setup_restic_env "${dest}"

    restic --verbose backup \
        --exclude-caches \
        --exclude-if-present ".nobackup" \
        --exclude-file "${exclude_file}" \
        "${BACKUP_PATHS[@]}"
}

backup_local() {
    local:mount_device_by_uuid "${LOCAL_FILESYSTEM_UUID}"
    local:unmount_on_exit "${LOCAL_FILESYSTEM_UUID}"
    configure_and_run local
}

backup_remote() {
    configure_and_run remote
}

case "${args[destination]:-}" in
    local)
        backup_local
    ;;
    remote)
        backup_remote
    ;;
    *)
        # no destination specified; run both.
        log:step "Backing up to local..."
        backup_local
        log:step "Backing up to remote..."
        backup_remote
    ;;
esac
