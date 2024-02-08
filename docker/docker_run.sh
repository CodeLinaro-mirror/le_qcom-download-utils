#!/bin/bash

# **************************************************************************
#
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause
#
# **************************************************************************

check_workdir_length()
{
    echo "$WORKDIR"
    if [ ${#WORKDIR} -ge 70 ];
        then echo "Workdir length is too long" ; exit
    fi
}


echo_usage()
{
    cat <<'END_OF_USAGE'

Usage:
    ./sync_build.sh [OPTIONS]

    Options:
        -m, --manifest
            manifest url

        -h, --help
            Displays this help list

        -w, --workdir
            Working directory (Eg: /local/mnt/worksapce/test)

        -b, --branch
            branch name (Eg: LE.QCLINUX.1.0)

        -r, --release
            release

        -M, --machine
            machine (Eg: qcm6490)

        -d, --distro
            Distro (Eg: qcom-wayland)

        -i, --image
            Image (Eg: qcom-console-image)

        -t, --dockertag
            Dockertag

        -S, --script
            Sync Build Script

        -I --itr-session
            Interactive docker session

END_OF_USAGE
    exit 1
}

LONG_OPTS="manifest:,help:,branch:,release:,machine:,distro:,image:,workdir:,dockertag:,script:,itr-session:,"
GETOPT_CMD=$(getopt -o b:d:h:i:r:M:m:w:I:t:S: -l $LONG_OPTS -n "$(basename "$0")" -- "$@"
) || \
            { echo "error parsing options."; echo_usage; }

eval set -- "$GETOPT_CMD"

while true; do
    case "$1" in
       -m|--manifest) MANIFEST="$2"; shift ;;
       -h|--help) echo_usage;;
       -b|--branch) BRANCH="$2"; shift ;;
       -r|--release) RELEASE="$2"; shift ;;
       -M|--machine) MACHINE="$2"; shift ;;
       -d|--distro) DISTRO="$2"; shift ;;
       -i|--image) IMAGE="$2"; shift ;;
       -w|--workdir) WORKDIR="$2"; shift ;;
       -t|--dockertag) DOCKERTAG="$2"; shift ;;
       -S|--script) SCRIPT="$2"; shift ;;
       -I|--itr-session) ITR_SESSION="$2"; shift ;;
       --) shift ; break ;;
       *) echo "Error processing args -- unrecognized option $1" >&2
          exit 1;;
    esac
    shift
done

if [[ "$WORKDIR" ]]; then
    if [[ "$SCRIPT" == "" ]]; then
        echo "Please provide sync_build script path also"
        exit 1
    fi
fi

[ -z "$RELEASE" ] && RELEASE="qcom-6.6.13-QLI.1.0-Ver.1.2"

source ./$RELEASE/config.sh

[ -z "$MANIFEST" ] && MANIFEST=$MANIFEST
[ -z "$BRANCH" ] && BRANCH=$BRANCH
[ -z "$MACHINE" ] && MACHINE=$MACHINE
[ -z "$DISTRO" ] && DISTRO=$DISTRO
[ -z "$IMAGE" ] && IMAGE=$IMAGE
[ -z "$WORKDIR" ] && WORKDIR=$WORK_DIR
[ -z "$DOCKERTAG" ] && DOCKERTAG=$DOCKER_TAG
[ -z "$SCRIPT" ] && SCRIPT="./utils/sync_build.sh"
[ -z "$ITR_SESSION" ] && ITR_SESSION=true

if [[ $ITR_SESSION == true ]]; then
    DOCKER_ARGS="-t"
else
    DOCKER_ARGS=""
fi

check_workdir_length

docker run --rm $DOCKER_ARGS -v "${HOME}/.gitconfig":"/home/${USER}/.gitconfig" \
    -v "${HOME}/.netrc":"/home/${USER}/.netrc" \
    -v "$(pwd)":"$(pwd)" -v "$WORKDIR":"$WORKDIR" \
    -w "$WORKDIR" -u "$(id -u)":"$(id -g)" \
    "$DOCKERTAG" /bin/bash "$SCRIPT" \
    -m "$MANIFEST" -b "$BRANCH" -r "${RELEASE}.xml" \
    -M "$MACHINE" -d "$DISTRO" -i "$IMAGE" \
    -w "$WORKDIR/$RELEASE" \
    2>&1 | tee ./logs/docker_run.txt
