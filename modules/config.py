import os
from pydantic import BaseModel

class CreatorIdentity(BaseModel):
    name: str = "Mani Pandey"
    email: str = "maanigargpandey@gmail.com"
    phone: str = "86041 41005"
    master_pass: str = "1005@Maani"

class Settings:
    PROJECT_NAME: str = "Zarvish OS Backend"
    VERSION: str = "4.0.0"
    API_V1_STR: str = "/api/v1"
    
    # API Keys (Loaded from environment variables on Hugging Face)
    GEMINI_API_KEY: str = os.getenv("GEMINI_API_KEY", "dummy_gemini_key")
    DEEPSEEK_API_KEY: str = os.getenv("DEEPSEEK_API_KEY", "dummy_deepseek_key")
    OPENAI_API_KEY: str = os.getenv("OPENAI_API_KEY", "dummy_openai_key")
    
    CREATOR = CreatorIdentity()

settings = Settings()
