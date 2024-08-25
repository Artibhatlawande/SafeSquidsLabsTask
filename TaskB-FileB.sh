#!/bin/bash

# Function to log output to /var/log/security_audit.log
log() {
    echo -e "$1" | tee -a /var/log/security_audit.log
}

# Ensure the script is run as root
if [[ "$(id -u)" -ne 0 ]]; then
    log "This script must be run as root"
    exit 1
fi

log "Starting security audit...\n"

# Listing all users
log "Users and Groups:"
log "-------------------------------------------------------------"
log "| Usernames               | Group Names                    |"
log "-------------------------------------------------------------"
paste <(cut -d: -f1 /etc/passwd) <(cut -d: -f1 /etc/group) | awk '{printf "| %-25s | %-30s |\n", $1, $2}'
log "-------------------------------------------------------------\n"

# Users with UID 0
log "Users with UID 0:"
log "----------------------------------"
log "| Username                       |"
log "----------------------------------"
awk -F: '$3 == 0 {printf "| %-30s |\n", $1}' /etc/passwd
log "----------------------------------\n"

# Users without passwords
log "Users without Passwords:"
log "----------------------------------"
log "| Username                       |"
log "----------------------------------"
awk -F: '($2 == "" && $1 != "root") {printf "| %-30s |\n", $1}' /etc/shadow
log "----------------------------------\n"

# World-writable files and directories
log "World-writable Files and Directories:"
log "-------------------------------------------------------------------"
log "| Permissions  | Owner  | Group  | Path                           |"
log "-------------------------------------------------------------------"
find / -xdev -type d -perm -0007 -exec ls -ld {} \; | awk '{printf "| %-12s | %-6s | %-6s | %-30s |\n", $1, $3, $4, $9}'
log "-------------------------------------------------------------------\n"

# Checking .ssh directory permissions
log ".ssh Directory Permissions:"
log "-------------------------------------------------------------------"
log "| Permissions  | Owner  | Group  | Path                           |"
log "-------------------------------------------------------------------"
find /home -type d -name ".ssh" -exec ls -ld {} \; | awk '{printf "| %-12s | %-6s | %-6s | %-30s |\n", $1, $3, $4, $9}'
log "-------------------------------------------------------------------\n"

# Files with SUID or SGID bits set
log "Files with SUID or SGID Bits Set:"
log "-------------------------------------------------------------------"
log "| Permissions  | Owner  | Group  | Path                           |"
log "-------------------------------------------------------------------"
find / -xdev \( -perm -4000 -o -perm -2000 \) -type f -exec ls -l {} \; | awk '{printf "| %-12s | %-6s | %-6s | %-30s |\n", $1, $3, $4, $9}'
log "-------------------------------------------------------------------\n"

# Listing all running services
log "Running Services:"
log "--------------------------------------------------------------"
log "| Service Name                   | Status                     |"
log "--------------------------------------------------------------"
systemctl list-units --type=service --state=running | grep '.service' | awk '{printf "| %-30s | %-25s |\n", $1, $4}'
log "--------------------------------------------------------------\n"

# Ensuring critical services are running
log "Critical Services Status:"
log "--------------------------------------------------------------"
log "| Service Name                   | Status                     |"
log "--------------------------------------------------------------"
for service in acpid amazon-ssm-agent atd auditd chronyd dbus-broker getty@tty1 gssproxy libstoragemgmt rngd serial-getty@ttyS0 sshd systemd-homed systemd-journald systemd-logind systemd-networkd systemd-resolved systemd-udevd systemd-userdbd; do
    if systemctl is-active --quiet "$service"; then
        log "| $(printf '%-30s' "$service") | Running                    |"
    else
        log "| $(printf '%-30s' "$service") | Not Running                |"
    fi
done
log "--------------------------------------------------------------\n"

# Checking for firewall configuration
if command -v firewall-cmd &> /dev/null; then
    log "Firewalld Rules:"
    log "--------------------------------------------------------------"
    log "$(firewall-cmd --list-all)"
    log "--------------------------------------------------------------\n"
else
    log "firewalld not found. Skipping firewall configuration.\n"
fi

# Checking IP forwarding
log "IP Forwarding Configuration:"
log "----------------------------------"
log "$(sysctl net.ipv4.ip_forward)"
log "----------------------------------\n"

# Checking IP addresses
log "Network Interfaces and IP Addresses:"
log "-----------------------------------------"
log "$(ip addr show)"
log "-----------------------------------------\n"

# Checking for security updates
log "Checking for Security Updates:"
if command -v yum &> /dev/null; then
    log "$(yum check-update)"
elif command -v dnf &> /dev/null; then
    log "$(dnf check-update)"
else
    log "No package manager found for security updates.\n"
fi

# Checking SSH configuration
log "SSH Configuration:"
log "----------------------------------"
grep -E '^PermitRootLogin|^PasswordAuthentication|^AllowUsers|^DenyUsers' /etc/ssh/sshd_config
log "----------------------------------\n"

# Disabling IPv6
log "Disabling IPv6:"
log "----------------------------------"
log "$(sysctl net.ipv6.conf.all.disable_ipv6)"
log "----------------------------------\n"

# Setting GRUB password
log "Setting GRUB password: (This is a placeholder action)"
log "Security audit completed. Check /var/log/security_audit.log for details."
