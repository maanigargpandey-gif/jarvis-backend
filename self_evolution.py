import os
from fastapi import FastAPI, HTTPException, Header
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel
from dotenv import load_dotenv

# मॉड्यूल इम्पोर्ट्स
from modules.ai_brain import execute_god_brain
from modules.app_factory import build_flutter_app
from modules.media_studio import generate_media
from modules.document_forge import create_document
from modules.social_vault import manage_social_task
from modules.security_core import run_security_protocol
from modules.system_memory import manage_memory
from modules.identity_core import identity

load_dotenv()
app = FastAPI(title="Jarvis God-Mode: The Ultimate OS")

# 1. CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 2. APK फाइल सर्विंग के लिए Static Directory (Delivery System)
APK_DIR = "frontend/build/app/outputs/flutter-apk/"
if not os.path.exists(APK_DIR):
    os.makedirs(APK_DIR, exist_ok=True)
app.mount("/builds", StaticFiles(directory=APK_DIR), name="builds")

# 3. स्टार्टअप इवेंट (ओनर पहचान)
@app.on_event("startup")
async def startup_event():
    owner = identity.get_owner()
    if not owner:
        print("SYSTEM: [ALERT] No owner bound. Initiate onboarding.")
    else:
        print(f"SYSTEM: [VERIFIED] Welcome back, {owner['name']}.")

# 4. Vault (API Keys)
system_vault = {
    "api_keys": {
        "Groq": os.getenv("Jarvis_Logic", ""),
        "HuggingFace_Uncensored": os.getenv("HF_KEY", "")
    },
    "active_provider": "Groq"
}

# 5. Pydantic Model
class Command(BaseModel):
    action: str
    role: str
    details: dict

# --- ENDPOINTS ---

@app.get("/download-apk/{filename}")
async def download_apk(filename: str):
    file_path = f"{APK_DIR}{filename}"
    if os.path.exists(file_path):
        return FileResponse(file_path, media_type='application/vnd.android.package-archive', filename=filename)
    raise HTTPException(status_code=404, detail="APK file not ready yet.")

@app.post("/ultimate-jarvis")
async def ultimate_jarvis(cmd: Command):
    # A. Security Gate (Guest restrict)
    if cmd.role == "guest" and cmd.action not in ["god_prompt", "save_memory", "retrieve_memory"]:
        raise HTTPException(status_code=403, detail="ACCESS DENIED: Guest mode restricted.")

    # B. Module Dispatcher
    # 1. Security
    if cmd.action in ["login", "system_scan"]:
        return await run_security_protocol(cmd.action, cmd.role, cmd.details)
    
    # 2. System Memory
    if cmd.action in ["save_memory", "retrieve_memory"]:
        mem_action = "save" if cmd.action == "save_memory" else "retrieve"
        return await manage_memory(mem_action, cmd.role, cmd.details.get("data"))

    # 3. AI Brain (God Prompt)
    if cmd.action == "god_prompt":
        return await execute_god_brain(cmd.details.get("task"), system_vault["active_provider"], system_vault["api_keys"])

    # 4. App Factory (Build APK/IPA)
    if cmd.action == "build_apk":
        idea = cmd.details.get("idea")
        platform = cmd.details.get("platform", "android")
        return await build_flutter_app(idea, system_vault["api_keys"], platform)

    # 5. Media Studio
    if cmd.action in ["create_image", "create_reel"]:
        return await generate_media(cmd.action, cmd.details, system_vault["api_keys"])

    # 6. Document Forge
    if cmd.action == "generate_doc":
        return await create_document(cmd.details.get("type"), cmd.details)

    # 7. Social Vault
    if cmd.action in ["auto_post", "recover_password"]:
        return await manage_social_task(cmd.action, cmd.details.get("platform"), cmd.details, {})

    raise HTTPException(status_code=400, detail="Command not recognized by Jarvis OS.")
                                        
