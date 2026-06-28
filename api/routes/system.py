from fastapi import APIRouter, Depends
from core.security import verify_creator
from services.phone_doctor_service import PhoneDoctor
from services.call_manager_service import CallManager
from services.pc_control_service import PCControlService

router = APIRouter()

@router.get("/phone-health")
async def check_phone_health(is_creator: bool = Depends(verify_creator)):
    return await PhoneDoctor.run_scan()

@router.get("/monitor-calls")
async def monitor_calls(is_creator: bool = Depends(verify_creator)):
    return await CallManager.monitor_calls()

@router.post("/pc-action")
async def control_pc(action: str, is_creator: bool = Depends(verify_creator)):
    # action can be "shutdown", "sleep", "open chrome"
    return await PCControlService.execute_pc_command(action)
  
