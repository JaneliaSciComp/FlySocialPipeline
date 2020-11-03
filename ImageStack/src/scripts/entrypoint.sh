#!/usr/bin/env bash

if [[ "$USE_MCR_CACHE" = true ]] ; then
  if [ -d /scratch ] ; then
    export MCR_CACHE_ROOT="/scratch/${USER}/mcr_cache_$$"
  else
    export MCR_CACHE_ROOT=`mktemp -u`
  fi
  [ -d ${MCR_CACHE_ROOT} ] || mkdir -p ${MCR_CACHE_ROOT}
  echo "Use MCR_CACHE_ROOT ${MCR_CACHE_ROOT}"
fi

helpmsg="<experiment directory path> <filter value: 0|1> <path to xml config> <path to deepID_values config>"

if [ $# == 0 ] ; then
    echo "${helpmsg}"
    exit 1
fi

umask 0002

appName="ImageStack"
flag="$1"

case ${flag} in
     -h|--help)
        echo "${helpmsg}"
        exit 0
        ;;
     *) # for anything else run the step
        /app/${appName} "$@"
        exit 0
        ;;
esac
