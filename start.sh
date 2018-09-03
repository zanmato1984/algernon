#!/bin/bash

function print_usage() {
  echo "[bin] -kafka-only/-no-binlog/-no-drainer/-all"
}

if [ -z $1 ] || [ "$1" == "-all" ]; then
  if [ -z $HOST_IP ]; then
    echo "You must specify env \$HOST_IP"
    exit 1
  fi
  docker-compose up --scale tidb1=0
elif [ "$1" == "-kafka-only" ]; then
  docker-compose up --scale pd0=0 --scale tikv0=0 --scale pump0=0 --scale tidb0=0 --scale tidb1=0 --scale drainer0=0
elif [ "$1" == "-no-binlog" ]; then
  docker-compose up --scale zk0=0 --scale kafka0=0 --scale pump0=0 --scale tidb0=0 --scale drainer0=0
elif [ "$1" == "-no-drainer" ]; then
  docker-compose up --scale tidb1=0 --scale drainer0=0
else
  print_usage
  exit 1
fi
