#!/bin/bash

set -e

# Mac docker uses IP of host.docker.internal, likely as the following, but not for 100% sure.
MAC_DOCKER_IP="192.168.65.2"
# Linux docker uses fixed IP as following.
LINUX_DOCKER_IP="172.17.0.1"

# Export $1 as docker internal.
function export_addr() {
  if [ -z $1 ]; then
    echo "This funciton need a parameter."
    return
  fi

  if [ `uname` == "Darwin" ]; then
    eval "export $1=${MAC_DOCKER_IP}"
    echo "Mac docker detected."
  else
    eval "export $1=${LINUX_DOCKER_IP}"
    echo "Linux docker detected."
  fi
  echo "Using $1 as ${!1}."
}
