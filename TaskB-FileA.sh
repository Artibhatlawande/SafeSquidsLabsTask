#!/bin/bash

# Function to log output to /var/log/security_audit.log
log() {
    echo "$1" | tee -a /var/log/security_audit.log
}

# Ensure the script is run as root
if [[ "$(id -u)" -ne 0 ]]; then
    log "This script must be run as root"
    exit 1
fi

log "Starting security audit..."

# Listing all users and groups
log "Listing all users and groups:"
cut -d: -f1 /etc/passwd
cut -d: -f1 /etc/group

# Users with UID 0
log "Users with UID 0:"
awk -F: '$3 == 0 {print $1}' /etc/passwd

# Users without passwords
log "Users without passwords:"
awk -F: '($2 == "" && $1 != "root") {print $1}' /etc/shadow

# World-writable files and directories
log "World-writable files and directories:"
find / -xdev -type d -perm -0007 -exec ls -ld {} \;

# Checking .ssh directory permissions
log "Checking .ssh directory permissions:"
find /home -type d -name ".ssh" -exec ls -ld {} \;

# Files with SUID or SGID bits set
log "Files with SUID or SGID bits set:"
find / -xdev \( -perm -4000 -o -perm -2000 \) -type f -exec ls -l {} \;

# Listing all running services
log "Listing all running services:"
systemctl list-units --type=service --state=running

# Ensuring critical services are running
log "Ensuring critical services are running:"
for service in acpid amazon-ssm-agent atd auditd chronyd dbus-broker getty@tty1 gssproxy libstoragemgmt rngd serial-getty@ttyS0 sshd systemd-homed systemd-journald systemd-logind systemd-networkd systemd-resolved systemd-udevd systemd-userdbd; do
    systemctl is-active --quiet "$service" && log "$service is running" || log "$service is not running"
done

# Checking for firewall configuration
if command -v firewall-cmd &> /dev/null; then
    log "Listing firewalld rules:"
    firewall-cmd --list-all
else
    log "firewalld not found. Skipping firewall configuration."
fi

# Checking IP forwarding
log "Checking IP forwarding:"
sysctl net.ipv4.ip_forward

# Checking IP addresses
log "Checking IP addresses:"
ip addr show

# Checking for security updates
log "Checking for security updates:"
if command -v yum &> /dev/null; then
    yum check-update
elif command -v dnf &> /dev/null; then
    dnf check-update
else
    log "No package manager found for security updates."
fi

# Checking SSH configuration
log "Updating SSH configuration:"
grep -E '^PermitRootLogin|^PasswordAuthentication|^AllowUsers|^DenyUsers' /etc/ssh/sshd_config

# Disabling IPv6
log "Disabling IPv6:"
sysctl net.ipv6.conf.all.disable_ipv6

# Setting GRUB password
log "Setting GRUB password: (This is a placeholder action)"
# Implementation depends on specific system setup

log "Security audit completed. Check /var/log/security_audit.log for details."
