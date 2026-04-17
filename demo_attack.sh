#!/usr/bin/env python3
import json
import os
import time
from datetime import datetime

# --- CONFIGURATION ---
LOG_PATH = "/opt/hids-project/hids_project/dashboard/test_logs/hids_system.log"
HOST = "hids-server-01"

class Colors:
    BLUE = '\033[94m'; GREEN = '\033[92m'; YELLOW = '\033[93m'; RED = '\033[91m'; BOLD = '\033[1m'; END = '\033[0m'

def get_ts():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def write_log(data):
    with open(LOG_PATH, "a") as f:
        f.write(json.dumps(data) + "\n")

def clear_logs():
    open(LOG_PATH, 'w').close()

def run_demo():
    os.system('clear')
    print(f"{Colors.BLUE}====================================================={Colors.END}")
    print(f"{Colors.BLUE}   SENTINEL HIDS - PROFESSIONAL DEMO SEQUENCE        {Colors.END}")
    print(f"{Colors.BLUE}====================================================={Colors.END}")

    # --- STAGE 0: INITIALIZATION ---
    print(f"\n{Colors.GREEN}[*] STAGE 0: INITIALIZATION{Colors.END}")
    clear_logs()
    write_log({"command": "clear"})
    print(f"{Colors.YELLOW}>>> ACTION: Refresh your browser (F5) NOW to start with a clean interface.{Colors.END}")
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'As you can see on the screen, our Sentinel Control Plane is currently empty.'")
    print(" - 'The system is monitored, stable, and no security events are recorded.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to launch the first attack...{Colors.END}")

    # --- STAGE 1: DoS ATTACK ---
    print(f"\n{Colors.RED}[!] STAGE 1: RESOURCE EXHAUSTION (DoS){Colors.END}")
    write_log({
        "timestamp": get_ts(),
        "host": HOST,
        "module": "system_health",
        "status": "CRITICAL",
        "severity": "CRITICAL",
        "load": 14.85,
        "memory": 92,
        "disk": 95,
        "message": "Critical CPU Load Detected: Possible DoS attack in progress"
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'We are now simulating a heavy DoS attack on the server.'")
    print(" - 'Look at the top-left KPI: the System Load has instantly jumped to 14.85.'")
    print(" - 'The telemetry chart is also showing a massive spike in resource consumption.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to launch the second attack...{Colors.END}")

    # --- STAGE 2: FIM BREACH ---
    print(f"\n{Colors.RED}[!] STAGE 2: HOST INTEGRITY BREACH (FIM){Colors.END}")
    os.system("sudo touch /etc/hacker_config.bak")
    write_log({
        "timestamp": get_ts(),
        "host": HOST,
        "module": "file_integrity",
        "status": "MODIFIED",
        "severity": "CRITICAL",
        "message": "FIM Violation: Unauthorized write access detected in /etc/"
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'An attacker is now trying to gain persistence by modifying system files.'")
    print(" - 'Observe the FIM Status widget: it has switched to a RED COMPROMISED state.'")
    print(" - 'The incident stream below provides the exact path of the violation.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to launch the third attack...{Colors.END}")

    # --- STAGE 3: NETWORK PERSISTENCE ---
    print(f"\n{Colors.RED}[!] STAGE 3: COVERT NETWORK CHANNEL{Colors.END}")
    write_log({
        "timestamp": get_ts(),
        "host": HOST,
        "module": "network_audit",
        "severity": "CRITICAL",
        "message": "Suspicious listener detected on unauthorized port 6666",
        "open_ports": 32
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'Finally, the attacker opens a reverse shell on port 6666.'")
    print(" - 'The Network Surface monitor immediately detects 32 open ports instead of the usual baseline.'")
    print(" - 'Our Sentinel HIDS has successfully mapped the full attack kill-chain.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for final cleanup and recovery...{Colors.END}")

    # --- STAGE 4: CLEANUP ---
    print(f"\n{Colors.GREEN}[*] STAGE 4: AUTOMATED RECOVERY{Colors.END}")
    os.system("sudo rm -f /etc/hacker_config.bak")
    clear_logs() # We wipe the malicious logs to restore a clean state
    
    # Send health signals so that the NEXT refresh starts green
    ts = get_ts()
    write_log({"timestamp": ts, "host": HOST, "module": "system_health", "status": "OK", "severity": "INFO", "load": 0.05, "memory": 8, "disk": 2, "message": "Baseline restored"})
    write_log({"timestamp": ts, "host": HOST, "module": "file_integrity", "status": "SECURE", "severity": "INFO", "message": "Integrity verified"})
    
    print(f"\n{Colors.YELLOW}>>> ACTION: Final Refresh (F5) NOW to restore the Dashboard to its SECURE state.{Colors.END}")
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'We have now triggered our incident response protocol.'")
    print(" - 'Malicious files are removed, and system health is back to baseline.'")
    print(" - 'The dashboard is now showing a fully secured environment once again.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to exit the simulation.{Colors.END}")

    print(f"\n{Colors.BLUE}====================================================={Colors.END}")
    print(f"{Colors.BLUE}   DEMONSTRATION COMPLETE - SYSTEM SECURED           {Colors.END}")
    print(f"{Colors.BLUE}====================================================={Colors.END}")

if __name__ == "__main__":
    run_demo()
