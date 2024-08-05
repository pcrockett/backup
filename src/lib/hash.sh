# shellcheck shell=bash

hash:get_file_hash() {
    # given a backup destination and file path within the backup, gets the hash of
    # the file from the latest snapshot.
    #
    # generates a lot of stdout; actual result is saved in `FILE_HASH` env variable
    #
    local backup_dest="${1}"
    local file_path="${2}"
    local restic_pid=0
    local mount_dir restic_output_file pid_file

    mount_dir="$(mount:mountpoint_for_backup_dest "${backup_dest}")"
    util:mkdir_private "${mount_dir}"

    pid_file="$(mount:pid_file_by_dest "${backup_dest}")"

    if ! mount:is_mountpoint "${mount_dir}" || ! mount:process_is_running "${backup_dest}"; then
        restic_output_file="$(util:temp_file)"
        restic mount "${mount_dir}" > "${restic_output_file}" &
        restic_pid=${!}
        echo "${restic_pid}" > "${pid_file}"
        mount:wait "${mount_dir}" "${restic_pid}"

        if mount:is_mountpoint "${mount_dir}" && process:is_running "${restic_pid}"; then
            echo "Repository mounted at ${mount_dir}"
        else
            cat "${restic_output_file}"
            panic "Unable to mount backup repository"
        fi
    fi

    local backup_file_path="${mount_dir}/snapshots/latest${file_path}"
    test -f "${backup_file_path}" || panic "${file_path} does not exist in latest snapshot."
    FILE_HASH="$(util:sha256sum "${backup_file_path}")"
    export FILE_HASH

    if [ ${restic_pid} -ne 0 ]; then
        kill -SIGTERM "${restic_pid}"
        process:wait "${restic_pid}"
        rm -f "${pid_file}"
    fi
}
