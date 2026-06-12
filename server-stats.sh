#!/bin/bash

# Ensure the script is run on Linux
if [ "$(uname)" != "Linux" ]; then
    echo "Error: This script is designed for Linux systems only."
    exit 1
fi

echo "========================================"
echo "          SERVER PERFORMANCE STATS      "
echo "========================================"
echo "Date: $(date)"
echo "Host: $(hostname)"
echo "----------------------------------------"

# 1. Total Resources Usage
cpu_idle=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")
cpu_use=$(echo "100 - $cpu_idle" | bc 2>/dev/null || awk "BEGIN {print 100 - $cpu_idle}")
memory_use=$(free -m | awk 'NR==2{printf "%.2f%", $3*100/$2}')
disk_use=$(df -h / | awk 'NR==2{print $5}')

echo "Total CPU Usage: ${cpu_use}%"
echo "Total Memory Usage: ${memory_use}%"
echo "Total Disk Usage (Root /): ${disk_use}"

# 2. Top 5 Processes by CPU Usage
echo "  PID   %CPU  COMMAND"
ps -eo pid,%cpu,comm --sort=-%cpu | head -n 6 | tail -n +2 | awk '{printf "  %-5s %-5s %s\n", $1, $2, $3}'

# 3. Top 5 Processes by Memory Usage
echo "Top 5 Processes by Memory Usage:"
echo "  PID   %MEM  COMMAND"
ps -eo pid,%mem,comm --sort=-%mem | head -n 6 | tail -n +2 | awk '{printf "  %-5s %-5s %s\n", $1, $2, $3}'