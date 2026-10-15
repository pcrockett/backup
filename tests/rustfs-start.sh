#!/usr/bin/env bash
set -euo pipefail

RUSTFS_DATA_DIR="${RUSTFS_DATA_DIR:-/data}"
export RUSTFS_ACCESS_KEY="${RUSTFS_ACCESS_KEY:-testaccesskey}"
export RUSTFS_SECRET_KEY="${RUSTFS_SECRET_KEY:-testsecretkey}"
STATE_DIR="${XDG_STATE_HOME:-"${HOME}/.local/state"}/backup"
PID_FILE="${STATE_DIR}/rustfs-pid"
LOG_FILE="${STATE_DIR}/rustfs-logs.txt"
mkdir --parent "${STATE_DIR}"

if [ -f "${PID_FILE}" ]; then
  # service is already running; run `rustfs-stop.sh` to kill it
  exit 0
fi

rustfs server "${RUSTFS_DATA_DIR}" &>"${LOG_FILE}" &

echo "$!" >"${PID_FILE}"
echo "rustfs logs are being stored in ${LOG_FILE}"

# HACK: on my slow laptop, the first test fails because it starts
# running before rustfs is all the way up. i could fix this the _right_
# way by waiting for an http endpoint to respond... or i could fix
# it the lazy way that'll probably be good enough:
sleep 1
