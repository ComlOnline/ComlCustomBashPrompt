#! /bin/bash


sudo apt-get update
sudo apt-get install -y figlet

sudo rm /etc/update-motd.d/10-help-text
sudo rm /etc/update-motd.d/00-header
sudo rm /etc/update-motd.d/00-logo
sudo rm /etc/update-motd.d/01-distro
sudo rm /etc/update-motd.d/01-info

cat <<EOF1 | sudo tee /etc/update-motd.d/00-logo
#! /bin/bash

figlet "Coml Systems"
EOF1

cat <<EOF3 | sudo tee /etc/update-motd.d/01-info
#!/bin/sh

UPTIME_DAYS=$(expr `cat /proc/uptime | cut -d '.' -f1` % 31556926 / 86400)
UPTIME_HOURS=$(expr `cat /proc/uptime | cut -d '.' -f1` % 31556926 % 86400 / 3600)
UPTIME_MINUTES=$(expr `cat /proc/uptime | cut -d '.' -f1` % 31556926 % 86400 % 3600 / 60)

cat << EOF
%                                                                            %
%+++++++++++++++++++++++++++++++ SERVER INFO ++++++++++++++++++++++++++++++++%
%                                                                            %
	Name: `hostname`
	Uptime: $UPTIME_DAYS days, $UPTIME_HOURS hours, $UPTIME_MINUTES minutes

	CPU: `cat /proc/cpuinfo | grep 'model name' | head -1 | cut -d':' -f2`
	Memory: `free -m | head -n 2 | tail -n 1 | awk {'print $2'}`M
	Swap: `free -m | tail -n 1 | awk {'print $2'}`M
	Disk: `df -h / | awk '{ a = $2 } END { print a }'`
	Distro: `lsb_release -s -d` with `uname -r`

	CPU Load: `cat /proc/loadavg | awk '{print $1 ", " $2 ", " $3}'`
	Free Memory: `free -m | head -n 2 | tail -n 1 | awk {'print $4'}`M
	Free Swap: `free -m | tail -n 1 | awk {'print $4'}`M
	Free Disk: `df -h / | awk '{ a = $2 } END { print a }'`

	External Address: `ifconfig ens160 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`
	Internal Address: `ifconfig ens192 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`
EOF
EOF3

cat <<EOF2 >> ~/.bashrc
export PS1="[\[$(tput sgr0)\]\[\033[38;5;196m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;243m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]] [\[$(tput sgr0)\]\[\033[38;5;196m\]\w\]\[\033[38;5;15m\]] "
EOF2


sudo chmod +x /etc/update-motd.d/00-logo
sudo chmod +x /etc/update-motd.d/01-info