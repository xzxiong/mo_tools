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


echo_proxy "start build debug"
make clean; make debug
#make clean; make build
check_retcode "make failed"

echo_proxy "static-check"
make static-check
check_retcode_without_exit "failed to static-check"

echo_proxy "run ut"
make ut > ut.log
check_retcode_without_exit "failed to ut"

sh ./stop.sh
check_retcode "failed to kill"

echo_proxy "start bvt"
st=`date +%s`
mv store{,.${st}}
sh ./start.sh && sleep 5 && ./run_bvt.sh

