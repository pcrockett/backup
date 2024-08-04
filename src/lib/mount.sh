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

mount:mount_restic_repo() {
    local backup_dest="${1}"

    mount_dir="$(mount:mountpoint_for_backup_dest "${backup_dest}")"
    util:mkdir_private "${mount_dir}"

    if mount:is_mountpoint "${mount_dir}"; then
        panic "Already mounted: ${mount_dir}"
    fi

    restic_output_file="$(util:temp_file)"
    restic mount "${mount_dir}" > "${restic_output_file}" &
    restic_pid=${!}
    echo "${restic_pid}" > "$(mount:pid_file_by_dest "${backup_dest}")"

    mount:wait "${mount_dir}" "${restic_pid}"

    if mount:is_mountpoint "${mount_dir}" && process:is_running "${restic_pid}"; then
        echo "Repository mounted at ${mount_dir}"
    else
        cat "${restic_output_file}"
        panic "Unable to mount backup repository"
    fi
}

mount:unmount_restic_repo() {
    local backup_dest="${1}"
    mount_dir="$(mount:mountpoint_for_backup_dest "${backup_dest}")"

    if [ ! -d "${mount_dir}" ] || ! mount:is_mountpoint "${mount_dir}"; then
        return 0
    fi

    pid_file="$(mount:pid_file_by_dest "${backup_dest}")"
    pid="$(head --lines 1 "${pid_file}")"
    kill -SIGTERM "${pid}"
    process:wait "${pid}"
    rm -f "${pid_file}"
}
