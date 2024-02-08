#!/bin/bash

# **************************************************************************
#
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause
#
# **************************************************************************

exit_msg() {
    echo "Error: $1"
    exit 1
}

check_netrc_config() {
  if [[ -e ~/.netrc ]];then
      echo ".netrc file found in home directory"
      if grep -q "chipmaster2.qti.qualcomm.com" "$HOME/.netrc"; then
         echo "chipmaster2 credentials found in .netrc";
      else
         exit_msg "Please add chipmaster2.qti.qualcomm.com credentials in $HOME/.netrc like below

machine chipmaster2.qti.qualcomm.com
login ****
password ***"
      fi
      if grep -q "qpm-git.qualcomm.com" "$HOME/.netrc"; then
         echo "qpm-git credentials found in .netrc";
      else
          exit_msg "Please add qpm-git.qualcomm.com credentials in  $HOME/.netrc like below

machine chipmaster2.qti.qualcomm.com
login ****
password ***"
      fi
  else
      exit_msg "Please create .netrc file in home directory ($HOME/.netrc) and add below lines

machine chipmaster2.qti.qualcomm.com
login ****
password ***

machine qpm-git.qualcomm.com
login ****
password ***"
  fi
}

check_git_config() {
USER_NAME=$(git config --get user.name)
USER_EMAIL=$(git config --get user.email)
if [[ "$USER_EMAIL" == "" || "$USER_NAME" == "" ]]; then
  exit_msg "Git config not found in your $HOME/.gitconfig Please run below below commands to set

git config --global user.name 'john'
git config --global user.email 'john@example.com'"
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
  size_in_gb="$(($(stat -f --format="%a*%s/1024/1024/1024" "$WORKDIR")))"
  if [ $size_in_gb -le $size ]; then
    echo "$WORKDIR Free Space: $size_in_gb"". Free Space: $size_in_gb""GB < 200GB"
    exit 1
  else
    echo "$WORKDIR"". Free Space: ""$size_in_gb""GB"
  fi
}

check_netrc_config
check_git_config
update_git_config_buffer
check_disk_space
