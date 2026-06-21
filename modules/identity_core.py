import os
import json
import asyncio
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="J.A.R.V.I.S Identity & Auth Engine", version="3.0.0")

# ====================================================================
# 🛡️ THE SUPREME CREATOR CREDENTIALS (HARDCODED SECURITY)
# ====================================================================
MASTER_EMAIL = "maanigargpandey@gmail.com"
MASTER_PHONE = "+918604141005"
MASTER_PIN = "1005@Mani"

# ====================================================================
# 💾 OLD IDENTITY CORE LOGIC (Preserved for Biometric/Profile saving)
# ====================================================================
class IdentityCore:
    def __init__(self, config_path="data/owner_profile.json"):
        self.config_path = config_path
        self.ensure_data_dir()

    def ensure_data_dir(self):
        if not os.path.exists("data"):
            os.makedirs("data")

    def register_owner(self, name, face_id, voice_print, pin):
        """पहली बार सेटअप के समय ओनर का डेटा सेव करना"""
        owner_data = {
            "name": name,
            "face_id": face_id,  # यहाँ तुम्हारा फेस एनक्रिप्शन होगा
            "voice_print": voice_print,
            "pin": pin,
            "status": "BOUND"
        }
        with open(self.config_path, "w") as f:
            json.dump(owner_data, f, indent=4)
        return True

    def get_owner(self):
        """सिस्टम ओनर की जानकारी वापस लाएगा"""
        if os.path.exists(self.config_path):
            with open(self.config_path, "r") as f:
                return json.load(f)
        return None

# यह चेक करेगा कि क्या ओनर पहले से सेट है
identity_manager = IdentityCore()

# ====================================================================
# 🚦 CORE AUTHENTICATION ROUTER (Google / WhatsApp / Mobile)
# ====================================================================
class LoginRequest(BaseModel):
    method: str     # 'google', 'whatsapp', 'mobile'
    auth_data: str  # Email या Phone Number
    pin: str = None # वेरिफिकेशन के लिए मास्टर पासवर्ड

@app.post("/auth/verify_identity")
async def verify_identity(request: LoginRequest):
    try:
        # डेटा क्लीनिंग (ताकि यूज़र गलती से स्पेस डाल दे तो भी मैच हो जाए)
        auth_data_clean = request.auth_data.replace(" ", "").strip()
        method = request.method.lower()

        is_creator = False

        # 1. क्रिएटर की पहचान (Google या Phone से)
        if method == "google" and auth_data_clean.lower() == MASTER_EMAIL.lower():
            is_creator = True
        elif method in ["whatsapp", "mobile"] and auth_data_clean == MASTER_PHONE:
            is_creator = True

        # 2. अगर क्रिएटर पहचाना गया, तो मास्टर पिन चेक करो
        if is_creator:
            if request.pin == MASTER_PIN:
                print("[SECURITY CLEARANCE] Supreme Creator 'Mani' has entered the Nexus.")
                return {
                    "status": "success",
                    "user": "Mani",
                    "role": "Creator",
                    "clearance": "God-Mode",
                    "message": "Welcome back, Master. All God-Mode systems are online."
                }
            else:
                print("[SECURITY ALERT] Creator recognized, but invalid PIN attempt.")
                return {
                    "status": "pending_pin",
                    "role": "Locked",
                    "message": "Creator Identity Confirmed. Please enter the Master PIN ('1005@Mani') to proceed."
                }
        
        # 3. अगर कोई और इंसान लॉगिन करता है (Guest Protocol)
        else:
            print(f"[SYSTEM LOG] Unrecognized user logged in via {method}: {auth_data_clean}")
            return {
                "status": "success",
                "user": "Guest",
                "role": "Guest",
                "clearance": "Restricted Sandbox",
                "message": "Identity registered as Guest. Advanced features are locked."
            }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Core Security Engine Error: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8010)
    
