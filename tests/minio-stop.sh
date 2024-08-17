#!/usr/bin/env bash
set -Eeuo pipefail

MINIO_DATA_DIR="${MINIO_DATA_DIR:-/data}"
STATE_DIR="${XDG_STATE_HOME:-"${HOME}/.local/state"}/backup"
PID_FILE="${STATE_DIR}/minio-pid"
mkdir --parent "${STATE_DIR}"

if command -v mc &> /dev/null; then
    # we already have minio in our environment
    # (ex: we are running inside a docker container already with mc installed)
    if [ -f "${PID_FILE}" ]; then
        kill "$(head -n 1 "${PID_FILE}")" || true
        rm "${PID_FILE}"
    fi
else
    # we're running on a host somewhere that is running minio via docker compose
    # (used during local development)
    docker compose down
fi
