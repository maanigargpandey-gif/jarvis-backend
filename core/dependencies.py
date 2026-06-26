from fastapi import HTTPException, Security
from fastapi.security import APIKeyHeader
from core.config import settings
from typing import Optional

api_key_header = APIKeyHeader(name="X-Creator-Token", auto_error=False)

async def verify_creator(creator_token: str = Security(api_key_header)) -> bool:
    if not creator_token:
        raise HTTPException(status_code=401, detail="Missing Creator Token")
    if creator_token != settings.ADMIN_TOKEN:
        raise HTTPException(status_code=403, detail="Access Denied. Creator mode only.")
    return True

async def get_current_user(token: Optional[str] = None) -> dict:
    if not token:
        return {"role": "guest", "access_level": "restricted"}
    if token == settings.ADMIN_TOKEN:
        return {"role": "creator", "access_level": "god_mode"}
    return {"role": "guest", "access_level": "restricted"}
  
