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


echo_proxy "start build debug"
make clean; make debug
check_retcode "make failed"

echo_proxy "static-check"
make static-check
check_retcode "failed to static-check"

echo_proxy "run ut"
make ut > ut.log
check_retcode "failed to ut"

sh ./kill_mo.sh
check_retcode "failed to kill"

echo_proxy "start bvt"
sh ./start_mo.sh && sleep 5 && ./run_bvt.sh
