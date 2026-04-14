import asyncio
import json
from pathlib import Path
from collections import deque  # <-- Le nouvel outil magique !
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware

# Initialisation de l'API
app = FastAPI(title="HIDS Dashboard API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

BASE_DIR = Path(__file__).parent.parent
LOG_FILE = BASE_DIR / "test_logs" / "hids_system.log"

@app.websocket("/ws/alerts")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    
    LOG_FILE.parent.mkdir(parents=True, exist_ok=True)
    if not LOG_FILE.exists():
        LOG_FILE.touch()

    try:
        with open(LOG_FILE, "r") as f:
            # --- 1. CHARGEMENT DE L'HISTORIQUE ---
            # On lit tout le fichier mais on ne garde en mémoire que les 50 dernières lignes
            last_lines = deque(f, maxlen=50)
            
            for line in last_lines:
                if line.strip(): # On ignore les lignes vides
                    try:
                        log_data = json.loads(line.strip())
                        # On envoie l'historique au navigateur
                        await websocket.send_json(log_data)
                    except json.JSONDecodeError:
                        pass
            
            # --- 2. ÉCOUTE EN TEMPS RÉEL (LIVE) ---
            # Une fois l'historique lu, on s'assure d'être tout à la fin du fichier
            f.seek(0, 2) 
            
            while True:
                line = f.readline() 
                if not line:
                    await asyncio.sleep(1)
                    continue
                
                try:
                    log_data = json.loads(line.strip())
                    await websocket.send_json(log_data)
                except json.JSONDecodeError:
                    pass

    except WebSocketDisconnect:
        print("Client déconnecté")
