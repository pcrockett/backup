# shellcheck shell=bash

read_config
restic --verbose check --read-data-subset 100M
