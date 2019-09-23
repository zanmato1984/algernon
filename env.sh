#!/bin/bash

set -e

# Mac docker uses IP of host.docker.internal, likely as the following, but not for 100% sure.
MAC_DOCKER_IP="192.168.65.2"
# Linux docker uses fixed IP as following.
LINUX_DOCKER_IP="172.17.0.1"

if [ `uname` == "Darwin" ]; then
  export ENGINE_ADDR=${MAC_DOCKER_IP}
  export FLASH_ADDR=${MAC_DOCKER_IP}
  export MYSQL_HOST=${MAC_DOCKER_IP}
  echo "Mac docker detected."
else
  export ENGINE_ADDR=${LINUX_DOCKER_IP}
  export FLASH_ADDR=${LINUX_DOCKER_IP}
  export MYSQL_HOST=${LINUX_DOCKER_IP}
  echo "Linux docker detected."
fi

echo "Using ENGINE_ADDR as $ENGINE_ADDR, FLASH_ADDR as $FLASH_ADDR, MYSQL_HOST as $MYSQL_HOST."
