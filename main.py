# main.py
from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional

# Import the missing modules we just created
from auth import verify_creator
from memory import jarvis_memory
from modules.identity_core import identity
from services.moa_engine import moa_engine # (यह फाइल पहले से आपके पास है)

app = FastAPI(title="Zarvish OS Backend", version="4.0.0")

# CORS Setup for Flutter Binding
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class ChatRequest(BaseModel):
    query: str
    workspace_mode: str = "chat"

@app.get("/")
def health_check():
    return {"status": "Online", "creator": identity.name, "memory": jarvis_memory.db_status}

# 🔒 [CRITICAL CHANGE]: Added 'Depends(verify_creator)'
# अब कोई भी बिना '1005@Maani' टोकन के इस API को हिट नहीं कर सकता।
@app.post("/api/v1/chat", dependencies=[Depends(verify_creator)])
def handle_chat(request: ChatRequest):
    try:
        # 1. Process via MoA Engine
        result = moa_engine.process_query(request.query, request.workspace_mode)
        
        # 2. Save conversation to Infinite Memory
        jarvis_memory.save_context(request.query, result["response"])
        
        return {
            "reply": result["response"],
            "is_god_mode": True,
            "metadata": {"engine": result["provider"]}
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=7860, reload=True)
    
