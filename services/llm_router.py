import asyncio
import aiohttp
from typing import Dict, Any
from core.config import settings

class LLMRouter:
    def __init__(self):
        self.models = {
            "llama_405b": {
                "key": settings.LLAMA_405B_KEY,
                "url": "https://api.groq.com/openai/v1/chat/completions",
                "model": "llama-3.1-405b-reasoning"
            },
            "llama_70b": {
                "key": settings.LLAMA_70B_KEY,
                "url": "https://api.groq.com/openai/v1/chat/completions",
                "model": "llama-3.1-70b-versatile"
            },
            "qwen_72b": {
                "key": settings.QWEN_72B_KEY,
                "url": "https://api.together.xyz/v1/chat/completions",
                "model": "Qwen/Qwen2-72B-Instruct"
            },
            "gemini": {
                "key": settings.GEMINI_API_KEY,
                "url": "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"
            },
            "deepseek": {
                "key": settings.DEEPSEEK_API_KEY,
                "url": "https://api.deepseek.com/v1/chat/completions",
                "model": "deepseek-chat"
            }
        }
    
    async def route_query(self, query: str, task_type: str = "general") -> Dict[str, Any]:
        if task_type == "creative" or task_type == "social_media":
            model = "llama_405b"
        elif task_type == "code" or task_type == "math":
            model = "deepseek"
        elif task_type == "long_context":
            model = "gemini"
        elif task_type == "general":
            model = "llama_70b"
        else:
            model = "qwen_72b"
        return await self._call_llm(model, query)
    
    async def _call_llm(self, model_name: str, query: str) -> Dict[str, Any]:
        model_config = self.models.get(model_name)
        if not model_config:
            return {"response": "Model not available", "provider": "error", "status": "error"}
        
        try:
            async with aiohttp.ClientSession() as session:
                headers = {
                    "Authorization": f"Bearer {model_config['key']}",
                    "Content-Type": "application/json"
                }
                payload = {
                    "model": model_config["model"],
                    "messages": [{"role": "user", "content": query}],
                    "temperature": 0.7,
                    "max_tokens": 2000
                }
                async with session.post(model_config["url"], json=payload, headers=headers) as resp:
                    if resp.status == 200:
                        data = await resp.json()
                        response_text = self._parse_response(model_name, data)
                        return {
                            "response": response_text,
                            "provider": model_name,
                            "status": "success"
                        }
                    else:
                        return {
                            "response": f"API Error: {resp.status}",
                            "provider": model_name,
                            "status": "error"
                        }
        except Exception as e:
            return {
                "response": f"Connection error: {str(e)}",
                "provider": model_name,
                "status": "error"
            }
     q
    def _parse_response(self, model_name: str, data: Dict) -> str:
        try:
            if model_name in ["llama_405b", "llama_70b", "deepseek", "qwen_72b"]:
                return data.get("choices", [{}])[0].get("message", {}).get("content", "")
            elif model_name == "gemini":
                return data.get("candidates", [{}])[0].get("content", {}).get("parts", [{}])[0].get("text", "")
        except:
            pass
        return str(data)

llm_router = LLMRouter()
          
