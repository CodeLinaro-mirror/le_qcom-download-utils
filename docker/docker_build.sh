#!/bin/bash

# **************************************************************************
#
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause
#
# **************************************************************************

echo_usage()
{
    cat <<'END_OF_USAGE'

Usage:
    ./docker_build.sh [OPTIONS]

    Options:
        -f, --dockerfile
            dockerfile path
        -t, --dockertag
            docker tag name
        -r, --release
            release
        -h, --help
            Displays this help list

END_OF_USAGE
    exit 1
}

LONG_OPTS="dockerfile:,dockertag:,release:,"
GETOPT_CMD=$(getopt -o f:t:r -l $LONG_OPTS -n "$(basename "$0")" -- "$@"
) || \
            { echo "error parsing options."; echo_usage; }

eval set -- "$GETOPT_CMD"

while true; do
    case "$1" in
       -f|--dockerfile) DOCKERFILE="$2"; shift ;;
       -t|--dockertag) DOCKERTAG="$2"; shift ;;
       -r|--release) RELEASE="$2"; shift ;;
       --) shift ; break ;;
       *) echo "Error processing args -- unrecognized option $1" >&2
          exit 1;;
    esac
    shift
done

[ -z "$RELEASE" ] && RELEASE="qcom-6.6.13-QLI.1.0-Ver.1.2"

source ./$RELEASE/config.sh

[ -z "$DOCKERFILE" ] && DOCKERFILE="./docker/dockerfiles/$DOCKER_FILE"
[ -z "$DOCKERTAG" ] && DOCKERTAG=$DOCKER_TAG

mkdir -p ./logs

docker build -f  "$DOCKERFILE" \
    --build-arg "USER=$(whoami)" --build-arg "UID=$(id -u)" \
    --build-arg "GID=$(id -g)" -t "$DOCKERTAG" . \
    2>&1 | tee ./logs/docker_build.txt

