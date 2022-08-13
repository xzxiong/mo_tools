#!/bin/bash

echo_proxy()
{
    echo "[`date '+%F %T'`] $@"
}

check_retcode() {
        code=$?
        if [ "$code" -ne "0"  ]; then
                echo_proxy "[ERROR] $@"
                exit 1
        fi
}
check_retcode_without_exit() {
        code=$?
        if [ "$code" -ne "0"  ]; then
                echo_proxy "[ERROR] $@"
                echo_proxy "continue..."
        fi
}

itself=`readlink -f $0`
basedir=`dirname $itself`
cd $basedir


echo_proxy "run ut"

st=`date +%s`
if [ -f ut.log ]; then mv ut.log{,.${st}}; fi
nohup make ut > ut.log 2>&1 &
