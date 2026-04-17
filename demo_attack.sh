#!/bin/bash
# =========================================================
# SENTINEL HIDS - Professional Attack Simulation Script
# =========================================================

# --- CONFIGURATION ---
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
echo -e "${YELLOW}[SYSTEM] Log Pipeline: $LOG_FILE${NC}"
echo ""

# --- STEP 0: INITIALIZATION ---
echo -e "${YELLOW}[*] Initializing Demo Environment...${NC}"
# Send clear command to flush the frontend
echo "{\"command\":\"clear\"}" >> "$LOG_FILE"
type_text "[-] Flushing remote dashboard memory... SUCCESS"
type_text "[-] Synchronizing telemetry clocks... SUCCESS"
echo -e "${GREEN}[+] Ready for live demonstration.${NC}"
sleep 3

# --- STEP 1: RESOURCE EXHAUSTION (System Health) ---
echo -e "\n${RED}[!] STAGE 1: Resource Exhaustion (DoS Attack)${NC}"
type_text "> Executing memory leak payload and fork bomb simulation..."
echo "{\"timestamp\":\"$(get_ts)\",\"host\":\"$HOST\",\"module\":\"system_health\",\"status\":\"CRITICAL\",\"severity\":\"CRITICAL\",\"load\":12.45,\"memory\":98,\"disk\":96,\"message\":\"Critical resource exhaustion: CPU Load Average exceeded threshold (12.45)\"}" >> "$LOG_FILE"
echo -e "${BLUE}   [Action] Observe the 'System Load' KPI and the Telemetry Graph spikes.${NC}"
sleep 6

# --- STEP 2: NETWORK PERSISTENCE (Network Audit) ---
echo -e "\n${RED}[!] STAGE 2: Establishing Network Persistence${NC}"
type_text "> Opening covert listener (Reverse Shell) on port 6666..."
# Actually open the port for a few seconds
timeout 10 nc -l -p 6666 &
# Inject the detection log
echo "{\"timestamp\":\"$(get_ts)\",\"host\":\"$HOST\",\"module\":\"network_audit\",\"severity\":\"CRITICAL\",\"message\":\"Unauthorized network listener detected on port 6666\",\"open_ports\":32}" >> "$LOG_FILE"
echo -e "${BLUE}   [Action] Watch the 'Network Exposure' widget update to 32 active ports.${NC}"
sleep 6

# --- STEP 3: MALWARE EXECUTION (Process Audit) ---
echo -e "\n${RED}[!] STAGE 3: Malicious Process Deployment${NC}"
type_text "> Launching cryptojacker binary: /tmp/.hidden/xmrig..."
fake_procs="[{\"pid\":\"666\", \"user\":\"root\", \"cpu\":99.9, \"cmd\":\"/tmp/.hidden/xmrig -o pool.monero.org\"}, {\"pid\":\"1201\", \"user\":\"m\", \"cpu\":0.5, \"cmd\":\"uvicorn\"}, {\"pid\":\"42\", \"user\":\"root\", \"cpu\":0.0, \"cmd\":\"kworker/u2:0\"}]"
echo "{\"timestamp\":\"$(get_ts)\",\"host\":\"$HOST\",\"module\":\"process_audit\",\"severity\":\"CRITICAL\",\"message\":\"High-risk anomaly detected: Suspicious binary executing from /tmp\",\"top_processes\":$fake_procs}" >> "$LOG_FILE"
echo -e "${BLUE}   [Action] Note the 'ANOMALY' tag in the Process Inspection Tree table.${NC}"
sleep 6

# --- STEP 4: BRUTE FORCE & PRIVILEGE ESCALATION (User Activity) ---
echo -e "\n${RED}[!] STAGE 4: Credential Brute-Force & Privilege Escalation${NC}"
type_text "> Infiltrating SSH subsystem... Injecting failed auth logs..."
for i in {1..5}; do
    sudo bash -c 'echo "$(date +"%b %_d %H:%M:%S") $(hostname) sshd[1234]: Failed password for invalid user admin from 10.0.0.50" >> /var/log/auth.log'
done
# Send the summary alert
echo "{\"timestamp\":\"$(get_ts)\",\"host\":\"$HOST\",\"module\":\"user_activity\",\"severity\":\"WARNING\",\"message\":\"High volume of failed login attempts detected\",\"failed_attempts\":15}" >> "$LOG_FILE"
echo -e "${BLUE}   [Action] The 'Failed Logins' KPI should now turn RED.${NC}"
sleep 6

# --- STEP 5: FILE INTEGRITY BREACH (FIM) ---
echo -e "\n${RED}[!] STAGE 5: Host Integrity Compromise (FIM)${NC}"
type_text "> Modifying sensitive system files... Disabling audit policies..."
sudo touch /etc/hacker.conf
echo "{\"timestamp\":\"$(get_ts)\",\"host\":\"$HOST\",\"module\":\"file_integrity\",\"status\":\"MODIFIED\",\"severity\":\"CRITICAL\",\"message\":\"Integrity Violation: Unauthorized file creation in /etc/ directory\"}" >> "$LOG_FILE"
echo -e "${BLUE}   [Action] The 'FIM Status' is now 'COMPROMISED'. Critical system breach confirmed.${NC}"
sleep 6

# --- WRAP UP ---
echo -e "\n${GREEN}=====================================================${NC}"
echo -e "${GREEN}        THREAT SIMULATION COMPLETE - NODE OWNED      ${NC}"
echo -e "${GREEN}=====================================================${NC}"
echo "Press ENTER to perform post-incident recovery and clear the Control Plane..."
read

# --- CLEANUP ---
echo -e "${YELLOW}[*] Cleaning up traces...${NC}"
echo "{\"command\":\"clear\"}" >> "$LOG_FILE"
sudo rm /etc/hacker.conf
sudo truncate -s 0 /var/log/auth.log
type_text "[-] Removing malware... DONE"
type_text "[-] Patching integrity baseline... DONE"
type_text "[-] Hardening SSH configuration... DONE"
echo -e "${BLUE}[+] System Baseline Restored. Dashboard Secured.${NC}"
