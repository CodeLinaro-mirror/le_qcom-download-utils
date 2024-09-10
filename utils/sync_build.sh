#!/bin/bash

# **************************************************************************
#
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause
#
# **************************************************************************

set -x

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
            release xml

        -M, --machine
            machine (Eg: qcm6490)

        -d, --distro
            Distro (Eg: qcom-wayland)

        -i, --image
            Image (Eg: qcom-console-image)

        -a, --alternate-repo
            Install repo from clo

        -o, --build-override
            Build Override (Eg: base)

END_OF_USAGE
    exit 1
}

LONG_OPTS="manifest:,help,branch:,release:,machine:,distro:,image:,workdir:,alternate-repo:,build-override:,"
GETOPT_CMD=$(getopt -o b:d:h:i:r:M:m:w:a:o: -l $LONG_OPTS -n "$(basename "$0")" -- "$@"
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
       -a|--alternate-repo) ALTERNATE_REPO="$2"; shift ;;
       -o|--build-override) BUILD_OVERRIDE="$2"; shift ;;
       --) shift ; break ;;
       *) echo "Error processing args -- unrecognized option $1" >&2
          exit 1;;
    esac
    shift
done

[ -z "$MANIFEST" ] && MANIFEST="https://github.com/quic-yocto/qcom-manifest"
[ -z "$BRANCH" ] && BRANCH="qcom-linux-kirkstone"
[ -z "$RELEASE" ] && RELEASE="qcom-6.6.13-QLI.1.0-Ver.1.2.xml"
[ -z "$MACHINE" ] && MACHINE="qcm6490"
[ -z "$DISTRO" ] && DISTRO="qcom-wayland"
[ -z "$IMAGE" ] && IMAGE="qcom-multimedia-image"
[ -z "$ALTERNATE_REPO" ] && ALTERNATE_REPO="false"
[ -z "$BUILD_OVERRIDE" ] && BUILD_OVERRIDE="custom"

if [ -z "$WORKDIR" ];then
  echo "Please provide working directory to sync and build"
  exit 1
fi


# Create if working directory not created
mkdir -p "$WORKDIR"

# Go to working directory
cd "$WORKDIR"

repo_sync() {
  if [ "$ALTERNATE_REPO" == "true" ]; then
    mkdir -p ~/bin && cd ~/bin
    rm -rf ~/bin/repo_tool
    git clone https://git.codelinaro.org/clo/la/tools/repo.git -b v2.41 repo_tool
    cd repo_tool
    git checkout -b v2.41
    export PATH=~/bin/repo_tool:$PATH
  fi

  # Go to working directory
  cd "$WORKDIR"

  # repo init
  repo init -u "$MANIFEST" -b "$BRANCH" -m "$RELEASE"

  # repo sync
  repo sync -j"$(nproc)"
}

envsetup() {
  # build variables
    MACHINE="$MACHINE"
    DISTRO="$DISTRO"

  # build override parameter for base
    if [[ "$BUILD_OVERRIDE" == "base" ]]; then
       QCOM_SELECTED_BSP="base"
    fi

  # setup environment
    export SHELL=/bin/bash
  # shellcheck source=/dev/null

  # copy qnn and snpe in downloads folder for qim-product-sdk release
   if [[ "$RELEASE" =~ "qim-product-sdk-1.1" ]];then
     export EXTRALAYERS="meta-qcom-qim-product-sdk"
     if [[ -d "$WORKDIR/qnn" ]] && [[ -d "$WORKDIR/snpe" ]]; then
       cp -rf $WORKDIR/qnn $WORKDIR/downloads
       cp -rf $WORKDIR/snpe $WORKDIR/downloads
     fi
   fi

   # export extralayers for realtime SDK
   if [[ "$RELEASE" =~ "realtime-linux-1.0" ]];then
     export EXTRALAYERS="meta-qcom-realtime"
   fi
   source setup-environment
}

repo_sync

envsetup

bitbake $IMAGE
