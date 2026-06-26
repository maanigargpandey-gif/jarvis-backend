from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import Dict, Optional
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
import base64
import json
import os
from core.config import settings
from core.dependencies import verify_creator
from datetime import datetime

router = APIRouter()

class CredentialStore(BaseModel):
    service_name: str
    username: str
    password: str
    notes: Optional[str] = ""
    category: str = "general"

class CredentialRecovery(BaseModel):
    service_name: str
    recovery_key: str

class VaultManager:
    def __init__(self):
        self.vault_path = "data/credential_vault.enc"
        self.cipher = self._initialize_cipher()
        self.credentials: Dict = {}
        self._load_vault()
    
    def _initialize_cipher(self) -> Fernet:
        salt = b'zarvish_salt_2024'
        kdf = PBKDF2HMAC(
            algorithm=hashes.SHA256(),
            length=32,
            salt=salt,
            iterations=100000,
        )
        key = base64.urlsafe_b64encode(kdf.derive(settings.ENCRYPTION_KEY))
        return Fernet(key)
    
    def _load_vault(self):
        if os.path.exists(self.vault_path):
            try:
                with open(self.vault_path, 'rb') as f:
                    encrypted_data = f.read()
                    decrypted_data = self.cipher.decrypt(encrypted_data)
                    self.credentials = json.loads(decrypted_data)
            except Exception:
                self.credentials = {}
    
    def _save_vault(self):
        os.makedirs(os.path.dirname(self.vault_path), exist_ok=True)
        encrypted_data = self.cipher.encrypt(json.dumps(self.credentials).encode())
        with open(self.vault_path, 'wb') as f:
            f.write(encrypted_data)
    
    def add_credential(self, cred: CredentialStore) -> Dict:
        encrypted_password = self.cipher.encrypt(cred.password.encode()).decode()
        self.credentials[cred.service_name] = {
            "username": cred.username,
            "password_encrypted": encrypted_password,
            "notes": cred.notes,
            "category": cred.category,
            "created_at": str(datetime.now())
        }
        self._save_vault()
        return {"status": "success", "message": f"Credentials for {cred.service_name} stored securely"}
    
    def get_credential(self, service_name: str, recovery_key: str) -> Dict:
        if recovery_key != settings.ADMIN_TOKEN:
            raise HTTPException(status_code=403, detail="Invalid recovery key")
        cred = self.credentials.get(service_name)
        if not cred:
            raise HTTPException(status_code=404, detail="Service not found")
        decrypted_password = self.cipher.decrypt(cred["password_encrypted"].encode()).decode()
        return {
            "service": service_name,
            "username": cred["username"],
            "password": decrypted_password,
            "notes": cred["notes"],
            "category": cred["category"]
        }
    
    def list_services(self) -> Dict:
        services = []
        for name, data in self.credentials.items():
            services.append({
                "service": name,
                "username": data["username"],
                "category": data["category"]
            })
        return {"services": services, "total": len(services)}

vault_manager = VaultManager()

@router.post("/store")
async def store_credential(cred: CredentialStore, creator: bool = Depends(verify_creator)):
    if not creator:
        raise HTTPException(status_code=403, detail="Creator access required")
    return vault_manager.add_credential(cred)

@router.post("/recover")
async def recover_credential(recovery: CredentialRecovery, creator: bool = Depends(verify_creator)):
    if not creator:
        raise HTTPException(status_code=403, detail="Creator access required")
    return vault_manager.get_credential(recovery.service_name, recovery.recovery_key)

@router.get("/list")
async def list_credentials(creator: bool = Depends(verify_creator)):
    if not creator:
        raise HTTPException(status_code=403, detail="Creator access required")
    return vault_manager.list_services()
  
