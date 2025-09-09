#!/bin/bash

# **************************************************************************
#
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause
#
# **************************************************************************

# Release tag
RELEASE="qcom-6.6.97-QLI.1.6-Ver.1.0_realtime-linux-1.0"

DOCKER_FILE="Dockerfile_22.04"
OS=$(echo $DOCKER_FILE | cut -d'_' -f2)

# Docker tag name
DOCKER_TAG="${RELEASE,,}_${OS}"

# Working directory
WORK_DIR="$(pwd)"

# Sync variables

MANIFEST="https://github.com/quic-yocto/qcom-manifest"
BRANCH="qcom-linux-scarthgap"
MANIFEST_FILE="${RELEASE}.xml"

# Build variables

MACHINE="qcs6490-rb3gen2-core-kit"
DISTRO="qcom-wayland"
IMAGE="qcom-multimedia-image"
