from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from core.security import verify_creator
from services.llm_router import router as llm_router

router = APIRouter()

class ChatRequest(BaseModel):
    prompt: str
    user_id: str = "Mani_Pandey_God"

@router.post("/send")
async def send_message(request: ChatRequest, is_creator: bool = Depends(verify_creator)):
    try:
        # Ye command seedha aapke LLM Router (Boss) ke paas jayegi
        response = await llm_router.route_command(request.prompt, request.user_id)
        return {"status": "success", "response": response}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
      
