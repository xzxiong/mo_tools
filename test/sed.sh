


test_sed() {
    file=$1
    sed -i '' 's/^\t*fmt.Print.*\\n")/&asdf/g'  $file
    sed -i '' 's/\\n")asdf/")/g' $file

    sed -i '' 's/^\t*fmt.Print.*\\n",/&asdf/g'  $file
    sed -i '' 's/\\n",asdf/",/g' $file

    sed -i '' 's/^\t*fmt.Println/logutil.Info/g'  $file
    sed -i '' 's/^\t*fmt.Print/logutil.Info/g'  $file

#    sed -i '' 's/"fmt"//g' $file

    gofmt -s -w $file

    #if [ "` grep -w fmt $file | wc -l | awk '{print $1}'`" == "1" ] ; then
    #    echo "WARNING"
    #    echo "WARN: still have fmt in: $file"
    #    echo "WARNING"
    #    exit 1
    #fi

}

## append
while read file position
do
    if [[ "$file" =~ "#" ]]; then echo "pass append: $file"; continue; fi

    position="${position//\"/}"

    sed -i '' 's;"'$position'";&\n"github.com/matrixorigin/matrixone/pkg/logutil";g' $file
#sed -i '' 's;"github.com/matrixorigin/matrixone/pkg/defines";&\n"github.com/matrixorigin/matrixone/pkg/logutil";g' pkg/frontend/mysql_protocol_test.go
done << EOF
#pkg/frontend/mysql_protocol_test.go         "github.com/matrixorigin/matrixone/pkg/defines"
#pkg/hakeeper/checkers/coordinator_test.go   "github.com/matrixorigin/matrixone/pkg/hakeeper"
#pkg/util/batchpipe/batch_pipe_test.go       "github.com/stretchr/testify/assert"
#pkg/hakeeper/checkers/logservice/check_test.go  "github.com/matrixorigin/matrixone/pkg/hakeeper"
#pkg/common/bitmap/bitmap_test.go    github.com/stretchr/testify/require
##pkg/sql/parsers/example/eg_mysql.go  github.com/matrixorigin/matrixone/pkg/sql/parsers/dialect
pkg/vm/engine/tae/common/interval.go    sync/atomic
pkg/vm/engine/tae/common/intervals.go   sort
pkg/vm/engine/tae/logstore/driver/batchstoredriver/file.go  github.com/matrixorigin/matrixone/pkg/vm/engine/tae/logstore/driver/entry
EOF

## replace
while read file;
do 
    if [[ "$file" =~ "#" ]]; then echo "pass replace: $file"; continue; fi
sed -i '' 's;"fmt";"github.com/matrixorigin/matrixone/pkg/logutil";g' $file
done << EOF
pkg/sql/compile/scope.go
cmd/mo-service/version.go
pkg/vm/engine/tae/common/intervals.go
#./pkg/compress/compress_test.go
#pkg/frontend/load_test.go
#pkg/frontend/mysql_protocol_test.go
#pkg/sql/parsers/example/eg_mysql.go
EOF

## remove
while read file;
do
    if [[ "$file" =~ "#" ]]; then echo "pass remove: $file"; continue; fi
    sed -i '' 's;"fmt";;g' $file
done << EOF
pkg/cnservice/tae.go
./pkg/frontend/server.go
#pkg/frontend/load_test.go
#pkg/frontend/iopackage_test.go
#pkg/hakeeper/checkers/coordinator_test.go
#pkg/hakeeper/checkers/logservice/check_test.go
#pkg/hakeeper/checkers/logservice/parse_test.go
#pkg/container/types/datetime_test.go
EOF


## special
#sed -i '' 's;logutil.Info(time;logutil.Infof("%v", time;g' pkg/util/batchpipe/batch_pipe_test.go


## main
##############################
cat filelist | while read file;
do
    if [[ "$file" =~ "_test.go" ]]; then echo "pass testfile: $file"; continue; fi
    if [[ "$file" =~ "example" ]]; then echo "pass example: $file"; continue; fi
    if [[ "$file" =~ "version.go" ]]; then echo "pass file: $file"; continue; fi
    if [[ "$file" =~ "goyacc.go" ]]; then echo "pass tool: $file"; continue; fi
#    test_sed cmd/mo-service/version.go
#    test_sed pkg/frontend/server.go
#    exit 1

    test_sed $file

    #sed -i '' 's/\\n//g' $file
    #sed -i '' 's/fmt.Print/loguitl.Debug/g' $file

done

## special after all replase
while read file;
do
    if [[ "$file" =~ "#" ]]; then echo "pass in test.file: $file"; continue; fi
sed -i '' 's;logutil.Infof;t.Logf;g' $file
sed -i '' 's;logutil.Info;t.Log;g' $file
done << EOF
#pkg/container/types/datetime_test.go
#pkg/frontend/mysql_protocol_test.go
#pkg/common/bitmap/bitmap_test.go
#pkg/hakeeper/bootstrap/bootstrap_test.go
EOF

#sed -i '' 's;t := FromCalendar;d := FromCalendar;g' pkg/container/types/datetime_test.go
#sed -i '' 's;:= t\.;:= d\.;g' pkg/container/types/datetime_test.go
#sed -i '' 's;logutil.Info(err);logutil.Infof("%v", err);g'  pkg/sql/parsers/example/eg_mysql.go
sed -i '' 's;logutil.Info(line);logutil.Infof("%v", line);g'  pkg/frontend/init_db.go


#git diff --color-words
set -x
CGO_CFLAGS="-I/Users/jacksonxie/go/src/github.com/matrixorigin/matrixone/cgo" CGO_LDFLAGS="-L/Users/jacksonxie/go/src/github.com/matrixorigin/matrixone/cgo -lmo -lm" golangci-lint run -c .golangci.yml ./...
