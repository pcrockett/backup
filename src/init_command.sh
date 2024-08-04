# shellcheck shell=bash
# shellcheck disable=SC2154

config:read
config:setup_restic_env "${args[destination]}"

if [ "${args[destination]}" == "local" ]; then
    local:mount_device_by_uuid "${LOCAL_FILESYSTEM_UUID}"
    local:unmount_on_exit "${LOCAL_FILESYSTEM_UUID}"
    touch "$(local:device_mount_path_by_uuid "${LOCAL_FILESYSTEM_UUID}")/.nobackup"
fi

restic init
