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

helpmsg="Run <options> \n\n\
Command line options:\n\
  -e <experiment folder> \n\
  -jab <single jab file> \n\
  -jl <jab list file> \n\
  [--dtfe-append {classified|errors}]
"

if [ $# == 0 ] ; then
    printf "${helpmsg}"
    exit 1
fi

umask 0002

appName="JAABADetect"

experimentDir=
jabFile=
jabListFile=
other_args=()
dtfeAppend=

while [[ $# > 0 ]]; do
    key="$1"
    shift # past the key
    case ${key} in
        -h|--help)
            printf "${helpmsg}"
            exit 0
            ;;
        -e|--experiment-dir)
            experimentDir="$1"
            shift
            ;;
        -jab)
            jabFile="$1"
            shift
            ;;
        -jl|--jab-list-file)
            jabListFile="$1"
            shift
            ;;
        --dtfe-append)
            if [[ "$1" =~ "errors" || "$1" =~ "-1" ]] ; then
                dtfeAppend="-1"
            elif [[ "$1" =~ "classified" || "$1" =~ "1" ]] ; then
                dtfeAppend="1"
            else
                # default - append to errors array
                dtfeAppend="1"
            fi
            shift
            ;;
        *) # for anything else run the step
            other_args=("${other_args[@]}" ${key})
            ;;
    esac
done

if [[ "${experimentDir}" != "" ]] ; then
    cmd_args=(${experimentDir} "${cmd_args[@]}")
fi

if [[ "${jabFile}" != "" ]] ; then
    cmd_args=("${cmd_args[@]}" "jabfiles" ${jabFile})
fi

if [[ "${jabListFile}" != "" ]] ; then
    cmd_args=("${cmd_args[@]}" "jablistfile" ${jabListFile})
fi

echo "Run: /app/${appName} ${cmd_args[@]}"
/app/${appName} "${cmd_args[@]}"
echo "Finished running: /app/${appName} ${cmd_args[@]}"

if [[ "${dtfeAppend}" != "" ]] ; then
    echo "Run dtfe_append ${experimentDir} ${dtfeAppend}"
    /app/dtfe_append ${experimentDir} ${dtfeAppend}
    echo "Finished running dtfe_append ${experimentDir} ${dtfeAppend}"
else
    echo "No dtfe_append required"
fi
