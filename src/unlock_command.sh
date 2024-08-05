# shellcheck shell=bash
# shellcheck disable=SC2154

config:read

if [ "${args[destination]}" == "local" ]; then
    local:mount_device_by_uuid "${LOCAL_FILESYSTEM_UUID}"
    local:unmount_on_exit "${LOCAL_FILESYSTEM_UUID}"
fi

config:setup_restic_env "${args[destination]}"
restic unlock
