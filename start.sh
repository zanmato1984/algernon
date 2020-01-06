#!/bin/bash

set -e

source env.sh

function print_usage() {
  echo "./start.sh [tiflash [-debug]]"
}

if [ -z $1 ]; then
  docker-compose up -d --scale tiflash-gateway0=0 --scale tiflash0=0
  mysql -h 127.0.0.1 -P 4000 -u root -e "set @@global.tidb_row_format_version=1;"
elif [ "$1" == "tiflash" ]; then
  if [ -z $2 ]; then
    docker-compose up -d --scale tiflash-gateway0=0
  elif [ "$2" == "-debug" ]; then
    export_tiflash_addr
    docker-compose up -d --scale tiflash0=0
  else
    print_usage
    exit 1
  fi
else
  print_usage
  exit 1
fi
