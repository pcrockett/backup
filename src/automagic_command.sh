# shellcheck shell=bash

test -f "$(config:file_path)" || panic "No backup has been configured yet for the root user."

THIS_SCRIPT_PATH="/usr/local/bin/backup"  # TODO: Properly determine the location of this script
AUTOMAGIC_SCRIPT_PATH="$(config:directory_path)/automagic.sh"

config:read

ENCODED_FILESYSTEM_UUID="${EXTERNAL_FILESYSTEM_UUID//-/\\x2d}"

AUTOMAGIC_SCRIPT="$(cat <<EOF
#!/usr/bin/env bash
set -Eeuo pipefail
BACKUP_SCRIPT=$(util:escape_value "${THIS_SCRIPT_PATH}")
export HOME=/root  # Restic wants to know where HOME is for caching purposes
"\${BACKUP_SCRIPT}" run
"\${BACKUP_SCRIPT}" check
# TODO: run / check different destinations in parallel as background jobs?
EOF
)"

SYSTEMD_UNIT="$(cat <<EOF
[Unit]
Description=Automagical Backup
DefaultDependencies=false
StopWhenUnneeded=true

[Install]
WantedBy=dev-disk-by\x2duuid-${ENCODED_FILESYSTEM_UUID}.device

[Service]
Type=simple
ExecStart=${AUTOMAGIC_SCRIPT_PATH}
EOF
)"

echo "${SYSTEMD_UNIT}" > /etc/systemd/system/automagical-backup.service
echo "${AUTOMAGIC_SCRIPT}" > "${AUTOMAGIC_SCRIPT_PATH}"
chmod +x "${AUTOMAGIC_SCRIPT_PATH}"
systemctl daemon-reload
systemctl enable automagical-backup.service
