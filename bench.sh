#!/usr/bin/env bash

set -e

source functions.sh

IMAGES='golang debian distroless alpine busybox scratch'
TYPE='sizes'
IMAGE_PREPEND='zgllbmvylwjlbm'
DEPENDENCIES='xargs docker bc grep cut'
DOCKER_ARGS=( --no-cache )
VERBOSE=0
DEBUG=0
PREPULL=1
CHECK=1

set_params $@

check_os
check_deps ${DEPENDENCIES}

prepull ${IMAGES}

title "Started images benchmark"

for IMAGE in ${IMAGES}; do
    waiting "Building ${IMAGE} image with parameters: '${DOCKER_ARGS[*]}'"

    START=$(${DATE_COMMAND} +%s.%N)

    docker_build ${IMAGE}

    END=$(${DATE_COMMAND} +%s.%N)

    DIFF=$(echo "scale=3; (${END} - ${START})*1000/1" | bc )
    T_LAYERS=$(docker history --format='{{.Size}}' ${IMAGE_PREPEND}-${IMAGE} | grep '' -c)
    S_LAYERS=$(docker history --format='{{.Size}}' ${IMAGE_PREPEND}-${IMAGE} | grep -v '0B' -c)
    SIZE=$(docker image ls --format='{{.Repository}} {{ .Size}}' | grep ${IMAGE_PREPEND}-${IMAGE} | cut -d " " -f 2)

    success "Build time: ${DIFF} microseconds"
    success "Total size: ${SIZE}"
    success "Total layers without empty ones: ${S_LAYERS}"
    success "Total layers: ${T_LAYERS}"
    verbose success "Layers details:"
    verbose eol
    verbose docker history ${IMAGE_PREPEND}-${IMAGE}


    eol
done

clean ${IMAGES}
