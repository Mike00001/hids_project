#!/bin/bash

# =========================================
# HIDS - Main Orchestrator
# =========================================

cd "$(dirname "$0")"

./system_json.sh
./file_json.sh
./process_json.sh