import os
from fastapi import FastAPI
import httpx
from pydantic import BaseModel

app = FastAPI(title="Jarvis God-Mode OS")

# 🧠 स्मार्ट मेमोरी: यहाँ नयी चाबियाँ स्टोर होंगी
temp_keys = {"Jarvis_Logic": None, "Jarvis_Unbound": None}

class KeyUpdate(BaseModel):
    service: str # 'Jarvis_Logic' या 'Jarvis_Unbound'
    new_key: str

@app.post("/update-keys")
async def update_keys(data: KeyUpdate):
    temp_keys[data.service] = data.new_key
    return {"status": "success", "message": f"{data.service} updated in memory!"}

def get_key(service):
    # पहले मेमोरी चेक करो, फिर रेंडर वाली तिजोरी
    return temp_keys.get(service) or os.getenv(service)

@app.post("/jarvis-god-mode")
async def jarvis_brain(data: dict):
    user_prompt = data.get("message", "")
    
    # चाबियाँ यहाँ से उठाएगा
    groq_key = get_key("Jarvis_Logic")
    
    if not groq_key:
        return {"status": "error", "output": "चाबी गायब है! /update-keys पर नयी चाबी भेजो।"}

    async with httpx.AsyncClient() as client:
        response = await client.post(
            "https://api.groq.com/openai/v1/chat/completions",
            headers={"Authorization": f"Bearer {groq_key}"},
            json={
                "model": "llama3-70b-8192",
                "messages": [{"role": "user", "content": f"Generate Flutter code: {user_prompt}"}]
            }
        )
        return {"output": response.json()['choices'][0]['message']['content']}
        
