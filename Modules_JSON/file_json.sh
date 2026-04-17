#!/bin/bash

# ============================================
# HIDS - Module File Integrity (JSON Export)
# ============================================

# ---- CONFIGURATION ----
source "$(dirname "$0")/config.env"

mkdir -p "$BASELINE_DIR"

# ---- FUNCTION: Send Alert to Dashboard ----
send_alert() {
    local severity=$1
    local message=$2
    local extra=$3
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local host=$(hostname)

    local safe_message=$(echo "$message" | sed 's/"/\\"/g')

    if [ -n "$extra" ]; then
        echo "{\"timestamp\":\"$timestamp\",\"host\":\"$host\",\"module\":\"file_integrity\",\"severity\":\"$severity\",\"message\":\"$safe_message\",$extra}" >> "$LOG_FILE"
    else
        echo "{\"timestamp\":\"$timestamp\",\"host\":\"$host\",\"module\":\"file_integrity\",\"severity\":\"$severity\",\"message\":\"$safe_message\"}" >> "$LOG_FILE"
    fi
}

# ============================================
# LOGIQUE MÉTIER (Intacte)
# ============================================

for file in $CRITICAL_FILES; do
    if [ ! -f "$file" ]; then
        send_alert "WARNING" "Missing: $file"
        continue
    fi

    base="$BASELINE_DIR/$(basename $file).hash"

    if [ ! -f "$base" ]; then
        sha256sum "$file" > "$base"
        send_alert "INFO" "Baseline created: $file"
        continue
    fi

    if [ "$(sha256sum "$file")" != "$(cat "$base")" ]; then
        send_alert "CRITICAL" "Modified: $file" "\"status\":\"MODIFIED\""
    fi
done

perm=$(stat -c "%a" /etc/shadow 2>/dev/null)
if [ "$perm" != "600" ]; then
    send_alert "HIGH" "/etc/shadow perm: $perm"
fi

while read f; do
    send_alert "WARNING" "World-writable: $f"
done < <(find /etc -type f -perm -002 2>/dev/null)