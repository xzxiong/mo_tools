package uuidutil

import (
	"time"

	"github.com/google/uuid"
)

func ParseTime(uuidStr string) time.Time {
	parseUuid := func(uuidStr string) time.Time {
		return time.Unix(uuid.Must(uuid.Parse(uuidStr)).Time().UnixTime())
	}
	return parseUuid(uuidStr)
}
