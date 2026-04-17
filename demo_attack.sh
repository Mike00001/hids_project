import json
import os
import time
from datetime import datetime

# --- CONFIGURATION ---
LOG_PATH = "/opt/hids-project/hids_project/dashboard/test_logs/hids_system.log"
HOST = "hids-server-01"

# ANSI Colors for Terminal Output
class Colors:
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    END = '\033[0m'

def get_timestamp():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def write_log(data):
    """Writes a single JSON line to the log file."""
    with open(LOG_PATH, "a") as f:
        f.write(json.dumps(data) + "\n")

def clear_logs():
    """Truncates the log file to zero."""
    open(LOG_PATH, 'w').close()

def wait_for_user(step_name):
    print(f"\n{Colors.YELLOW}[ACTION REQUIRED]{Colors.END}")
    print(f"{Colors.BOLD}1. Refresh your browser (F5){Colors.END} to see the {step_name} result.")
    input(f"{Colors.BOLD}2. Press [ENTER]{Colors.END} to move to the next stage...")

# --- DEMO SEQUENCE ---

def run_demo():
    os.system('clear')
    print(f"{Colors.BLUE}====================================================={Colors.END}")
    print(f"{Colors.BLUE}   SENTINEL HIDS - GUIDED DEMONSTRATION (PYTHON)     {Colors.END}")
    print(f"{Colors.BLUE}====================================================={Colors.END}")

    # STEP 0: INITIALIZATION
    print(f"\n{Colors.GREEN}[*] STAGE 0: SYSTEM INITIALIZATION{Colors.END}")
    clear_logs()
    write_log({"command": "clear"})
    print("[-] Logs truncated. 'Clear' signal sent to dashboard pipeline.")
    wait_for_user("CLEAN DASHBOARD")

    # STEP 1: RESOURCE EXHAUSTION
    print(f"\n{Colors.RED}[!] STAGE 1: RESOURCE EXHAUSTION (DoS ATTACK){Colors.END}")
    attack_data = {
        "timestamp": get_timestamp(),
        "host": HOST,
        "module": "system_health",
        "status": "CRITICAL",
        "severity": "CRITICAL",
        "load": 14.85,
        "memory": 92,
        "disk": 95,
        "message": "Critical CPU Load Detected: System instability imminent"
    }
    write_log(attack_data)
    print(f"[-] Injected System Health Critical Alert (Load: 14.85)")
    wait_for_user("SYSTEM LOAD SPIKE")

    # STEP 2: FILE INTEGRITY BREACH
    print(f"\n{Colors.RED}[!] STAGE 2: FILE INTEGRITY BREACH (FIM){Colors.END}")
    # Simulate a real file change for the demo
    os.system("sudo touch /etc/hacker_config.bak")
    fim_data = {
        "timestamp": get_timestamp(),
        "host": HOST,
        "module": "file_integrity",
        "status": "MODIFIED",
        "severity": "CRITICAL",
        "message": "FIM Violation: Unauthorized write access in /etc/"
    }
    write_log(fim_data)
    print("[-] Created /etc/hacker_config.bak and injected FIM Alert.")
    wait_for_user("FIM RED STATUS")

    # STEP 3: NETWORK PERSISTENCE
    print(f"\n{Colors.RED}[!] STAGE 3: COVERT NETWORK CHANNEL{Colors.END}")
    net_data = {
        "timestamp": get_timestamp(),
        "host": HOST,
        "module": "network_audit",
        "severity": "CRITICAL",
        "message": "Suspicious listener detected on unauthorized port 6666",
        "open_ports": 32
    }
    write_log(net_data)
    print("[-] Injected Network Audit Alert (32 open ports).")
    wait_for_user("NETWORK EXPOSURE")

    # STEP 4: AUTOMATED RECOVERY
    print(f"\n{Colors.GREEN}[*] STAGE 4: INCIDENT RESPONSE & RECOVERY{Colors.END}")
    os.system("sudo rm -f /etc/hacker_config.bak")
    clear_logs() # Wipe the "malicious" logs
    
    # Inject healthy baseline
    recovery_ts = get_timestamp()
    health_recovery = {
        "timestamp": recovery_ts,
        "host": HOST,
        "module": "system_health",
        "status": "OK",
        "severity": "INFO",
        "load": 0.05,
        "memory": 8,
        "disk": 2,
        "message": "Baseline restored: all systems nominal"
    }
    fim_recovery = {
        "timestamp": recovery_ts,
        "host": HOST,
        "module": "file_integrity",
        "status": "SECURE",
        "severity": "INFO",
        "message": "Integrity check passed: system files verified"
    }
    write_log(health_recovery)
    write_log(fim_recovery)
    
    print("[-] Attack traces removed. Health signals restored to baseline.")
    wait_for_user("RECOVERY (GREEN DASHBOARD)")

    print(f"\n{Colors.BLUE}====================================================={Colors.END}")
    print(f"{Colors.BLUE}   DEMONSTRATION COMPLETE - SYSTEM SECURED           {Colors.END}")
    print(f"{Colors.BLUE}====================================================={Colors.END}")

if __name__ == "__main__":
    try:
        run_demo()
    except KeyboardInterrupt:
        print("\nDemo aborted by user.")
