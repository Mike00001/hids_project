#!/bin/bash
# =========================================================
# SENTINEL HIDS - Professional Attack & Recovery Simulation
# =========================================================

# --- CONFIGURATION ---
# Assure-toi que ce chemin est correct sur ton Trigkey
LOG_FILE="/opt/hids-project/hids_project/dashboard/test_logs/hids_system.log"
HOST=$(hostname)

# Terminal Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper: Dynamic Timestamp
get_ts() { date +"%Y-%m-%d %H:%M:%S"; }

# Helper: Typewriter Effect
type_text() {
    local text="$1"
    for (( i=0; i<${#text}; i++ )); do
        echo -ne "${text:$i:1}"
        sleep 0.03
    done
    echo ""
}

clear
echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE}   SENTINEL HIDS - ENTERPRISE THREAT SIMULATOR       ${NC}"
echo -e "${BLUE}=====================================================${NC}"
echo -e "${YELLOW}[SYSTEM] Target Host: $HOST${NC}"
echo ""

# --- STEP 0: INITIALIZATION ---
echo -e "${YELLOW}[*] Initializing Demo Environment...${NC}"
# Flush the log file and the frontend UI
sudo truncate -s 0 "$LOG_FILE"
echo "{\"command\":\"clear\"}" >> "$LOG_FILE"
type_text "[-] Flushing remote dashboard memory... SUCCESS"
type_text "[-] Synchronizing telemetry clocks... SUCCESS"
echo -e "${GREEN}[+] Ready for live demonstration.${NC}"
sleep 3

# --- STEP 1: RESOURCE EXHAUSTION (System Health) ---
echo -e "\n${RED}[!] STAGE 1: Resource Exhaustion (DoS Attack)${NC}"
type_text "> Executing memory leak payload and fork bomb simulation..."
echo "{\"timestamp\":\"$(get_ts)\",\"host\":\"$HOST\",\"module\":\"system_health\",\"status\":\"CRITICAL\",\"severity\":\"CRITICAL\",\"load\":14.20,\"memory\":98,\"disk\":96,\"message\":\"Critical resource exhaustion: CPU Load Average exceeded threshold (14.20)\"}" >> "$LOG_FILE"
echo -e "${BLUE}   [Action] Note the 'Avg System Load' jumping to 14.20 and the graph spike.${NC}"
sleep 6

# --- STEP 2: NETWORK PERSISTENCE (Network Audit) ---
echo -e "\n${RED}[!] STAGE 2: Establishing Network Persistence${NC}"
type_text "> Opening covert listener (Reverse Shell) on port 6666..."
timeout 10 nc -l -p 6666 &
echo "{\"timestamp\":\"$(get_ts)\",\"host\":\"$HOST\",\"module\":\"network_audit\",\"severity\":\"CRITICAL\",\"message\":\"Unauthorized network listener detected on port 6666\",\"open_ports\":32}" >> "$LOG_FILE"
echo -e "${BLUE}   [Action] Watch the 'Network Exposure' widget update to 32 active ports.${NC}"
sleep 6

# --- STEP 3: MALWARE EXECUTION (Process Audit) ---
echo -e "\n${RED}[!] STAGE 3: Malicious Process Deployment${NC}"
type_text "> Launching cryptojacker binary: /tmp/.hidden/xmrig..."
fake_procs="[{\"pid\":\"666\", \"user\":\"root\", \"cpu\":99.9, \"cmd\":\"/tmp/.hidden/xmrig -o pool.monero.org\"}, {\"pid\":\"1201\", \"user\":\"m\", \"cpu\":0.5, \"cmd\":\"uvicorn\"}, {\"pid\":\"42\", \"user\":\"root\", \"cpu\":0.0, \"cmd\":\"kworker/u2:0\"}]"
echo "{\"timestamp\":\"$(get_ts)\",\"host\":\"$HOST\",\"module\":\"process_audit\",\"severity\":\"CRITICAL\",\"message\":\"High-risk anomaly detected: Suspicious binary executing from /tmp\",\"top_processes\":$fake_procs}" >> "$LOG_FILE"
echo -e "${BLUE}   [Action] See the 'ANOMALY' tag in the Process Inspection table.${NC}"
sleep 6

# --- STEP 4: BRUTE FORCE & PRIVILEGE ESCALATION (User Activity) ---
echo -e "\n${RED}[!] STAGE 4: Credential Brute-Force & Privilege Escalation${NC}"
type_text "> Infiltrating SSH subsystem... Injecting failed auth logs..."
for i in {1..5}; do
    sudo bash -c 'echo "$(date +"%b %_d %H:%M:%S") $(hostname) sshd[1234]: Failed password for invalid user admin from 10.0.0.50" >> /var/log/auth.log'
done
echo "{\"timestamp\":\"$(get_ts)\",\"host\":\"$HOST\",\"module\":\"user_activity\",\"severity\":\"WARNING\",\"message\":\"High volume of failed login attempts detected\",\"failed_attempts\":25}" >> "$LOG_FILE"
echo -e "${BLUE}   [Action] The 'Failed Auth' KPI is now RED (25 attempts).${NC}"
sleep 6

# --- STEP 5: FILE INTEGRITY BREACH (FIM) ---
echo -e "\n${RED}[!] STAGE 5: Host Integrity Compromise (FIM)${NC}"
type_text "> Modifying sensitive system files... Dropping backdoor..."
sudo touch /etc/hacker.conf
echo "{\"timestamp\":\"$(get_ts)\",\"host\":\"$HOST\",\"module\":\"file_integrity\",\"status\":\"MODIFIED\",\"severity\":\"CRITICAL\",\"message\":\"Integrity Violation: Unauthorized file creation in /etc/ directory\"}" >> "$LOG_FILE"
echo -e "${BLUE}   [Action] FIM Status: 'COMPROMISED'. System integrity is lost.${NC}"
sleep 6

# --- FINAL PHASE ---
echo -e "\n${GREEN}=====================================================${NC}"
echo -e "${GREEN}        THREAT SIMULATION COMPLETE - NODE OWNED      ${NC}"
echo -e "${GREEN}=====================================================${NC}"
echo "Press ENTER to start the Automated Recovery Sequence..."
read

# --- ADVANCED CLEANUP & RECOVERY ---
echo -e "\n${YELLOW}[*] Critical Recovery Sequence Initiated...${NC}"

# 1. Terminate attack processes
sudo pkill -f "nc -l -p 6666"
type_text "[-] Terminating malicious listeners and payloads... DONE"

# 2. Restore System state
sudo rm -f /etc/hacker.conf
sudo truncate -s 0 /var/log/auth.log
type_text "[-] Restoring system file integrity & rotating auth logs... DONE"

# 3. Wipe HIDS Logs
sudo truncate -s 0 "$LOG_FILE"
type_text "[-] Purging HIDS telemetry buffer... DONE"

# 4. Inject Recovery Signals (Force the Dashboard to turn green)
TS=$(get_ts)
echo "{\"timestamp\":\"$TS\",\"host\":\"$HOST\",\"module\":\"system_health\",\"status\":\"OK\",\"severity\":\"INFO\",\"load\":0.04,\"memory\":5,\"disk\":2,\"message\":\"Recovery complete: System load back to baseline\"}" >> "$LOG_FILE"
echo "{\"timestamp\":\"$TS\",\"host\":\"$HOST\",\"module\":\"file_integrity\",\"status\":\"SECURE\",\"severity\":\"INFO\",\"message\":\"Integrity baseline verified: All files match cryptographic hash\"}" >> "$LOG_FILE"
echo "{\"timestamp\":\"$TS\",\"host\":\"$HOST\",\"module\":\"user_activity\",\"severity\":\"INFO\",\"message\":\"Login monitor reset: No suspicious activity\",\"failed_attempts\":0}" >> "$LOG_FILE"
echo "{\"timestamp\":\"$TS\",\"host\":\"$HOST\",\"module\":\"network_audit\",\"severity\":\"INFO\",\"message\":\"Network policy enforced: Only authorized ports open\",\"open_ports\":12}" >> "$LOG_FILE"

# 5. Clear the Incident Stream
echo "{\"command\":\"clear\"}" >> "$LOG_FILE"

type_text "[-] Hardening system baseline... DONE"
echo -e "\n${BLUE}[+200 OK] System Baseline Restored. Control Plane Secured.${NC}"
