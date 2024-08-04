# shellcheck shell=bash
# shellcheck disable=SC2154

mount_dir="$(mount:mountpoint_for_backup_dest "${args[destination]}")"

if [ ! -d "${mount_dir}" ] || ! mount:is_mountpoint "${mount_dir}"; then
    exit 0
fi

pid_file="$(mount:pid_file_by_dest "${args[destination]}")"
pid="$(head --lines 1 "${pid_file}")"
kill -SIGTERM "${pid}"
wait_for_process "${pid}"

if [ "${args[destination]}" == "local" ]; then
    config:read
    local:unmount_on_exit "${LOCAL_FILESYSTEM_UUID}"
fi

rm -f "${pid_file}"
