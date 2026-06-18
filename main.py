import os
import traceback
from fastapi import FastAPI
from pydantic import BaseModel
import httpx

app = FastAPI(title="Jarvis God-Mode OS")

# 🧠 ऑटो-पायलट: रेंडर तिजोरी से Groq की चाबी उठाना (100% Free)
GROQ_API_KEY = os.getenv("Jarvis_Logic", "") 

class JarvisRequest(BaseModel):
    message: str
    power_level: str = "extreme"

@app.post("/jarvis-god-mode")
async def jarvis_brain(request_data: JarvisRequest):
    try:
        user_prompt = request_data.message.lower()
        
        # 🚀 सीधा Groq (Free Tier) को कॉल करना
        async with httpx.AsyncClient() as client:
            groq_response = await client.post(
                "https://api.groq.com/openai/v1/chat/completions",
                headers={"Authorization": f"Bearer {GROQ_API_KEY}"},
                json={
                    "model": "llama3-70b-8192", # Groq का सबसे तगड़ा फ्री मॉडल
                    "messages": [{"role": "user", "content": f"ACTIVATE AUTOPILOT: Generate full Flutter Dart code for Jarvis. Command: {user_prompt}"}]
                },
                timeout=60.0
            )
            
            if groq_response.status_code == 200:
                return {"status": "success", "output": groq_response.json()['choices'][0]['message']['content']}
            else:
                return {"status": "error", "output": f"GROQ_ERROR: {groq_response.text}"}

    except Exception as e:
        return {"status": "error", "detail": str(e)}
        
