#!/bin/bash

function print_usage() {
  echo "[bin] -raft/-hw"
}

if [ -z $1 ]; then
  docker-compose up -d --scale tikv-learner0=0
elif [ "$1" == "-raft" ]; then
  docker-compose up -d
elif [ "$1" == "-hw" ]; then
  mysql -h 127.0.0.1 -P 4000 -u root -e "drop table if exists test.t; create table test.t(s varchar(256), i int); insert into test.t values('Hello world', 666)"
else
  print_usage
  exit 1
fi
