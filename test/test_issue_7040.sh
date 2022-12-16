#!/bin/sh

itself=`greadlink -f $0`
basedir=`dirname $itself`
cd $basedir

if [ "`uname -a | grep -w Darwin | wc -l | awk '{print $1}'`" == "1" ] ; then
    alias date=gdate
fi

echo_proxy()
{
    echo "[`date '+%F %T'`] $@"
}


duration=3600
hours=8
interval=30

ts=`date +%s`
let duration=$duration*$hours
let end_ts=$ts+$duration

echo_proxy "start p.sh"
echo_proxy "end at `date -d @${end_ts} '+%F %T'`, interval $interval s"


check_prepare() {
if [ `./p.sh | wc -l` -eq 0 ]; then
    echo_proxy "NO process"
    exit 1
fi
}

work() {
        # clean_dir
        sh clean_dir.sh
        # start
        sh clean_run.sh dist_cn
        # check access
        sh check_access.sh
        # wait 5 min
        echo_proxy "sleep $interval"
        sleep $interval
        # check process
        sh p.sh
        sh check_access.sh
        # packge log and mo-data
        st=`date +%s`
        package=tmpdir/issue_7040/mo-data.${st}.tgz
        echo_proxy "tar to ${package}"
        tar zcfv ${package} mo-data mo-service.log
        # find panic in mo-service.log
        echo_proxy "try to find panic in log"
        grep "panic" mo-service.log -A 5
        # rm log and mo-data
        echo_proxy "rm log and mo-data"
        rm -rf mo-data mo-service.log
}

while [ "$ts" -lt "$end_ts" ];
do
    ts=`date +%s`
    #if work; then
    #    break
    #fi
    work
    sleep $interval
done

echo_proxy "done"
