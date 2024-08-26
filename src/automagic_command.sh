# shellcheck shell=bash

test -f "$(config:file_path)" || panic "No backup has been configured yet for the root user."

THIS_SCRIPT_PATH="$(readlink -f "${0}")"
AUTOMAGIC_SCRIPT_PATH="$(config:directory_path)/automagic.sh"
SYSTEMD_UNIT_NAME="automagical-backup"
SYSTEMD_UNIT_PATH="/etc/systemd/system/${SYSTEMD_UNIT_NAME}.service"

if [ "${args[--uninstall]:-}" != "" ]; then
    systemctl disable --now "${SYSTEMD_UNIT_NAME}.service"
    rm -f "${AUTOMAGIC_SCRIPT_PATH}" "${SYSTEMD_UNIT_PATH}"
    systemctl daemon-reload
    exit 0
fi

config:read

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
ExecStart=${AUTOMAGIC_SCRIPT_PATH}
EOF
)"

(
    umask u=rw,g=r,o=r
    echo "${SYSTEMD_UNIT}" > "${SYSTEMD_UNIT_PATH}"
    log:info "Created ${SYSTEMD_UNIT_PATH}"

    umask u=rwx,g=r,o=r
    echo "${AUTOMAGIC_SCRIPT}" > "${AUTOMAGIC_SCRIPT_PATH}"
    log:info "Created ${AUTOMAGIC_SCRIPT_PATH}"
)

systemctl daemon-reload
systemctl enable "${SYSTEMD_UNIT_NAME}.service"
