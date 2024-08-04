# shellcheck shell=bash

escape_value() {
    printf '%q' "${1}"
}
