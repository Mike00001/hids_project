#!/usr/bin/env python3
import json
import os
import subprocess
from datetime import datetime

# --- CONFIGURATION ---
LOG_PATH = "/opt/hids-project/hids_project/dashboard/test_logs/hids_system.log"
# Chemin vers ton script principal qui lance tous les modules
REAL_MONITOR_SCRIPT = "/opt/hids-project/hids_project/Modules_JSON/main_json.sh"
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

def toggle_real_monitoring(status):
    """Stops or starts the real monitoring background processes."""
    if status == "OFF":
        print(f"{Colors.YELLOW}[*] Muting real-time monitoring scripts...{Colors.END}")
        # On tue le script principal et tous les sous-scripts de détection
        os.system("sudo pkill -f 'main_json.sh'")
        os.system("sudo pkill -f '_json.sh'") # Tue les modules individuels
    else:
        print(f"\n{Colors.GREEN}[*] Restoring real-time monitoring...{Colors.END}")
        # On relance le script en arrière-plan (nohup évite qu'il coupe quand on ferme la démo)
        subprocess.Popen(["sudo", "nohup", "bash", REAL_MONITOR_SCRIPT], 
                         stdout=open(os.devnull, 'w'), stderr=open(os.devnull, 'w'))

def run_demo():
    os.system('clear')
    print(f"{Colors.BLUE}====================================================={Colors.END}")
    print(f"{Colors.BLUE}   SENTINEL HIDS - STEALTH DEMO MODE (5 MODULES)     {Colors.END}")
    print(f"{Colors.BLUE}====================================================={Colors.END}")

    # --- STAGE 0: INITIALIZATION & MUTE ---
    print(f"\n{Colors.GREEN}[*] STAGE 0: INITIALIZATION{Colors.END}")
    toggle_real_monitoring("OFF") # On met en sourdine
    clear_logs()
    write_log({"command": "clear"})
    print(f"{Colors.YELLOW}>>> ACTION: Refresh your browser (F5) NOW to start clean.{Colors.END}")
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Welcome to the Sentinel HIDS demonstration.'")
    print(" - 'The system is currently stable and all background monitors are active.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to start Stage 1...{Colors.END}")

    # --- STAGE 1: SYSTEM HEALTH ---
    print(f"\n{Colors.RED}[!] STAGE 1: RESOURCE EXHAUSTION (DoS){Colors.END}")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "system_health",
        "status": "CRITICAL", "severity": "CRITICAL", "load": 14.85, "memory": 92, "disk": 95,
        "message": "Critical CPU Load: Denial of Service attack suspected"
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Stage 1: A massive DoS attack hits the server.'")
    print(" - 'The System Load KPI jumps to 14.85, flagged as a Critical Alert.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Stage 2...{Colors.END}")

    # --- STAGE 2: PROCESS AUDIT ---
    print(f"\n{Colors.RED}[!] STAGE 2: MALWARE DETECTION (Process Audit){Colors.END}")
    fake_procs = [{"pid": "666", "user": "root", "cpu": 99.9, "cmd": "/tmp/.hidden/miner"}]
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "process_audit",
        "severity": "CRITICAL", "message": "High-risk process: Cryptominer detected",
        "top_processes": fake_procs
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Stage 2: We detect a malicious process running as root.'")
    print(" - 'The miner is identified in the /tmp directory, a common sign of compromise.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Stage 3...{Colors.END}")

    # --- STAGE 3: NETWORK AUDIT ---
    print(f"\n{Colors.RED}[!] STAGE 3: NETWORK SURFACE BREACH{Colors.END}")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "network_audit",
        "severity": "CRITICAL", "message": "Unauthorized port listener: 6666", "open_ports": 32
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Stage 3: The attacker attempts to establish a remote connection.'")
    print(" - 'Our audit flags an unauthorized port (6666) opening on the system.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Stage 4...{Colors.END}")

    # --- STAGE 4: USER ACTIVITY ---
    print(f"\n{Colors.RED}[!] STAGE 4: BRUTE FORCE (User Activity){Colors.END}")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "user_activity",
        "severity": "WARNING", "message": "Multiple failed logins on SSH", "failed_attempts": 25
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Stage 4: A brute-force attack is identified against the SSH service.'")
    print(" - 'The Failed Auth count increases to 25, triggering a security event.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Stage 5...{Colors.END}")

    # --- STAGE 5: FILE INTEGRITY ---
    print(f"\n{Colors.RED}[!] STAGE 5: INTEGRITY BREACH (FIM){Colors.END}")
    os.system("sudo touch /etc/hacker.conf")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "file_integrity",
        "status": "MODIFIED", "severity": "CRITICAL", "message": "FIM Violation: unauthorized change in /etc/"
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Stage 5: Finally, the attacker modifies system configuration files.'")
    print(" - 'The Host Integrity module switches the global state to COMPROMISED.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Final Recovery...{Colors.END}")

    # --- STAGE 6: CLEANUP & RESTORE ---
    print(f"\n{Colors.GREEN}[*] STAGE 6: RECOVERY{Colors.END}")
    os.system("sudo rm -f /etc/hacker.conf")
    clear_logs()
    
    # Inject one last "All Green" log set
    ts = get_ts()
    write_log({"timestamp": ts, "host": HOST, "module": "system_health", "status": "OK", "severity": "INFO", "load": 0.05, "memory": 5, "disk": 2, "message": "Recovery complete"})
    write_log({"timestamp": ts, "host": HOST, "module": "file_integrity", "status": "SECURE", "severity": "INFO", "message": "Baseline restored"})
    
    toggle_real_monitoring("ON") # On relance les vrais scripts
    
    print(f"\n{Colors.YELLOW}>>> ACTION: Final Refresh (F5) NOW to restore baseline.{Colors.END}")
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Incident Response is complete. We have sanitized the system.'")
    print(" - 'Our monitoring is back online, showing a fully secured environment.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to exit.{Colors.END}")

if __name__ == "__main__":
    run_demo()
