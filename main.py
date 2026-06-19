import os
import json
from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel
from dotenv import load_dotenv

# --- RETAINED MODULES (Do not remove these imports) ---
from modules.config import Config
from modules.ai_brain import execute_god_brain
from modules.app_factory import build_flutter_app
from modules.media_studio import generate_media
from modules.document_forge import create_document
from modules.social_vault import manage_social_task
from modules.security_core import run_security_protocol
from modules.system_memory import manage_memory
from modules.identity_core import identity
from modules.self_evolution import health_check

load_dotenv()
app = FastAPI(title="Jarvis God-Mode: The Ultimate OS")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

APK_DIR = Config.APK_DIR
if not os.path.exists(APK_DIR):
    os.makedirs(APK_DIR, exist_ok=True)
app.mount("/builds", StaticFiles(directory=APK_DIR), name="builds")

# --- GIRGIT MODE (New Feature) ---
UI_CONFIGS = {
    "AI_CHAT": {"bg": "holographic", "features": ["chat", "mic"]},
    "EXCEL": {"bg": "matrix", "features": ["grid", "formulas", "save"]},
    "MEDIA": {"bg": "neon", "features": ["eraser", "crop", "filters"]},
    "CRICKET": {"bg": "stadium", "features": ["live_score", "analysis"]}
}

def check_permission(role: str, action: str) -> bool:
    if role == "owner": return True
    try:
        if os.path.exists("data/permissions.json"):
            with open("data/permissions.json", "r") as f:
                perms = json.load(f)
                return action in perms.get(role, [])
    except Exception: pass
    return False

@app.on_event("startup")
async def startup_event():
    health_check()
    owner = identity.get_owner()
    if not owner: print("SYSTEM: [ALERT] No owner bound. Initiate onboarding.")
    else: print(f"SYSTEM: [VERIFIED] Welcome back, {owner['name']}.")

@app.get("/")
async def root_health_check():
    return {"status": "online", "system": "Jarvis God-Mode Backend is Active"}

@app.get("/download-apk/{filename}")
async def download_apk(filename: str):
    file_path = f"{APK_DIR}/{filename}"
    if os.path.exists(file_path):
        return FileResponse(file_path, media_type='application/vnd.android.package-archive', filename=filename)
    raise HTTPException(status_code=404, detail="APK file not ready yet.")

# --- GIRGIT MODE ROUTE ---
@app.get("/get-mode/{mode}")
async def get_mode(mode: str):
    return UI_CONFIGS.get(mode, UI_CONFIGS["AI_CHAT"])

# --- THE ULTIMATE ROUTER (ALL OLD FEATURES RETAINED) ---
class Command(BaseModel):
    action: str
    role: str
    details: dict

@app.post("/ultimate-jarvis")
async def ultimate_jarvis(cmd: Command):
    if not check_permission(cmd.role, cmd.action):
        raise HTTPException(status_code=403, detail="ACCESS DENIED: Role unauthorized.")

    api_keys = {"Groq": Config.get_key("Groq"), "HuggingFace_Uncensored": Config.get_key("HF")}

    if cmd.action == "backend_scan": return health_check()
    
    elif cmd.action == "install_api_key":
        prov = cmd.details.get("provider")
        key = cmd.details.get("api_key")
        if prov and key:
            Config.save_key(prov, key)
            return {"status": "success", "message": "API Key installed."}
        return {"status": "error", "message": "Invalid credentials."}

    elif cmd.action in ["login", "system_scan"]:
        return await run_security_protocol(cmd.action, cmd.role, cmd.details)

    elif cmd.action in ["save", "retrieve_memory"]:
        return await manage_memory(cmd.action, cmd.role, cmd.details.get("data"))

    elif cmd.action == "god_prompt":
        return await execute_god_brain(cmd.details.get("task"), api_keys)

    elif cmd.action == "build_apk":
        return await build_flutter_app(cmd.details.get("app_idea"), api_keys, cmd.details.get("platform", "android"))

    elif cmd.action in ["create_image", "create_reel"]:
        return await generate_media(cmd.action, cmd.details, api_keys)

    elif cmd.action == "generate_doc":
        return await create_document(cmd.details.get("type"), cmd.details)

    elif cmd.action in ["auto_post", "recover_password"]:
        return await manage_social_task(cmd.action, cmd.details.get("platform"), cmd.details, api_keys)
    
    elif cmd.action == "evolve":
        # Dynamic Self-Evolution
        feature = cmd.details
        UI_CONFIGS[feature["name"]] = feature["config"]
        return {"status": "success", "message": f"{feature['name']} evolved."}

    return {"status": "error", "message": "Command not recognized by Jarvis OS."}
    
