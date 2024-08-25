#!/bin/bash

# Function to show CPU usage
cpu_usage() {
    echo "Top 10 Processes by CPU Usage:"
    ps aux --sort=-%cpu | head -n 11
}

# Function to show memory usage
memory_usage() {
    echo "Memory Usage:"
    free -h
    echo ""
    echo "Top 10 Processes by Memory Usage:"
    ps aux --sort=-%mem | head -n 11
}

# Function to monitor network connections and traffic
network_monitoring() {
    echo "Network Connections and Traffic:"
    ss -s
    echo ""
    echo "Network Interface Traffic:"
    ifconfig eth0 | grep 'RX packets\|TX packets\|RX bytes\|TX bytes'
}

# Function to monitor disk usage
disk_usage() {
    echo "Disk Usage:"
    df -h | awk '{if($5 >= 80) print $0}'
}

# Function to monitor system load
system_load() {
    echo "System Load and CPU Usage:"
    uptime
    echo ""
    echo "Detailed CPU Usage:"
    mpstat
}

# Function to monitor processes
process_monitoring() {
    echo "Process Monitoring:"
    echo "Number of active processes: $(ps aux | wc -l)"
    echo "Top 5 Processes by CPU Usage:"
    ps aux --sort=-%cpu | head -n 6
}

# Function to monitor essential services
service_monitoring() {
    echo "Service Status:"
    systemctl is-active sshd
    systemctl is-active nginx
    systemctl is-active iptables
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
        * )         echo "Usage: $0 [-cpu] [-memory] [-network] [-disk] [-load] [-process] [-services] [-all]"; exit 1
    esac
    shift
done
