#!/usr/bin/env python3
import json
import os
import subprocess
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

# --- LA SOLUTION MAGIQUE : GELER AU LIEU DE TUER ---
def freeze_real_scripts():
    print(f"{Colors.YELLOW}[*] Freezing real-time monitoring...{Colors.END}")
    # Envoie le signal de PAUSE (SIGSTOP) aux scripts. Ils dorment en mémoire sans casser le clavier.
    subprocess.run(["sudo", "pkill", "-STOP", "-f", "main_json.sh"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    subprocess.run(["sudo", "pkill", "-STOP", "-f", "_json.sh"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def unfreeze_real_scripts():
    print(f"{Colors.GREEN}[*] Unfreezing real-time monitoring...{Colors.END}")
    # Envoie le signal de REPRISE (SIGCONT). Ils reprennent là où ils s'étaient arrêtés.
    subprocess.run(["sudo", "pkill", "-CONT", "-f", "main_json.sh"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    subprocess.run(["sudo", "pkill", "-CONT", "-f", "_json.sh"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def run_demo():
    os.system('clear')
    print(f"{Colors.BLUE}====================================================={Colors.END}")
    print(f"{Colors.BLUE}   SENTINEL HIDS - FULL 5-MODULE DEMO SEQUENCE       {Colors.END}")
    print(f"{Colors.BLUE}====================================================={Colors.END}")

    # --- STAGE 0: INITIALIZATION ---
    print(f"\n{Colors.GREEN}[*] STAGE 0: INITIALIZATION{Colors.END}")
    freeze_real_scripts() # On gèle les scripts ici !
    clear_logs()
    write_log({"command": "clear"})
    print(f"{Colors.YELLOW}>>> ACTION: Refresh your browser (F5) NOW to start clean.{Colors.END}")
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Welcome to the Sentinel HIDS demonstration.'")
    print(" - 'Our dashboard is clean, and all security modules are in a VERIFIED state.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to start Module 1...{Colors.END}")

    # --- STAGE 1: SYSTEM HEALTH (KPI 1) ---
    print(f"\n{Colors.RED}[!] STAGE 1: DOS ATTACK (System Health){Colors.END}")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "system_health",
        "status": "CRITICAL", "severity": "CRITICAL", "load": 14.85, "memory": 92, "disk": 95,
        "message": "Critical CPU Load: Denial of Service attack suspected"
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'First, we simulate a DoS attack. Notice the System Load KPI jumping to 14.85.'")
    print(" - 'The real-time telemetry chart instantly reflects this resource exhaustion.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Module 2...{Colors.END}")

    # --- STAGE 2: PROCESS AUDIT (Table) ---
    print(f"\n{Colors.RED}[!] STAGE 2: MALWARE DETECTION (Process Audit){Colors.END}")
    fake_procs = [
        {"pid": "666", "user": "root", "cpu": 99.9, "cmd": "/tmp/.hidden/miner_pro"},
        {"pid": "1201", "user": "m", "cpu": 0.5, "cmd": "uvicorn"}
    ]
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "process_audit",
        "severity": "CRITICAL", "message": "High-risk anomaly: Unsigned binary in /tmp",
        "top_processes": fake_procs
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Now, look at the Process Inspection Table. A malicious cryptominer has been detected.'")
    print(" - 'It is flagged as an ANOMALY because it is running as root with 99% CPU usage.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Module 3...{Colors.END}")

    # --- STAGE 3: NETWORK AUDIT (KPI 3) ---
    print(f"\n{Colors.RED}[!] STAGE 3: COVERT CHANNEL (Network Audit){Colors.END}")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "network_audit",
        "severity": "CRITICAL", "message": "Unauthorized listener on port 6666",
        "open_ports": 32
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'The attacker opens a back-door on port 6666.'")
    print(" - 'The Network Exposure widget updates to 32 ports, identifying a surface breach.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Module 4...{Colors.END}")

    # --- STAGE 4: USER ACTIVITY (KPI 2) ---
    print(f"\n{Colors.RED}[!] STAGE 4: BRUTE FORCE (User Activity){Colors.END}")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "user_activity",
        "severity": "WARNING", "message": "Massive failed login attempts on SSH",
        "failed_attempts": 25
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'We are now seeing a brute-force attack on the SSH service.'")
    print(" - 'The Failed Auth KPI turns red as it records 25 failed attempts from a single IP.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Module 5...{Colors.END}")

    # --- STAGE 5: FILE INTEGRITY (KPI 4) ---
    print(f"\n{Colors.RED}[!] STAGE 5: INTEGRITY BREACH (FIM){Colors.END}")
    os.system("sudo touch /etc/hacker_config.bak")
    write_log({
        "timestamp": get_ts(), "host": HOST, "module": "file_integrity",
        "status": "MODIFIED", "severity": "CRITICAL", "message": "Unauthorized modification in /etc/"
    })
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Finally, the attacker tries to modify system files in the /etc directory.'")
    print(" - 'The Host Integrity (FIM) module immediately switches the global state to COMPROMISED.'")
    input(f"\n{Colors.BOLD}Press [ENTER] for Cleanup & Final Recovery...{Colors.END}")

    # --- STAGE 6: CLEANUP ---
    print(f"\n{Colors.GREEN}[*] STAGE 6: RECOVERY{Colors.END}")
    os.system("sudo rm -f /etc/hacker_config.bak")
    clear_logs()
    
    ts = get_ts()
    write_log({"timestamp": ts, "host": HOST, "module": "system_health", "status": "OK", "severity": "INFO", "load": 0.05, "memory": 8, "disk": 2, "message": "Baseline restored"})
    write_log({"timestamp": ts, "host": HOST, "module": "file_integrity", "status": "SECURE", "severity": "INFO", "message": "Integrity verified"})
    write_log({"timestamp": ts, "host": HOST, "module": "user_activity", "severity": "INFO", "failed_attempts": 0, "message": "Auth logs rotated"})
    
    unfreeze_real_scripts() # On dégèle les scripts ici !
    
    print(f"\n{Colors.YELLOW}>>> ACTION: Final Refresh (F5) NOW to restore the Dashboard baseline.{Colors.END}")
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'The threat has been mitigated. We have sanitized the environment and restored the baseline.'")
    print(" - 'Sentinel HIDS is back to its secure state. Thank you for your attention.'")
    input(f"\n{Colors.BOLD}Press [ENTER] to exit.{Colors.END}")

if __name__ == "__main__":
    try:
        run_demo()
    except KeyboardInterrupt:
        unfreeze_real_scripts()
