import httpx
from modules.app_factory import build_flutter_app
from modules.security_core import run_security_protocol

# --- 1. पुराना ब्रेन का लॉजिक (अब इसे LLM Logic कहेंगे) ---
async def execute_llm_logic(prompt: str, provider: str, api_keys: dict):
    if provider == "Groq":
        try:
            async with httpx.AsyncClient() as client:
                response = await client.post(
                    "https://api.groq.com/openai/v1/chat/completions",
                    headers={"Authorization": f"Bearer {api_keys.get('Groq')}"},
                    json={
                        "model": "llama-3.3-70b-versatile",
                        "messages": [{"role": "user", "content": prompt}]
                    },
                    timeout=30.0
                )
                return {"status": "success", "output": response.json()['choices'][0]['message']['content']}
        except Exception:
            return await _fallback_to_uncensored(prompt, api_keys, "Groq Failed")
    
    return await _fallback_to_uncensored(prompt, api_keys, "Direct Fallback")

async def _fallback_to_uncensored(prompt: str, api_keys: dict, error_msg: str):
    hf_key = api_keys.get("HuggingFace_Uncensored", "")
    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                "https://api-inference.huggingface.co/models/mistralai/Mistral-7B-Instruct-v0.3",
                headers={"Authorization": f"Bearer {hf_key}"},
                json={"inputs": f"[INST] {prompt} [/INST]"}
            )
            return {"status": "fallback_engaged", "output": response.json()[0]['generated_text']}
    except Exception:
        return {"status": "error", "message": "All God-Nodes are currently offline."}

# --- 2. नया मास्टर राउटर (यह तय करेगा कि क्या करना है) ---
async def execute_god_brain(prompt: str, provider: str, api_keys: dict):
    prompt_lower = prompt.lower()
    
    # अगर यूजर ऐप बनाना चाहता है (App Factory)
    if any(keyword in prompt_lower for keyword in ["build", "create", "app", "ui", "android", "ios"]):
        platform = "ios" if "ios" in prompt_lower else "android"
        return await build_flutter_app(prompt, api_keys, platform)
    
    # अगर यूजर सिक्योरिटी चेक करना चाहता है (Security Core)
    elif any(keyword in prompt_lower for keyword in ["login", "scan", "security"]):
        return await run_security_protocol(prompt)
    
    # अगर सिर्फ बातचीत है, तो पुराने LLM लॉजिक को कॉल कर दो
    else:
        return await execute_llm_logic(prompt, provider, api_keys)
        
