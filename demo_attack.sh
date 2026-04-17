#!/usr/bin/env python3
import json
import os
import time
from datetime import datetime

LOG_PATH = "/opt/hids-project/hids_project/dashboard/test_logs/hids_system.log"
HOST = "hids-server-01"

class Colors:
    BLUE = '\033[94m'; GREEN = '\033[92m'; YELLOW = '\033[93m'; RED = '\033[91m'; BOLD = '\033[1m'; END = '\033[0m'

def get_ts(): return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def write_log(data):
    with open(LOG_PATH, "a") as f:
        f.write(json.dumps(data) + "\n")

def run_demo():
    os.system('clear')
    print(f"{Colors.BLUE}====================================================={Colors.END}")
    print(f"{Colors.BLUE}   SENTINEL HIDS - EXECUTIVE DEMO SEQUENCE           {Colors.END}")
    print(f"{Colors.BLUE}====================================================={Colors.END}")

    # --- STAGE 0: INITIALIZATION ---
    # On vide le fichier pour forcer le backend à reset le mode démo
    open(LOG_PATH, 'w').close() 
    time.sleep(0.5)
    write_log({"command": "start_demo"}) 
    
    print(f"\n{Colors.GREEN}[*] STAGE 0: INITIALIZATION{Colors.END}")
    print(f"{Colors.YELLOW}>>> ACTION: Refresh your browser (F5) NOW.{Colors.END}")
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Welcome to the Sentinel HIDS demonstration.'")
    print(" - 'As you can see, the dashboard is now clean and ready for inspection.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to start Stage 1 (DoS Attack)...{Colors.END}")

    # --- STAGE 1: SYSTEM HEALTH ---
    print(f"\n{Colors.RED}[!] STAGE 1: DOS ATTACK{Colors.END}")
    
    # ON ENVOIE PLUSIEURS POINTS POUR LE GRAPHIQUE
    for l_val in [0.05, 0.12, 14.85]:
        write_log({
            "is_demo": True, "timestamp": get_ts(), "host": HOST, "module": "system_health",
            "status": "CRITICAL" if l_val > 10 else "OK", "severity": "CRITICAL" if l_val > 10 else "INFO",
            "load": l_val, "memory": 92, "disk": 95,
            "message": "Critical CPU Load: Potential DoS detected" if l_val > 10 else "System stable"
        })
        time.sleep(0.2)
    
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Notice the System Load KPI instantly jumping to 14.85.'")
    print(" - 'The telemetry chart now clearly shows the attack spike.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Stage 2 (Malware Detection)...{Colors.END}")

    # --- STAGE 2: PROCESS AUDIT ---
    print(f"\n{Colors.RED}[!] STAGE 2: MALICIOUS PROCESS{Colors.END}")
    write_log({
        "is_demo": True, "timestamp": get_ts(), "host": HOST, "module": "process_audit",
        "severity": "CRITICAL", "message": "High-risk anomaly: Cryptominer identified",
        "top_processes": [{"pid": "666", "user": "root", "cpu": 99.9, "cmd": "/tmp/.hidden/miner_pro"}]
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'In the Process Table, we detect a hidden miner running with root privileges.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Stage 3 (Network Breach)...{Colors.END}")

    # --- STAGE 3: NETWORK AUDIT ---
    print(f"\n{Colors.RED}[!] STAGE 3: COVERT CHANNEL{Colors.END}")
    write_log({
        "is_demo": True, "timestamp": get_ts(), "host": HOST, "module": "network_audit",
        "severity": "CRITICAL", "message": "Unauthorized port listener: 6666", "open_ports": 32
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Our network audit reveals an unauthorized backdoor on port 6666.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Stage 4 (Brute-Force SSH)...{Colors.END}")

    # --- STAGE 5: FILE INTEGRITY ---
    print(f"\n{Colors.RED}[!] STAGE 4: INTEGRITY BREACH{Colors.END}")
    write_log({
        "is_demo": True, "timestamp": get_ts(), "host": HOST, "module": "file_integrity",
        "status": "MODIFIED", "severity": "CRITICAL", "message": "FIM Violation: Unauthorized change in /etc/shadow"
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Finally, a core system file is modified. The FIM status turns COMPROMISED.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to RECOVER the system...{Colors.END}")

    # --- STAGE 6: RECOVERY ---
    print(f"\n{Colors.GREEN}[*] STAGE 6: RECOVERY{Colors.END}")
    open(LOG_PATH, 'w').close()
    time.sleep(0.5)
    
    ts = get_ts()
    # On envoie des logs "Green" marqués démo pour que le dernier écran soit propre
    write_log({"is_demo": True, "timestamp": ts, "host": HOST, "module": "system_health", "status": "OK", "severity": "INFO", "load": 0.05, "memory": 8, "disk": 2, "message": "Baseline restored"})
    write_log({"is_demo": True, "timestamp": ts, "host": HOST, "module": "file_integrity", "status": "SECURE", "severity": "INFO", "message": "Integrity verified"})
    
    write_log({"command": "stop_demo"}) 
    
    print(f"\n{Colors.YELLOW}>>> ACTION: Final Refresh (F5) NOW.{Colors.END}")
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'The incident is resolved. The system is secure again. Thank you.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to exit.{Colors.END}")

if __name__ == "__main__":
    run_demo()
