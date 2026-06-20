import os
import json
from fastapi import FastAPI, HTTPException, Depends, status, Security
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import APIKeyHeader
from pydantic import BaseModel

# === 1. पुराने मॉड्यूल्स (From your screenshot) ===
from modules.ai_brain import execute_god_brain
from modules.media_studio import generate_media
from modules.social_vault import manage_social_task
from modules.system_memory import manage_memory

# === 2. नए गॉड-मोड मॉड्यूल्स ===
from modules.quantum_security import QuantumSecurityCore
from modules.nexus_vault import NexusVault
from modules.office_forge import OfficeForge
from modules.call_manager import AutonomousCallManager
from modules.creator_security import CreatorSecurity
from modules.self_evolution import EvolutionEngine
from modules.fashion_3d_engine import FashionAnd3DEngine

app = FastAPI(title="Jarvis God-Mode: Final Unified System")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# === सिस्टम इनिशियलाइज़ेशन ===
security_core = QuantumSecurityCore()
creator_auth = CreatorSecurity()
nexus_vault = NexusVault()
office_forge = OfficeForge()
call_manager = AutonomousCallManager()
evolution_engine = EvolutionEngine()
fashion_engine = FashionAnd3DEngine()

# ====================================================================
# 🛡️ मास्टर सिक्योरिटी लॉक (API Authentication) - नया जोड़ा गया
# ====================================================================
api_key_header = APIKeyHeader(name="X-API-Key", auto_error=True)

def get_api_key(api_key_attempt: str = Security(api_key_header)):
    real_jarvis_token = os.environ.get("JARVIS_AUTH_TOKEN")
    
    # अगर सर्वर में टोकन नहीं मिला तो एरर देगा
    if not real_jarvis_token:
        raise HTTPException(status_code=500, detail="Server API Token not configured")
        
    # अगर पासवर्ड मैच हो गया तो अंदर जाने देगा
    if api_key_attempt == real_jarvis_token:
        return api_key_attempt
        
    # गलत पासवर्ड पर सीधा बाहर
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Access Denied: Bhaag yaha se! Invalid API Key."
    )
# ====================================================================

# --- पिंग एंडपॉइंट (इसे खुला रखा है ताकि cron-job सर्वर को 24/7 जगा सके) ---
@app.get("/")
async def root():
    return {"status": "online", "message": "Jarvis God-Mode is Active and Healthy"}

@app.get("/system-status")
def check_status():
    return {"Nexus_Vault": "Active", "Office_Forge": "Ready", "3D_Engine": "Active"}

# === द मास्टर एंडपॉइंट (सिक्योरिटी लॉक के साथ सुरक्षित) ===
@app.post("/ultimate-jarvis", dependencies=[Depends(get_api_key)])
async def ultimate_jarvis(cmd: dict):
    action = cmd.get("action")
    details = cmd.get("details", {})

    # 1. AI BRAIN
    if action == "god_prompt":
        return await execute_god_brain(details.get("task"))

    # 2. MEDIA STUDIO (पुराना इमेज/वीडियो)
    elif action in ["create_image", "create_reel", "eraser_tool"]:
        return await generate_media(action, details)

    # 3. SOCIAL VAULT
    elif action in ["auto_post", "recover_password"]:
        return await manage_social_task(action, details.get("platform"), details)

    # 4. SYSTEM MEMORY & CALC
    elif action in ["calc", "timer"]:
        return await manage_memory(action, "owner", details)

    # 5. NEW: NEXUS VAULT SAVE
    elif action == "save_to_nexus":
        return nexus_vault.save_to_nexus(details.get("path"), details.get("type"))

    # 6. NEW: CREATOR SECURITY VERIFICATION
    elif action == "verify_creator":
        return creator_auth.verify_creator(pin=details.get("pin"))

    # 7. NEW: FASHION 3D ENGINE
    elif action == "virtual_try_on":
        return fashion_engine.search_and_try_on(details.get("photo"), details.get("item"))

    # 8. SELF EVOLUTION (पुराना हेल्थ चेक + नया इवॉल्व)
    elif action == "evolve":
        return evolution_engine.health_check()

    return {"status": "error", "message": "Command not recognized or System Evolving"}
    
