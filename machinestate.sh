#!/usr/bin/env bash

ARCH="#Architecture: " "uname -a"
CPU="#CPU Physical: " "cat /proc/cpuinfo | grep "physical id" | wc -l"
VCPU="#vCPU: " "cat /proc/cpuinfo | grep "processor" | wc -l"
MEM_U="#Memory Usage: " "free --mega | grep Mem | awk '{ printf("%d/%dMB (%.2f%%)\n", $3, $2, $3/$2 * 100.0) }'"
DISK_U="#Disk Usage: " "df --total -h | grep total | awk '{ printf("%.2f/%sB (%s)\n", $3, $2, $5)}'"
CPU_LD="#CPU Load: " "mpstat 1 1 | tail -1 | awk '{printf("%.1f%%\n", 100-$12)}'"
LS_BOOT="#Last Boot: " "who -b | awk '{print $3 " " $4}'"
LVM_USE="#LVM use: " "if [[ $(cat /etc/fstab | grep "LVM" | wc -l) > 0 ]] then echo "yes"; else echo "no"; fi"
TCP="#TCP Connections: " "echo $(ss -ta | grep ESTAB | wc -l) | awk  '{ printf("%d ESTABLISHED\n", $1) }'"
USER_LOG="#Users logged0: " "users | wc -w"
NETWORK="#Network: "

echo $(ip link | grep "ether" | awk '{ print $2 }') | echo $(hostname -I) | awk '{printf("%s %s\n", $1, $2)}'
WIP
SUDO="#Sudo: "


if	[[ 1 ]]; then
	echo "Hello World"
fi
