import asyncio
import json
from pathlib import Path
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware

# Initialisation de l'API (C'est cette ligne qu'Uvicorn cherche !)
app = FastAPI(title="HIDS Dashboard API")

# Autorise le frontend à communiquer avec cette API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Pour tes tests sur PC
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
