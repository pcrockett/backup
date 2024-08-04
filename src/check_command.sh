# shellcheck shell=bash
# shellcheck disable=SC2154

config:read

configure_and_run() {
    local dest="${1}"
    config:setup_restic_env "${dest}"
    restic --verbose check --read-data-subset 100M
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
