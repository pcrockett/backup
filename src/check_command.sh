# shellcheck shell=bash
# shellcheck disable=SC2154

read_config
configure_restic "${args[--dest]}"

if [ "${args[--dest]}" == "local" ]; then
    mount_device_by_uuid "${LOCAL_FILESYSTEM_UUID}"
    unmount_on_exit "${LOCAL_FILESYSTEM_UUID}"
fi

restic --verbose check --read-data-subset 100M
