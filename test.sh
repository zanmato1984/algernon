#!/bin/bash

function print_usage() {
  echo "./test.sh [hw/ycsb/mysql-q query/tiflash-q query]"
}

MYSQL_HOST="192.168.65.2"

if [ -z "$1" ]; then
  print_usage
  exit 1
elif [ "$1" == "hw" ]; then
  mysql -h 127.0.0.1 -P 4000 -u root -e "drop table if exists test.t; create table test.t(s varchar(256), i int); insert into test.t values('Hello world', 666)"
elif [ "$1" == "ycsb" ]; then
  docker run --rm pingcap/go-ycsb load mysql -p mysql.host=$MYSQL_HOST -p mysql.port=4000 -p mysql.user=root -p recordcount=10000 -p operationcount=1000
  docker run --rm pingcap/go-ycsb run mysql -p mysql.host=$MYSQL_HOST -p mysql.port=4000 -p mysql.user=root -p recordcount=10000 -p operationcount=1000
elif [ "$1" == "mysql-q" ]; then
  if [ -z "$2" ]; then
    print_usage
    exit 1
  else
    mysql -h 127.0.0.1 -P 4000 -u root -e "$2"
  fi
elif [ "$1" == "tiflash-q" ]; then
  if [ -z "$2" ]; then
    print_usage
    exit 1
  else
    docker-compose exec tiflash0 ./tics/theflash client --host="127.0.0.1" --query="$2"
  fi
else
  print_usage
  exit 1
fi
