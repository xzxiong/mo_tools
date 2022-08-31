#!/bin/bash

itself=`readlink -f $0`
basedir=`dirname $itself`

cd $basedir

usage() {
    cat << EOF
usage: $0 [branch]
like:
       $0 service
options:
    branch   - val in [service, server], default: service, 
EOF
}

if [ "$1" == "-h" -o "$1" == "--help" ]; then
    usage
    exit 1
fi

branch=$1
if [ -z "$branch" ]; then branch=service; fi
if [ "$branch" != "server" -a "$branch" != "service" ]; then usage; exit 1; fi

ulimit -n 102400
if [ "$branch" == "server" ]; then
    nohup ./mo-server ./system_vars_config.toml > ./mo-server.log 2>mo-server.err &
elif [ "$branch" == "service" ]; then
    ./mo-service -cfg ./etc/cn-standalone-test.toml &>mo-service.log &
#    ./mo-service -cfg ./cn-s3-test.toml &>mo-service.log &
else
    usage
    exit 1
fi
