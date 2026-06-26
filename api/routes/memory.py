from fastapi import APIRouter
from pydantic import BaseModel
from typing import Optional, Dict
from services.pinecone_service import PineconeService
import time
import asyncio

router = APIRouter()

class CalculatorRequest(BaseModel):
    expression: str

class TimerRequest(BaseModel):
    duration: int
    label: Optional[str] = "Timer"

active_timers: Dict[str, Dict] = {}

@router.post("/calculate")
async def calculate(request: CalculatorRequest):
    try:
        allowed_names = {"abs": abs, "round": round, "min": min, "max": max, "pow": pow}
        result = eval(request.expression, {"__builtins__": {}}, allowed_names)
        return {
            "expression": request.expression,
            "result": result,
            "status": "success"
        }
    except Exception as e:
        return {
            "expression": request.expression,
            "error": str(e),
            "status": "error"
        }

@router.post("/timer/start")
async def start_timer(request: TimerRequest):
    timer_id = f"timer_{int(time.time())}"
    timer_data = {
        "id": timer_id,
        "duration": request.duration,
        "label": request.label,
        "start_time": time.time(),
        "end_time": time.time() + request.duration,
        "status": "running"
    }
    active_timers[timer_id] = timer_data
    asyncio.create_task(_complete_timer(timer_id, request.duration))
    return {
        "timer_id": timer_id,
        "duration": request.duration,
        "message": f"Timer '{request.label}' started for {request.duration} seconds"
    }

async def _complete_timer(timer_id: str, duration: int):
    await asyncio.sleep(duration)
    if timer_id in active_timers:
        active_timers[timer_id]["status"] = "completed"

@router.get("/timer/status/{timer_id}")
async def get_timer_status(timer_id: str):
    timer = active_timers.get(timer_id)
    if not timer:
        return {"status": "not_found"}
    remaining = max(0, timer["end_time"] - time.time())
    return {
        "timer_id": timer_id,
        "label": timer["label"],
        "duration": timer["duration"],
        "remaining": int(remaining),
        "status": timer["status"]
    }

@router.get("/search")
async def search_memories(query: str, limit: int = 10):
    memories = await PineconeService.search_memory(query, top_k=limit)
    return {"query": query, "memories": memories, "total": len(memories)}
  
