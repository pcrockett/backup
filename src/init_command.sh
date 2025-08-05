# shellcheck shell=bash
# shellcheck disable=SC2154

config:read
config:setup_restic_env "${args[destination]}"

if [ "${args[destination]}" == "${EXTERNAL_BACKUP_DEST}" ]; then
  external:mount_device_by_uuid "${EXTERNAL_FILESYSTEM_UUID}"
  external:unmount_on_exit "${EXTERNAL_FILESYSTEM_UUID}"
  touch "$(external:device_mount_path_by_uuid "${EXTERNAL_FILESYSTEM_UUID}")/.nobackup"
fi

restic init
