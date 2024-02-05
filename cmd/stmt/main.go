package main

import (
	"flag"
	"fmt"
	"github.com/xzxiong/mo_tools/pkg/util/uuidutil"
	"strings"
)

const EndLine = "\n"

func main() {
	var stmtId string
	var account string
	flag.StringVar(&stmtId, "stmtId", "", "statement id")
	flag.StringVar(&account, "account", "", "account_name")
	flag.Parse()
	// END of command-line argument parsing

	// format stmtId
	stmtId = strings.ReplaceAll(stmtId, "_", "-")
	account = strings.ReplaceAll(account, "-", "_")
	// END format stmtId

	stmtTS := uuidutil.ParseTime(stmtId)
	fmt.Printf("timestamp: %v\n", stmtTS)
	fmt.Printf("Result:\n")
	fmt.Printf("select * from system.statement_info where statement_id = '%s'"+
		" and request_at between UNIX_TIMESTAMP(%d) and UNIX_TIMESTAMP(%d)",
		stmtId,
		stmtTS.Unix(), stmtTS.Unix()+1,
	)
	if account != "" {
		fmt.Printf(" and account = '%s'", account)
	}
	fmt.Printf(EndLine)
}
