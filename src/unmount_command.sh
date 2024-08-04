# shellcheck shell=bash
# shellcheck disable=SC2154

mount:unmount_restic_repo "${args[destination]}"

if [ "${args[destination]}" == "local" ]; then
    config:read
    local:unmount_on_exit "${LOCAL_FILESYSTEM_UUID}"
fi
