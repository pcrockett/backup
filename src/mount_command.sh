# shellcheck shell=bash
# shellcheck disable=SC2154

config:read
config:setup_restic_env "${args[destination]}"

if [ "${args[destination]}" == "${EXTERNAL_BACKUP_DEST}" ]; then
    external:mount_device_by_uuid "${EXTERNAL_FILESYSTEM_UUID}"
fi

mount_dir="$(mount:mountpoint_for_backup_dest "${args[destination]}")"
util:mkdir_private "${mount_dir}"

if mount:is_mountpoint "${mount_dir}"; then
    panic "Already mounted: ${mount_dir}"
fi

restic_output_file="$(util:temp_file)"
restic mount "${mount_dir}" > "${restic_output_file}" &
restic_pid=${!}
echo "${restic_pid}" > "$(mount:pid_file_by_dest "${args[destination]}")"

mount:wait "${mount_dir}" "${restic_pid}"

if mount:is_mountpoint "${mount_dir}" && process:is_running "${restic_pid}"; then
    echo "Repository mounted at ${mount_dir}"
else
    cat "${restic_output_file}"
    panic "Unable to mount backup repository"
fi
