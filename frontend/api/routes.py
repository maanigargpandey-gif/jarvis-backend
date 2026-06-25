from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import Optional
from services.moa_engine import moa_engine
from core.config import settings

router = APIRouter()

# Data models for Frontend <-> Backend connection
class ChatRequest(BaseModel):
    query: str
    workspace_mode: str = "chat"
    creator_token: Optional[str] = None

class ActionRequest(BaseModel):
    action_type: str  # e.g., 'summarize', 'translate', 'vision'
    payload: dict

@router.get("/")
def health_check():
    return {
        "status": "Online", 
        "os": settings.PROJECT_NAME, 
        "creator": settings.CREATOR.name
    }

@router.post("/chat")
def handle_chat(request: ChatRequest):
    """
    Flutter ऐप से टेक्स्ट या वॉइस कमांड यहाँ आएगी।
    """
    try:
        # Check if God-Mode is requested
        is_god_mode = request.creator_token == settings.CREATOR.master_pass
        
        # Process via our MoA Engine
        result = moa_engine.process_query(
            query=request.query, 
            workspace_mode=request.workspace_mode
        )
        
        return {
            "reply": result["response"],
            "is_god_mode": is_god_mode,
            "metadata": {"engine": result["provider"]}
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/workspace/action")
def handle_workspace_action(request: ActionRequest):
    """
    Flutter ऐप के 'Omni Workspace' (3-dot menu) से आने वाले एक्शन्स: Summarize, Translate etc.
    """
    return {
        "status": "success",
        "action_executed": request.action_type,
        "result": f"Executed {request.action_type} successfully on backend."
    }
  
