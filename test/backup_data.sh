#!/bin/sh

if [ "`uname -a | grep -w Darwin | wc -l | awk '{print $1}'`" == "1" ] ; then
    alias date=gdate
fi

echo_proxy()
{
    echo "[`date '+%F %T'`] $@"
}


duration=3600
hours=48
interval=1

ts=`date +%s`
let duration=$duration*$hours
let end_ts=$ts+$duration

echo_proxy "start p.sh"
echo_proxy "end at `date -d @${end_ts} '+%F %T'`, interval $interval s"

#if [ `./p.sh | wc -l` -eq 0 ]; then
#    echo_proxy "NO process"
#    exit 1
#fi

work() {
        st=`date +'%F_%T'`
        package=tmpdir/backup/mo-data.${st}.tgz
        echo_proxy "tar to ${package}"
        tar zcfv ${package} mo-data mo-service.log
}

while [ "$ts" -lt "$end_ts" ];
do
    ts=`date +%s`
    if work; then
        break
    fi
    sleep $interval
done

echo_proxy "done"
