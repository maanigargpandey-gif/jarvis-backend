import os
import traceback
from fastapi import FastAPI, Request
import httpx

app = FastAPI(title="Jarvis God-Mode OS")

# 🧠 ऑटो-पायलट: तुम्हारी रेंडर तिजोरी के बिल्कुल असली नाम 
GROQ_API_KEY = os.getenv("Jarvis_Logic", "")
HUGGINGFACE_API_KEY = os.getenv("Jarvis_Vision", "")
OPENROUTER_API_KEY = os.getenv("Jarvis_Unbound", "")
GITHUB_API_KEY = os.getenv("Jarvis_APK_Builder", "")

@app.post("/jarvis-god-mode")
async def jarvis_brain(request: Request):
    try:
        data = await request.json()
        user_prompt = data.get("message", "").lower()
        power_level = data.get("power_level", "extreme")

        response_payload = {
            "status": "success",
            "active_systems": [],
            "output": "",
            "ui_action": "AUTO_PILOT_ENGAGED"
        }

        # ⚡ चेक करना कि कौन-कौन सी चाबियां एक्टिव हैं
        if OPENROUTER_API_KEY:
            response_payload["active_systems"].append("Jarvis_Unbound (OpenRouter Active)")
        if GROQ_API_KEY:
            response_payload["active_systems"].append("Jarvis_Logic (Groq Active)")
        if HUGGINGFACE_API_KEY:
            response_payload["active_systems"].append("Jarvis_Vision (HuggingFace Active)")
        if GITHUB_API_KEY:
            response_payload["active_systems"].append("Jarvis_APK_Builder (GitHub Active)")

        # अगर रेंडर में नाम मैच नहीं हुआ
        if not OPENROUTER_API_KEY and not GROQ_API_KEY:
            return {
                "status": "error", 
                "output": "CRITICAL: रेंडर में 'Jarvis_Unbound' या 'Jarvis_Logic' नाम की कोई चाबी नहीं मिली!"
            }

        # 🔴 EXTREME MODE - ऑटोमेटिक OpenRouter (Jarvis_Unbound) को कॉल करना
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
                
                # अगर API ने सही जवाब दिया
                if ai_response.status_code == 200:
                    response_payload["output"] = ai_response.json()['choices'][0]['message']['content']
                else:
                    response_payload["output"] = f"API_REJECTED: OpenRouter Error -> {ai_response.text}"
                    
        return response_payload

    # 🛡️ द अल्टीमेट शील्ड: अगर सिस्टम क्रैश हुआ, तो सीधा बीमारी बताएगा
    except Exception as e:
        error_msg = str(e)
        stack_trace = traceback.format_exc() 
        return {
            "status": "SYSTEM_DIAGNOSTIC_REPORT",
            "error_detail": error_msg,
            "solution": "Traceback चेक करें",
            "traceback": stack_trace
        }
        
        
