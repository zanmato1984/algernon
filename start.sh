#!/bin/bash

function print_usage() {
  echo "[bin] -raft/-pump/-binlog"
}

if [ -z $1 ]; then
  docker-compose up -d --scale tikv-learner0=0 --scale pump0=0 --scale tidb-raft0=0 --scale tidb-binlog0=0 --scale drainer0=0
elif [ "$1" == "-raft" ]; then
  docker-compose up -d --scale pump0=0 --scale tidb0=0 --scale tidb-binlog0=0 --scale drainer0=0
elif [ "$1" == "-raft1" ]; then
  docker-compose up -d --scale pump0=0 --scale tidb0=0 --scale tidb-raft0=0 --scale tidb-binlog0=0 --scale drainer0=0
elif [ "$1" == "-raft2" ]; then
  docker-compose exec pd0 /pd-ctl -d op add add-learner 2 4
  docker-compose exec pd0 /pd-ctl -d config set max-merge-region-keys 0
  docker-compose exec pd0 /pd-ctl -d config set max-merge-region-value 0
elif [ "$1" == "-raft3" ]; then
  docker-compose run -d tidb-raft0
elif [ "$1" == "-pump" ]; then
  docker-compose up -d --scale tikv-learner0=0 --scale tidb-raft0=0 --scale tidb0=0 --scale drainer0=0
elif [ "$1" == "-binlog" ]; then
  if [ -z $HOST_IP ]; then
    echo "You must specify env \$HOST_IP"
    exit 1
  fi
  docker-compose up -d --scale tikv-learner0=0 --scale tidb-raft0=0 --scale tidb0=0
else
  print_usage
  exit 1
fi
