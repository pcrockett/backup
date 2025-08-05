#!/usr/bin/env bash
set -Eeuo pipefail

MINIO_DATA_DIR="${MINIO_DATA_DIR:-/data}"
STATE_DIR="${XDG_STATE_HOME:-"${HOME}/.local/state"}/backup"
PID_FILE="${STATE_DIR}/minio-pid"
LOG_FILE="${STATE_DIR}/minio-logs.txt"
mkdir --parent "${STATE_DIR}"

if [ -f "${PID_FILE}" ]; then
  # service is already running; run minio-stop.sh to kill it
  exit 0
fi
minio server "${MINIO_DATA_DIR}" &>"${LOG_FILE}" &
echo "${!}" >"${PID_FILE}"
echo "Minio logs are being stored in ${LOG_FILE}"

# HACK: on my slow laptop, the first test fails because it starts
# running before minio is all the way up. i could fix this the _right_
# way by waiting for an http endpoint to respond... or i could fix
# it the lazy way that'll probably be good enough:
sleep 1
