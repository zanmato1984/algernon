#!/bin/bash

function print_usage() {
  echo "[bin] -raft [ycsb]/-pump/-binlog/-hw"
}

if [ -z $1 ]; then
  docker-compose up -d --scale tikv-learner0=0 --scale pump0=0 --scale tidb-binlog0=0 --scale drainer0=0
elif [ "$1" == "-raft" ]; then
  if [ -z $2 ]; then
    docker-compose up -d --scale pump0=0 --scale tidb-binlog0=0 --scale drainer0=0
  elif [ "$2" == "ycsb" ]; then
    docker-compose -f docker-compose-go-ycsb.yaml run go-ycsb0 load mysql -P /go-ycsb.conf -p mysql.host=tidb0 -p mysql.port=4000 -p mysql.user=root
    docker-compose -f docker-compose-go-ycsb.yaml run go-ycsb0 run mysql -P /go-ycsb.conf -p mysql.host=tidb0 -p mysql.port=4000 -p mysql.user=root
  else
    print_usage
    exit 1
  fi
elif [ "$1" == "-pump" ]; then
  docker-compose up -d --scale tikv-learner0=0 --scale tidb0=0 --scale drainer0=0
elif [ "$1" == "-binlog" ]; then
  if [ -z $HOST_IP ]; then
    echo "You must specify env \$HOST_IP"
    exit 1
  fi
  docker-compose up -d --scale tikv-learner0=0 --scale tidb0=0
elif [ "$1" == "-hw" ]; then
  mysql -h 127.0.0.1 -P 4000 -u root -e "drop table if exists test.t; create table test.t(s varchar(256), i int); insert into test.t values('Hello world', 666)"
else
  print_usage
  exit 1
fi
