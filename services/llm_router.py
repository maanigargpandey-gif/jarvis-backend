import re
from core.config import settings

class LLMRouter:
    def __init__(self):
        self.groq_key = settings.GROQ_API_KEY
        self.gemini_key = settings.GEMINI_API_KEY
    
    async def route_command(self, user_prompt: str, user_id: str):
        prompt_lower = user_prompt.lower()
        
        # 1. Phone Doctor Routing
        if any(word in prompt_lower for word in ["scan phone", "lag", "virus", "clean storage", "बैटरी", "फोन स्कैन"]):
            from services.phone_doctor_service import PhoneDoctor
            return await PhoneDoctor.scan_and_heal()
            
        # 2. Call Manager Routing
        elif any(word in prompt_lower for word in ["intercept call", "call record", "monitor call", "कॉल सुनो"]):
            from services.call_manager_service import CallManager
            return await CallManager.check_active_calls()
            
        # 3. Media Studio Routing
        elif any(word in prompt_lower for word in ["generate image", "make video", "photo", "फोटो बनाओ"]):
            from services.media_studio import MediaStudio
            return await MediaStudio.generate_media(user_prompt)
            
        # 4. PC / Webhook Routing
        elif any(word in prompt_lower for word in ["shutdown pc", "laptop", "मेरा पीसी"]):
            return {"status": "success", "message": "PC Webhook triggered. Executing command."}
            
        # 5. Default Chat (Groq / Gemini)
        else:
            return await self._standard_chat_response(user_prompt)

    async def _standard_chat_response(self, prompt: str):
        # यहाँ Groq/Llama-3 का लॉजिक चलेगा (Normal Chat)
        return {"status": "success", "message": f"Zarvish AI Processed: {prompt}"}

router = LLMRouter()
