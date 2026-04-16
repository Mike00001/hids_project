#!/bin/bash
# =========================================================
# HIDS - Live Demo Attack Simulator (Cinematic Mode)
# =========================================================

LOG_FILE="/opt/hids-project/hids_project/dashboard/test_logs/hids_system.log"

echo "================================================="
echo "💀 HIDS Live Demo Simulator - CINEMATIC MODE 💀"
echo "================================================="
echo "Nettoyage du Dashboard en cours..."
> "$LOG_FILE"
echo '{"command":"clear"}' >> "$LOG_FILE"
echo "-> Magie ! Le Dashboard s'est vidé tout seul en direct."
echo "La présentation commence dans 5 secondes..."
sleep 5
echo ""

# === 1. SYSTEM HEALTH & DISK (Fake Payload Injection) ===
echo "🔥 [1/5] SIMULATION : Fuite de mémoire et saturation Disque (Logic Bomb)..."
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
host=$(hostname)
echo "{\"timestamp\":\"$timestamp\",\"host\":\"$host\",\"module\":\"system_health\",\"status\":\"CRITICAL\",\"severity\":\"CRITICAL\",\"load\":\"94\",\"memory\":\"99\",\"disk\":\"98\",\"message\":\"Critical resource exhaustion detected!\"}" >> "$LOG_FILE"
sleep 8
echo "   -> Regardez le graphique et l'allocation disque à 98% !"
echo ""

# === 2. NETWORK AUDIT (Port 6666) ===
echo "🔥 [2/5] SIMULATION : Ouverture d'un port caché (Reverse Shell)..."
timeout 10 nc -l -p 6666 &
sleep 8
echo "   -> Regardez le widget 'Open Ports' et le flux d'incidents !"
echo ""

# === 3. PROCESS AUDIT (High CPU) ===
echo "🔥 [3/5] SIMULATION : Lancement d'un Malware cryptomineur..."
timeout 10 bash -c 'while true; do :; done' &
sleep 8
echo "   -> Regardez le tableau 'Active Process' (la ligne rouge SUSPICIOUS) !"
echo ""

# === 4. USER ACTIVITY (Brute Force + Sudo) ===
echo "🔥 [4/5] SIMULATION : Attaque Brute-Force & Usurpation..."
for i in {1..6}; do
    sudo bash -c 'echo "$(date +"%b %_d %H:%M:%S") $(hostname) sshd[9999]: Failed password for invalid user pirate from 1.2.3.4 port 33" >> /var/log/auth.log'
done
sudo bash -c 'echo "$(date +"%b %_d %H:%M:%S") $(hostname) sudo: pirate : TTY=pts/0 ; PWD=/home ; USER=root ; COMMAND=/bin/bash" >> /var/log/auth.log'
sleep 8
echo "   -> Le Widget 'Failed Logins' grimpe en rouge !"
echo ""

# === 5. FILE INTEGRITY (Droits sur Shadow) ===
echo "🔥 [5/5] SIMULATION : Corruption de l'intégrité (FIM)..."
sudo chmod 640 /etc/shadow
sudo touch /etc/hacker.conf
sudo chmod 777 /etc/hacker.conf
sleep 8
sudo chmod 600 /etc/shadow
sudo rm /etc/hacker.conf
echo "   -> Le Widget FIM est passé en ROUGE (CHANGED) !"
echo ""
echo "================================================="
echo "✅ DÉMO TERMINÉE ET RÉUSSIE !"
echo "================================================="
echo "Appuyez sur ENTRÉE pour nettoyer le dashboard et clore la présentation..."
read
> "$LOG_FILE"
echo '{"command":"clear"}' >> "$LOG_FILE"
echo "Nettoyage terminé ! À bientôt."
