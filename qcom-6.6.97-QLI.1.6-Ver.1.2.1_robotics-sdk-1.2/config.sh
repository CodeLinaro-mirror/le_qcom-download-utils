#!/bin/bash

# **************************************************************************
#
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause
#
# **************************************************************************

echo "config.sh qcom-6.6.97-QLI.1.6-Ver.1.2.1_robotics-sdk-1.2"
# Release tag
RELEASE="qcom-6.6.97-QLI.1.6-Ver.1.2.1_robotics-sdk-1.2"

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

MACHINE="qcs6490-rb3gen2-vision-kit"
IMAGE="qcom-robotics-full-image"
DISTRO="qcom-robotics-ros2-jazzy"
