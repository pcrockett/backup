# shellcheck shell=bash
# shellcheck disable=SC2154

read_config

configure_and_run() {
    local dest="${1}"
    configure_restic "${dest}"
    restic --verbose check --read-data-subset 100M
}

check_local() {
    mount_device_by_uuid "${LOCAL_FILESYSTEM_UUID}"
    unmount_on_exit "${LOCAL_FILESYSTEM_UUID}"
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
        check_local
        check_remote
    ;;
esac
