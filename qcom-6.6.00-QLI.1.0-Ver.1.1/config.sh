#!/bin/bash

# **************************************************************************
#
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause
#
# **************************************************************************

# Release tag
RELEASE="qcom-6.6.00-QLI.1.0-Ver.1.1"

DOCKER_FILE="Dockerfile_20.04"
OS=$(echo $DOCKER_FILE | cut -d'_' -f2)

# Docker tag name
DOCKER_TAG="${RELEASE,,}_${OS}"

# Working directory
WORK_DIR="$(pwd)"

# Sync variables

MANIFEST="https://github.com/quic-yocto/qcom-manifest"
BRANCH="qcom-linux-kirkstone"
MANIFEST_FILE="${RELEASE}.xml"

# Build variables

MACHINE="qcm6490"
DISTRO="qcom-wayland"
IMAGE="qcom-multimedia-image"
