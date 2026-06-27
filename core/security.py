from fastapi import Security, HTTPException, status
from fastapi.security import APIKeyHeader
from core.config import settings

# Flutter ऐप हर रिक्वेस्ट के हैडर में "X-Creator-Token" भेजेगा
api_key_header = APIKeyHeader(name="X-Creator-Token", auto_error=False)

async def verify_creator(creator_token: str = Security(api_key_header)):
    if not creator_token:
        print("❌ Auth Failed: No Token Provided")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing Creator Token"
        )
    
    # यहाँ हम God Mode Pin से वेरिफाई कर रहे हैं (आप इसे बाद में एन्क्रिप्टेड टोकन से बदल सकते हैं)
    if creator_token != settings.GOD_MODE_PIN:
        print("🚫 Unauthorized Access Attempt Blocked!")
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access Denied. God-Mode Only."
        )
    
    return True
    
