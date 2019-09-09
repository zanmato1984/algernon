#!/bin/bash

set -e

function print_usage() {
  echo "./start.sh [-raft]"
}

# Mac docker uses IP of host.docker.internal, likely as the following, but not for 100% sure.
MAC_DOCKER_IP="192.168.65.2"
# Linux docker uses fixed IP as following.
LINUX_DOCKER_IP="172.17.0.1"

if [ -z $1 ]; then
  docker-compose up -d --scale tiflash0=0 --scale tiflash-gateway0=0 --scale tikv-learner0=0
elif [ "$1" == "-raft" ]; then
  if [ -z $2 ]; then
    docker-compose up -d --build
  elif [ "$2" == "debug" ]; then
    if [ `uname` == "Darwin" ]; then
      export FLASH_ADDR=${MAC_DOCKER_IP}
      export ENGINE_ADDR=${MAC_DOCKER_IP}
      echo "Mac docker detected, using FLASH_ADDR as $FLASH_ADDR and ENGINE_ADDR as $ENGINE_ADDR."
    else
      export FLASH_ADDR=${LINUX_DOCKER_IP}
      echo "Linux docker detected, using FLASH_ADDR as $FLASH_ADDR."
    fi
    docker-compose up -d --scale tiflash0=0 --build
  else
    print_usage
    exit 1
  fi
else
  print_usage
  exit 1
fi
