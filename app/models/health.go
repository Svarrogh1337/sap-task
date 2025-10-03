package models

import (
	"github.com/shirou/gopsutil/host"
	"time"
)

type SysInfoData struct {
	Hostname             string
	Uptime               uint64
	Platform             string
	PlatformFamily       string
	PlatformVersion      string
	VirtualizationSystem string
	VirtualizationRole   string
	DateTime             time.Time
}

func SysInfo() (SysInfoData, error) {
	hostStat, _ := host.Info()
	sysinfo := SysInfoData{
		Hostname:             hostStat.Hostname,
		Uptime:               hostStat.Uptime,
		Platform:             hostStat.Platform,
		PlatformFamily:       hostStat.PlatformFamily,
		PlatformVersion:      hostStat.PlatformVersion,
		VirtualizationSystem: hostStat.VirtualizationSystem,
		VirtualizationRole:   hostStat.VirtualizationRole,
		DateTime:             time.Now(),
	}
	return sysinfo, nil
}
