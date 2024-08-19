# shellcheck shell=bash

if [ "$(id --user)" -ne 0 ]; then
    panic "You must run as root for this command."
fi

test -f "$(config:file_path)" || panic "No backup has been configured yet for the root user."

SCRIPT_PATH="/usr/local/bin/backup"
# TODO: Properly determine the location of this script

config:read

ENCODED_FILESYSTEM_UUID="${EXTERNAL_FILESYSTEM_UUID//-/\\x2d}"

SYSTEMD_UNIT="$(cat <<EOF
[Unit]
Description=Automagical Backup
DefaultDependencies=false
StopWhenUnneeded=true

[Install]
WantedBy=dev-disk-by\x2duuid-${ENCODED_FILESYSTEM_UUID}.device

[Service]
Type=simple
ExecStart=${SCRIPT_PATH} run
ExecStart=${SCRIPT_PATH} check
EOF
)"

echo "${SYSTEMD_UNIT}" > /etc/systemd/system/automagical-backup.service
