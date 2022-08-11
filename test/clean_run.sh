#!/bin/bash
#/usr/local/go/bin/go tool test2json -t /private/var/folders/04/2gxhgn_53tz7232mpqt97wcm0000gn/T/GoLand/___TestStructIndexes_in_github_com_matrixorigin_matrixone_pkg_util_trace.test -test.v -test.paniconexit0 -test.run ^\QTestStructIndexes\E$


#set -x
#cd pkg/util/trace
#go test -test.v -test.paniconexit0 -test.run "Test_newBuffer2Sql_base"

echo_proxy()
{
    echo "[`date '+%F %T'`] $@"
}

echo_proxy "start compile"
make build

echo_proxy "start running"
rm -rf store/
mkdir store
./mo-server ./system_vars_config.toml > store/mo.log

echo_proxy "Done."


