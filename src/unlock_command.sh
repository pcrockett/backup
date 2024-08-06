# shellcheck shell=bash
# shellcheck disable=SC2154

config:read

if [ "${args[destination]}" == "external" ]; then
    external:mount_device_by_uuid "${EXTERNAL_FILESYSTEM_UUID}"
    external:unmount_on_exit "${EXTERNAL_FILESYSTEM_UUID}"
fi

config:setup_restic_env "${args[destination]}"
restic unlock
