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
  -e <experiment folder - movie file name defaults to movie.avi> \n\
  -xml <xml config - Clstr3R_params.xml | Clstr3R_params45000.xml> \n\
  -s <settings folder containing appdata.mat and roidata.mat> \n\
  -trx <path to manually corrected data to run with correction enabled> \n\
"

if [ $# == 0 ] ; then
    printf "${helpmsg}"
    exit 1
fi

umask 0002

appName="DuoTrax"

movieFile=
xmlParams=
settingsDir=
trxCorrections=
appDataFile=
roiFile=
other_args=()

while [[ $# > 0 ]]; do
    key="$1"
    shift # past the key
    case ${key} in
        -h|--help)
            printf "${helpmsg}"
            exit 0
            ;;
        -e|--experiment-dir)
            movieFile="$1/movie.avi"
            shift
            ;;
        --movie)
            movieFile="$1"
            shift
            ;;
        -xml|--xml-config)
            xmlParams="$1"
            shift
            ;;
        -s|--settings-dir)
            settingsDir="$1"
            shift
            ;;
        -af)
            appDataFile="$1"
            shift
            ;;
        -rf)
            roiFile="$1"
            shift
            ;;
        -trx|--trx-corrected-data)
            trxCorrections="$1"
            shift
            ;;
        *) # for anything else run the step
            other_args=("${other_args[@]}" ${key})
            ;;
    esac
done

if [[ "${movieFile}" != "" ]] ; then
    cmd_args=("${cmd_args[@]}" "movFile" ${movieFile})
fi

if [[ "${xmlParams}" != "" ]] ; then
    cmd_args=("${cmd_args[@]}" "trackXMLfile" ${xmlParams})
fi

if [[ "${settingsDir}" != "" ]] ; then
    cmd_args=("${cmd_args[@]}" "settingsDir" ${settingsDir})
fi

if [[ "${appDataFile}" != "" ]] ; then
    cmd_args=("${cmd_args[@]}" "appDataFile" ${appDataFile})
fi

if [[ "${roiFile}" != "" ]] ; then
    cmd_args=("${cmd_args[@]}" "roiFile" ${roiFile})
fi

if [[ "${trxCorrections}" != "" ]] ; then
    cmd_args=("${cmd_args[@]}" "trxFileFixed" ${trxCorrections})
fi

echo "Run: /app/${appName} ${cmd_args[@]}"
/app/${appName} "${cmd_args[@]}"
