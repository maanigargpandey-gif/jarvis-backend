import os
import json
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel
from dotenv import load_dotenv

# Modules Configuration
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
    if not owner:
        print("SYSTEM: [ALERT] No owner bound. Initiate onboarding.")
    else:
        print(f"SYSTEM: [VERIFIED] Welcome back, {owner['name']}.")

class Command(BaseModel):
    action: str
    role: str
    details: dict

@app.get("/download-apk/{filename}")
async def download_apk(filename: str):
    file_path = f"{APK_DIR}{filename}"
    if os.path.exists(file_path): 
        return FileResponse(file_path, media_type='application/vnd.android.package-archive', filename=filename)
    raise HTTPException(status_code=404, detail="APK file not ready yet.")

@app.post("/ultimate-jarvis")
async def ultimate_jarvis(cmd: Command):
    if not check_permission(cmd.role, cmd.action):
        raise HTTPException(status_code=403, detail="ACCESS DENIED: Role unauthorized.")

    # Dynamic Retrieval of Keys
    api_keys = {
        "Groq": Config.get_key("Groq"),
        "HuggingFace_Uncensored": Config.get_key("HF")
    }

    # --- CORE AUTOMATION ENDPOINTS ---
    if cmd.action == "backend_scan":
        return health_check()

    if cmd.action == "install_api_key":
        prov = cmd.details.get("provider")
        key = cmd.details.get("api_key")
        if prov and key:
            Config.save_key(prov, key)
            return {"status": "success", "message": f"Successfully installed new API Key for {prov}. System upgraded."}
        return {"status": "error", "message": "Invalid provider or api_key details."}

    # --- 7 SYSTEM PILLARS ROUTING ---
    # 1. Security Core
    if cmd.action in ["login", "system_scan"]: 
        return await run_security_protocol(cmd.action, cmd.role, cmd.details)
        
    # 2. System Memory
    if cmd.action in ["save_memory", "retrieve_memory"]: 
        mem_action = "save" if cmd.action == "save_memory" else "retrieve"
        return await manage_memory(mem_action, cmd.role, cmd.details.get("data"))
        
    # 3. AI Brain
    if cmd.action == "god_prompt": 
        prompt = cmd.details.get("task")
        return await execute_god_brain(prompt, "Groq", api_keys)
        
    # 4. App Factory
    if cmd.action == "build_apk": 
        app_idea = cmd.details.get("idea")
        platform = cmd.details.get("platform", "android")
        return await build_flutter_app(app_idea, api_keys, platform)
        
    # 5. Media Studio
    if cmd.action in ["create_image", "create_reel"]: 
        media_type = "image" if cmd.action == "create_image" else "reel"
        return await generate_media(media_type, cmd.details, api_keys)
        
    # 6. Document Forge
    if cmd.action == "generate_doc": 
        doc_type = cmd.details.get("type")
        return await create_document(doc_type, cmd.details)
        
    # 7. Social Vault
    if cmd.action in ["auto_post", "recover_password"]: 
        platform = cmd.details.get("platform")
        return await manage_social_task(cmd.action, platform, cmd.details, api_keys)

    return {"status": "error", "message": "Command not recognized by Jarvis OS."}
    
