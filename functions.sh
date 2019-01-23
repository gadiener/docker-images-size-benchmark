#!/usr/bin/env bash

set -e

source output.sh

function check_os {
    if [ "$(uname)" == "Darwin" ]; then
        DATE_COMMAND='gdate'
    else
        DATE_COMMAND='date'
    fi
    DEPENDENCIES+=" ${DATE_COMMAND}"
}

function check_deps {
    if [ ${CHECK} -eq 0 ]; then
        return
    fi

    title "Check dependencies"

    for DEPENDENCY in ${@}; do
        if [ -f `which ${DEPENDENCY}` ]; then
            verbose success "Dependency ${DEPENDENCY} installed"
        else
            verbose error "Dependency ${DEPENDENCY} missing, please install it and retry"
            exit 1
        fi
    done

    verbose eol
}

function verbose {
    if [ ${VERBOSE} -eq 1 ]; then
        local COMMAND="${1}"
        shift
        $COMMAND "${@}"
    fi
}

function debug {
    if [ "$DEBUG" -eq 1 ]; then
        "$@"
    else
        "$@" > /dev/null
    fi
}

function help_message {
    eol
	title "Usage: ./bench.sh [OPTIONS]"

	title "Run it."

    echo 'Options:'
    echo '   -h, --help         Show help docker'
    echo '   -v, --verbose      Talk a lot while doing things'
    echo '   -d, --debug        Enable debug mode, it also activates verbose'
    echo '       --with-cache   Enable cache on Docker build'
    echo '       --no-prepull   Disable prepull of base images'
    echo '       --no-check     Skip dependencies preflight check'
    echo '       --squash       Squash newly built layers into a single new layer on Docker build'
}

function set_params {
    while [[ $# -gt 0 ]];do
        key="${1}"

        case ${key} in
            -h|--help)
                help_message
                exit 0
            ;;
            -v|--verbose)
                VERBOSE=1
                shift
            ;;
            -d|--debug)
                VERBOSE=1
                DEBUG=1
                shift
            ;;
            --with-cache)
                remove_from_docker_args --no-cache
                shift
            ;;
            --no-prepull)
                PREPULL=0
                shift
            ;;
            --no-check)
                CHECK=0
                shift
            ;;
            --squash)
                DOCKER_ARGS+=( --squash )
                shift
            ;;
            *)
            error "Unrecognized option ${key}, use -h"
            exit 1
        esac
    done
}

function prepull {
    if [ ${PREPULL} -eq 0 ]; then
        return
    fi

    title "Prepulling base images"

    for IMAGE in ${@}; do
        for BASE_IMAGE in `grep FROM images/Dockerfile-alpine | cut -d " " -f 2`; do
            verbose waiting "Pulling ${BASE_IMAGE}"
            debug docker pull ${BASE_IMAGE}
            verbose success "Image ${BASE_IMAGE} up to date"

            verbose eol
        done
    done
}

function clean {
    title "Cleaning temporary images"

    for IMAGE in ${@}; do
        debug docker image rm ${IMAGE_PREPEND}-${IMAGE}
    done

    verbose success "Clean ended"
}

function docker_build {
    debug docker build -t ${IMAGE_PREPEND}-${1} -f images/Dockerfile-${1} ${DOCKER_ARGS[@]} context
}

function remove_from_docker_args {
    local element=${1}

    for (( i=0; i<${#DOCKER_ARGS[@]}; i++ )); do
        if [[ ${DOCKER_ARGS[i]} == $element ]]; then
            DOCKER_ARGS=( "${DOCKER_ARGS[@]:0:$i}" "${DOCKER_ARGS[@]:$((i + 1))}" )
            i=$((i - 1))
        fi
    done
}
