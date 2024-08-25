#!/bin/bash

# Function to show CPU usage in a table format
cpu_usage() {
    echo -e "\n\e[1;33mTop 10 Processes by CPU Usage:\e[0m"
    echo -e "\e[1;32mUSER\t\tPID\t%CPU\t%MEM\tVSZ\t\tRSS\t\tCOMMAND\e[0m"
    ps aux --sort=-%cpu | awk 'NR<=11 {printf "%-10s\t%-8s\t%-6s\t%-6s\t%-10s\t%-10s\t%s\n", $1, $2, $3, $4, $5, $6, $11}'
}

# Function to show memory usage in a table format
memory_usage() {
    echo -e "\n\e[1;33mMemory Usage:\e[0m"
    free -h
    echo -e "\n\e[1;33mTop 10 Processes by Memory Usage:\e[0m"
    echo -e "\e[1;32mUSER\t\tPID\t%CPU\t%MEM\tVSZ\t\tRSS\t\tCOMMAND\e[0m"
    ps aux --sort=-%mem | awk 'NR<=11 {printf "%-10s\t%-8s\t%-6s\t%-6s\t%-10s\t%-10s\t%s\n", $1, $2, $3, $4, $5, $6, $11}'
}

# Function to monitor network connections and traffic in a table format
network_monitoring() {
    echo -e "\n\e[1;33mNetwork Connections and Traffic:\e[0m"
    ss -s
    echo -e "\n\e[1;33mNetwork Interface Traffic (eth0):\e[0m"
    echo -e "\e[1;32mDirection\tPackets\tBytes\e[0m"
    ifconfig eth0 | awk '/RX packets/ {print "RX\t\t" $3 "\t" $5} /TX packets/ {print "TX\t\t" $3 "\t" $5}'
}

# Function to monitor disk usage in a table format
disk_usage() {
    echo -e "\n\e[1;33mDisk Usage (Threshold: 80%):\e[0m"
    echo -e "\e[1;32mFilesystem\tSize\tUsed\tAvail\tUse%\tMounted on\e[0m"
    df -h | awk '{if($5 >= 80) printf "%-15s\t%-6s\t%-6s\t%-6s\t%-4s\t%s\n", $1, $2, $3, $4, $5, $6}'
}

# Function to monitor system load in a table format
system_load() {
    echo -e "\n\e[1;33mSystem Load and CPU Usage:\e[0m"
    uptime
    echo -e "\n\e[1;33mDetailed CPU Usage:\e[0m"
    mpstat | grep -v '^Linux'
}

# Function to monitor processes in a table format
process_monitoring() {
    echo -e "\n\e[1;33mProcess Monitoring:\e[0m"
    echo "Number of active processes: $(ps aux | wc -l)"
    echo -e "\n\e[1;33mTop 5 Processes by CPU Usage:\e[0m"
    echo -e "\e[1;32mUSER\t\tPID\t%CPU\t%MEM\tVSZ\t\tRSS\t\tCOMMAND\e[0m"
    ps aux --sort=-%cpu | awk 'NR<=6 {printf "%-10s\t%-8s\t%-6s\t%-6s\t%-10s\t%-10s\t%s\n", $1, $2, $3, $4, $5, $6, $11}'
}

# Function to monitor essential services in a table format
service_monitoring() {
    echo -e "\n\e[1;33mService Status:\e[0m"
    services=( "sshd" "nginx" "iptables" )
    echo -e "\e[1;32mService\t\tStatus\e[0m"
    for service in "${services[@]}"; do
        status=$(systemctl is-active "$service")
        echo -e "$service\t\t$status"
    done
}

# Parse command-line arguments for specific monitoring options
while [ "$1" != "" ]; do
    case $1 in
        -cpu )      cpu_usage ;;
        -memory )   memory_usage ;;
        -network )  network_monitoring ;;
        -disk )     disk_usage ;;
        -load )     system_load ;;
        -process )  process_monitoring ;;
        -services ) service_monitoring ;;
        -all )      cpu_usage; memory_usage; network_monitoring; disk_usage; system_load; process_monitoring; service_monitoring ;;
        * )         echo -e "\e[1;31mUsage: $0 [-cpu] [-memory] [-network] [-disk] [-load] [-process] [-services] [-all]\e[0m"; exit 1
    esac
    shift
done
