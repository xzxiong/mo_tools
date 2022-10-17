#!/bin/bash

get_itself() {
    if [ "`uname -a | grep -w Darwin | wc -l | awk '{print $1}'`" == "1" ] ; then
        greadlink -f $0
    else
        readlink -f $0
    fi
}


default_branch=dist
itself=`get_itself`
basedir=`dirname $itself`
cd $basedir

log_file=mo-service.log
max_file_cnt=10
function shrink_file()
{
    ## Usage: shrink_file <log_file> <max_file_cnt>
    ## input
    local file=$1
    local max_file_cnt=$2
    if [ ! -f $file  ];then
        return 1
    fi
    if [ -z "$max_file_cnt" ]; then
        max_file_cnt=10
    fi
    ## main
    local file_size=0
    if [ "`uname -a | grep -w Darwin | wc -l | awk '{print $1}'`" == "1" ] ; then
        file_size=`du -k $file | awk '{print $1}'`
        let file_size=$file_size*1024
    else
        file_size=`du -b $file | awk '{print $1}'`
    fi
    if [ $? -ne 0  ];then
        return 2
    fi
    max_size=32000000  #32M
    if [ $file_size -lt $max_size  ];then
        return 3
    fi
    for ((idx=$max_file_cnt-1;idx>0;idx--))
    do
        let next_idx=$idx+1
        local src_file="${file}.${idx}"
        local dst_file="${file}.${next_idx}"
        [ -e "$src_file" ] && mv "${src_file}" "${dst_file}"
    done
    [ -e "$file" ] && mv ${file} ${file}.1
    return 0
}
shrink_file $log_file $max_file_cnt

usage() {
    cat << EOF
usage: $0 [branch]
like:
       $0 service
options:
    branch   - val in [service, s3, server], default: $default_branch
               s3: means start service with s3 etl
               dist: run districuted mode in one process.
EOF
}

if [ "$1" == "-h" -o "$1" == "--help" ]; then
    usage
    exit 1
fi

branch=$1
if [ -z "$branch" ]; then branch=$default_branch; fi

ulimit -n 102400
case "$branch" in
    server)
        nohup ./mo-server ./system_vars_config.toml > ./mo-server.log 2>mo-server.err &
        ;;
    service)
        ./mo-service -cfg ./etc/cn-standalone-test.toml &>mo-service.log &
        ;;
    s3|S3)
        ./mo-service -cfg ./cn-s3-test.toml &>mo-service.log &
        ;;
    log|logservice)
        [ ! -d store ] && mkdir store
        touch store/thisisalocalfileservicedir
        ./mo-service -cfg ./log-test.toml &> log-service.log &
        ;;
    dn|DN)
        [ ! -d store ] && mkdir store
        touch store/thisisalocalfileservicedir
        ./mo-service -cfg ./dn-test.toml &> dn-service.log &
        ;;
    debug)
        [ ! -d store ] && mkdir store
        touch store/thisisalocalfileservicedir
        ./mo-service -cfg ./cn-debug.toml &> mo-service.log &
        ;;
    dist)
        ./mo-service -launch ./etc/launch-tae-logservice/launch.toml &>mo-service.log &
        ;;
    *)
        echo "[ERROR] unknown [branch]: $branch"
        usage
        exit 1
        ;;
esac
