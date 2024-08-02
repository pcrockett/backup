# shellcheck shell=bash
# shellcheck disable=SC2154

read_config

mount_dir="$(get_mount_dir "${args[destination]}")"
mkdir --parent "${mount_dir}"

if is_mounted "${mount_dir}"; then
    panic "Already mounted: ${mount_dir}"
fi

restic mount "${mount_dir}" &
restic_pid=${!}
echo "${restic_pid}" > "$(get_mount_pid_file "${args[destination]}")"

# TODO: Detect when `restic mount` background job fails and abort early

wait_for_mount "${mount_dir}"  # make sure temp files aren't cleaned up before restic starts
