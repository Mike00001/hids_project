import asyncio
import json
from pathlib import Path
from collections import deque
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware

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
            # Envoi historique
            history = deque(f, maxlen=50)
            for line in history:
                if line.strip():
                    try:
                        await websocket.send_json(json.loads(line.strip()))
                    except json.JSONDecodeError:
                        pass
            
            # Temps réel
            f.seek(0, 2) 
            while True:
                line = f.readline() 
                if not line:
                    await asyncio.sleep(1)
                    continue
                try:
                    await websocket.send_json(json.loads(line.strip()))
                except json.JSONDecodeError:
                    pass
    except WebSocketDisconnect:
        print("Client disconnected")
    except Exception as e:
        print(f"Error: {e}")
