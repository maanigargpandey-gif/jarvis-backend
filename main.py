import os
from fastapi import FastAPI
import httpx
from pydantic import BaseModel

app = FastAPI(title="Jarvis God-Mode Self-Evolving OS")

# 🧠 गॉड-मेमोरी: सिस्टम का दिमाग और चाबियाँ अब यहीं रहेंगी
system_state = {
    "api_keys": {"Groq": os.getenv("Jarvis_Logic", ""), "OpenRouter": os.getenv("Jarvis_Unbound", "")},
    "active_model": "llama3-70b-8192",
    "features": ["Chat", "Error-Overlay"],
    "directives": "You are Jarvis. Be efficient, fast, and strict."
}

class Command(BaseModel):
    action: str  # "update_key", "change_model", "add_feature", "execute_task"
    details: dict

@app.post("/god-mode")
async def god_mode(cmd: Command):
    global system_state
    
    # 1. चाबी अपडेट करना (System Evolution)
    if cmd.action == "update_key":
        system_state["api_keys"][cmd.details["provider"]] = cmd.details["key"]
        return {"status": "success", "message": f"{cmd.details['provider']} updated."}
    
    # 2. टास्क पूरा करना (Execution)
    if cmd.action == "execute_task":
        prompt = f"DIRECTIVE: {system_state['directives']}. FEATURES ENABLED: {system_state['features']}. TASK: {cmd.details['task']}"
        
        # Groq का इस्तेमाल (Default)
        async with httpx.AsyncClient() as client:
            try:
                response = await client.post(
                    "https://api.groq.com/openai/v1/chat/completions",
                    headers={"Authorization": f"Bearer {system_state['api_keys']['Groq']}"},
                    json={"model": system_state['active_model'], "messages": [{"role": "user", "content": prompt}]},
                    timeout=60.0
                )
                return {"status": "success", "output": response.json()['choices'][0]['message']['content']}
            except Exception as e:
                return {"status": "error", "message": str(e)}

    return {"status": "error", "message": "Unknown command."}
    
