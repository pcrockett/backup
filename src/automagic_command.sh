# shellcheck shell=bash

test -f "$(config:file_path)" || panic "No backup has been configured yet for the root user."

THIS_SCRIPT_PATH="$(readlink -f "${0}")"
AUTOMAGIC_SCRIPT_PATH="$(config:directory_path)/automagic.sh"
AUTOMAGIC_HOOKS_DIR="$(config:directory_path)/automagic_hooks"
BEFORE_HOOK_SCRIPT_PATH="${AUTOMAGIC_HOOKS_DIR}/before.sh"
AFTER_HOOK_SCRIPT_PATH="${AUTOMAGIC_HOOKS_DIR}/after.sh"
SYSTEMD_UNIT_NAME="automagical-backup"
SYSTEMD_UNIT_PATH="/etc/systemd/system/${SYSTEMD_UNIT_NAME}.service"

if [ "${args['--uninstall']:-}" != "" ]; then
    systemctl disable --now "${SYSTEMD_UNIT_NAME}.service"
    rm -f "${AUTOMAGIC_SCRIPT_PATH}" "${SYSTEMD_UNIT_PATH}"
    rm -rf "${AUTOMAGIC_HOOKS_DIR}"
    systemctl daemon-reload
    exit 0
fi

config:read

AUTOMAGIC_SCRIPT="$(cat <<EOF
#!/usr/bin/env bash
set -Eeuo pipefail

BACKUP_SCRIPT=$(util:escape_value "${THIS_SCRIPT_PATH}")
export HOME=/root  # Restic wants to know where HOME is for caching purposes

run_and_check() {
    "\${BACKUP_SCRIPT}" run
    "\${BACKUP_SCRIPT}" check
}

"${BEFORE_HOOK_SCRIPT_PATH}"

if run_and_check; then
    export AUTOMAGIC_BACKUP_RESULT=0
else
    export AUTOMAGIC_BACKUP_RESULT=\${?}
fi

"${AFTER_HOOK_SCRIPT_PATH}" || true

exit \${AUTOMAGIC_BACKUP_RESULT}
EOF
)"

AFTER_HOOK_SCRIPT="$(cat <<EOF
#!/usr/bin/env bash
set -Eeuo pipefail

# Script inputs:
#
# * AUTOMAGIC_BACKUP_RESULT environment variable indicating exit code of EITHER the \`run\` or
#   \`check\` phase.
#
EOF
)"


BEFORE_HOOK_SCRIPT="$(cat <<EOF
#!/usr/bin/env bash
set -Eeuo pipefail

# TODO

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
    umask u=rw,g=,o=

    mkdir --parent "${AUTOMAGIC_HOOKS_DIR}"
    echo "${AFTER_HOOK_SCRIPT}" > "${AFTER_HOOK_SCRIPT_PATH}"
    echo "${BEFORE_HOOK_SCRIPT}" > "${BEFORE_HOOK_SCRIPT_PATH}"
    echo "${AUTOMAGIC_SCRIPT}" > "${AUTOMAGIC_SCRIPT_PATH}"
    log:info "Created ${AUTOMAGIC_SCRIPT_PATH}"
)

chmod +x "${AUTOMAGIC_SCRIPT_PATH}" "${BEFORE_HOOK_SCRIPT_PATH}" "${AFTER_HOOK_SCRIPT_PATH}"

(
    umask u=rw,g=r,o=r

    echo "${SYSTEMD_UNIT}" > "${SYSTEMD_UNIT_PATH}"
    log:info "Created ${SYSTEMD_UNIT_PATH}"
)

systemctl daemon-reload
systemctl enable "${SYSTEMD_UNIT_NAME}.service"
