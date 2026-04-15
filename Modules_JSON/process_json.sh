#!/bin/bash

# ===============================================
# HIDS - Module Process & Network (JSON Export)
# ===============================================

# ---- CONFIGURATION ----
source "$(dirname "$0")/config.env"

# ---- FUNCTION: Send Alert to Dashboard ----
send_alert() {
    local module=$1
    local severity=$2
    local message=$3
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local host=$(hostname)

    local safe_message=$(echo "$message" | sed 's/"/\\"/g')

    echo "{\"timestamp\":\"$timestamp\",\"host\":\"$host\",\"module\":\"$module\",\"severity\":\"$severity\",\"message\":\"$safe_message\"}" >> "$LOG_FILE"
}

# ============================================
# LOGIQUE MÉTIER (Intacte)
# ============================================

# 1. High CPU (>70%)
while read line; do
    proc=$(echo $line | awk '{print $11}')
    cpu=$(echo $line | awk '{print $3}')
    # J'ai passé la sévérité de "HIGH" à "CRITICAL" pour que ton frontend l'affiche bien en rouge
    send_alert "process_audit" "CRITICAL" "High CPU: $proc ($cpu%)"
done < <(ps aux --sort=-%cpu | awk 'NR>1 && $3>70')

# 2. Suspicious dirs (Exécution depuis /tmp etc.)
for dir in $SUSPICIOUS_DIRS; do
    while read line; do
        proc=$(echo $line | awk '{print $11}')
        send_alert "process_audit" "CRITICAL" "Suspicious path: $proc"
    done < <(ps aux | grep "$dir" | grep -v grep)
done

# 3. Ports (Ports non autorisés ouverts)
while read line; do
    port=$(echo "$line" | awk '{print $5}')
    proc=$(echo "$line" | awk '{print $7}')
    
    if echo "$proc" | grep -qE "$ALLOWED_PROCS"; then
        continue
    fi

    if ! echo "$port" | grep -E "$ALLOWED_PORTS" >/dev/null; then
        send_alert "network_audit" "WARNING" "Port: $port ($proc)"
    fi
done < <(ss -tulnp | tail -n +2)