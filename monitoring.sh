TOTAL_RAM=$(free -h | grep Mem | awk '{print $2}')
USED_RAM=$(free -h | grep Mem | awk '{print $3}')
RAM_PER100=$(free -k | grep Mem | awk '{printf("%.2f%%"), $3 / $2 * 100}')
TOTAL_DISK=$(df -h --total | grep total | awk '{print $2}')
USED_DISK=$(df -h --total | grep total | awk '{print $3}')
DISK_PER100=$(df -h --total | grep total | awk '{print $5}')
IPS=$(hostname -I | awk '{print $1}')
MAC=$(ip link show | grep link/ether | awl '{print $2}')

wall "
		********************************************************
		Architecture: $(uname -srvmo)
		CPU: $(grep 'physical id' /proc/cpuinfo | uniq | wc -l)
		vCPU: $(grep processor /proc/cpuinfo | uniq | wc -l)
		Memory Usage: $USED_RAM/$TOTAL_RAM ($RAM_PER100)
		Disk Usage: $USED_DISK/$TOTAL_DISK ($DISK_PER100)
		CPU load: $(top -bn1 | grep '^%Cpu' | xargs | awk '{printf("%.1f%%"), $2 + $4}')
		Last boot: $(who -b | awk '{print($3 " " $4)}')
		LVM use: $(if [ $(lsbls | grep lvm | wc -l) -eq 0]; then echo no; else echo yes; fi)
		Connexions TCP: $(grep TCP /proc/net/sockstat | awk '{print $3}') ESTABLISHED
		User log: $(wjo | wc -l)
		Network: $IPS ($MAC)
		Sudo: $(grep COMMAND /var/log/sudo/sudo.log | wc -l) cmd
		********************************************************"
