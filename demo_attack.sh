#!/usr/bin/env python3
import json
import os
from datetime import datetime

# --- CONFIG ---
LOG_PATH = "/opt/hids-project/hids_project/dashboard/test_logs/hids_system.log"
HOST = "hids-server-01"

class Colors:
    BLUE = '\033[94m'; GREEN = '\033[92m'; YELLOW = '\033[93m'; RED = '\033[91m'; BOLD = '\033[1m'; END = '\033[0m'

def get_ts(): return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def write_log(data):
    with open(LOG_PATH, "a") as f:
        f.write(json.dumps(data) + "\n")

def clear_logs(): open(LOG_PATH, 'w').close()

def wait_step(step_name):
    print(f"\n{Colors.YELLOW}[ACTION REQUIRED]{Colors.END}")
    print(f"{Colors.BOLD}1. Refresh your browser (F5){Colors.END} to see: {step_name}")
    input(f"{Colors.BOLD}2. Press [ENTER]{Colors.END} to continue...")

def run():
    os.system('clear')
    print(f"{Colors.BLUE}====================================================={Colors.END}")
    print(f"{Colors.BLUE}   SENTINEL HIDS - GUIDED DEMO (MANUAL SYNC)         {Colors.END}")
    print(f"{Colors.BLUE}====================================================={Colors.END}")

    # STAGE 0
    print(f"\n{Colors.GREEN}[*] STAGE 0: INITIALIZATION{Colors.END}")
    clear_logs()
    write_log({"command": "clear"})
    wait_step("CLEAN DASHBOARD")

    # STAGE 1
    print(f"\n{Colors.RED}[!] STAGE 1: DOS ATTACK{Colors.END}")
    write_log({"timestamp": get_ts(), "host": HOST, "module": "system_health", "status": "CRITICAL", "severity": "CRITICAL", "load": 14.85, "memory": 92, "disk": 95, "message": "Critical CPU Load Detected"})
    wait_step("SYSTEM LOAD SPIKE")

    # STAGE 2
    print(f"\n{Colors.RED}[!] STAGE 2: INTEGRITY BREACH{Colors.END}")
    os.system("sudo touch /etc/hacker_config.bak")
    write_log({"timestamp": get_ts(), "host": HOST, "module": "file_integrity", "status": "MODIFIED", "severity": "CRITICAL", "message": "FIM Violation in /etc/"})
    wait_step("FIM RED STATUS")

    # STAGE 3
    print(f"\n{Colors.GREEN}[*] STAGE 3: RECOVERY{Colors.END}")
    os.system("sudo rm -f /etc/hacker_config.bak")
    clear_logs()
    ts = get_ts()
    write_log({"timestamp": ts, "host": HOST, "module": "system_health", "status": "OK", "severity": "INFO", "load": 0.05, "memory": 8, "disk": 2, "message": "Baseline restored"})
    write_log({"timestamp": ts, "host": HOST, "module": "file_integrity", "status": "SECURE", "severity": "INFO", "message": "Integrity verified"})
    wait_step("RECOVERY (GREEN DASHBOARD)")

if __name__ == "__main__":
    run()
