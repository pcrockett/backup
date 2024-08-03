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

get_usb_drive_mount_path() {
    local run_user_dir mount_path
    run_user_dir="/run/user/$(id --user)"
    if [ -d "${run_user_dir}" ]; then
        mount_path="${run_user_dir}/backup/usb_drive"
    else
        mount_path="${XDG_STATE_HOME}/backup/usb_drive"
    fi
    mkdir_private "${mount_path}"
    echo "${mount_path}"
}

get_usb_repo_path() {
    echo "$(get_usb_drive_mount_path)/repo"
}

unmount_usb_device() {
    sudo_if_needed umount "$(get_usb_drive_mount_path)"
}
