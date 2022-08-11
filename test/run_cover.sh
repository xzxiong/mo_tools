
extra_arg="-race"
extra_arg="$extra_arg -cover  -coverprofile ./cover.profile"

set -x
go test $extra_arg  \
    "github.com/matrixorigin/matrixone/pkg/util/trace" \
    "github.com/matrixorigin/matrixone/pkg/util" \
    "github.com/matrixorigin/matrixone/pkg/logutil" \
    "github.com/matrixorigin/matrixone/pkg/util/errors" \
    "github.com/matrixorigin/matrixone/pkg/util/export" 
#    "github.com/matrixorigin/matrixone/pkg/util/batchpipe" 
#go tool cover -html=./cover.profile -o coverage.html


#go test $extra_arg -cover  -coverprofile  ./cover.profile "github.com/matrixorigin/matrixone/pkg/util/export"  -test.v -test.paniconexit0 -test.run "TestNewMOCollector"
