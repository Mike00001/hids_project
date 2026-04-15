#!/bin/bash

OUTPUT_FILE="hids_log.json"

echo "[" > "$OUTPUT_FILE"

run_module() {
    local script=$1

    if [ ! -x "$script" ]; then
        echo "{\"module\":\"$script\",\"error\":\"Not executable\"}," >> "$OUTPUT_FILE"
        return
    fi

    result=$($script | tail -n 1)

    if [[ "$result" == \{* ]]; then
        echo "$result," >> "$OUTPUT_FILE"
    else
        echo "{\"module\":\"$script\",\"error\":\"Invalid JSON output\"}," >> "$OUTPUT_FILE"
    fi
}

run_module "./system_json.sh"
run_module "./process_json.sh"
run_module "./file_json.sh"

# Fix trailing comma
sed -i '$ s/,$//' "$OUTPUT_FILE"

echo "]" >> "$OUTPUT_FILE"

echo "✅ HIDS execution complete → $OUTPUT_FILE"