# shellcheck shell=bash

proc_is_running() {
    ps "${1}" &> /dev/null
}

wait_for_process() {
    local pid="${1}"
    local TIMEOUT_SECONDS=20
    local iteration_count=0
    while proc_is_running "${pid}"
    do
        iteration_count=$((iteration_count+1))
        if [ ${iteration_count} -gt ${TIMEOUT_SECONDS} ]; then
            panic "Timeout while waiting for process ${pid} to stop."
        else
            sleep 1
        fi
    done
}
