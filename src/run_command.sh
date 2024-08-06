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

backup_external() {
    external:mount_device_by_uuid "${EXTERNAL_FILESYSTEM_UUID}"
    external:unmount_on_exit "${EXTERNAL_FILESYSTEM_UUID}"
    configure_and_run "${EXTERNAL_BACKUP_DEST}"
}

backup_offsite() {
    configure_and_run "${OFFSITE_BACKUP_DEST}"
}

case "${args[destination]:-}" in
    "${EXTERNAL_BACKUP_DEST}")
        backup_external
    ;;
    "${OFFSITE_BACKUP_DEST}")
        backup_offsite
    ;;
    *)
        # no destination specified; run both.
        log:step "Backing up to ${EXTERNAL_BACKUP_DEST}..."
        backup_external
        log:step "Backing up to ${OFFSITE_BACKUP_DEST}..."
        backup_offsite
    ;;
esac
