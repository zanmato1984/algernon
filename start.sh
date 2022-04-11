#!/bin/bash

set -e

source env.sh

function print_usage() {
  echo "usage: [VERSION=nightly] ./start.sh [dbgkv] [dbgflash | flash]"
  echo "    default: pd+tidb+tikv"
  echo "    flash: with a tiflash instance"
  echo "    dbgflash: you can start your own tiflash with 'server --config=./config/tiflash-debug.toml'"
  echo "    dbgkv: without tikv, you can start your own tikv with '--config=./config/tikv-debug.toml'"
}

# old config: ./start.sh [tiflash [-debug]]
if [ "$1" == "tiflash" ]; then
  if [ -z $2 ]; then
    docker-compose up -d --scale tiflash=1
  elif [ "$2" == "-debug" ]; then
    export_addr "TIFLASH_ADDR"
    docker-compose up -d --scale tiflash-gateway0=1
  else
    print_usage
    exit 1
  fi
# new config
else
  # default: pd+tidb+tikv
  # flash: +tiflash
  # dbgflash: +tiflash-gateway
  # dbgkv: -tikv, +tikv-gateway
  
  dbgkv=0; dbgflash=0; flash=0

  # check valid
  for arg in $*
  do
    if [ $arg == "dbgkv" ]; then dbgkv=1;
    elif [ $arg == "dbgflash" ]; then dbgflash=1;
    elif [ $arg == "flash" ]; then flash=1;
    else print_usage; exit 1
    fi
  done
  if [ "$dbgflash" == "1" ] && [ "$flash" == "1" ]; then
    print_usage; exit 1
  fi

  # construct command
  cmd="docker-compose up -d"
  if [ "$dbgkv" == "1" ]; then export_addr "TIKV_ADDR"; cmd=$cmd" --scale tikv0=0 --scale tikv-gateway0=1"; fi
  if [[ "$dbgflash" == "1" ]]; then export_addr "TIFLASH_ADDR"; cmd=$cmd" --scale tiflash-gateway0=1"; fi
  if [[ "$flash" == "1" ]]; then cmd=$cmd" --scale tiflash0=1"; fi

  $cmd
fi
