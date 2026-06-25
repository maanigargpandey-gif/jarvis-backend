from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import Optional
from services.moa_engine import moa_engine
from auth import verify_creator
from memory import jarvis_memory
from core.config import settings

router = APIRouter()

class ChatRequest(BaseModel):
    query: str
    workspace_mode: str = "chat"

class ActionRequest(BaseModel):
    action_type: str 
    payload: dict

# This route requires God-Mode token to be accessed
@router.post("/chat", dependencies=[Depends(verify_creator)])
def handle_chat(request: ChatRequest):
    try:
        # Process via MoA Engine
        result = moa_engine.process_query(request.query, request.workspace_mode)
        
        # Save to memory
        jarvis_memory.save_context(request.query, result["response"])
        
        return {
            "reply": result["response"],
            "is_god_mode": True,
            "metadata": {"engine": result["provider"]}
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/workspace/action", dependencies=[Depends(verify_creator)])
def handle_workspace_action(request: ActionRequest):
    return {
        "status": "success",
        "action_executed": request.action_type,
        "result": f"Executed {request.action_type} successfully on backend."
    }
    
