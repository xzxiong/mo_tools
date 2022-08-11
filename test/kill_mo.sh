#!/bin/bash

kill_mo() {
    pid=$1
    ps -ef | grep -w "$pid"| grep -v grep
    #ps -ef | grep -w "$pid"| grep -v grep | wc -l
    if [ "`ps -ef | grep -w "$pid"| grep -v grep  | wc -l | awk '{print $1}'`" == "1" ] ; then
        set -x
        kill -SIGTERM $pid
    fi
}


ps -eo 'pid,ppid,user,command'  | grep -E "mo-server|matrixone_cmd_db_server" | while read pid ppid user cmd _other;
do
    [ `basename $cmd` == "go_build_github_com_matrixorigin_matrixone_cmd_db_server" ] && kill_mo $pid;
    [ `basename $cmd` == "mo-server" ] && kill_mo $pid
done;
#kill -SIGTERM $pid
