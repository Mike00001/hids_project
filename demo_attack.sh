#!/usr/bin/env python3
import json
import os
import subprocess
import time
from datetime import datetime

# --- CONFIGURATION ---
LOG_PATH = "/opt/hids-project/hids_project/dashboard/test_logs/hids_system.log"
# The script that triggers the real monitoring
REAL_MONITOR = "/opt/hids-project/hids_project/Modules_JSON/main_json.sh"
HOST = "hids-server-01"

class Colors:
    BLUE = '\033[94m'; GREEN = '\033[92m'; YELLOW = '\033[93m'; RED = '\033[91m'; BOLD = '\033[1m'; END = '\033[0m'

def get_ts(): return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def write_log(data):
    with open(LOG_PATH, "a") as f:
        f.write(json.dumps(data) + "\n")

def toggle_monitoring(status):
    """Aggressively stops or restarts real monitoring."""
    if status == "OFF":
        print(f"{Colors.YELLOW}[*] SILENCING REAL-TIME MONITORING...{Colors.END}")
        # Kill any running monitoring process
        os.system("sudo pkill -9 -f 'main_json.sh'")
        os.system("sudo pkill -9 -f '_json.sh'")
        # Temporarily rename the script to prevent auto-restart
        if os.path.exists(REAL_MONITOR):
            os.system(f"sudo mv {REAL_MONITOR} {REAL_MONITOR}.bak")
        print(f"{Colors.GREEN}[+] System is now muted. No background noise allowed.{Colors.END}")
    else:
        print(f"\n{Colors.GREEN}[*] RESTORING REAL-TIME MONITORING...{Colors.END}")
        # Restore the original script name
        if os.path.exists(REAL_MONITOR + ".bak"):
            os.system(f"sudo mv {REAL_MONITOR}.bak {REAL_MONITOR}")
        # Restart the real monitoring in background
        subprocess.Popen(["sudo", "bash", REAL_MONITOR], stdout=open(os.devnull, 'w'), stderr=open(os.devnull, 'w'))

def run_demo():
    os.system('clear')
    print(f"{Colors.BLUE}====================================================={Colors.END}")
    print(f"{Colors.BLUE}   SENTINEL HIDS - PROFESSIONAL DEMO SEQUENCE        {Colors.END}")
    print(f"{Colors.BLUE}====================================================={Colors.END}")

    # --- STAGE 0: INITIALIZATION ---
    toggle_monitoring("OFF")
    open(LOG_PATH, 'w').close() 
    write_log({"command": "clear"})
    
    print(f"\n{Colors.YELLOW}>>> BROWSER ACTION: REFRESH (F5) NOW.{Colors.END}")
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Welcome to the Sentinel HIDS Control Plane.'")
    print(" - 'As we begin, the dashboard is empty, representing a secure and fresh baseline.'")
    input(f"\n{Colors.BOLD}[Press ENTER to start the Attack Sequence]{Colors.END}")

    # --- STAGE 1: SYSTEM HEALTH (DoS) ---
    print(f"\n{Colors.RED}[!] STAGE 1: DoS ATTACK{Colors.END}")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "system_health",
        "status": "CRITICAL", "severity": "CRITICAL", "load": 14.85, "memory": 92, "disk": 95,
        "message": "Critical CPU Load: Potential Denial of Service in progress"
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'We start by simulating a high-load DoS attack.'")
    print(" - 'Observe the System Load KPI: it instantly spikes to 14.85, and the chart reacts.'")
    input(f"\n{Colors.BOLD}[Press ENTER for Stage 2: Malware Detection]{Colors.END}")

    # --- STAGE 2: PROCESS AUDIT (MALWARE) ---
    print(f"\n{Colors.RED}[!] STAGE 2: MALICIOUS PROCESS{Colors.END}")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "process_audit",
        "severity": "CRITICAL", "message": "High-risk anomaly: Cryptominer identified",
        "top_processes": [{"pid":"666", "user":"root", "cpu":99.9, "cmd":"/tmp/.hidden/miner"}]
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'Simultaneously, an unauthorized process is detected in the background.'")
    print(" - 'In the Process Tree, we see a hidden miner running as root with 99% CPU usage.'")
    input(f"\n{Colors.BOLD}[Press ENTER for Stage 3: Network Exposure]{Colors.END}")

    # --- STAGE 3: NETWORK AUDIT ---
    print(f"\n{Colors.RED}[!] STAGE 3: COVERT CHANNEL{Colors.END}")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "network_audit",
        "severity": "CRITICAL", "message": "Unauthorized port listener: 6666", "open_ports": 32
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'The attacker is now opening a backdoor on port 6666.'")
    print(" - 'Our Network module flags this new open port immediately on the dashboard.'")
    input(f"\n{Colors.BOLD}[Press ENTER for Stage 4: Brute-Force]{Colors.END}")

    # --- STAGE 4: USER ACTIVITY ---
    print(f"\n{Colors.RED}[!] STAGE 4: SSH BRUTE-FORCE{Colors.END}")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "user_activity",
        "severity": "WARNING", "message": "SSH Brute-force attempt detected from 1.2.3.4", "failed_attempts": 25
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'The attack continues with an SSH brute-force attempt.'")
    print(" - 'The Failed Auth counter turns red, showing 25 unsuccessful attempts in seconds.'")
    input(f"\n{Colors.BOLD}[Press ENTER for Stage 5: File Integrity]{Colors.END}")

    # --- STAGE 5: FILE INTEGRITY (FIM) ---
    print(f"\n{Colors.RED}[!] STAGE 5: INTEGRITY BREACH{Colors.END}")
    os.system("sudo touch /etc/hacker.conf")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "file_integrity",
        "status": "MODIFIED", "severity": "CRITICAL", "message": "FIM Violation: Unauthorized change in /etc/shadow"
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'Finally, a core system configuration file is modified.'")
    print(" - 'The FIM module switches the global Integrity Health to COMPROMISED.'")
    input(f"\n{Colors.BOLD}[Press ENTER for Final Cleanup & Recovery]{Colors.END}")

    # --- STAGE 6: RECOVERY ---
    print(f"\n{Colors.GREEN}[*] STAGE 6: SYSTEM RECOVERY{Colors.END}")
    os.system("sudo rm -f /etc/hacker.conf")
    open(LOG_PATH, 'w').close()
    
    # Pre-inject green baseline
    ts = get_ts()
    write_log({"timestamp": ts, "host": HOST, "module": "system_health", "status": "OK", "severity": "INFO", "load": 0.05, "memory": 5, "disk": 2, "message": "Recovery complete: baseline restored"})
    write_log({"timestamp": ts, "host": HOST, "module": "file_integrity", "status": "SECURE", "severity": "INFO", "message": "FIM: System files verified"})
    
    toggle_monitoring("ON")
    
    print(f"\n{Colors.YELLOW}>>> BROWSER ACTION: FINAL REFRESH (F5) NOW.{Colors.END}")
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'We have triggered our automated incident response protocol.'")
    print(" - 'Malicious processes were killed, files removed, and the baseline is restored.'")
    print(" - 'Our system is now back to a fully SECURE state.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to end the session.{Colors.END}")

if __name__ == "__main__":
    try:
        run_demo()
    except KeyboardInterrupt:
        toggle_monitoring("ON")
        print("\nExiting...")
