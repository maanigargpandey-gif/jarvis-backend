import httpx
from modules.config import Config
from modules.app_factory import build_flutter_app
from modules.security_core import run_security_protocol

async def execute_llm_logic(prompt: str, provider: str, api_keys: dict):
    groq_key = api_keys.get("Groq") or Config.get_key("Groq")
    if not groq_key:
        return {"status": "error", "message": "Groq API Key is MISSING! Please install or check Render Env."}

    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                "https://api.groq.com/openai/v1/chat/completions",
                headers={"Authorization": f"Bearer {groq_key}"},
                json={
                    "model": "llama-3.3-70b-versatile",
                    "messages": [{"role": "user", "content": prompt}]
                },
                timeout=120.0
            )
            
            if response.status_code != 200:
                return {"status": "error", "message": f"Groq API Error {response.status_code}: {response.text}"}
                
            data = response.json()
            if "choices" in data:
                return {"status": "success", "output": data["choices"][0]["message"]["content"]}
            return {"status": "error", "message": str(data)}
    except Exception as e:
        return {"status": "error", "message": f"Groq Connection Failed: {str(e)}"}

async def execute_god_brain(prompt: str, provider: str, api_keys: dict):
    prompt_lower = prompt.lower()
    
    if any(keyword in prompt_lower for keyword in ["build", "create", "app", "ui"]):
        platform = "ios" if "ios" in prompt_lower else "android"
        return await build_flutter_app(prompt, api_keys, platform)
        
    elif any(keyword in prompt_lower for keyword in ["login", "scan", "security"]):
        return await run_security_protocol(prompt, "owner", {})
        
    else:
        return await execute_llm_logic(prompt, provider, api_keys)
        
