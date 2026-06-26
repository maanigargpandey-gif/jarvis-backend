from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import Optional, List, Dict
from services.llm_router import llm_router
from services.pinecone_service import PineconeService
from core.dependencies import get_current_user
import time

router = APIRouter()

class ChatRequest(BaseModel):
    query: str
    workspace_mode: str = "chat"
    context: Optional[List[Dict]] = []
    session_id: Optional[str] = None

class ChatResponse(BaseModel):
    reply: str
    provider: str
    mode: str
    memory_context: Optional[List[Dict]] = []
    processing_time: float

@router.post("/send")
async def send_message(request: ChatRequest, user: dict = Depends(get_current_user)):
    start_time = time.time()
    
    if user["role"] == "guest":
        if request.workspace_mode in ["document", "code", "admin"]:
            raise HTTPException(
                status_code=403,
                detail="Guest mode restricted. Please authenticate for full access."
            )
    
    memories = await PineconeService.search_memory(request.query, top_k=3)
    result = await llm_router.route_query(request.query, request.workspace_mode)
    
    await PineconeService.store_memory(
        query=request.query,
        response=result["response"],
        metadata={
            "workspace_mode": request.workspace_mode,
            "user_role": user["role"]
        }
    )
    
    processing_time = time.time() - start_time
    
    return ChatResponse(
        reply=result["response"],
        provider=result["provider"],
        mode=request.workspace_mode,
        memory_context=memories,
        processing_time=round(processing_time, 2)
    )
  
