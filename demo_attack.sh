#!/usr/bin/env python3
import json
import os
import subprocess
import time
from datetime import datetime

# --- CONFIGURATION ---
LOG_PATH = "/opt/hids-project/hids_project/dashboard/test_logs/hids_system.log"
# NOM DE TON SERVICE (Vérifie avec 'systemctl list-units --type=service')
SERVICE_NAME = "hids-monitor.service" 
# Chemin vers ton script de lancement au cas où ce n'est pas un service
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
    """Nuclear stop of all real monitoring processes."""
    if status == "OFF":
        print(f"{Colors.YELLOW}[*] SILENCING REAL MONITORING...{Colors.END}")
        # 1. Arrêt du service systemd s'il existe
        os.system(f"sudo systemctl stop {SERVICE_NAME} 2>/dev/null")
        # 2. Kill agressif des scripts bash
        os.system("sudo pkill -9 -f 'main_json.sh'")
        os.system("sudo pkill -9 -f '_json.sh'")
        print(f"{Colors.GREEN}[+] System is now muted. Only demo logs will be recorded.{Colors.END}")
    else:
        print(f"\n{Colors.GREEN}[*] RESTORING REAL MONITORING...{Colors.END}")
        # Relance via le service si possible, sinon via le script
        os.system(f"sudo systemctl start {SERVICE_NAME} 2>/dev/null")
        # Si pas de service, on lance le script en arrière-plan
        subprocess.Popen(["sudo", "nohup", "bash", REAL_MONITOR_SCRIPT], 
                         stdout=open(os.devnull, 'w'), stderr=open(os.devnull, 'w'))

def run_demo():
    os.system('clear')
    print(f"{Colors.BLUE}====================================================={Colors.END}")
    print(f"{Colors.BLUE}   SENTINEL HIDS - STEALTH PRESENTATION MODE         {Colors.END}")
    print(f"{Colors.BLUE}====================================================={Colors.END}")

    # --- STAGE 0: START ---
    print(f"\n{Colors.GREEN}[*] STAGE 0: INITIALIZATION{Colors.END}")
    toggle_real_monitoring("OFF")
    clear_logs()
    write_log({"command": "clear"})
    
    print(f"\n{Colors.YELLOW}>>> ACTION: Refresh your browser (F5) NOW to start clean.{Colors.END}")
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Our Sentinel HIDS is now active and monitoring the node.'")
    print(" - 'The dashboard is clear, showing a 100% secure and stable environment.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to launch the first attack...{Colors.END}")

    # --- STAGE 1: DoS ---
    print(f"\n{Colors.RED}[!] STAGE 1: RESOURCE EXHAUSTION{Colors.END}")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "system_health",
        "status": "CRITICAL", "severity": "CRITICAL", "load": 14.85, "memory": 92, "disk": 95,
        "message": "Critical CPU Load Detected: Possible DoS attack in progress"
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'We begin by simulating a high-intensity Denial of Service attack.'")
    print(" - 'Look at the System Load KPI: it immediately spiked to 14.85.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for the next attack...{Colors.END}")

    # --- STAGE 2: PROCESS ---
    print(f"\n{Colors.RED}[!] STAGE 2: MALICIOUS PROCESS{Colors.END}")
    fake_procs = [{"pid": "666", "user": "root", "cpu": 99.9, "cmd": "/tmp/.hidden/miner"}]
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "process_audit",
        "severity": "CRITICAL", "message": "High-risk process: Cryptominer detected",
        "top_processes": fake_procs
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'An attacker has now deployed a hidden cryptominer.'")
    print(" - 'Sentinel identifies the process in the /tmp directory, running with root privileges.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for the next attack...{Colors.END}")

    # --- STAGE 3: NETWORK ---
    print(f"\n{Colors.RED}[!] STAGE 3: NETWORK BREACH{Colors.END}")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "network_audit",
        "severity": "CRITICAL", "message": "Unauthorized port listener: 6666", "open_ports": 32
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'The threat actor is opening a backdoor for persistence.'")
    print(" - 'The Network module flags port 6666 as an unauthorized listener.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for the next attack...{Colors.END}")

    # --- STAGE 4: USER ACTIVITY ---
    print(f"\n{Colors.RED}[!] STAGE 4: BRUTE FORCE{Colors.END}")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "user_activity",
        "severity": "WARNING", "message": "Massive SSH Brute-force attempt", "failed_attempts": 25
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'Simultaneously, we detect a brute-force attack on the SSH service.'")
    print(" - 'The dashboard records 25 failed attempts, triggering a warning alert.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for the final attack...{Colors.END}")

    # --- STAGE 5: FIM ---
    print(f"\n{Colors.RED}[!] STAGE 5: INTEGRITY BREACH{Colors.END}")
    os.system("sudo touch /etc/hacker.conf")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "file_integrity",
        "status": "MODIFIED", "severity": "CRITICAL", "message": "FIM Violation: unauthorized change in /etc/"
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'Finally, the attacker modifies core system configurations.'")
    print(" - 'The FIM module instantly switches the global integrity state to COMPROMISED.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to recover the system...{Colors.END}")

    # --- STAGE 6: RECOVERY ---
    print(f"\n{Colors.GREEN}[*] STAGE 6: RECOVERY & RESTORE{Colors.END}")
    os.system("sudo rm -f /etc/hacker.conf")
    clear_logs()
    
    # Pre-inject green baseline for the final refresh
    ts = get_ts()
    write_log({"timestamp": ts, "host": HOST, "module": "system_health", "status": "OK", "severity": "INFO", "load": 0.05, "memory": 5, "disk": 2, "message": "Recovery complete"})
    write_log({"timestamp": ts, "host": HOST, "module": "file_integrity", "status": "SECURE", "severity": "INFO", "message": "Baseline verified"})
    
    toggle_real_monitoring("ON") # On relance tout
    
    print(f"\n{Colors.YELLOW}>>> ACTION: Final Refresh (F5) NOW to show the restored system.{Colors.END}")
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'The incident response team has sanitized the environment.'")
    print(" - 'Malicious processes were killed, and system integrity has been restored.'")
    print(" - 'Sentinel HIDS is once again monitoring a healthy and secure infrastructure.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to finish.{Colors.END}")

if __name__ == "__main__":
    run_demo()
