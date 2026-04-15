#!/bin/bash
# Aller dans le dossier du projet
cd /opt/hids-project/hids_project/

# Activer le venv
source venv/bin/activate

# Lancer le serveur sur toutes les interfaces (0.0.0.0)
exec ./venv/bin/uvicorn dashboard.backend.main:app --host 0.0.0.0 --port 8000
