import os
import httpx
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="Jarvis Self-Evolving OS")

# ये 'स्मृति' (Memory) है, जो सर्वर चलने तक याद रखेगी कि तूने क्या आदेश दिया
system_directive = "Act as a professional Flutter Architect. Keep UI dark and hacker-themed."

class LogicUpdate(BaseModel):
    new_directive: str

@app.post("/update-logic")
async def update_logic(logic: LogicUpdate):
    global system_directive
    system_directive = logic.new_directive
    return {"status": "success", "message": "System Evolved! New Directive Saved."}

@app.post("/jarvis-god-mode")
async def jarvis_brain(data: dict):
    user_prompt = data.get("message", "")
    
    # यहाँ 'system_directive' काम करेगा जो तूने आखिरी बार सेट किया था
    prompt_with_context = f"SYSTEM DIRECTIVE: {system_directive}. USER COMMAND: {user_prompt}"

    # ऑटो-फेलओवर (Groq)
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "https://api.groq.com/openai/v1/chat/completions",
            headers={"Authorization": f"Bearer {os.getenv('Jarvis_Logic')}"},
            json={
                "model": "llama3-70b-8192",
                "messages": [{"role": "user", "content": prompt_with_context}]
            },
            timeout=60.0
        )
        return {"output": response.json()['choices'][0]['message']['content']}
        os
import traceback
from fastapi import FastAPI
from pydantic import BaseModel
import httpx

app = FastAPI(title="Jarvis God-Mode OS")

# चाबियां
GROQ_API_KEY = os.getenv("Jarvis_Logic", "") 
OPENROUTER_API_KEY = os.getenv("Jarvis_Unbound", "")

class JarvisRequest(BaseModel):
    message: str
    power_level: str = "extreme"

async def ask_groq(prompt):
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "https://api.groq.com/openai/v1/chat/completions",
            headers={"Authorization": f"Bearer {GROQ_API_KEY}"},
            json={
                "model": "llama3-70b-8192",
                "messages": [{"role": "user", "content": f"Generate full Flutter code for: {prompt}"}]
            },
            timeout=60.0
        )
        if response.status_code == 200:
            return response.json()['choices'][0]['message']['content']
    return None

@app.post("/jarvis-god-mode")
async def jarvis_brain(request_data: JarvisRequest):
    user_prompt = request_data.message.lower()
    
    # 1. पहले OpenRouter ट्राई करो
    if OPENROUTER_API_KEY:
        async with httpx.AsyncClient() as client:
            try:
                ai_response = await client.post(
                    "https://openrouter.ai/api/v1/chat/completions",
                    headers={"Authorization": f"Bearer {OPENROUTER_API_KEY}"},
                    json={
                        "model": "meta-llama/llama-3-8b-instruct",
                        "messages": [{"role": "user", "content": f"Generate Flutter code for: {user_prompt}"}]
                    },
                    timeout=30.0
                )
                if ai_response.status_code == 200:
                    return {"status": "success", "output": ai_response.json()['choices'][0]['message']['content']}
            except:
                pass # ओपन राउटर फेल हुआ तो चुपचाप नीचे जाओ

    # 2. अगर OpenRouter फेल हुआ या क्रेडिट नहीं है, तो ऑटोमैटिक Groq पर स्विच करो
    groq_output = await ask_groq(user_prompt)
    if groq_output:
        return {"status": "success", "output": groq_output}
    
    return {"status": "error", "output": "दोनों AI सर्विस डाउन हैं। कृपया चाबियां चेक करें।"}
    
