FROM docker.io/library/debian:trixie-slim AS base
SHELL [ "/bin/bash", "-euo", "pipefail", "-c" ]

ARG DEBIAN_FRONTEND=noninteractive

# don't need to pin apt package versions
# hadolint ignore=DL3008
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
rm -f /etc/apt/apt.conf.d/docker-clean && \
apt-get update && \
apt-get install --yes --no-install-recommends curl ca-certificates git python3 python3-venv extrepo make build-essential procps fuse3 libyaml-dev ruby-dev libffi-dev && \
extrepo enable mise && \
apt-get update && \
apt-get install --yes --no-install-recommends mise && \
mkdir /app && \
mkdir /data

RUN \
python3 -m venv /opt/pipx-venv && \
/opt/pipx-venv/bin/pip install pipx && \
ln -s /opt/pipx-venv/bin/pipx /usr/local/bin/pipx

# TODO: pin to specific image tag, but after we setup renovate
# hadolint ignore=DL3007
FROM quay.io/minio/minio:latest AS minio
# we're just pulling a couple binaries out of this image. it looks like
# the `dl.min.io` site where they recommend to download artifacts is fairly
# unreliable, and as far as i can tell, very slow too. i imagine quay.io is
# a better place from which to download.

FROM base AS devenv
SHELL [ "/bin/bash", "-euo", "pipefail", "-c" ]

COPY --from=minio /usr/bin/minio /usr/local/bin
COPY --from=minio /usr/bin/mc /usr/local/bin

ENV PATH="/root/.local/bin:${PATH}"
WORKDIR /app
COPY mise.toml mise.lock ./
RUN mise install --locked && mise trust

COPY .pre-commit-config.yaml .
RUN \
git config --global init.defaultBranch main && \
git init . && \
mise exec -- pre-commit install --install-hooks

COPY . .
RUN git add .  # tell pre-commit what files to run against

ENTRYPOINT [ "mise", "exec", "--" ]
CMD [ "minio", "server", "/data", "--console-address", ":9001" ]
