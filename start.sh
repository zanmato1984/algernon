#!/bin/bash

set -e

source env.sh

function print_usage() {
  echo "./start.sh [-raft [debug] | -docker start/restart/stop/...]"
}

if [ -z $1 ]; then
  docker-compose up -d --scale tidb1=0 --scale tiflash0=0 --scale tiflash-gateway0=0 --scale tikv-learner0=0
elif [ "$1" == "-raft" ]; then
  if [ -z $2 ]; then
    docker-compose up -d --scale tidb0=0 --build
  elif [ "$2" == "debug" ]; then
    docker-compose up -d --scale tidb0=0 --scale tiflash0=0 --build
  else
    print_usage
    exit 1
  fi
elif [ "$1" == "-docker" ]; then
  docker-compose "${@:2}"
else
  print_usage
  exit 1
fi
