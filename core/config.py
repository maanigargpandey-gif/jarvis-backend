import os
from pydantic_settings import BaseSettings
from typing import Optional

class Settings(BaseSettings):
    PROJECT_NAME: str = "Zarvish OS Backend"
    VERSION: str = "4.0.0"
    API_V1: str = "/api/v1"
    
    CREATOR_NAME: str = "Mani Pandey"
    CREATOR_EMAIL: str = "maanigargpandey@gmail.com"
    CREATOR_PHONE: str = "+918604141005"
    CREATOR_MASTER_PIN: str = "1005@Maani"
    ADMIN_TOKEN: str = "mani_jarvis_admin_786"
    
    LLAMA_405B_KEY: Optional[str] = os.getenv("LLAMA_405B_KEY", "")
    LLAMA_70B_KEY: Optional[str] = os.getenv("LLAMA_70B_KEY", "")
    QWEN_72B_KEY: Optional[str] = os.getenv("QWEN_72B_KEY", "")
    GEMINI_API_KEY: Optional[str] = os.getenv("GEMINI_API_KEY", "")
    DEEPSEEK_API_KEY: Optional[str] = os.getenv("DEEPSEEK_API_KEY", "")
    FLUX_API_KEY: Optional[str] = os.getenv("FLUX_API_KEY", "")
    REPLICATE_API_TOKEN: Optional[str] = os.getenv("REPLICATE_API_TOKEN", "")
    
    PINECONE_API_KEY: Optional[str] = os.getenv("PINECONE_API_KEY", "")
    PINECONE_ENVIRONMENT: str = os.getenv("PINECONE_ENVIRONMENT", "us-west1-gcp")
    PINECONE_INDEX_NAME: str = "zarvish-memory"
    
    SECRET_KEY: str = os.getenv("SECRET_KEY", "zarvish-ultra-secure-key-2024")
    ENCRYPTION_KEY: bytes = os.getenv("ENCRYPTION_KEY", "zarvish-aes-256-key-32bytes-here").encode().ljust(32)[:32]
    
    class Config:
        env_file = ".env"

settings = Settings()
