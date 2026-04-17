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

def get_ts(): return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def write_log(data):
    with open(LOG_PATH, "a") as f:
        f.write(json.dumps(data) + "\n")

def clear_logs():
    open(LOG_PATH, 'w').close()

def run_demo():
    os.system('clear')
    print(f"{Colors.BLUE}====================================================={Colors.END}")
    print(f"{Colors.BLUE}   SENTINEL HIDS - EXECUTIVE DEMO SEQUENCE           {Colors.END}")
    print(f"{Colors.BLUE}====================================================={Colors.END}")

    # --- STAGE 0: INITIALIZATION ---
    clear_logs() 
    time.sleep(0.5) # On laisse le temps au backend de capter le nettoyage
    write_log({"command": "start_demo"}) # On dit au backend d'ignorer les vrais logs
    write_log({"command": "clear", "is_demo": True}) 
    
    print(f"\n{Colors.GREEN}[*] STAGE 0: INITIALIZATION{Colors.END}")
    print(f"{Colors.YELLOW}>>> ACTION: Refresh your browser (F5) NOW to start clean.{Colors.END}")
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Welcome to the Sentinel HIDS demonstration.'")
    print(" - 'Our dashboard is clean, and the underlying infrastructure is operating securely.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to start Stage 1...{Colors.END}")

    # --- STAGE 1: SYSTEM HEALTH ---
    print(f"\n{Colors.RED}[!] STAGE 1: DOS ATTACK (System Health){Colors.END}")
    
    # ASTUCE GRAPHIQUE : 3 points de données pour forcer le traçage de la ligne
    write_log({"is_demo": True, "timestamp": get_ts(), "host": HOST, "module": "system_health", "status": "OK", "severity": "INFO", "load": 0.05, "memory": 10, "disk": 95, "message": "Baseline"})
    time.sleep(0.5)
    write_log({"is_demo": True, "timestamp": get_ts(), "host": HOST, "module": "system_health", "status": "OK", "severity": "INFO", "load": 0.08, "memory": 10, "disk": 95, "message": "Baseline"})
    time.sleep(0.5)
    write_log({
        "is_demo": True,
        "timestamp": get_ts(), "host": HOST, "module": "system_health",
        "status": "CRITICAL", "severity": "CRITICAL", "load": 14.85, "memory": 92, "disk": 95,
        "message": "Critical CPU Load: Denial of Service attack suspected"
    })
    
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'We begin by simulating a massive DoS attack.'")
    print(" - 'Notice the System Load KPI instantly jumping to a critical level of 14.85.'")
    print(" - 'The real-time telemetry chart reflects this immediate resource exhaustion.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Stage 2...{Colors.END}")

    # --- STAGE 2: PROCESS AUDIT ---
    print(f"\n{Colors.RED}[!] STAGE 2: MALWARE DETECTION (Process Audit){Colors.END}")
    write_log({
        "is_demo": True,
        "timestamp": get_ts(), "host": HOST, "module": "process_audit",
        "severity": "CRITICAL", "message": "High-risk anomaly: Unsigned binary in /tmp",
        "top_processes": [{"pid": "666", "user": "root", "cpu": 99.9, "cmd": "/tmp/.hidden/miner_pro"}]
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Meanwhile, the attacker deploys a payload. Look at the Process Inspection Table.'")
    print(" - 'A malicious cryptominer is flagged as an ANOMALY because it runs as root with 99% CPU.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Stage 3...{Colors.END}")

    # --- STAGE 3: NETWORK AUDIT ---
    print(f"\n{Colors.RED}[!] STAGE 3: COVERT CHANNEL (Network Audit){Colors.END}")
    write_log({
        "is_demo": True,
        "timestamp": get_ts(), "host": HOST, "module": "network_audit",
        "severity": "CRITICAL", "message": "Unauthorized listener on port 6666", "open_ports": 32
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'The threat actor attempts to establish persistence by opening a backdoor.'")
    print(" - 'The Network Exposure widget detects the surface breach, showing an unauthorized listener.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Stage 4...{Colors.END}")

    # --- STAGE 4: USER ACTIVITY ---
    print(f"\n{Colors.RED}[!] STAGE 4: BRUTE FORCE (User Activity){Colors.END}")
    write_log({
        "is_demo": True,
        "timestamp": get_ts(), "host": HOST, "module": "user_activity",
        "severity": "WARNING", "message": "Massive failed login attempts on SSH", "failed_attempts": 25
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Simultaneously, we observe a brute-force attack on the SSH service.'")
    print(" - 'The Auth Failures KPI turns red, recording 25 rapid failed attempts.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Stage 5...{Colors.END}")

    # --- STAGE 5: FILE INTEGRITY ---
    print(f"\n{Colors.RED}[!] STAGE 5: INTEGRITY BREACH (FIM){Colors.END}")
    write_log({
        "is_demo": True,
        "timestamp": get_ts(), "host": HOST, "module": "file_integrity",
        "status": "MODIFIED", "severity": "CRITICAL", "message": "Unauthorized modification in /etc/shadow"
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Finally, the attacker tries to escalate privileges by modifying system files.'")
    print(" - 'The Host Integrity module immediately switches the global state to COMPROMISED.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Cleanup & Recovery...{Colors.END}")

    # --- STAGE 6: CLEANUP ---
    print(f"\n{Colors.GREEN}[*] STAGE 6: RECOVERY{Colors.END}")
    clear_logs()
    time.sleep(0.5)
    
    ts = get_ts()
    write_log({"is_demo": True, "timestamp": ts, "host": HOST, "module": "system_health", "status": "OK", "severity": "INFO", "load": 0.05, "memory": 8, "disk": 2, "message": "Baseline restored"})
    write_log({"is_demo": True, "timestamp": ts, "host": HOST, "module": "file_integrity", "status": "SECURE", "severity": "INFO", "message": "Integrity verified"})
    write_log({"is_demo": True, "timestamp": ts, "host": HOST, "module": "user_activity", "severity": "INFO", "failed_attempts": 0, "message": "Auth logs rotated"})
    
    write_log({"command": "stop_demo"}) # Le backend se remet à écouter le vrai système !
    
    print(f"\n{Colors.YELLOW}>>> ACTION: Final Refresh (F5) NOW to restore the Dashboard baseline.{Colors.END}")
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'The automated incident response has mitigated the threat and sanitized the system.'")
    print(" - 'Sentinel HIDS is back to its secure baseline state. Thank you.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to exit.{Colors.END}")

if __name__ == "__main__":
    try:
        run_demo()
    except KeyboardInterrupt:
        write_log({"command": "stop_demo"})
