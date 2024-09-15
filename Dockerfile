FROM docker.io/library/debian:12-slim AS base
SHELL [ "/bin/bash", "-Eeuo", "pipefail", "-c" ]

ARG DEBIAN_FRONTEND=noninteractive
ENV ASDF_DIR=/root/.asdf \
    PATH="/root/.asdf/shims:/root/.asdf/bin:${PATH}"

# don't need to pin apt package versions
# hadolint ignore=DL3008
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
rm -f /etc/apt/apt.conf.d/docker-clean && \
apt-get update && \
apt-get install --yes --no-install-recommends curl ca-certificates git


FROM quay.io/minio/minio AS minio
# we're just pulling a couple binaries out of this image. it looks like
# the `dl.min.io` site where they recommend to download artifacts is fairly
# unreliable, and as far as i can tell, very slow too. i imagine quay.io is
# a better place from which to download.


FROM base AS restic
SHELL [ "/bin/bash", "-Eeuo", "pipefail", "-c" ]
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
apt-get install --yes --no-install-recommends bzip2 && \
curl -SsfL https://philcrockett.com/yolo/v1.sh | bash -s -- restic


FROM base AS asdf
SHELL [ "/bin/bash", "-Eeuo", "pipefail", "-c" ]
# don't care about "source" warning in shellcheck
# hadolint ignore=SC1091
RUN \
curl -SsfL https://philcrockett.com/yolo/v1.sh | bash -s -- docker/asdf && \
. "${ASDF_DIR}/asdf.sh" && \
asdf plugin add bashly https://github.com/pcrockett/asdf-bashly.git && \
asdf plugin add bats https://github.com/pcrockett/asdf-bats.git && \
asdf plugin add cue && \
asdf plugin add shellcheck

FROM base AS devenv
SHELL [ "/bin/bash", "-Eeuo", "pipefail", "-c" ]

# don't need to pin apt package versions
# hadolint ignore=DL3008
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
mkdir /app && \
mkdir /data && \
apt-get install --yes --no-install-recommends \
    make build-essential procps fuse3 libyaml-dev ruby-dev

COPY --from=minio /usr/bin/minio /usr/local/bin
COPY --from=minio /usr/bin/mc /usr/local/bin
COPY --from=restic /usr/local/bin/restic /usr/local/bin
COPY --from=asdf "${ASDF_DIR}" "${ASDF_DIR}"

WORKDIR /app
COPY .tool-versions .
RUN asdf install

COPY . .

CMD [ "/usr/local/bin/minio", "server", "/data", "--console-address", ":9001" ]
