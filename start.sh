#!/bin/bash

function print_usage() {
  echo "[bin] -raft/-pump/-binlog"
}

if [ -z $1 ]; then
  docker-compose up --scale tikv-learner0=0 --scale pump0=0 --scale tidb-raft0=0 --scale tidb-binlog0=0 --scale drainer0=0
elif [ "$1" == "-raft" ]; then
  docker-compose up --scale pump0=0 --scale tidb0=0 --scale tidb-binlog0=0 --scale drainer0=0
elif [ "$1" == "-pump" ]; then
  docker-compose up --scale tikv-learner0=0 --scale tidb-raft0=0 --scale tidb0=0 --scale drainer0=0
elif [ "$1" == "-binlog" ]; then
  if [ -z $HOST_IP ]; then
    echo "You must specify env \$HOST_IP"
    exit 1
  fi
  docker-compose up --scale tikv-learner0=0 --scale tidb-raft0=0 --scale tidb0=0
else
  print_usage
  exit 1
fi
