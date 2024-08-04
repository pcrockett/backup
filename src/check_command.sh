# shellcheck shell=bash
# shellcheck disable=SC2154

config:read

path_to_check="${args[--file]:-}"

if [ "${path_to_check}" != "" ]; then
    test -f "${path_to_check}" || panic "${path_to_check} doesn't exist"
    path_to_check="$(readlink --canonicalize-existing "${path_to_check}")"
fi

configure_and_run() {
    local dest="${1}"
    config:setup_restic_env "${dest}"

    if [ "${path_to_check}" == "" ]; then
        restic --verbose check --read-data-subset 100M
    else
        mount:mount_restic_repo "${dest}"
        mount_dir="$(mount:mountpoint_for_backup_dest "${dest}")"
        backup_copy="${mount_dir}/snapshots/latest/${path_to_check}"
        test -f "${backup_copy}" || panic "Unable to find ${path_to_check} in latest backup snapshot."
        # TODO: finish verification
        mount:unmount_restic_repo "${dest}"
    fi
}

check_local() {
    local:mount_device_by_uuid "${LOCAL_FILESYSTEM_UUID}"
    local:unmount_on_exit "${LOCAL_FILESYSTEM_UUID}"
    configure_and_run local
}

check_remote() {
    configure_and_run remote
}

case "${args[destination]:-}" in
    local)
        check_local
    ;;
    remote)
        check_remote
    ;;
    *)
        # no destination specified; run both.
        log:step "Checking local..."
        check_local | log:indent
        log:step "Checking remote..."
        check_remote | log:indent
    ;;
esac
