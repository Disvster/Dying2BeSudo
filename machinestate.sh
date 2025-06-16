#!/usr/bin/env bash

ARCH="#Architecture: " "uname -a"
CPU="#CPU Physical: " "nproc --all" # OR 16 if physical processors in host machine
VCPU="#vCPU: " "nproc --all" # virtual CPU is only one
MEM_U="#Memory Usage: "
DISK_U="#Disk Usage: "
CPU_LD="#CPU Load: "
LS_BOOT="#Last Boot: "
LVM_USE="#LVM use: "
TCP="#TCP Connections: "
USER_LOG="#User log[ged]: "
NETWORK="#Network: "
SUDO="#Sudo: "

if	[[ 1 ]]; then
	echo "Hello World"
fi
