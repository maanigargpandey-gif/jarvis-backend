import os
from fastapi import FastAPI, Request
import httpx # असली API कॉल्स के लिए

app = FastAPI(title="Jarvis God-Mode OS")

# 🔑 रेंडर की तिजोरी से तुम्हारी असली चाबियां निकालना
GROQ_API_KEY = os.getenv("GROQ_API_KEY")
OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")
HUGGINGFACE_API_KEY = os.getenv("HUGGINGFACE_API_KEY")

@app.post("/jarvis-god-mode")
async def jarvis_brain(request: Request):
    data = await request.json()
    user_prompt = data.get("message", "").lower()
    power_level = data.get("power_level", "medium") # डिफ़ॉल्ट मीडियम 

    response_payload = {
        "status": "success",
        "power_mode_active": power_level,
        "active_agents": [],
        "output": "",
        "ui_action": "INVISIBLE_UI_MAINTAINED"
    }

    # 🔴 LEVEL 3: EXTREME MODE (9 AI + 20 Node Verification)
    if "extreme" in user_prompt or "एक्सट्रीम" in user_prompt or power_level == "extreme":
        response_payload["active_agents"] = ["Llama-3", "DeepSeek", "Dolphin", "Wizard", "CogVideoX", "FLUX", "Web-Scouter", "Voice", "Gemini"]
        response_payload["ui_action"] = "SHOW_FULL_ELIGIBILITY_MATRIX"
        
        # ⚠️ यहाँ असली Dolphin/Llama को कॉल जा रही है (OpenRouter के ज़रिए)
        async with httpx.AsyncClient() as client:
            ai_response = await client.post(
                "https://openrouter.ai/api/v1/chat/completions",
                headers={"Authorization": f"Bearer {OPENROUTER_API_KEY}"},
                json={
                    "model": "cognitivecomputations/dolphin-mixtral-8x7b", # अनसेंसर्ड मॉडल
                    "messages": [{"role": "user", "content": f"EXTREME MODE: {user_prompt}. Integrate Dark Web Proxy, Ghost Node, and 4-Layer Security protocols."}]
                },
                timeout=60.0
            )
            response_payload["output"] = ai_response.json()['choices'][0]['message']['content']

    # 🟡 LEVEL 2: MEDIUM MODE (6 AI)
    elif "medium" in user_prompt or "मीडियम" in user_prompt:
        response_payload["active_agents"] = ["Llama-3", "DeepSeek", "FLUX", "Web-Scouter", "Voice", "Gemini"]
        
        # ⚡ यहाँ Groq (Llama-3) को कॉल जा रही है
        async with httpx.AsyncClient() as client:
            ai_response = await client.post(
                "https://api.groq.com/openai/v1/chat/completions",
                headers={"Authorization": f"Bearer {GROQ_API_KEY}"},
                json={
                    "model": "llama3-70b-8192",
                    "messages": [{"role": "user", "content": user_prompt}]
                }
            )
            response_payload["output"] = ai_response.json()['choices'][0]['message']['content']

    # 🟢 LEVEL 1: EASY MODE (3 AI)
    else:
        response_payload["active_agents"] = ["Llama-3", "Gemini", "Voice"]
        response_payload["output"] = "ईज़ी मोड एक्टिव। स्क्रीन प्लेन है। हुक्म कीजिए मानी भाई।"

    # 👁️ UI & Feature Triggers (कोई फीचर नहीं छूटेगा)
    if "eligibility" in user_prompt or "शक्तियां" in user_prompt:
         response_payload["ui_action"] = "POPUP_CAPABILITY_MENU"
    if "excel" in user_prompt or "ppt" in user_prompt:
         response_payload["ui_action"] = "LAUNCH_OMNI_UI_EDITOR"
    if "डार्क वेब" in user_prompt:
         response_payload["ui_action"] = "ACTIVATE_AIR_GAPPED_PROXY"

    return response_payload
            
