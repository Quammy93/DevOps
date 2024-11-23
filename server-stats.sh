#!/bin/bash

echo "=== Server Performance Stats ==="

# Total CPU Usage
echo -e "\nCPU Usage:"
top -bn1 | grep "Cpu(s)" | \
awk '{print "Total CPU Usage: " $2 + $4 "%"}'

# Total Memory Usage (Free vs Used including percentage)
echo -e "\nMemory Usage:"
free -m | awk 'NR==2{printf "Used: %sMB\nFree: %sMB\nTotal Memory Usage: %.2f%\n", $3, $4, $3*100/($3+$4)}'

# Total Disk Usage (Free vs Used including percentage)
echo -e "\nDisk Usage:"
df -h --total | grep 'total' | \
awk '{printf "Used: %s\nFree: %s\nTotal Disk Usage: %s\n", $3, $4, $5}'

# Top 5 processes by CPU usage
echo -e "\nTop 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

# Top 5 processes by memory usage
echo -e "\nTop 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

# Stretch Goal: Additional Stats
# OS Version
echo -e "\nOS Version:"
cat /etc/os-release | grep PRETTY_NAME | sed 's/PRETTY_NAME=//g'

# Uptime
echo -e "\nSystem Uptime:"
uptime -p

# Load Average
echo -e "\nLoad Average:"
uptime | awk -F 'load average:' '{ print $2 }'

# Logged in Users
echo -e "\nLogged in Users:"
who | wc -l

# Failed Login Attempts (optional, requires `lastb` command)
echo -e "\nFailed Login Attempts:"
lastb | wc -l

echo -e "\n=== End of Server Performance Stats ==="

