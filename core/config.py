import os
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    # Core
    PROJECT_NAME: str = "Zarvish God-Mode OS"
    VERSION: str = "4.0.0"
    ENVIRONMENT: str = os.getenv("ENVIRONMENT", "production")
    
    # Creator Identity (Mani Pandey)
    GOD_MODE_PIN: str = os.getenv("GOD_MODE_PIN", "1005")
    CREATOR_EMAIL: str = os.getenv("CREATOR_EMAIL", "maanigargpandey@gmail.com")
    CREATOR_PHONE: str = os.getenv("CREATOR_PHONE", "9125121459")
    
    # API Keys (Multi-Agent Brains)
    GROQ_API_KEY: str = os.getenv("GROQ_API_KEY", "")
    GEMINI_API_KEY: str = os.getenv("GEMINI_API_KEY", "")
    DEEPSEEK_API_KEY: str = os.getenv("DEEPSEEK_API_KEY", "")
    PINECONE_API_KEY: str = os.getenv("PINECONE_API_KEY", "")
    
    # V8 Engines (Media & Call Manager)
    FLUX_API_KEY: str = os.getenv("FLUX_API_KEY", "")
    REPLICATE_API_TOKEN: str = os.getenv("REPLICATE_API_TOKEN", "")
    TWILIO_ACCOUNT_SID: str = os.getenv("TWILIO_ACCOUNT_SID", "")
    TWILIO_AUTH_TOKEN: str = os.getenv("TWILIO_AUTH_TOKEN", "")
    ENCRYPTION_KEY: str = os.getenv("ENCRYPTION_KEY", "")

    class Config:
        env_file = ".env"

settings = Settings()
