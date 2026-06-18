import httpx
from modules.app_factory import build_flutter_app
from modules.security_core import run_security_protocol

async def execute_llm_logic(prompt: str, provider: str, api_keys: dict):
    if provider == "Groq":
        try:
            async with httpx.AsyncClient() as client:
                response = await client.post(
                    "https://api.groq.com/openai/v1/chat/completions",
                    headers={"Authorization": f"Bearer {api_keys.get('Groq')}"},
                    json={
                        "model": "llama3-70b-8192",
                        "messages": [{"role": "user", "content": prompt}]
                    },
                    timeout=30.0
                )
                data = response.json()
                if "choices" in data:
                    return {"status": "success", "output": data["choices"][0]["message"]["content"]}
                return {"status": "error", "message": str(data)}
        except Exception as e:
            return {"status": "error", "message": f"Groq Failed: {str(e)}"}
    return {"status": "error", "message": "Unknown Provider"}

async def execute_god_brain(prompt: str, provider: str, api_keys: dict):
    prompt_lower = prompt.lower()
    
    # App Builder Route
    if any(keyword in prompt_lower for keyword in ["build", "create", "app", "ui"]):
        platform = "ios" if "ios" in prompt_lower else "android"
        return await build_flutter_app(prompt, api_keys, platform)
        
    # Security Route
    elif any(keyword in prompt_lower for keyword in ["login", "scan", "security"]):
        return await run_security_protocol(prompt, "owner", {})
        
    # Default LLM Route
    else:
        return await execute_llm_logic(prompt, provider, api_keys)
        
