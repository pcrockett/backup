# shellcheck shell=bash
# shellcheck disable=SC2154

mount_dir="$(get_mount_dir "${args[destination]}")"

if [ ! -d "${mount_dir}" ] || ! is_mounted "${mount_dir}"; then
    exit 0
fi

pid_file="$(get_mount_pid_file "${args[destination]}")"
pid="$(head --lines 1 "${pid_file}")"
kill -SIGTERM "${pid}"
rm -f "${pid_file}"
