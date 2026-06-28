from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from core.security import verify_creator
from services.nexus_vault_service import NexusVaultService

router = APIRouter()
vault = NexusVaultService()

class VaultData(BaseModel):
    data: str

@router.post("/encrypt")
async def encrypt_data(payload: VaultData, is_creator: bool = Depends(verify_creator)):
    encrypted = vault.encrypt_data(payload.data)
    return {"status": "success", "encrypted_data": encrypted}

@router.post("/decrypt")
async def decrypt_data(payload: VaultData, is_creator: bool = Depends(verify_creator)):
    try:
        decrypted = vault.decrypt_data(payload.data)
        return {"status": "success", "decrypted_data": decrypted}
    except:
        raise HTTPException(status_code=400, detail="Invalid Encryption Key or Data")
        
