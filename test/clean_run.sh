#!/bin/bash
#/usr/local/go/bin/go tool test2json -t /private/var/folders/04/2gxhgn_53tz7232mpqt97wcm0000gn/T/GoLand/___TestStructIndexes_in_github_com_matrixorigin_matrixone_pkg_util_trace.test -test.v -test.paniconexit0 -test.run ^\QTestStructIndexes\E$


#set -x
#cd pkg/util/trace
#go test -test.v -test.paniconexit0 -test.run "Test_newBuffer2Sql_base"

echo_proxy()
{
    echo "[`date '+%F %T'`] $@"
}

echo_proxy "exec stop"
./stop.sh

echo_proxy "start compile"
make clean; make build

echo_proxy "stop running mo-servcie"
st=`date +%s`
mv store{,.${st}}
mv mo-data{,.${st}}
rm -rf node-{1,2,3}-data

echo_proxy "start running"
./start.sh

echo_proxy "Done."


