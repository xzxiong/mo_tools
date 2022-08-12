#!/bin/bash

work() {
    pid=$1
    ps -ef | grep -w "$pid"| grep -v grep
}


ps -eo 'pid,ppid,user,command'  | grep -E "mo-server|matrixone_cmd_db_server" | while read pid ppid user cmd _other;
do
    [ `basename $cmd` == "go_build_github_com_matrixorigin_matrixone_cmd_db_server" ] && work $pid;
    [ `basename $cmd` == "mo-server" ] && work $pid
done;
#kill -SIGTERM $pid
