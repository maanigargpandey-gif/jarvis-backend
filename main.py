import os
from fastapi import FastAPI
import httpx
from pydantic import BaseModel

app = FastAPI(title="Jarvis God-Mode Robust OS")

system_state = {
    "api_keys": {"Groq": os.getenv("Jarvis_Logic", "")},
    "active_model": "llama3-70b-8192"
}

class Command(BaseModel):
    action: str
    details: dict

@app.post("/god-mode")
async def god_mode(cmd: Command):
    # 1. चाबी अपडेट करना
    if cmd.action == "update_key":
        system_state["api_keys"][cmd.details["provider"]] = cmd.details["key"]
        return {"status": "success", "message": f"{cmd.details['provider']} updated."}
    
    # 2. टास्क पूरा करना (बेहतर एरर हैंडलिंग के साथ)
    if cmd.action == "execute_task":
        async with httpx.AsyncClient() as client:
            try:
                response = await client.post(
                    "https://api.groq.com/openai/v1/chat/completions",
                    headers={"Authorization": f"Bearer {system_state['api_keys']['Groq']}"},
                    json={
                        "model": system_state['active_model'], 
                        "messages": [{"role": "user", "content": cmd.details['task']}]
                    },
                    timeout=60.0
                )
                
                resp_data = response.json()
                
                # यहाँ हमने चेक लगा दिया है: अगर 'choices' नहीं है, तो पूरा डेटा दिखाओ
                if "choices" in resp_data:
                    return {"status": "success", "output": resp_data['choices'][0]['message']['content']}
                else:
                    return {"status": "error", "raw_response": resp_data} # क्या गड़बड़ है, वो दिखाएगा

            except Exception as e:
                return {"status": "error", "message": str(e)}

    return {"status": "error", "message": "Unknown command."}

