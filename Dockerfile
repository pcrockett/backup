FROM docker.io/library/debian:12-slim
SHELL [ "/bin/bash", "-Eeuo", "pipefail", "-c" ]
ARG DEBIAN_FRONTEND=noninteractive

# don't need to pin apt package versions
# hadolint ignore=DL3008
RUN useradd --create-home user && \
mkdir /app && \
chown -R user:user /app && \
apt-get update && \
apt-get install --yes --no-install-recommends curl ca-certificates git make build-essential libyaml-dev ruby-dev && \
apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
ENV ASDF_DIR=/home/user/.asdf \
    PATH="/home/user/.asdf/shims:/home/user/.asdf/bin:${PATH}"

# don't care about "source" warning in shellcheck
# hadolint ignore=SC1091
RUN \
curl -SsfL https://philcrockett.com/yolo/v1.sh | bash -s -- docker/asdf && \
. "${ASDF_DIR}/asdf.sh" && \
asdf plugin add bashly https://github.com/pcrockett/asdf-bashly.git && \
asdf plugin add bats https://github.com/pcrockett/asdf-bats.git && \
asdf plugin add cue && \
asdf plugin add shellcheck

WORKDIR /app
COPY --chown=user:user .tool-versions .
RUN asdf install

COPY --chown=user:user . .

CMD [ "/bin/bash" ]