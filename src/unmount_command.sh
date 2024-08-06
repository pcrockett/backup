# shellcheck shell=bash
# shellcheck disable=SC2154

mount_dir="$(mount:mountpoint_for_backup_dest "${args[destination]}")"

if [ ! -d "${mount_dir}" ] || ! mount:is_mountpoint "${mount_dir}"; then
    return 0
fi

pid_file="$(mount:pid_file_by_dest "${args[destination]}")"
pid="$(head --lines 1 "${pid_file}")"
kill -SIGTERM "${pid}"
process:wait "${pid}"
rm -f "${pid_file}"

if [ "${args[destination]}" == "${EXTERNAL_BACKUP_DEST}" ]; then
    config:read
    external:unmount_on_exit "${EXTERNAL_FILESYSTEM_UUID}"
fi
