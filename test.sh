#!/bin/bash

function print_usage() {
  echo "./test.sh [-mysql-read/-tiflash-read]"
}

if [ -z $1 ]; then
  mysql -h 127.0.0.1 -P 4000 -u root -e "drop table if exists test.t; create table test.t(s varchar(256), i int); insert into test.t values('Hello world', 666)"
elif [ "$1" == "-mysql-read" ]; then
  mysql -h 127.0.0.1 -P 4000 -u root -e "select * from test.t"
elif [ "$1" == "-tiflash-read" ]; then
  docker-compose exec tiflash0 ./theflash client --host="127.0.0.1" --query="select * from test.t"
else
  print_usage
  exit 1
fi
