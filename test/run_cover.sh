
extra_arg="-race"
extra_arg="$extra_arg -cover  -coverprofile ./cover.profile"

cover_export() {
go test $extra_arg  \
    "github.com/matrixorigin/matrixone/pkg/util/export" 
}
cover_util() {
go test $extra_arg  \
    "github.com/matrixorigin/matrixone/pkg/util/metric" \
    "github.com/matrixorigin/matrixone/pkg/util/trace" \
    "github.com/matrixorigin/matrixone/pkg/util" \
    "github.com/matrixorigin/matrixone/pkg/logutil" \
    "github.com/matrixorigin/matrixone/pkg/util/errors" \
    "github.com/matrixorigin/matrixone/pkg/util/export" 
}

cover_batchpipe() {
go test $extra_arg  \
    "github.com/matrixorigin/matrixone/pkg/util/batchpipe"
}

cover_trace_no_cover() {
    go test "github.com/matrixorigin/matrixone/pkg/util/trace"
}
cover_trace() {
    go test $extra_arg "github.com/matrixorigin/matrixone/pkg/util/trace"
}

cover_error() {
    go test $extra_arg "github.com/matrixorigin/matrixone/pkg/common/moerr"
}

cover_test() {
    go test $extra_arg "github.com/matrixorigin/matrixone/pkg/vm/engine/tae/db" > cover.log
}


    #"github.com/matrixorigin/matrixone/pkg/txn/client" 

times=$1
if [ -z "$times" ]; then times=2; fi

count_down() {
    num=$1
    let num=$num-1
    echo $num
}

#go test $extra_arg -cover  -coverprofile  ./cover.profile "github.com/matrixorigin/matrixone/pkg/util/export"  -test.v -test.paniconexit0 -test.run "TestNewMOCollector"

#while true; do sh -x ./run_cover.sh; if [ $? -ne 0 ]; then break; fi; sleep 1; done
while true; do
set -x
   cover_util
   set +x
   #cover_trace
   #cover_batchpipe
   #cover_error
   #cover_export
   #cover_test
    if [ $? -ne 0 ]; then break; fi;
    times=`count_down $times`
        if [ "$times" -eq 0 ]; then break; fi
done

go tool cover -html=./cover.profile -o coverage.html
