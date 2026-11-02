FROM docker.io/library/debian:trixie-slim AS base
SHELL [ "/bin/bash", "-euo", "pipefail", "-c" ]

ARG DEBIAN_FRONTEND=noninteractive

# don't need to pin apt package versions
# hadolint ignore=DL3008
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
rm -f /etc/apt/apt.conf.d/docker-clean && \
apt-get update && \
apt-get install --yes --no-install-recommends curl ca-certificates git extrepo make build-essential procps fuse3 libyaml-dev libffi-dev jq && \
extrepo enable mise && \
apt-get update && \
apt-get install --yes --no-install-recommends mise && \
mkdir /app && \
mkdir /data

FROM base AS devenv
SHELL [ "/bin/bash", "-euo", "pipefail", "-c" ]

ENV PATH="/root/.local/bin:${PATH}"
WORKDIR /app
COPY mise.toml mise.lock ./
COPY .mise ./.mise
RUN mise trust && mise install --locked

COPY .pre-commit-config.yaml .
RUN \
git config --global init.defaultBranch main && \
git init . && \
mise exec -- pre-commit install --install-hooks

COPY . .
RUN git add .  # tell pre-commit what files to run against

ENTRYPOINT [ "mise", "exec", "--" ]
CMD [ "rustfs", "server", "/data", "--console-address", ":9001" ]
