# shellcheck shell=bash

get_device_path() {
    # get the filesystem location of a device by UUID
    local uuid="${1}"
    blkid --uuid "${uuid}" || panic "Unable to get device path for UUID ${uuid}"
}

get_device_current_mount_path() {
    # get the filesystem location where a device is mounted
    #
    # accepts single parameter: either the device path itself, or the (suspected)
    # mount directory path
    #
    # writes nothing to stdout if the device isn't mounted
    local device_or_mount_path="${1}"
    findmnt --raw --noheadings --output TARGET "${device_or_mount_path}" || true
}

get_local_drive_mount_path() {
    local uuid run_user_dir mount_path
    uuid="${1}"
    run_user_dir="/run/user/$(id --user)"
    if [ -d "${run_user_dir}" ]; then
        mount_path="${run_user_dir}/backup/${uuid}"
    else
        mount_path="${XDG_STATE_HOME}/backup/${uuid}"
    fi
    mkdir_private "${mount_path}"
    echo "${mount_path}"
}

get_local_repo_path() {
    local uuid="${1}"
    echo "$(get_local_drive_mount_path "${uuid}")/repo"
}

unmount_device_by_uuid() {
    local uuid="${1}"
    sudo_if_needed umount "$(get_local_drive_mount_path "${uuid}")"
}

mount_device_by_uuid() {
    local uuid device_path current_mount_path desired_mount_path
    uuid="${1}"
    device_path="$(get_device_path "${uuid}")"
    current_mount_path="$(get_device_current_mount_path "${device_path}")"
    desired_mount_path="$(get_local_drive_mount_path "${uuid}")"
    if [ "${current_mount_path}" == "" ]; then
        echo "Mounting ${device_path} to ${desired_mount_path}..."
        sudo_if_needed mount "${device_path}" "${desired_mount_path}"
    elif [ "${current_mount_path}" != "${desired_mount_path}" ]; then
        panic "${device_path} is already mounted to ${current_mount_path}"
    fi
}

unmount_on_exit() {
    local filesystem_uuid="${1}"
    # shellcheck disable=SC2064  # intentionally expanding this trap string now
    trap "unmount_device_by_uuid $(escape_value "${filesystem_uuid}")" EXIT
}
