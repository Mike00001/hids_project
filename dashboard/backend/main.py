import asyncio
import json
from pathlib import Path
from collections import deque
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse  # Crucial pour envoyer le HTML

app = FastAPI(title="HIDS - Cyber Sentinel API")

# 1. Configuration CORS
# Permet à ton navigateur de communiquer avec l'API même en venant d'une IP différente
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 2. Chemins des fichiers
# BASE_DIR pointera vers le dossier 'dashboard/'
BASE_DIR = Path(__file__).parent.parent
LOG_FILE = BASE_DIR / "test_logs" / "hids_system.log"

# --- ROUTE RACINE : SERVIR LE DASHBOARD ---
@app.get("/")
async def get_dashboard():
    """
    Cette route s'active quand tu tapes l'IP:8000 dans ton navigateur.
    Elle renvoie le fichier index.html situé dans le dossier frontend.
    """
    frontend_path = BASE_DIR / "frontend" / "index.html"
    
    # Petite vérification de sécurité pour le debug
    if not frontend_path.exists():
        return {"error": f"Fichier index.html introuvable dans {frontend_path}"}
        
    return FileResponse(frontend_path)

# --- WEBSOCKET : FLUX D'ALERTES ---
@app.websocket("/ws/alerts")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    
    # S'assurer que le dossier des logs existe
    LOG_FILE.parent.mkdir(parents=True, exist_ok=True)
    if not LOG_FILE.exists():
        LOG_FILE.touch()

    try:
        with open(LOG_FILE, "r") as f:
            # Étape A : Envoyer l'historique (50 dernières lignes)
            history = deque(f, maxlen=50)
            for line in history:
                if line.strip():
                    try:
                        await websocket.send_json(json.loads(line.strip()))
                    except json.JSONDecodeError:
                        pass
            
            # Étape B : Streamer les nouvelles lignes en temps réel (Tail -f)
            f.seek(0, 2)  # Se placer à la fin du fichier
            while True:
                line = f.readline() 
                if not line:
                    await asyncio.sleep(1) # Pause pour ne pas saturer le CPU
                    continue
                try:
                    await websocket.send_json(json.loads(line.strip()))
                except json.JSONDecodeError:
                    pass
                    
    except WebSocketDisconnect:
        print("Client déconnecté du WebSocket")
    except Exception as e:
        print(f"Erreur WebSocket : {e}")
