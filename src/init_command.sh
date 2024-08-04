# shellcheck shell=bash
# shellcheck disable=SC2154

read_config
configure_restic "${args[destination]}"

if [ "${args[destination]}" == "local" ]; then
    mount_device_by_uuid "${LOCAL_FILESYSTEM_UUID}"
    unmount_on_exit "${LOCAL_FILESYSTEM_UUID}"
    touch "$(get_local_drive_mount_path "${LOCAL_FILESYSTEM_UUID}")/.nobackup"
fi

restic init
