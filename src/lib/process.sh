# shellcheck shell=bash

process:is_running() {
    ps "${1}" &> /dev/null
}

process:wait() {
    local pid="${1}"
    local TIMEOUT_SECONDS=20
    local iteration_count=0
    while process:is_running "${pid}"
    do
        iteration_count=$((iteration_count+1))
        if [ ${iteration_count} -gt ${TIMEOUT_SECONDS} ]; then
            panic "Timeout while waiting for process ${pid} to stop."
        else
            sleep 1
        fi
    done
}
