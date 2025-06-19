#!/bin/bash

sleep 10

while [ true ]
do

ARCH=$(uname -a)
CPU=$(cat /proc/cpuinfo | grep "physical id" | wc -l)
VCPU=$(cat /proc/cpuinfo | grep "processor" | wc -l)
MEM_U=$(free --mega | grep Mem | awk '{ printf("%d/%dMB (%.2f%%)\n", $3, $2, $3/$2 * 100.0) }')
DISK_U=$(df --total -h | grep total | awk '{ printf("%.2f/%sB (%s)\n", $3, $2, $5)}')
CPU_LD=$(mpstat 1 1 | tail -1 | awk '{printf("%.1f%%\n", 100-$12)}')
LS_BOOT=$(who -b | awk '{print $3 " " $4}')
LVM_USE=$(if [[ $(cat /etc/fstab | grep "LVM" | wc -l) > 0 ]]; then echo "yes"; else echo "no"; fi)
TCP=$(ss -ta | grep ESTAB | wc -l)
USER_LOG=$(users | wc -w)
NETWORK=$(echo "IP $(hostname -I) ($(ip link | grep "ether" | awk '{ print $2 }'))")
SUDO=$(cat /var/log/sudo/sudo.log | grep "COMMAND=" | wc -l)

        wall "
        #Architecture: $ARCH
        #CPU Physical: $CPU
        #vCPU: $VCPU
        #Memory Usage: $MEM_U
        #Disk Usage: $DISK_U
        #CPU Load: $CPU_LD
        #Last Boot: $LS_BOOT
        #LVM use: $LVM_USE
        #TCP Connections: $TCP ESTABLISHED
        #Users logged: $USER_LOG
        #Network: $NETWORK
        #Sudo: $SUDO cmd"
        sleep 600
done
