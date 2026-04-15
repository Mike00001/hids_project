
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
        echo "lastb not available, falling back to /var/log/auth.log"
        sudo grep -Ei "failed password|authentication failure|invalid user" /var/log/auth.log | tail -n 10
    else
        echo "No failed-login source found."
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
awk -F: '$3 == 0 {print $1, $3, $7}' /etc/passwd
echo ""




