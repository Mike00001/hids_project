#!/bin/bash

# ===============================================
# HIDS - Module User Activity (JSON Export)
# ===============================================

LOG_FILE="/opt/hids-project/hids_project/dashboard/test_logs/hids_system.log"

# ---- FUNCTION: Send Alert to Dashboard ----
send_alert() {
    local severity=$1
    local message=$2
    local extra=$3
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local host=$(hostname)

    local safe_message=$(echo "$message" | sed 's/"/\\"/g')
    
    if [ -n "$extra" ]; then
        echo "{\"timestamp\":\"$timestamp\",\"host\":\"$host\",\"module\":\"user_activity\",\"severity\":\"$severity\",\"message\":\"$safe_message\",$extra}" >> "$LOG_FILE"
    else
        echo "{\"timestamp\":\"$timestamp\",\"host\":\"$host\",\"module\":\"user_activity\",\"severity\":\"$severity\",\"message\":\"$safe_message\"}" >> "$LOG_FILE"
    fi
}

# ============================================
# LOGIQUE MÉTIER
# ============================================

# 1. Failed Login Attempts
failed_count=0
if command -v lastb >/dev/null 2>&1; then
    # Parse lastb, drop empty lines and header/footer
    failed_count=$(sudo lastb | grep -v 'wtmp begins' | grep -v '^$' | wc -l)
elif [ -f /var/log/auth.log ]; then
    failed_count=$(sudo grep -Ei "failed password|authentication failure|invalid user" /var/log/auth.log | wc -l)
fi

# We send an INFO level alert to transmit the failed attempts counter
send_alert "INFO" "User activity check complete" "\"failed_attempts\":\"$failed_count\""

if [ "$failed_count" -gt 5 ]; then
    send_alert "CRITICAL" "High number of failed login attempts ($failed_count)"
fi

# 2. Check for UID 0 accounts (Admin privileges outside root)
while read line; do
    user=$(echo "$line" | awk '{print $1}')
    if [ "$user" != "root" ]; then
        send_alert "CRITICAL" "UID 0 assigned to non-root user: $user"
    fi
done < <(awk -F: '$3 == 0 {print $1}' /etc/passwd)

# 3. Recent Sudo Actions
if [ -f /var/log/auth.log ]; then
    sudo_actions=$(sudo grep "sudo:" /var/log/auth.log | tail -n 1)
    if [ -n "$sudo_actions" ]; then
        send_alert "WARNING" "Recent sudo action detected (auth.log)"
    fi
elif command -v journalctl >/dev/null 2>&1; then
    sudo_actions=$(sudo journalctl _COMM=sudo -n 1 --no-pager)
    if [ -n "$sudo_actions" ]; then
        send_alert "WARNING" "Recent sudo action detected (journalctl)"
    fi
fi
