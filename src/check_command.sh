# shellcheck shell=bash
# shellcheck disable=SC2154

read_config
configure_restic "${args[--dest]}"
restic --verbose check --read-data-subset 100M
