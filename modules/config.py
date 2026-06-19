import os
import json
from dotenv import load_dotenv

load_dotenv()

class Config:
    APK_DIR = "frontend/build/app/outputs/flutter-apk/"

    @staticmethod
    def get_key(provider: str) -> str:
        try:
            if os.path.exists("data/keys.json"):
                with open("data/keys.json", "r") as f:
                    keys = json.load(f)
                    if provider in keys and keys[provider]:
                        return keys[provider]
        except Exception:
            pass
            
        if provider == "Groq":
            return os.getenv("Jarvis_Logic", "")
        if provider == "HF":
            return os.getenv("HF_KEY", "")
        return ""

    @staticmethod
    def save_key(provider: str, api_key: str) -> bool:
        try:
            os.makedirs("data", exist_ok=True)
            keys = {}
            if os.path.exists("data/keys.json"):
                with open("data/keys.json", "r") as f:
                    keys = json.load(f)
            
            keys[provider] = api_key
            with open("data/keys.json", "w") as f:
                json.dump(keys, f, indent=4)
            return True
        except Exception:
            return False
            
