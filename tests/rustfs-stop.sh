#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-"${HOME}/.local/state"}/backup"
PID_FILE="${STATE_DIR}/rustfs-pid"
mkdir --parent "${STATE_DIR}"

if [ -f "${PID_FILE}" ]; then
  kill "$(head -n 1 "${PID_FILE}")" || true
  rm "${PID_FILE}"
fi
