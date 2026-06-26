from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import Optional
from services.mfa_service import mfa_service
from core.config import settings

router = APIRouter()

class LoginRequest(BaseModel):
    method: str
    auth_data: Optional[str] = None
    pin: Optional[str] = None

class MFAVerificationRequest(BaseModel):
    session_token: str
    step: str
    biometric_data: Optional[bytes] = None
    pin: Optional[str] = None

class AdminLoginRequest(BaseModel):
    email: str
    pin: str
    admin_token: str

@router.post("/login")
async def login(request: LoginRequest):
    if request.method == "guest":
        return {
            "status": "success",
            "role": "guest",
            "clearance": "restricted",
            "message": "Welcome to Zarvish Guest Mode"
        }
    
    if request.method == "google":
        if request.auth_data and request.auth_data.lower() == settings.CREATOR_EMAIL.lower():
            if request.pin == settings.CREATOR_MASTER_PIN:
                mfa_session = await mfa_service.start_mfa_sequence("creator_mani")
                return {
                    "status": "mfa_required",
                    "session_token": mfa_session["session_token"],
                    "next_step": mfa_session["next_step"],
                    "message": "Creator identity confirmed. MFA verification required."
                }
            else:
                return {"status": "pending_pin", "message": "Enter Master PIN"}
    
    return {
        "status": "success",
        "role": "guest",
        "clearance": "restricted",
        "message": "Standard access granted"
    }

@router.post("/mfa/verify")
async def verify_mfa_step(request: MFAVerificationRequest):
    if request.step == "face_id":
        success = await mfa_service.verify_face_id(
            request.session_token, 
            request.biometric_data or b""
        )
    elif request.step == "fingerprint":
        success = await mfa_service.verify_fingerprint(
            request.session_token,
            request.biometric_data or b""
        )
    elif request.step == "voice_match":
        success = await mfa_service.verify_voice_match(
            request.session_token,
            request.biometric_data or b""
        )
    elif request.step == "secure_pin":
        success = await mfa_service.verify_secure_pin(
            request.session_token,
            request.pin or ""
        )
    else:
        raise HTTPException(status_code=400, detail="Invalid MFA step")
    
    if success:
        if mfa_service.is_mfa_complete(request.session_token):
            return {
                "status": "mfa_complete",
                "role": "creator",
                "clearance": "god_mode",
                "message": "Full access granted. Welcome, Creator."
            }
        steps = ["face_id", "fingerprint", "voice_match", "secure_pin"]
        completed = len(mfa_service.sessions[request.session_token]["completed_steps"])
        return {
            "status": "step_completed",
            "next_step": steps[completed] if completed < 4 else None
        }
    
    raise HTTPException(status_code=401, detail="Verification failed")

@router.post("/admin/login")
async def admin_login(request: AdminLoginRequest):
    if request.email != settings.CREATOR_EMAIL:
        raise HTTPException(status_code=403, detail="Access denied")
    if request.pin != settings.CREATOR_MASTER_PIN:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    if request.admin_token != settings.ADMIN_TOKEN:
        raise HTTPException(status_code=403, detail="Invalid admin token")
    
    mfa_session = await mfa_service.start_mfa_sequence("admin_mani")
    return {
        "status": "mfa_required",
        "session_token": mfa_session["session_token"],
        "message": "Admin access requires full MFA verification"
    }
  
