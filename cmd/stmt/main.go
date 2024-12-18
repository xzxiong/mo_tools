package main

import (
	"flag"
	"fmt"
	"strings"
	"time"

	"github.com/xzxiong/mo_tools/pkg/util/uuidutil"
)

const EndLine = "\n"

func main() {
	var stmtId string
	var account string
	var window uint64
	flag.StringVar(&stmtId, "stmtId", "", "statement id")
	flag.StringVar(&stmtId, "id", "", "statement id")
	flag.StringVar(&account, "account", "", "account_name")
	flag.Uint64Var(&window, "window", 0, "truncat the request_at with window (sec), if window > 0")
	flag.Parse()
	// END of command-line argument parsing

	// format stmtId
	stmtId = strings.ReplaceAll(stmtId, "_", "-")
	account = strings.ReplaceAll(account, "-", "_")
	// END format stmtId

	// format startTS
	stmtTS := uuidutil.ParseTime(stmtId)
	startTs, stopTs := stmtTS, stmtTS.Add(time.Second)
	if window > 0 {
		windowDuration := time.Duration(window) * time.Second
		startTs = stmtTS.Truncate(windowDuration)
		stopTs = startTs.Add(windowDuration)
	}
	// END startTS

	// filter condition
	filterCondition := fmt.Sprintf("statement_id = '%s'"+
		" AND request_at between FROM_UNIXTIME(%d) AND FROM_UNIXTIME(%d)",
		stmtId,
		startTs.Unix(), stopTs.Unix(),
	)
	if account != "" {
		filterCondition += fmt.Sprintf(" and account = '%s'", account)
	}
	// END filter condition

	// output
	fmt.Printf("timestamp: %v\n", stmtTS)
	fmt.Println()
	fmt.Printf("-- Query History:\n")
	fmt.Printf("SELECT * FROM system.statement_info WHERE 1=1 AND %s\n",
		filterCondition,
	)
	fmt.Println()
	fmt.Printf("-- Query CU\n")
	fmt.Printf(`SELECT
stats,
duration,
json_extract(stats, '$[8]') as cu,
CAST(mo_cu(stats, duration, "total") AS DECIMAL(32,4)) cu_total,
CAST(mo_cu(stats, duration, "cpu") AS DECIMAL(32,4)) cu_cpu,
CAST(mo_cu(stats, duration, "mem") AS DECIMAL(32,4)) cu_mem,
CAST(mo_cu(stats, duration, "ioin") AS DECIMAL(32,4)) cu_ioin,
CAST(mo_cu(stats, duration, "ioout") AS DECIMAL(32,4)) cu_ioout,
CAST(mo_cu(stats, duration, "iolist") AS DECIMAL(32,4)) cu_iolist,
CAST(mo_cu(stats, duration, "iodelete") AS DECIMAL(32,4)) cu_iodelete,
CAST(mo_cu(stats, duration, "network") AS DECIMAL(32,4)) cu_network FROM system.statement_info WHERE 1=1 AND %s
`,
		filterCondition,
	)
	fmt.Printf(EndLine)
}
