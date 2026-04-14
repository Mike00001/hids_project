# HIDS Project: Host-based Intrusion Detection System

## Project Overview

This project aims to develop a custom **Host-based Intrusion Detection System (HIDS)** designed to monitor and secure a Linux-based server. The system focuses on real-time monitoring of user activity, file integrity, and system logs to detect potential security breaches or unauthorized changes.

## 👥 The Team

- **Admin/Lead:** Axel
- **Security Researcher & Developer:** Vaishnu
- **Security Researcher & Developer:** Mike

## 🏗️ Architecture & Infrastructure

- **Target Machine:** Trigkey G4 (Ubuntu Server)
- **Network:** Secured via **Tailscale** Private Mesh VPN.
- **Development Directory:** `/opt/hids-project`

## 🛠️ Planned Modules

1. **User Activity Monitor:** Tracking logins, `sudo` usage, and command history.
2. **File Integrity Monitor (FIM):** Detecting unauthorized modifications to sensitive system files (e.g., `/etc/passwd`, `/etc/shadow`).
3. **Network Monitoring:** Analyzing active connections and open ports.
4. **Log Analysis:** Parsing system logs for brute-force patterns or suspicious errors.

## 🚀 Development Workflow

To maintain a clean and stable environment, we follow a strict **"GitHub First"** workflow:

1. **Local Coding:** Develop scripts on your local machine using your preferred IDE (VS Code, etc.).
2. **Version Control:** Push all changes to this GitHub repository.
3. **Deployment:** Log in to the server via SSH and pull the latest changes:
4. **Testing:** Execute and test the modules directly on the server.

*Note: Avoid using `nano` or `vim` for primary coding on the server. Use them only for quick debugging.*

## ⚖️ Server Rules & Ethics

To ensure system stability and environmental responsibility:

- **Eco-Reflex:** The server is active during standard hours (08:30 - 17:00). If you are the last one working, verify activity with `who` and shut down the machine using `sudo shutdown now`.
- **Communication:** Send a message to the group if you need the server active outside of standard hours.
- **Security:** Never share your SSH credentials. Always use `sudo` for administrative tasks to ensure actions are logged under your specific username.

## ⚙️ Requirements

- **Language:** Python / Bash
- **Dependencies:** (To be updated as the project progresses)
- **Access:** Requires an authorized Tailscale account.

*This project is for educational purposes as part of our cybersecurity laboratory.*
