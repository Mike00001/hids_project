#!/bin/bash

CRITICAL_FILES="/etc/passwd /etc/shadow /etc/sudoers /etc/ssh/sshd_config"
BASELINE_DIR="./baseline"
LOG_FILE="./file_integrity.log"

RED="\e[31m"; YELLOW="\e[33m"; BLUE="\e[34m"; RESET="\e[0m"

mkdir -p "$BASELINE_DIR"
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

echo "=== File Integrity Check ==="

for file in $CRITICAL_FILES; do
    [ ! -f "$file" ] && log_alert "WARNING" "Missing: $file" && continue

    base="$BASELINE_DIR/$(basename $file).hash"

    if [ ! -f "$base" ]; then
        sha256sum "$file" > "$base"
        log_alert "INFO" "Baseline created: $file"
        continue
    fi

    [ "$(sha256sum "$file")" != "$(cat "$base")" ] && \
        log_alert "CRITICAL" "Modified: $file"
done

# Permissions
perm=$(stat -c "%a" /etc/shadow 2>/dev/null)
[ "$perm" != "600" ] && log_alert "HIGH" "/etc/shadow perm: $perm"

# World writable
while read f; do
    log_alert "WARNING" "World-writable: $f"
done < <(find /etc -type f -perm -002 2>/dev/null)

echo "=== Scan Complete ==="

# JSON output
timestamp=$(date +"%F %T")
host=$(hostname)

printf "{\"timestamp\":\"%s\",\"host\":\"%s\",\"module\":\"file_integrity\",\"alerts\":[" "$timestamp" "$host"
for ((i=0;i<${#JSON_ALERTS[@]};i++)); do
    printf "%s" "${JSON_ALERTS[$i]}"
    [ $i -lt $((${#JSON_ALERTS[@]}-1)) ] && printf ","
done
printf "]}\n"