# shellcheck shell=bash

get_mount_dir() {
    local backup_dest="${1}"
    echo "${XDG_STATE_HOME}/backup/mount/${backup_dest}"
}

get_mount_pid_file() {
    local backup_dest="${1}"
    local pid_dir="${XDG_STATE_HOME}/backup/pid"
    mkdir --parent "${pid_dir}"
    echo "${pid_dir}/${backup_dest}"
}

is_mounted() {
    local dir_path="${1}"
    findmnt --raw --noheadings --output TARGET "${dir_path}" > /dev/null
}

wait_for_mount() {
    local dir_path="${1}"

    local MOUNT_TIMEOUT_SECONDS=20
    local iteration_count=0
    while ! is_mounted "${dir_path}"
    do
        iteration_count=$((iteration_count+1))

        if [ ${iteration_count} -gt ${MOUNT_TIMEOUT_SECONDS} ]; then
            panic "Unable to mount \"${dir_path}\" : timeout."
        else
            sleep 1
        fi
    done
}
