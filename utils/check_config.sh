#!/bin/bash

# **************************************************************************
#
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause
#
# **************************************************************************

exit_msg() {
    echo " ********** Error: $1 **********"
    exit 1
}

check_git_config() {
USER_NAME=$(git config --get user.name)
USER_EMAIL=$(git config --get user.email)
if [[ "$USER_EMAIL" == "" || "$USER_NAME" == "" ]]; then
  exit_msg "Git config not found in your $HOME/.gitconfig Please run below below commands to set

git config --global user.name 'john'
git config --global user.email 'john@example.com'"
fi
COLOR_AUTO=$(git config --get color.ui)
if [[ "$COLOR_AUTO" == "" ]]; then
  git config --global color.ui auto
fi
}

update_git_config_buffer() {
local buffer_size=1048576000
POST_BUFFER=$(git config --get http.postBuffer)
MAX_REQUEST_BUFFER=$(git config --get http.maxRequestBuffer)
if [[ "$POST_BUFFER" != "$buffer_size" || "$MAX_REQUEST_BUFFER" != "$buffer_size" ]]; then
  git config --global http.maxRequestBuffer $buffer_size
  git config --global http.postBuffer $buffer_size
fi
}

check_disk_space() {
  local WORKDIR
  WORKDIR="$(pwd)"
  local size=200

  if [[ $# -gt 0 && "$1" == "qcom-robotics-full-image" ]]; then
    size=450
  fi

  size_in_gb="$(($(stat -f --format="%a*%s/1024/1024/1024" "$WORKDIR")))"
  if [ $size_in_gb -le $size ]; then
    exit_msg "$WORKDIR Free Space: $size_in_gb"". Free Space: $size_in_gb""GB < $size GB"
    exit 1
  else
    echo "$WORKDIR"". Free Space: ""$size_in_gb""GB"
  fi
}

check_docker_installation_and_config() {
if [[ $(which docker) && $(docker --version) ]]; then
    echo "Docker installed already"
    docker_users=$(grep /etc/group -e "docker")
    if [[ "$docker_users" =~ "$USER" ]]; then
     echo "$USER is part of docker group"
    else
     exit_msg "docker is installed but user is not part of the docker group, please run below commands to add user

sudo usermod -aG docker $USER
newgrp docker

After this logout and login changes to take affect"
    fi
fi
}

check_git_config
update_git_config_buffer
check_disk_space "$@"
check_docker_installation_and_config
