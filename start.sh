#!/bin/bash

function print_usage() {
  echo "./start.sh [-raft]"
}

if [ -z $1 ]; then
  docker-compose up -d --scale tiflash0=0 --scale tikv-learner0=0
elif [ "$1" == "-raft" ]; then
  docker-compose up -d
else
  print_usage
  exit 1
fi
