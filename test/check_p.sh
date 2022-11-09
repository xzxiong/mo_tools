#!/bin/bash


echo_proxy()
{
    echo "[`date '+%F %T'`] $@"
}


duration=3600
hours=48
interval=5

ts=`date +%s`
let duration=$duration*$hours
let end_ts=$ts+$duration

echo_proxy "start p.sh"
echo_proxy "end at `date -d @${end_ts} '+%F %T'`"

work() {
    echo_proxy "datetime"
    ./p.sh
    return 0
}

while [ "$ts" -lt "$end_ts" ];
do
    ts=`date +%s`
    work
    sleep $interval
done

echo_proxy "done"
