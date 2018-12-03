#!/bin/bash

function print_usage() {
  echo "[bin] -no-binlog/-no-drainer/-all"
}

if [ -z $1 ] || [ "$1" == "-all" ]; then
  if [ -z $HOST_IP ]; then
    echo "You must specify env \$HOST_IP"
    exit 1
  fi
  docker-compose up --scale tidb-no-binlog0=0
elif [ "$1" == "-no-binlog" ]; then
  docker-compose up --scale zk0=0 --scale kafka0=0 --scale pump0=0 --scale tidb0=0 --scale drainer0=0
elif [ "$1" == "-no-drainer" ]; then
  docker-compose up --scale tidb-no-binlog0=0 --scale drainer0=0
else
  print_usage
  exit 1
fi
