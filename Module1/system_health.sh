#!/bin/bash

# ==============================
# HIDS - Module 1: System Health
# ==============================

# ---- COLORS ----
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# ---- CONFIGURATION ----
LOG_FILE="$HOME/hids_system.log"
STATE_FILE="$HOME/hids_system_state"

LOAD_LIMIT_MULTIPLIER=2
MEM_LIMIT=85
DISK_LIMIT=90

touch "$LOG_FILE"

# ---- FUNCTION: Write Log ----
write_log() {
    echo "$1" >> "$LOG_FILE"
}

# ---- FUNCTIONS: Metrics ----
get_cpu_load() {
    cut -d ' ' -f1 /proc/loadavg
}

get_cpu_cores() {
    nproc
}

get_memory_usage() {
    mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    mem_available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    echo $((100 - (mem_available * 100 / mem_total)))
}

get_disk_usage() {
    df / | awk 'NR==2 {print $5}' | tr -d '%'
}

# ---- FUNCTION: Generate Alert ----
generate_alert() {

    load=$(get_cpu_load)
    cores=$(get_cpu_cores)
    mem_usage=$(get_memory_usage)
    disk_usage=$(get_disk_usage)

    load_int=$(printf "%.0f" "$load")
    load_limit=$((cores * LOAD_LIMIT_MULTIPLIER))

    status="OK"
    severity="INFO"
    message="System healthy"

    # ---- PRIORITY-BASED RULES ----
    if [ "$load_int" -gt "$load_limit" ]; then
        status="HIGH_LOAD"
        severity="CRITICAL"
        message="Load $load exceeds limit $load_limit"

    elif [ "$disk_usage" -gt "$DISK_LIMIT" ]; then
        status="HIGH_DISK"
        severity="CRITICAL"
        message="Disk usage at ${disk_usage}%"

    elif [ "$mem_usage" -gt "$MEM_LIMIT" ]; then
        status="HIGH_MEMORY"
        severity="WARNING"
        message="Memory usage at ${mem_usage}%"
    fi

    # ---- EMOJI + COLOR ----
    case "$severity" in
        "CRITICAL")
            color=$RED
            emoji="🚨"
            ;;
        "WARNING")
            color=$YELLOW
            emoji="⚠️"
            ;;
        "INFO")
            color=$GREEN
            emoji="✅"
            ;;
    esac

    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    host=$(hostname)

    # ---- TERMINAL OUTPUT (colored) ----
    echo -e "${color}${emoji} [$severity] $message | Load: $load | Mem: ${mem_usage}% | Disk: ${disk_usage}%${NC}"

    # ---- JSON LOG (clean, no colors) ----
    echo "{\"timestamp\":\"$timestamp\",\"host\":\"$host\",\"module\":\"system_health\",\"status\":\"$status\",\"severity\":\"$severity\",\"load\":\"$load\",\"cores\":\"$cores\",\"memory\":\"$mem_usage\",\"disk\":\"$disk_usage\",\"message\":\"$message\"}"
}

# ---- FUNCTION: Prevent Alert Spam ----
should_alert() {
    current_status="$1"

    if [ -f "$STATE_FILE" ]; then
        previous_status=$(cat "$STATE_FILE")
    else
        previous_status="NONE"
    fi

    echo "$current_status" > "$STATE_FILE"

    if [ "$current_status" != "$previous_status" ]; then
        return 0
    else
        return 1
    fi
}

# ---- MAIN ----
main() {

    alert=$(generate_alert)

    status=$(echo "$alert" | sed -n 's/.*"status":"\([^"]*\)".*/\1/p')

    if should_alert "$status"; then
        write_log "$alert"
    fi
}

main