# shellcheck shell=bash

proc_is_running() {
    ps "${1}" &> /dev/null
}
