# shellcheck shell=bash
# shellcheck disable=SC2154

config:read
config:setup_restic_env "${args[destination]}"

if [ "${args[destination]}" == "local" ]; then
    local:mount_device_by_uuid "${LOCAL_FILESYSTEM_UUID}"
fi

mount:mount_restic_repo "${args[destination]}"
