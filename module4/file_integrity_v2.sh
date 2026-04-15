#!/bin/bash

cd "$(dirname "$0")"

BASELINE="baseline_suid.txt"
CURRENT="current_suid.txt"
LOGFILE="hids.log"

logger() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - [ANALYSIS] - $1" >> "$LOGFILE"
}

# 1. Scan
find /usr/bin -perm /4000 -exec sha256sum {} + > "$CURRENT"

if [ ! -f "$BASELINE" ]; then
    cp "$CURRENT" "$BASELINE"
    exit 0
fi

# 2. Precise Analysis
# We check every file in the current scan
while read -r line; do
    current_hash=$(echo "$line" | awk '{print $1}')
    current_path=$(echo "$line" | awk '{print $2}')

    # Check if the path exists in the baseline
    baseline_entry=$(grep "$current_path" "$BASELINE")

    if [ -z "$baseline_entry" ]; then
        logger "NEW FILE DETECTED: $current_path"
        echo "⚠️ New SUID file found: $current_path"
    else
        baseline_hash=$(echo "$baseline_entry" | awk '{print $1}')
        if [ "$current_hash" != "$baseline_hash" ]; then
            logger "INTEGRITY BREACH: Hash changed for $current_path"
            echo "🚨 ALERT: File content modified: $current_path"
        fi
    fi
done < "$CURRENT"

# 3. Check for deleted files (optional but recommended)
# We check if files from baseline are missing in current
while read -r line; do
    baseline_path=$(echo "$line" | awk '{print $2}')
    if ! grep -q "$baseline_path" "$CURRENT"; then
        logger "FILE DELETED: $baseline_path"
        echo "ℹ️ SUID file removed: $baseline_path"
    fi
done < "$BASELINE"

