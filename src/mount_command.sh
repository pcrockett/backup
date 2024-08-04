# shellcheck shell=bash
# shellcheck disable=SC2154

config:read
config:setup_restic_env "${args[destination]}"

mount_dir="$(get_mount_dir "${args[destination]}")"
mkdir_private "${mount_dir}"

if is_mounted "${mount_dir}"; then
    panic "Already mounted: ${mount_dir}"
fi

if [ "${args[destination]}" == "local" ]; then
    mount_device_by_uuid "${LOCAL_FILESYSTEM_UUID}"
fi

restic_output_file="$(temp_file)"

restic mount "${mount_dir}" > "${restic_output_file}" &
restic_pid=${!}
echo "${restic_pid}" > "$(get_mount_pid_file "${args[destination]}")"

# make sure temp files aren't cleaned up before restic starts
wait_for_mount "${mount_dir}" "${restic_pid}"

if is_mounted "${mount_dir}" && proc_is_running "${restic_pid}"; then
    echo "Repository mounted at ${mount_dir}"
else
    cat "${restic_output_file}"
    panic "Unable to mount backup repository"
fi
