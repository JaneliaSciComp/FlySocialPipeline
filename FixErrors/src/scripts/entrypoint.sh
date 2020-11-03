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

helpmsg="Run\n\n\
  [--include-touch]
"

umask 0002

appName="fixerrors"

includeTouch=false
other_args=()

while [[ $# > 0 ]]; do
    key="$1"
    shift # past the key
    case ${key} in
        -h|--help)
            printf "${helpmsg}"
            exit 0
            ;;
        --include-touch)
            includeTouch=true
            ;;
        *) # for anything else run the step
            other_args=("${other_args[@]}" ${key})
            ;;
    esac
done

cmd="/app/${appName} includeTouch ${includeTouch}"
echo "Run ${cmd}"
$cmd
