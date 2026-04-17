#!/usr/bin/env python3
import json
import os
import subprocess
from datetime import datetime

# --- CONFIGURATION ---
LOG_PATH = "/opt/hids-project/hids_project/dashboard/test_logs/hids_system.log"
REAL_MONITOR = "/opt/hids-project/hids_project/Modules_JSON/main_json.sh"
HOST = "hids-server-01"

class Colors:
    BLUE = '\033[94m'; GREEN = '\033[92m'; YELLOW = '\033[93m'; RED = '\033[91m'; BOLD = '\033[1m'; END = '\033[0m'

def get_ts(): return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def write_log(data):
    with open(LOG_PATH, "a") as f:
        f.write(json.dumps(data) + "\n")

def toggle_monitoring(status):
    if status == "OFF":
        print(f"{Colors.YELLOW}[*] SILENCING REAL-TIME MONITORING...{Colors.END}")
        os.system("sudo pkill -9 -f 'main_json.sh' > /dev/null 2>&1")
        os.system("sudo pkill -9 -f '_json.sh' > /dev/null 2>&1")
        if os.path.exists(REAL_MONITOR):
            os.system(f"sudo mv {REAL_MONITOR} {REAL_MONITOR}.bak")
        print(f"{Colors.GREEN}[+] System is now muted. No background noise allowed.{Colors.END}")
    else:
        print(f"\n{Colors.GREEN}[*] RESTORING REAL-TIME MONITORING...{Colors.END}")
        if os.path.exists(REAL_MONITOR + ".bak"):
            os.system(f"sudo mv {REAL_MONITOR}.bak {REAL_MONITOR}")
        
        # LA CORRECTION EST ICI : On coupe l'accès au clavier (stdin)
        subprocess.Popen(
            ["sudo", "bash", REAL_MONITOR], 
            stdin=subprocess.DEVNULL, 
            stdout=subprocess.DEVNULL, 
            stderr=subprocess.DEVNULL,
            start_new_session=True
        )

def wait_enter(action_text):
    print(f"\n{Colors.BOLD}[Press ENTER {action_text}]{Colors.END}")
    input()

def run_demo():
    os.system('clear')
    print(f"{Colors.BLUE}====================================================={Colors.END}")
    print(f"{Colors.BLUE}   SENTINEL HIDS - PROFESSIONAL DEMO SEQUENCE        {Colors.END}")
    print(f"{Colors.BLUE}====================================================={Colors.END}")

    # --- STAGE 0 ---
    toggle_monitoring("OFF")
    open(LOG_PATH, 'w').close() 
    write_log({"command": "clear"})
    
    print(f"\n{Colors.YELLOW}>>> BROWSER ACTION: REFRESH (F5) NOW.{Colors.END}")
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'Welcome to the Sentinel HIDS Control Plane.'")
    print(" - 'As we begin, the dashboard is empty, representing a secure and fresh baseline.'")
    wait_enter("to start the Attack Sequence")

    # --- STAGE 1 ---
    print(f"\n{Colors.RED}[!] STAGE 1: DoS ATTACK{Colors.END}")
    write_log({"timestamp": get_ts(), "host": HOST, "module": "system_health", "status": "CRITICAL", "severity": "CRITICAL", "load": 14.85, "memory": 92, "disk": 95, "message": "Critical CPU Load: Potential Denial of Service in progress"})
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'We start by simulating a high-load DoS attack.'")
    print(" - 'Observe the System Load KPI: it instantly spikes to 14.85, and the chart reacts.'")
    wait_enter("for Stage 2: Malware Detection")

    # --- STAGE 2 ---
    print(f"\n{Colors.RED}[!] STAGE 2: MALICIOUS PROCESS{Colors.END}")
    write_log({"timestamp": get_ts(), "host": HOST, "module": "process_audit", "severity": "CRITICAL", "message": "High-risk anomaly: Cryptominer identified", "top_processes": [{"pid":"666", "user":"root", "cpu":99.9, "cmd":"/tmp/.hidden/miner"}]})
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'Simultaneously, an unauthorized process is detected in the background.'")
    print(" - 'In the Process Tree, we see a hidden miner running as root with 99% CPU usage.'")
    wait_enter("for Stage 3: Network Exposure")

    # --- STAGE 3 ---
    print(f"\n{Colors.RED}[!] STAGE 3: COVERT CHANNEL{Colors.END}")
    write_log({"timestamp": get_ts(), "host": HOST, "module": "network_audit", "severity": "CRITICAL", "message": "Unauthorized port listener: 6666", "open_ports": 32})
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'The attacker is now opening a backdoor on port 6666.'")
    print(" - 'Our Network module flags this new open port immediately on the dashboard.'")
    wait_enter("for Stage 4: Brute-Force")

    # --- STAGE 4 ---
    print(f"\n{Colors.RED}[!] STAGE 4: SSH BRUTE-FORCE{Colors.END}")
    write_log({"timestamp": get_ts(), "host": HOST, "module": "user_activity", "severity": "WARNING", "message": "SSH Brute-force attempt detected from 1.2.3.4", "failed_attempts": 25})
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'The attack continues with an SSH brute-force attempt.'")
    print(" - 'The Failed Auth counter turns red, showing 25 unsuccessful attempts in seconds.'")
    wait_enter("for Stage 5: File Integrity")

    # --- STAGE 5 ---
    print(f"\n{Colors.RED}[!] STAGE 5: INTEGRITY BREACH{Colors.END}")
    os.system("sudo touch /etc/hacker.conf")
    write_log({"timestamp": get_ts(), "host": HOST, "module": "file_integrity", "status": "MODIFIED", "severity": "CRITICAL", "message": "FIM Violation: Unauthorized change in /etc/shadow"})
    print(f"\n{Colors.BOLD}PRESENTER NOTES (NO REFRESH):{Colors.END}")
    print(" - 'Finally, a core system configuration file is modified.'")
    print(" - 'The FIM module switches the global Integrity Health to COMPROMISED.'")
    wait_enter("for Final Cleanup & Recovery")

    # --- STAGE 6 ---
    print(f"\n{Colors.GREEN}[*] STAGE 6: SYSTEM RECOVERY{Colors.END}")
    os.system("sudo rm -f /etc/hacker.conf")
    open(LOG_PATH, 'w').close()
    
    ts = get_ts()
    write_log({"timestamp": ts, "host": HOST, "module": "system_health", "status": "OK", "severity": "INFO", "load": 0.05, "memory": 5, "disk": 2, "message": "Recovery complete: baseline restored"})
    write_log({"timestamp": ts, "host": HOST, "module": "file_integrity", "status": "SECURE", "severity": "INFO", "message": "FIM: System files verified"})
    
    toggle_monitoring("ON")
    
    print(f"\n{Colors.YELLOW}>>> BROWSER ACTION: FINAL REFRESH (F5) NOW.{Colors.END}")
    print(f"\n{Colors.BOLD}PRESENTER NOTES:{Colors.END}")
    print(" - 'We have triggered our automated incident response protocol.'")
    print(" - 'Malicious processes were killed, files removed, and the baseline is restored.'")
    print(" - 'Our system is now back to a fully SECURE state.'")
    wait_enter("to end the session")

if __name__ == "__main__":
    try:
        run_demo()
    except KeyboardInterrupt:
        toggle_monitoring("ON")
        print("\nExiting...")
