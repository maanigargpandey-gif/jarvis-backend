import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    GROQ_API_KEY = os.getenv("Jarvis_Logic")
    HF_API_KEY = os.getenv("HF_KEY")
    APK_DIR = "frontend/build/app/outputs/flutter-apk/"
  
