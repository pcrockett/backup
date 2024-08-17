#!/usr/bin/env bash
set -Eeuo pipefail

MINIO_DATA_DIR="${MINIO_DATA_DIR:-/data}"
STATE_DIR="${XDG_STATE_HOME:-"${HOME}/.local/state"}/backup"
PID_FILE="${STATE_DIR}/minio-pid"
LOG_FILE="${STATE_DIR}/minio-logs.txt"
mkdir --parent "${STATE_DIR}"

if command -v mc &> /dev/null; then
    # we already have minio in our environment
    # (ex: we are running inside a docker container already with mc installed)
    if [ -f "${PID_FILE}" ]; then
        # service is already running; run minio-stop.sh to kill it
        exit 0
    fi
    minio server "${MINIO_DATA_DIR}" &> "${LOG_FILE}" &
    echo "${!}" > "${PID_FILE}"
    echo "Minio logs are being stored in ${LOG_FILE}"
else
    # we're running on a host somewhere that is running minio via docker compose
    # (used during local development)
    docker compose up --build --wait
fi
