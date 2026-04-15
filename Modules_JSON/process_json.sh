#!/bin/bash

SUSPICIOUS_DIRS="/tmp /dev/shm /var/tmp"
LOG_FILE="./process_network.log"

RED="\e[31m"; YELLOW="\e[33m"; BLUE="\e[34m"; RESET="\e[0m"

JSON_ALERTS=()

log_alert() {
    local severity=$1
    local message=$2

    case "$severity" in
        INFO) echo -e "${BLUE}[INFO]${RESET} $message" ;;
        WARNING) echo -e "${YELLOW}[WARNING]${RESET} $message" ;;
        HIGH|CRITICAL) echo -e "${RED}[$severity]${RESET} $message" ;;
    esac

    echo "$(date '+%F %T') [$severity] $message" >> "$LOG_FILE"

    esc=$(echo "$message" | sed 's/"/\\"/g')
    JSON_ALERTS+=("{\"severity\":\"$severity\",\"message\":\"$esc\"}")
}

echo "=== Process & Network Audit ==="

# High CPU
while read line; do
    proc=$(echo $line | awk '{print $11}')
    cpu=$(echo $line | awk '{print $3}')
    log_alert "HIGH" "High CPU: $proc ($cpu%)"
done < <(ps aux --sort=-%cpu | awk 'NR>1 && $3>70')

# Suspicious dirs
for dir in $SUSPICIOUS_DIRS; do
    while read line; do
        proc=$(echo $line | awk '{print $11}')
        log_alert "CRITICAL" "Suspicious path: $proc"
    done < <(ps aux | grep "$dir" | grep -v grep)
done

# Ports
while read line; do
    port=$(echo $line | awk '{print $5}')
    proc=$(echo $line | awk '{print $7}')
    if ! echo "$port" | grep -E ":22|:80|:443" >/dev/null; then
        log_alert "WARNING" "Port: $port ($proc)"
    fi
done < <(ss -tulnp | tail -n +2)

echo "=== Scan Complete ==="

# JSON output
timestamp=$(date +"%F %T")
host=$(hostname)

printf "{\"timestamp\":\"%s\",\"host\":\"%s\",\"module\":\"process_network\",\"alerts\":[" "$timestamp" "$host"
for ((i=0;i<${#JSON_ALERTS[@]};i++)); do
    printf "%s" "${JSON_ALERTS[$i]}"
    [ $i -lt $((${#JSON_ALERTS[@]}-1)) ] && printf ","
done
printf "]}\n"