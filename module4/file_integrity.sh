#!/bin/bash

# Move to the script's directory to handle relative paths safely
cd "$(dirname "$0")"

# --- Configuration ---
BASELINE="baseline_suid.txt"
CURRENT="current_suid.txt"
LOGFILE="hids.log"

# --- Functions ---
logger() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - [CRITICAL] - $message" >> "$LOGFILE"
}

# --- Execution ---

# 1. Generate current hashes of all SUID files
find /usr/bin -perm /4000 -exec sha256sum {} + > "$CURRENT"

# create baseline with hash and path if not already created
if [ ! -f "$BASELINE" ]; then
    cp "$CURRENT" "$BASELINE"  # On copie le scan (avec hashes) vers la baseline
    exit 0
fi

# 2. Check if baseline exists, if not, create it and exit (first run)
if [ ! -f "$BASELINE" ]; then
    cp "$CURRENT" "$BASELINE"
    echo "Baseline created for the first time. Run again to monitor."
    exit 0
fi

# 3. Compare current state with baseline
diff_result=$(diff "$BASELINE" "$CURRENT")

if [ -z "$diff_result" ]; then
    echo "Status: OK - No integrity changes."
else
    logger "FILE INTEGRITY ALERT: SUID change detected! Details: $diff_result"
    echo "⚠️ ALERT: File integrity compromised. Check $LOGFILE."
fi

