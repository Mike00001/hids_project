#!/bin/bash

# =========================================
# HIDS - Module 3 (Process & Network Audit)
# =========================================

# ---- COLORS ----
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

LOG_FILE="$HOME/hids_process.log"
touch "$LOG_FILE"

# ---- CONFIG ----
SUSPICIOUS_PATHS="/tmp|/dev/shm|/var/tmp|/home"
ALLOWED_PORTS="22|80|443"

CPU_LIMIT=50
MEM_LIMIT=50

# ---- LOG FUNCTION ----
write_log() {
    echo "$1" >> "$LOG_FILE"
}

# ---- ALERT ----
print_alert() {
    severity="$1"
    message="$2"

    case "$severity" in
        CRITICAL) color=$RED; emoji="🚨";;
        WARNING) color=$YELLOW; emoji="⚠️";;
        *) color=$GREEN; emoji="✅";;
    esac

    echo -e "${color}${emoji} [$severity] $message${NC}"
}

# ---- CHECK PROCESSES ----
check_processes() {

    ps -eo pid,user,comm,%cpu,%mem --no-headers | while read pid user comm cpu mem; do

        exe=$(readlink -f /proc/$pid/exe 2>/dev/null)
        [ -z "$exe" ] && continue

        # 🚨 Suspicious path
        if echo "$exe" | grep -qE "$SUSPICIOUS_PATHS"; then
            msg="Process $comm (PID $pid) running from unusual path: $exe"
            print_alert "CRITICAL" "$msg"
            write_log "{\"type\":\"process\",\"severity\":\"CRITICAL\",\"msg\":\"$msg\"}"
        fi

        # 🚨 Hidden file execution
        if echo "$exe" | grep -qE "/\."; then
            msg="Hidden executable detected: $exe (PID $pid)"
            print_alert "WARNING" "$msg"
            write_log "{\"type\":\"process\",\"severity\":\"WARNING\",\"msg\":\"$msg\"}"
        fi

        # 🚨 Suspicious process name
        if [[ ${#comm} -le 2 ]]; then
            msg="Suspicious short process name: $comm (PID $pid)"
            print_alert "WARNING" "$msg"
            write_log "{\"type\":\"process\",\"severity\":\"WARNING\",\"msg\":\"$msg\"}"
        fi

        # 🚨 High resource usage (lower threshold)
        cpu_int=${cpu%.*}
        if [ "$cpu_int" -gt "$CPU_LIMIT" ]; then
            msg="High CPU process: $comm using ${cpu}%"
            print_alert "WARNING" "$msg"
            write_log "{\"type\":\"process\",\"severity\":\"WARNING\",\"msg\":\"$msg\"}"
        fi

    done
}

# ---- CHECK PORTS ----
check_ports() {

    ss -tulpn 2>/dev/null | grep LISTEN | while read line; do

        port=$(echo "$line" | awk '{print $5}' | awk -F: '{print $NF}')
        proc=$(echo "$line" | grep -oP 'users:\(\("\K[^"]+')

        # 🚨 Unknown port
        if ! echo "$port" | grep -qE "$ALLOWED_PORTS"; then
            msg="Unknown listening port: $port (process: $proc)"
            print_alert "WARNING" "$msg"
            write_log "{\"type\":\"network\",\"severity\":\"WARNING\",\"msg\":\"$msg\"}"
        fi

    done
}

# ---- CHECK CONNECTIONS ----
check_connections() {

    ss -tpn 2>/dev/null | grep ESTAB | while read line; do

        proc=$(echo "$line" | grep -oP 'users:\(\("\K[^"]+')
        remote=$(echo "$line" | awk '{print $6}')

        # 🚨 External connection detection
        if echo "$remote" | grep -vqE "127.0.0.1|192.168|10\."; then
            msg="External connection: $proc → $remote"
            print_alert "WARNING" "$msg"
            write_log "{\"type\":\"network\",\"severity\":\"WARNING\",\"msg\":\"$msg\"}"
        fi

    done
}

# ---- MAIN ----
echo -e "${GREEN}🔍 Running Process & Network Audit...${NC}"

check_processes
check_ports
check_connections