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



echo_proxy "run ut"
nohup make ut > ut.log &
#check_retcode "failed to ut"

