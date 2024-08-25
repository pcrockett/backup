# shellcheck shell=bash

_device_path_by_uuid() {
    # get the filesystem location of a device by UUID
    local uuid="${1}"
    blkid --uuid "${uuid}" || panic "Unable to get device path for UUID ${uuid}"
}

_get_device_current_mount_path() {
    # get the filesystem location where a device is mounted
    #
    # accepts single parameter: either the device path itself, or the (suspected)
    # mount directory path
    #
    # writes nothing to stdout if the device isn't mounted
    local device_or_mount_path="${1}"
    findmnt --raw --noheadings --output TARGET "${device_or_mount_path}" || true
}

external:device_mount_path_by_uuid() {
    local uuid mount_path
    uuid="${1}"
    mount_path="${RUN_STATE_DIR}/mounts/fs/${uuid}"
    util:mkdir_private "${mount_path}"
    echo "${mount_path}"
}

external:repo_path_by_uuid() {
    local uuid="${1}"
    local backup_subdir="${2}"
    echo "$(external:device_mount_path_by_uuid "${uuid}")/${backup_subdir}"
}

_unmount_device_by_uuid() {
    local uuid="${1}"
    umount "$(external:device_mount_path_by_uuid "${uuid}")"
}

external:mount_device_by_uuid() {
    local uuid device_path current_mount_path desired_mount_path
    uuid="${1}"
    device_path="$(_device_path_by_uuid "${uuid}")"
    current_mount_path="$(_get_device_current_mount_path "${device_path}")"
    desired_mount_path="$(external:device_mount_path_by_uuid "${uuid}")"
    if [ "${current_mount_path}" == "" ]; then
        echo "Mounting ${device_path} to ${desired_mount_path}..."
        mount "${device_path}" "${desired_mount_path}"
    elif [ "${current_mount_path}" != "${desired_mount_path}" ]; then
        panic "${device_path} is already mounted to ${current_mount_path}"
    fi
}

external:unmount_on_exit() {
    local filesystem_uuid="${1}"
    # shellcheck disable=SC2064  # intentionally expanding this trap string now
    add_trap "_unmount_device_by_uuid $(util:escape_value "${filesystem_uuid}")"
}
