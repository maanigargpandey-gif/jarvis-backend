from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from core.security import verify_creator
from services.media_studio import MediaStudio

router = APIRouter()

class MediaRequest(BaseModel):
    prompt: str
    reference_image_url: str = None

@router.post("/generate")
async def generate_media(request: MediaRequest, is_creator: bool = Depends(verify_creator)):
    try:
        result = await MediaStudio.generate_media(request.prompt, request.reference_image_url)
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Media Engine Error: {str(e)}")
      
