#!/bin/bash
arc=$(uname -a)
pcpu=$(lscpu | grep "Socket(s)" | awk '{print $2}')
vcpu=$(nproc)
ram=$(free -m | grep Mem: | awk '{printf "%d/%dMB (%.2f%%)\n", $3, $2, $3/$2*100}')
dsk_total=$(df -BG | grep '^/dev/mapper' | awk 'NR>0 {total += $2} END {print total "Gb"}')
dsk_used=$(df -BM | grep '^/dev/mapper' | awk 'NR>0 {used += $3} END {print used}')
disk_percent=$(df -BM | grep '^/dev/mapper' | awk 'NR>0 {total += $2} {used += $3} END {printf "%.2f%%\n",(used/total)*100}')
cpu_l=$(mpstat | awk 'NR == 4 {print 100-$13"%"}')
l_boot=$(who -b | awk 'END {print $3 " " $4}')
lvm=$(if [ $(lsblk | grep lvm | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
tcp=$(netstat | grep -c ESTABLISHED)
ulog=$(users | wc -w)
mac=$(ip link show | grep ether | awk '{print $2}')
ip=$(hostname -I)
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall 
"	#Architecture: $arc
	#CPU physical: $pcpu
	#vCPU: $vcpu
	#Memory Usage: $ram
	#Disk Usage: $dsk_used/${dsk_total}Gb ($disk_percent%)
	#CPU load: $cpu_l
	#Last boot: $l_boot
	#LVM use: $lvm
	#Connexions TCP: $tcp ESTABLISHED
	#User log: $ulog
	#Network: IP $ip ($mac)
	#Sudo: $cmds cmd
"
