import os
from fastapi import FastAPI
import httpx
from pydantic import BaseModel

app = FastAPI(title="Jarvis Orchestrator OS")

# 🧠 सर्विस रजिस्ट्री (इसे तू कभी भी ऑडिट करके बदल सकता है)
service_registry = {
    "Groq": {"url": "https://api.groq.com/openai/v1/chat/completions", "active": True},
    "OpenRouter": {"url": "https://openrouter.ai/api/v1/chat/completions", "active": False},
    "HuggingFace": {"url": "https://api-inference.huggingface.co/models/meta-llama/Meta-Llama-3-8B-Instruct", "active": False}
}

system_state = {
    "api_keys": {"Groq": os.getenv("Jarvis_Logic", ""), "OpenRouter": os.getenv("Jarvis_Unbound", ""), "HuggingFace": os.getenv("HF_KEY", "")},
    "active_provider": "Groq"
}

class Command(BaseModel):
    action: str # "audit", "switch", "execute"
    details: dict

@app.post("/god-mode")
async def god_mode(cmd: Command):
    global system_state
    
    # 1. ऑडिट: ये खुद चेक करेगा कौन सा सर्वर जिंदा है
    if cmd.action == "audit":
        report = {}
        async with httpx.AsyncClient() as client:
            for name, config in service_registry.items():
                try:
                    # हल्का टेस्ट चेक (ping)
                    resp = await client.get(config["url"].split("/v1")[0], timeout=5.0)
                    report[name] = "Available" if resp.status_code < 400 else "Down/Restricted"
                except:
                    report[name] = "Failed to reach"
        return {"status": "Audit Complete", "report": report, "current_active": system_state["active_provider"]}

    # 2. स्विच: तू बोलेगा "HuggingFace लगाओ", ये लगा देगा
    if cmd.action == "switch":
        provider = cmd.details["provider"]
        if provider in service_registry:
            system_state["active_provider"] = provider
            return {"status": "success", "message": f"Switched to {provider}"}
        return {"status": "error", "message": "Provider not found"}

    # 3. एग्जीक्यूट: ये ऑटोमैटिकली एक्टिव प्रोवाइडर यूज़ करेगा
    if cmd.action == "execute":
        provider = system_state["active_provider"]
        key = system_state["api_keys"].get(provider)
        url = service_registry[provider]["url"]
        
        async with httpx.AsyncClient() as client:
            response = await client.post(url, headers={"Authorization": f"Bearer {key}"}, json={"model": "llama3-70b-8192", "messages": [{"role": "user", "content": cmd.details['task']}]}, timeout=60.0)
            return {"status": "success", "provider": provider, "output": response.json()}
            
