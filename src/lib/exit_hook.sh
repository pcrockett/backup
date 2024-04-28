# shellcheck shell=bash

exit_hook() {
    # run a command before the script exits

    EXIT_HOOKS+=(
        "$(lines "${@}" | each printf "%q ")"
    )
}
