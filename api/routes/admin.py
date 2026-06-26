from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import Dict, List
from core.dependencies import verify_creator
from services.pinecone_service import PineconeService
import psutil
import time

router = APIRouter()

class SystemStats(BaseModel):
    cpu_usage: float
    memory_usage: float
    disk_usage: float
    uptime: float
    active_sessions: int
    total_memories: int

@router.get("/dashboard")
async def get_admin_dashboard(creator: bool = Depends(verify_creator)):
    if not creator:
        raise HTTPException(status_code=403, detail="Admin access required")
    
    cpu_percent = psutil.cpu_percent()
    memory = psutil.virtual_memory()
    disk = psutil.disk_usage('/')
    
    try:
        stats_obj = PineconeService.index.describe_index_stats() if PineconeService.index else None
        total_memories = stats_obj.total_vector_count if stats_obj else 0
    except:
        total_memories = 0
    
    stats = SystemStats(
        cpu_usage=cpu_percent,
        memory_usage=memory.percent,
        disk_usage=disk.percent,
        uptime=time.time() - psutil.boot_time(),
        active_sessions=1,
        total_memories=total_memories
    )
    
    return {
        "status": "success",
        "system_stats": stats.dict(),
        "creator": {
            "name": "Mani Pandey",
            "mode": "God Mode Active"
        },
        "quick_actions": [
            {"name": "System Scan", "action": "scan"},
            {"name": "Clear Cache", "action": "clear_cache"},
            {"name": "Backup Vault", "action": "backup"},
            {"name": "View Logs", "action": "logs"}
        ]
    }
  
