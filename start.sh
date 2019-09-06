#!/bin/bash

function print_usage() {
  echo "./start.sh [-raft]"
}

if [ -z $1 ]; then
  docker-compose up -d --scale tiflash-gateway0=0 --scale tiflash0=0 --scale tikv-learner0=0
elif [ "$1" == "-raft" ]; then
  if [ -z $2 ]; then
    docker-compose up -d --build
  elif [ "$2" == "debug" ]; then
    docker-compose up -d --scale tiflash0=0 --build
  else
    print_usage
    exit 1
  fi
else
  print_usage
  exit 1
fi
