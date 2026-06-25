# auth.py
from fastapi import HTTPException, Security
from fastapi.security import APIKeyHeader
from modules.identity_core import identity

# Flutter ऐप हर रिक्वेस्ट के हैडर में "X-Creator-Token" भेजेगा
api_key_header = APIKeyHeader(name="X-Creator-Token", auto_error=False)

def verify_creator(creator_token: str = Security(api_key_header)):
    if not creator_token:
        print("⚠️ Authentication Failed: No Token Provided")
        raise HTTPException(status_code=401, detail="Missing Creator Token")
        
    if not identity.verify_access(creator_token):
        print("⚠️ Unauthorized Access Attempt Blocked!")
        raise HTTPException(status_code=403, detail="Access Denied. God-Mode Only.")
        
    return True
    
