#!/bin/bash
# HIDS - Host Intrusion Detection System
# Module 2 : User Activity


#exec > user_activity.log 2>&1

# Define log file and redirect output to it + screen
LOG_FILE="user_activity.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "==============================="
echo " ℹ️  HIDS - User Activity Report"
echo " $(date)"
echo "==============================="
echo ""

# --- Who is currently logged in ---
echo "[*] Currently logged in users:"
who
echo ""

# --- More detailed current activity ---
echo "[*] Detailed current activity:"
w
echo ""

# --- Login history --- read into /var/log/wtmp
echo "[*] Recent login history:"
last -a | head -n 25
echo ""


# --- Failed login attempts ---
# If lastb is missing, authentication logs such as /var/log/auth.log can be searched by pattern
show_failed_logins() {
    echo "[*] Failed login attempts:"

    if command -v lastb >/dev/null 2>&1; then
        sudo lastb | head -n 10
    elif [ -f /var/log/auth.log ]; then
        echo "⚠️ lastb not available, falling back to /var/log/auth.log"
        sudo grep -Ei "failed password|authentication failure|invalid user" /var/log/auth.log | tail -n 10
    else
        echo "🚨 No failed-login source found."
    fi

    echo ""
}

show_failed_logins


# --- Accounts with a real login shell ---
echo "[*] Accounts with a real shell:"
grep -v "nologin\|false" /etc/passwd
echo ""

# --- Check for UID 0 accounts ---
echo "[*] Accounts with Admin privileges:"
awk -F: '$3 == 0 {print "🚨", $1, $3, $7}' /etc/passwd
echo ""
# --- Recent Sudo Actions (Hybrid Analysis) ---
echo "[*] Recent administrative (sudo) actions:"

if [ -f /var/log/auth.log ]; then
    echo "--- ℹ️ Source: /var/log/auth.log ---"
    # On cherche "sudo:" et on affiche les 15 dernières actions
    sudo grep "sudo:" /var/log/auth.log | tail -n 15
    
    # Petit check si le grep est resté muet
    if [ ${PIPESTATUS[1]} -ne 0 ]; then
        echo "✅ No sudo actions found in auth.log."
    fi

elif command -v journalctl >/dev/null 2>&1; then
    echo "--- ℹ️ Source: systemd-journalctl ---"
    # On interroge le journal binaire pour les actions sudo
    sudo journalctl _COMM=sudo -n 15 --no-pager
    
else
    echo "🚨 [!] No login logs found (neither auth.log nor journalctl)."
fi
echo ""

