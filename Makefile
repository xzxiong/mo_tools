
## whoami
##################
ROOT_DIR = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BIN_NAME := mo-service
UNAME_S := $(shell uname -s)
GOPATH := $(shell go env GOPATH)
GO_VERSION=$(shell go version)
BRANCH_NAME=$(shell git rev-parse --abbrev-ref HEAD)
LAST_COMMIT_ID=$(shell git rev-parse --short HEAD)
BUILD_TIME=$(shell date +%s)
MO_VERSION=$(shell git describe --always --tags $(shell git rev-list --tags --max-count=1))
GO_MODULE=$(shell go list -m)


## base const
##################
RACE_OPT :=
DEBUG_OPT :=
CGO_DEBUG_OPT :=
#CGO_OPTS=CGO_CFLAGS="-I$(ROOT_DIR)/cgo " CGO_LDFLAGS="-L$(ROOT_DIR)/cgo -lmo -lm"
CGO_OPTS :=
GOLDFLAGS=-ldflags="-X '$(GO_MODULE)/pkg/version.GoVersion=$(GO_VERSION)' -X '$(GO_MODULE)/pkg/version.BranchName=$(BRANCH_NAME)' -X '$(GO_MODULE)/pkg/version.CommitID=$(LAST_COMMIT_ID)' -X '$(GO_MODULE)/pkg/version.BuildTime=$(BUILD_TIME)' -X '$(GO_MODULE)/pkg/version.Version=$(MO_VERSION)'"


## target
##################
BIN_STMT=./bin/stmt

# build mo-service binary for debugging with go's race detector enabled
# produced executable is 10x slower and consumes much more memory
.PHONY: debug
debug: override BUILD_NAME := debug-binary
debug: override RACE_OPT := -race
debug: override DEBUG_OPT := -gcflags=all="-N -l"
debug: override CGO_DEBUG_OPT := debug
debug: build

build: stmt

.PHONY: stmt
stmt:
	go build  $(RACE_OPT) $(GOLDFLAGS) $(DEBUG_OPT) -o $(BIN_STMT) ./cmd/stmt

## clean
##################
clean:
	rm -rf $(BIN_STMT)
