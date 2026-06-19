import os
import json
from fastapi import FastAPI, HTTPException
from modules.ai_brain import execute_god_brain
from modules.media_studio import generate_media
from modules.document_forge import create_document
from modules.system_memory import manage_memory
from modules.security_core import run_security_protocol
from modules.social_vault import manage_social_task
from modules.self_evolution import health_check

app = FastAPI(title="Jarvis God-Mode: Final Unified System")

@app.post("/ultimate-jarvis")
async def ultimate_jarvis(cmd: dict):
    action = cmd.get("action")
    details = cmd.get("details", {})
    
    # 1. AI & Brain
    if action == "god_prompt": return await execute_god_brain(details.get("task"))
    
    # 2. System Health, Virus Scan, Battery, GPS (System Memory)
    elif action in ["system_scan", "battery_status", "get_gps"]:
        return await run_security_protocol(action, "owner", details)
    
    # 3. Calculator & Timer (System Memory)
    elif action in ["calc", "timer"]:
        return await manage_memory(action, "owner", details)
        
    # 4. Media (Eraser, Studio)
    elif action in ["create_image", "create_reel", "eraser_tool"]:
        return await generate_media(action, details)
        
    # 5. Docs (Excel, PDF)
    elif action == "generate_doc":
        return await create_document(details.get("type"), details)
        
    # 6. Girgit Mode (UI Config)
    elif action == "evolve":
        return {"status": "success", "mode_updated": details.get("mode")}
        
    return {"status": "error", "message": "Command unrecognized"}
    
