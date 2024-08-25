#!/usr/bin/env bash
set -Eeuo pipefail

IMAGE_NAME="${IMAGE_NAME:-backup-ci}"
CONTAINER_NAME="${CONTAINER_NAME:-backup-ci-temp}"

docker container rm --force "${CONTAINER_NAME}" &> /dev/null || true

on_exit() {
    docker container rm --force "${CONTAINER_NAME}"
}
trap 'on_exit' EXIT

# shellcheck disable=SC2086  # we want word splitting for DOCKER_ARGS
docker run \
    --env MINIO_ROOT_USER=adminuser \
    --env MINIO_ROOT_PASSWORD=adminpassword \
    --device /dev/fuse \
    --cap-add SYS_ADMIN \
    --security-opt apparmor:unconfined \
    --name "${CONTAINER_NAME}" \
    ${DOCKER_ARGS:-} \
    "${IMAGE_NAME}" "${@}"

if [ "${COPY_ARTIFACTS:-}" != "" ]; then
    docker cp "${CONTAINER_NAME}":/app/backup .
    docker cp "${CONTAINER_NAME}":/app/release-please-config.json .
fi
