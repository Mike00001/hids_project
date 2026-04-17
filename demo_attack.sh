#!/bin/bash

# --- CONFIGURATION ---
LOG_FILE="/opt/hids-project/hids_project/dashboard/test_logs/hids_system.log"
REAL_MONITOR="/opt/hids-project/hids_project/Modules_JSON/main_json.sh"
HOST="hids-server-01"

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

get_ts() { date +"%Y-%m-%d %H:%M:%S"; }

clear
echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE}   SENTINEL HIDS - BULLETPROOF DEMO SCRIPT           ${NC}"
echo -e "${BLUE}=====================================================${NC}"

# --- 1. MUTE DES VRAIS SCRIPTS ---
echo -e "${YELLOW}[*] Silencing real-time monitoring...${NC}"
if [ -f "$REAL_MONITOR" ]; then
    sudo mv "$REAL_MONITOR" "${REAL_MONITOR}.bak"
fi
sudo pkill -9 -f 'main_json.sh' >/dev/null 2>&1
sudo pkill -9 -f '_json.sh' >/dev/null 2>&1
echo -e "${GREEN}[+] System muted.${NC}"

# --- 2. STAGE 0 : INIT ---
> "$LOG_FILE"
echo '{"command": "clear"}' >> "$LOG_FILE"

echo -e "\n${YELLOW}>>> BROWSER ACTION: REFRESH (F5) NOW.${NC}"
echo "PRESENTER: 'As we begin, the dashboard is empty, representing a secure baseline.'"
echo ""
read -p "=> Press [ENTER] to launch Stage 1 (DoS)... "

# --- 3. STAGE 1 : DOS ---
TS=$(get_ts)
echo "{\"timestamp\":\"$TS\",\"host\":\"$HOST\",\"module\":\"system_health\",\"status\":\"CRITICAL\",\"severity\":\"CRITICAL\",\"load\":14.85,\"memory\":92,\"disk\":95,\"message\":\"Critical CPU Load: Potential DoS\"}" >> "$LOG_FILE"

echo -e "\n${RED}[!] STAGE 1 INJECTED.${NC}"
echo "PRESENTER: 'Stage 1: A DoS attack targets the node. Notice the System Load KPI jumping to 14.85.'"
read -p "=> Press [ENTER] to launch Stage 2 (Malware)... "

# --- 4. STAGE 2 : PROCESS ---
TS=$(get_ts)
echo "{\"timestamp\":\"$TS\",\"host\":\"$HOST\",\"module\":\"process_audit\",\"severity\":\"CRITICAL\",\"message\":\"High-risk anomaly: Miner identified\",\"top_processes\":[{\"pid\":\"666\",\"user\":\"root\",\"cpu\":99.9,\"cmd\":\"/tmp/.hidden/miner\"}]}" >> "$LOG_FILE"

echo -e "\n${RED}[!] STAGE 2 INJECTED.${NC}"
echo "PRESENTER: 'Stage 2: We detect a high-risk process. A miner is running as root.'"
read -p "=> Press [ENTER] to launch Stage 3 (Network)... "

# --- 5. STAGE 3 : NETWORK ---
TS=$(get_ts)
echo "{\"timestamp\":\"$TS\",\"host\":\"$HOST\",\"module\":\"network_audit\",\"severity\":\"CRITICAL\",\"message\":\"Unauthorized port listener: 6666\",\"open_ports\":32}" >> "$LOG_FILE"

echo -e "\n${RED}[!] STAGE 3 INJECTED.${NC}"
echo "PRESENTER: 'Stage 3: The attacker attempts to establish persistence. Suspicious listener on port 6666.'"
read -p "=> Press [ENTER] to launch Stage 4 (Brute Force)... "

# --- 6. STAGE 4 : USER ACTIVITY ---
TS=$(get_ts)
echo "{\"timestamp\":\"$TS\",\"host\":\"$HOST\",\"module\":\"user_activity\",\"severity\":\"WARNING\",\"message\":\"SSH Brute-force detected\",\"failed_attempts\":25}" >> "$LOG_FILE"

echo -e "\n${RED}[!] STAGE 4 INJECTED.${NC}"
echo "PRESENTER: 'Stage 4: Simultaneously, a brute-force attack on SSH. 25 failed attempts recorded.'"
read -p "=> Press [ENTER] to launch Stage 5 (FIM)... "

# --- 7. STAGE 5 : FIM ---
TS=$(get_ts)
echo "{\"timestamp\":\"$TS\",\"host\":\"$HOST\",\"module\":\"file_integrity\",\"status\":\"MODIFIED\",\"severity\":\"CRITICAL\",\"message\":\"FIM Violation in /etc/shadow\"}" >> "$LOG_FILE"

echo -e "\n${RED}[!] STAGE 5 INJECTED.${NC}"
echo "PRESENTER: 'Stage 5: A critical system file is modified. Integrity Health switches to COMPROMISED.'"
read -p "=> Press [ENTER] to CLEANUP & RECOVER... "

# --- 8. RECOVERY & UNMUTE ---
echo -e "\n${YELLOW}[*] Recovery sequence initiated...${NC}"
> "$LOG_FILE"
TS=$(get_ts)
echo "{\"timestamp\":\"$TS\",\"host\":\"$HOST\",\"module\":\"system_health\",\"status\":\"OK\",\"severity\":\"INFO\",\"load\":0.05,\"memory\":5,\"disk\":2,\"message\":\"Recovery complete\"}" >> "$LOG_FILE"
echo "{\"timestamp\":\"$TS\",\"host\":\"$HOST\",\"module\":\"file_integrity\",\"status\":\"SECURE\",\"severity\":\"INFO\",\"message\":\"Baseline restored\"}" >> "$LOG_FILE"

if [ -f "${REAL_MONITOR}.bak" ]; then
    sudo mv "${REAL_MONITOR}.bak" "$REAL_MONITOR"
fi
sudo nohup bash "$REAL_MONITOR" >/dev/null 2>&1 &

echo -e "\n${YELLOW}>>> BROWSER ACTION: FINAL REFRESH (F5) NOW.${NC}"
echo "PRESENTER: 'The incident is resolved. Malicious traces are removed, and the baseline is restored. The system is secure again.'"
echo -e "${GREEN}Demo finished!${NC}"
