#!/bin/bash
#/usr/local/go/bin/go tool test2json -t /private/var/folders/04/2gxhgn_53tz7232mpqt97wcm0000gn/T/GoLand/___TestStructIndexes_in_github_com_matrixorigin_matrixone_pkg_util_trace.test -test.v -test.paniconexit0 -test.run ^\QTestStructIndexes\E$


#set -x
#cd pkg/util/trace
#go test -test.v -test.paniconexit0 -test.run "Test_newBuffer2Sql_base"
export LANG="en-US"
export GOPATH="/Users/jacksonxie/go"

echo_proxy()
{
    echo "[`date '+%F %T'`] $@"
}

cleanup()
{
    rm -rf /tmp/tmp_daiufwihwidhqiwfhei.csv /tmp/tmp_xadadwhfefef.csv
}


usage()
{
    cat <<EOF
usage: $0 [testcase folder]
like:
       $0 $GOPATH/src/github.com/matrixorigin/matrixone/test/cases/function/func_anyvalue.test
or     $0 check    ## check 'report.txt' result
EOF
}

itself=`readlink -f $0`
basedir=`dirname $itself`
cd $basedir

if [ $# -eq 1 -a "$1" == "-h" ]; then
    usage
    exit 1
fi


cleanup

echo_proxy "start bvt"
set -x
if [ "$1" == "check" ]; then
    cd ../mo-tester
    pwd
    grep SUCCESS report/report.txt | grep -v 100
elif [ $# -eq 0 ]; then
    cd ../mo-tester
    pwd
    ./run.sh -n -g -p ../matrixone/test/cases 2>&1 > $basedir/bvt.log &
else
    cd ../mo-tester
    ./run.sh -n -g -p $@ && echo_proxy "done"
fi
 #./run.sh -n -g -p ../matrixone/test/cases/database/drop_database.test
 #./run.sh -n -g -p ../matrixone/test/cases/database/create_database.test
 #./run.sh -n -g -p ../matrixone/test/cases/database/new_database.test
 #./run.sh -n -g -p ../matrixone/test/cases/database
