# shellcheck shell=bash
# shellcheck disable=SC2154

read_config
configure_restic "${args[destination]}"

if [ "${args[destination]}" == "local" ]; then
    device_path="$(get_device_path "${LOCAL_FILESYSTEM_UUID}")"
    current_mount_path="$(get_device_current_mount_path "${device_path}")"
    desired_mount_path="$(get_local_drive_mount_path)"
    if [ "${current_mount_path}" == "" ]; then
        echo "Mounting ${device_path} to ${desired_mount_path}..."
        sudo_if_needed mount "${device_path}" "${desired_mount_path}"
    elif [ "${current_mount_path}" != "${desired_mount_path}" ]; then
        panic "${device_path} is already mounted to ${current_mount_path}"
    fi
    trap 'unmount_local_device' EXIT
    touch "${desired_mount_path}/.nobackup"
fi

restic init
