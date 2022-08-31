

work() {
    pid=$1
    gops stack $pid
}


ps -eo 'pid, ppid, user, command'  | grep -E "mo-server|matrixone_cmd_db_server|export.test|batchpipe.test" | while read pid ppid user cmd _other;
do
    [ `basename $cmd` == "go_build_github_com_matrixorigin_matrixone_cmd_db_server" ] && work $pid;
    [ `basename $cmd` == "mo-server" ] && work $pid
    [[ `basename $cmd` =~ "export.test" ]] && work $pid
    [[ `basename $cmd` =~ "batchpipe.test" ]] && work $pid
done;
#kill -SIGTERM $pid
