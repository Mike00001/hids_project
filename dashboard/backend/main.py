import asyncio
import json
from pathlib import Path
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
import os

app = FastAPI(title="Sentinel HIDS - Management API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

BASE_DIR = Path(__file__).parent.parent
LOG_FILE = BASE_DIR / "test_logs" / "hids_system.log"

@app.get("/")
async def get_dashboard():
    return FileResponse(BASE_DIR / "frontend" / "index.html")

@app.websocket("/ws/alerts")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    if not LOG_FILE.exists():
        LOG_FILE.parent.mkdir(parents=True, exist_ok=True)
        LOG_FILE.touch()

    # --- VARIABLE D'ÉTAT DU MODE DÉMO ---
    demo_mode = False 

    # --- CHARGEMENT DE L'HISTORIQUE AU DÉMARRAGE ---
    try:
        with open(LOG_FILE, "r") as f:
            lines = f.readlines()
            for line in lines[-100:]: 
                if line.strip():
                    await websocket.send_json(json.loads(line.strip()))
    except:
        pass

    try:
        while True:
            with open(LOG_FILE, "r") as f:
                f.seek(0, os.SEEK_END)
                last_size = os.path.getsize(LOG_FILE)
                
                while True:
                    current_size = os.path.getsize(LOG_FILE)
                    
                    # SI LE FICHIER A ÉTÉ VIDÉ (TRUNCATE)
                    if current_size < last_size:
                        demo_mode = False 
                        break 

                    line = f.readline()
                    if not line:
                        await asyncio.sleep(0.2)
                        last_size = current_size
                        continue
                    
                    if line.strip():
                        try:
                            payload = json.loads(line.strip())
                            
                            # INTERCEPTION DES COMMANDES DE DÉMO
                            if payload.get("command") == "start_demo":
                                demo_mode = True
                                continue
                            elif payload.get("command") == "stop_demo":
                                demo_mode = False
                                continue
                                
                            # LE FILTRE MAGIQUE
                            if demo_mode and not payload.get("is_demo"):
                                continue

                            await websocket.send_json(payload)
                        except:
                            pass
                    last_size = current_size
    except WebSocketDisconnect:
        pass
    except Exception as e:
        print(f"WS Error: {e}")
