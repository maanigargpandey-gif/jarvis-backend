import os
import json
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel

# सभी मॉड्यूल्स का इम्पोर्ट
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

app = FastAPI(title="Jarvis God-Mode: The Ultimate OS")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# APK डायरेक्टरी सेटअप
if not os.path.exists(Config.APK_DIR): 
    os.makedirs(Config.APK_DIR, exist_ok=True)
app.mount("/builds", StaticFiles(directory=Config.APK_DIR), name="builds")

def check_permission(role: str, action: str) -> bool:
    if role == "owner": 
        return True
    try:
        if os.path.exists("data/permissions.json"):
            with open("data/permissions.json", "r") as f:
                perms = json.load(f)
                return action in perms.get(role, [])
    except Exception:
        pass
    return False

@app.on_event("startup")
async def startup_event():
    health_check()
    owner = identity.get_owner()
    print(f"SYSTEM: [VERIFIED] Welcome back, {owner['name'] if owner else 'Guest'}.")

class Command(BaseModel):
    action: str
    role: str
    details: dict

@app.get("/download-apk/{filename}")
async def download_apk(filename: str):
    file_path = f"{Config.APK_DIR}{filename}"
    if os.path.exists(file_path): 
        return FileResponse(file_path, media_type='application/vnd.android.package-archive', filename=filename)
    raise HTTPException(status_code=404, detail="APK file not ready yet.")

@app.post("/ultimate-jarvis")
async def ultimate_jarvis(cmd: Command):
    # डायनामिक सिक्योरिटी गेट
    if not check_permission(cmd.role, cmd.action):
        raise HTTPException(status_code=403, detail="ACCESS DENIED: Role unauthorized for this action.")

    api_keys = {"Groq": Config.GROQ_API_KEY, "HuggingFace_Uncensored": Config.HF_API_KEY}

    # 1. Security Core
    if cmd.action in ["login", "system_scan"]: 
        return await run_security_protocol(cmd.action, cmd.role, cmd.details)
        
    # 2. System Memory
    if cmd.action in ["save_memory", "retrieve_memory"]: 
        mem_action = "save" if cmd.action == "save_memory" else "retrieve"
        return await manage_memory(mem_action, cmd.role, cmd.details.get("data"))
        
    # 3. AI Brain
    if cmd.action == "god_prompt": 
        return await execute_god_brain(cmd.details.get("task"), "Groq", api_keys)
        
    # 4. App Factory
    if cmd.action == "build_apk": 
        return await build_flutter_app(cmd.details.get("idea"), api_keys, cmd.details.get("platform", "android"))
        
    # 5. Media Studio
    if cmd.action in ["create_image", "create_reel"]: 
        return await generate_media(cmd.action, cmd.details, api_keys)
        
    # 6. Document Forge
    if cmd.action == "generate_doc": 
        return await create_document(cmd.details.get("type"), cmd.details)
        
    # 7. Social Vault
    if cmd.action in ["auto_post", "recover_password"]: 
        return await manage_social_task(cmd.action, cmd.details.get("platform"), cmd.details, api_keys)

    return {"status": "error", "message": "Command not recognized by Jarvis OS."}
