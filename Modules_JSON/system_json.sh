#!/bin/bash

# =========================================
# HIDS - Module System Health (JSON Export)
# =========================================

# ---- CONFIGURATION ----
source "$(dirname "$0")/config.env"

# ---- FUNCTIONS ----
get_cpu_load() { cut -d ' ' -f1 /proc/loadavg; }
get_cpu_cores() { nproc; }

get_memory_usage() {
    mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    mem_available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    echo $((100 - (mem_available * 100 / mem_total)))
}

get_disk_usage() {
    df / | awk 'NR==2 {print $5}' | tr -d '%'
}

generate_alert() {
    load=$(get_cpu_load)
    cores=$(get_cpu_cores)
    mem=$(get_memory_usage)
    disk=$(get_disk_usage)

    load_int=$(printf "%.0f" "$load")
    load_limit=$((cores * LOAD_LIMIT_MULTIPLIER))

    status="OK"
    severity="INFO"
    message="System healthy"

    if [ "$load_int" -gt "$load_limit" ]; then
        status="HIGH_LOAD"; severity="CRITICAL"; message="High CPU load"
    elif [ "$disk" -gt "$DISK_LIMIT" ]; then
        status="HIGH_DISK"; severity="CRITICAL"; message="High disk usage"
    elif [ "$mem" -gt "$MEM_LIMIT" ]; then
        status="HIGH_MEMORY"; severity="WARNING"; message="High memory usage"
    fi

    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    host=$(hostname)

    # ---- EXPORT JSON (Format NDJSON) ----
    json_payload="{\"timestamp\":\"$timestamp\",\"host\":\"$host\",\"module\":\"system_health\",\"status\":\"$status\",\"severity\":\"$severity\",\"load\":\"$load\",\"memory\":\"$mem\",\"disk\":\"$disk\",\"message\":\"$message\"}"
    
    echo "$json_payload" >> "$LOG_FILE"
}

generate_alert