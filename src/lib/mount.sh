# shellcheck shell=bash

mount:is_mountpoint() {
    local dir_path="${1}"
    findmnt --raw --noheadings --output TARGET "${dir_path}" > /dev/null
}

mount:mountpoint_for_backup_dest() {
    local backup_dest="${1}"
    echo "${XDG_STATE_HOME}/backup/mount/${backup_dest}"
}

mount:pid_file_by_dest() {
    local backup_dest="${1}"
    local pid_dir run_user_dir
    run_user_dir="/run/user/$(id --user)"
    if [ -d "${run_user_dir}" ]; then
        pid_dir="${run_user_dir}/backup/pid"
    else
        pid_dir="${XDG_STATE_HOME}/backup/pid"
    fi
    util:mkdir_private "${pid_dir}"
    echo "${pid_dir}/${backup_dest}"
}

mount:process_is_running() {
    local backup_dest="${1}"
    local pid_file pid
    pid_file="$(mount:pid_file_by_dest "${backup_dest}")"
    if [ ! -f "${pid_file}" ]; then
        return 1
    fi
    pid="$(head -n 1 "${pid_file}")"
    process:is_running "${pid}"
}

mount:wait() {
    local dir_path="${1}"
    local pid="${2}"

    local MOUNT_TIMEOUT_SECONDS=20
    local iteration_count=0
    while ! mount:is_mountpoint "${dir_path}" && process:is_running "${pid}"
    do
        iteration_count=$((iteration_count+1))

        if [ ${iteration_count} -gt ${MOUNT_TIMEOUT_SECONDS} ]; then
            panic "Unable to mount \"${dir_path}\" : timeout."
        else
            sleep 1
        fi
    done
}
