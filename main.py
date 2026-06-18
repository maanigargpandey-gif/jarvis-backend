import os
import traceback
from fastapi import FastAPI
from pydantic import BaseModel # 👈 यह वो जादू है जो डिब्बा वापस लाएगा
import httpx

app = FastAPI(title="Jarvis God-Mode OS")

# 🧠 ऑटो-पायलट: रेंडर से चाबियां खींचना
GROQ_API_KEY = os.getenv("Jarvis_Logic", "")
HUGGINGFACE_API_KEY = os.getenv("Jarvis_Vision", "")
OPENROUTER_API_KEY = os.getenv("Jarvis_Unbound", "")
GITHUB_API_KEY = os.getenv("Jarvis_APK_Builder", "")

# 🎯 Swagger UI को डिब्बा दिखाने का निर्देश
class JarvisRequest(BaseModel):
    message: str
    power_level: str = "extreme"

@app.post("/jarvis-god-mode")
async def jarvis_brain(request_data: JarvisRequest): # 👈 डिब्बा यहाँ से कनेक्ट होगा
    try:
        user_prompt = request_data.message.lower()
        power_level = request_data.power_level

        response_payload = {
            "status": "success",
            "active_systems": [],
            "output": "",
            "ui_action": "AUTO_PILOT_ENGAGED"
        }

        if OPENROUTER_API_KEY:
            response_payload["active_systems"].append("Jarvis_Unbound (OpenRouter Active)")
        if GROQ_API_KEY:
            response_payload["active_systems"].append("Jarvis_Logic (Groq Active)")

        if not OPENROUTER_API_KEY and not GROQ_API_KEY:
            return {
                "status": "error", 
                "output": "CRITICAL: रेंडर में 'Jarvis_Unbound' या 'Jarvis_Logic' नाम की कोई चाबी नहीं मिली!"
            }

        # 🔴 EXTREME MODE - ऑटोमेटिक OpenRouter को कॉल करना
        if OPENROUTER_API_KEY:
            async with httpx.AsyncClient() as client:
                ai_response = await client.post(
                    "https://openrouter.ai/api/v1/chat/completions",
                    headers={"Authorization": f"Bearer {OPENROUTER_API_KEY}"},
                    json={
                        "model": "cognitivecomputations/dolphin-mixtral-8x7b",
                        "messages": [{"role": "user", "content": f"ACTIVATE AUTOPILOT: Generate full Flutter Dart code for Jarvis God-Mode. Command: {user_prompt}"}]
                    },
                    timeout=60.0
                )
                
                if ai_response.status_code == 200:
                    response_payload["output"] = ai_response.json()['choices'][0]['message']['content']
                else:
                    response_payload["output"] = f"API_REJECTED: OpenRouter Error -> {ai_response.text}"
                    
        return response_payload

    except Exception as e:
        error_msg = str(e)
        stack_trace = traceback.format_exc() 
        return {
            "status": "SYSTEM_DIAGNOSTIC_REPORT",
            "error_detail": error_msg,
            "solution": "Traceback चेक करें",
            "traceback": stack_trace
        }
        
