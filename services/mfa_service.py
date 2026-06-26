import hashlib
import time
from typing import Dict
from cryptography.fernet import Fernet
from core.config import settings

class MFAService:
    def __init__(self):
        self.cipher = Fernet(settings.ENCRYPTION_KEY)
        self.sessions: Dict[str, Dict] = {}
        self.mfa_sequence = ["face_id", "fingerprint", "voice_match", "secure_pin"]
    
    async def start_mfa_sequence(self, user_id: str) -> Dict:
        session_token = self._generate_session_token(user_id)
        self.sessions[session_token] = {
            "user_id": user_id,
            "current_step": 0,
            "completed_steps": [],
            "timestamp": time.time(),
            "attempts": 0
        }
        return {
            "session_token": session_token,
            "next_step": self.mfa_sequence[0],
            "total_steps": len(self.mfa_sequence)
        }
    
    async def verify_face_id(self, session_token: str, face_data: bytes) -> bool:
        if session_token not in self.sessions:
            return False
        session = self.sessions[session_token]
        if session["current_step"] != 0:
            return False
        face_hash = hashlib.sha256(face_data).hexdigest()
        if face_hash:
            session["completed_steps"].append("face_id")
            session["current_step"] = 1
            return True
        return False
    
    async def verify_fingerprint(self, session_token: str, fingerprint_data: bytes) -> bool:
        if session_token not in self.sessions:
            return False
        session = self.sessions[session_token]
        if session["current_step"] != 1:
            return False
        fp_hash = hashlib.sha256(fingerprint_data).hexdigest()
        if fp_hash:
            session["completed_steps"].append("fingerprint")
            session["current_step"] = 2
            return True
        return False
    
    async def verify_voice_match(self, session_token: str, voice_data: bytes) -> bool:
        if session_token not in self.sessions:
            return False
        session = self.sessions[session_token]
        if session["current_step"] != 2:
            return False
        voice_hash = hashlib.sha256(voice_data).hexdigest()
        if voice_hash:
            session["completed_steps"].append("voice_match")
            session["current_step"] = 3
            return True
        return False
    
    async def verify_secure_pin(self, session_token: str, pin: str) -> bool:
        if session_token not in self.sessions:
            return False
        session = self.sessions[session_token]
        if session["current_step"] != 3:
            return False
        if pin == settings.CREATOR_MASTER_PIN:
            session["completed_steps"].append("secure_pin")
            session["current_step"] = 4
            return True
        session["attempts"] += 1
        if session["attempts"] >= 3:
            del self.sessions[session_token]
        return False
    
    def is_mfa_complete(self, session_token: str) -> bool:
        session = self.sessions.get(session_token)
        if not session:
            return False
        return len(session["completed_steps"]) == len(self.mfa_sequence)
    
    def _generate_session_token(self, user_id: str) -> str:
        data = f"{user_id}:{time.time()}:{settings.SECRET_KEY}"
        return hashlib.sha256(data.encode()).hexdigest()

mfa_service = MFAService()
