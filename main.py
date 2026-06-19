import os
import json
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from modules.ai_brain import execute_god_brain
from modules.app_factory import build_flutter_app
from modules.media_studio import generate_media
from modules.document_forge import create_document
from modules.system_memory import manage_memory
from modules.security_core import run_security_protocol
from modules.social_vault import manage_social_task
from modules.self_evolution import health_check

app = FastAPI(title="Jarvis God-Mode: Final Unified System")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- RENDERING FIX: रेंडर के लिए हेल्थ चेक ---
@app.get("/")
async def root():
    return {"status": "online", "message": "Jarvis God-Mode is Active and Healthy"}

@app.post("/ultimate-jarvis")
async def ultimate_jarvis(cmd: dict):
    action = cmd.get("action")
    details = cmd.get("details", {})
    
    # 1. AI BRAIN & PROMPTS
    if action == "god_prompt": 
        return await execute_god_brain(details.get("task"))
    
    # 2. SYSTEM HEALTH (वायरस स्कैन, बैटरी, GPS)
    elif action in ["system_scan", "battery_status", "get_gps"]:
        return await run_security_protocol(action, "owner", details)
    
    # 3. CALCULATOR & TIMER
    elif action in ["calc", "timer"]:
        return await manage_memory(action, "owner", details)
        
    # 4. MEDIA STUDIO (इरेजर, फोटो/वीडियो)
    elif action in ["create_image", "create_reel", "eraser_tool"]:
        return await generate_media(action, details)
        
    # 5. DOCUMENT FORGE (Excel, PDF, PPT, Word)
    elif action == "generate_doc":
        return await create_document(details.get("type"), details)
        
    # 6. SOCIAL VAULT
    elif action in ["auto_post", "recover_password"]:
        return await manage_social_task(action, details.get("platform"), details)

    # 7. SELF EVOLUTION (UI मोड बदलना)
    elif action == "evolve":
        return await health_check("evolve", details)
        
    return {"status": "error", "message": "Command not recognized"}
    
