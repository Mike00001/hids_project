#!/bin/bash
# =========================================================
# HIDS - Live Demo Attack Simulator
# Usage: ./demo_attack.sh (will prompt for sudo sometimes)
# =========================================================

echo "================================================="
echo "💀 HIDS Live Demo Simulator - LET'S ROCK 💀"
echo "================================================="
echo "Mettez le Dashboard en plein écran, la démo commence !"
echo "Le timer d'automatisation tourne toutes les 5s."
echo ""
sleep 3

# === 1. NETWORK AUDIT (Port 6666) ===
echo "🔥 [1/4] SIMULATION : Ouverture d'un port caché (Reverse Shell)..."
# nc va écouter pendant 10 secondes et s'éteindre tout seul
timeout 10 nc -l -p 6666 &
# On attend 6 secondes pour s'assurer que le HIDS Agent (5s) l'attrape au vol
sleep 6 
echo "   -> Regardez le widget 'Open Ports' et le flux d'incidents !"
echo ""

# === 2. PROCESS AUDIT (High CPU) ===
echo "🔥 [2/4] SIMULATION : Lancement d'un Malware cryptomineur..."
# Une boucle infinie qui va saturer un coeur CPU pendant 10 secondes
timeout 10 bash -c 'while true; do :; done' &
sleep 6
echo "   -> Regardez le tableau 'Active Process' (une ligne rouge SUSPICIOUS devrait popper) !"
echo ""

# === 3. USER ACTIVITY (Brute Force + Sudo) ===
echo "🔥 [3/4] SIMULATION : Attaque Brute-Force & Usurpation..."
# On injecte manuellement 6 fausses erreurs de mot de passe dans les vrais logs Linux
for i in {1..6}; do
    sudo bash -c 'echo "$(date +"%b %_d %H:%M:%S") $(hostname) sshd[9999]: Failed password for invalid user pirate from 1.2.3.4 port 33" >> /var/log/auth.log'
done
# On injecte aussi une utilisation frelatée de Sudo
sudo bash -c 'echo "$(date +"%b %_d %H:%M:%S") $(hostname) sudo: pirate : TTY=pts/0 ; PWD=/home ; USER=root ; COMMAND=/bin/bash" >> /var/log/auth.log'
sleep 6
echo "   -> Le Widget 'Failed Logins' grimpe, et ça devrait sonner (CRITICAL) !"
echo ""

# === 4. FILE INTEGRITY (Droits sur Shadow) ===
echo "🔥 [4/4] SIMULATION : Corruption des droits du fichier /etc/shadow..."
# Le HIDS exige que le shadow soit en 600. On le passe en 640 (lisible par le groupe), ce qui est très dangereux.
sudo chmod 640 /etc/shadow
# On crée également un faux fichier de config public (world-writable) dans /etc/
sudo touch /etc/hacker.conf
sudo chmod 777 /etc/hacker.conf
sleep 6
# On nettoie derrière nous pour ne pas laisser de failles sur la machine !
sudo chmod 600 /etc/shadow
sudo rm /etc/hacker.conf
echo "   -> Alerte rouge sur l'intégrité !"
echo ""

echo "================================================="
echo "✅ DÉMO TERMINÉE ! C'est dans la boîte !"
echo "================================================="
