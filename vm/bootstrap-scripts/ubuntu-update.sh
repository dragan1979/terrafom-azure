#!/bin/bash

# Log file for script execution
LOG_FILE="/var/log/ubuntu_upgrade.log"

# Function to log messages with timestamps
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "Starting Ubuntu system upgrade and update script."

# Ensure non-interactive upgrades
export DEBIAN_FRONTEND=noninteractive

log "Updating package lists..."
if ! apt update -y; then
    log "ERROR: Failed to update package lists."
    exit 1
fi
log "Package lists updated."

log "Upgrading installed packages..."
if ! apt upgrade -y; then
    log "ERROR: Failed to upgrade installed packages."
    exit 1
fi
log "Installed packages upgraded."

log "Dist-upgrading the system (if a new distribution version is available)..."
if ! apt dist-upgrade -y; then
    log "ERROR: Failed to perform distribution upgrade."
    exit 1
fi
log "Distribution upgrade complete."

log "Cleaning up old packages..."
if ! apt autoremove -y; then
    log "ERROR: Failed to remove old packages."
    exit 1
fi
log "Old packages cleaned up."

log "Cleaning up apt cache..."
if ! apt clean; then
    log "ERROR: Failed to clean apt cache."
    exit 1
fi
log "Apt cache cleaned."

log "Ubuntu system upgrade and update script finished."

exit 0 # Exit with success code
