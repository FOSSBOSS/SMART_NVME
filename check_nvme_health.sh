#!/bin/bash
# Usage: sudo ./check_nvme_health.sh [nvme_device]
# Example: sudo ./check_nvme_health.sh /dev/nvme0

# Default NVMe device if not provided
NVME_DEV=${1:-/dev/nvme0}

# Check if nvme-cli is installed
if ! command -v nvme &> /dev/null; then
    echo "nvme-cli not found. Please install nvme-cli to use this script."
    exit 1
fi

# Get the SMART log output
SMART_LOG=$(sudo nvme smart-log "$NVME_DEV" > /dev/null)
if [ $? -ne 0 ]; then
    echo "Failed to retrieve SMART log from $NVME_DEV"
    exit 1
fi


# Extract relevant fields using awk
critical_warning=$(echo "$SMART_LOG" | awk -F ':' '/critical_warning/ {gsub(/ /, "", $2); print $2}')
media_errors=$(echo "$SMART_LOG" | awk -F ':' '/media_errors/ {gsub(/ /, "", $2); print $2}')
percentage_used=$(echo "$SMART_LOG" | awk -F ':' '/percentage_used/ {gsub(/ /, "", $2); gsub(/%/, "", $2); print $2}')

# Default values if extraction fails
critical_warning=${critical_warning:-0}
media_errors=${media_errors:-0}
percentage_used=${percentage_used:-0}

# Report overall health based on a simple criteria
if [[ "$critical_warning" -eq 0 && "$media_errors" -eq 0 && "$percentage_used" -eq 0 ]]; then
    echo "Overall Health: OK"
else
    echo "Overall Health: Potential Issues Detected"
    echo "Details:"
    echo "  critical_warning: $critical_warning"
    echo "  media_errors:     $media_errors"
    echo "  percentage_used:  ${percentage_used}%"
fi
