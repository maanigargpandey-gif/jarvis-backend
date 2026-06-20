import os
import requests
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

# ----------------- J.A.R.V.I.S MASTER GATEWAY (API ROUTER) -----------------
app = FastAPI(title="J.A.R.V.I.S Master Gateway", version="5.0.0")

# --- MICROSERVICES INTERNAL URLS (लोकल पोर्ट्स) ---
# ये पोर्ट्स तुम्हारी बाकी फाइलों को कनेक्ट करते हैं
BRAIN_SERVICE_URL = "http://localhost:8000/process_command"
MEDIA_SERVICE_URL = "http://localhost:8001/create_studio_project"
SOCIAL_SERVICE_URL = "http://localhost:8002/auto_post_content"
EVOLUTION_SERVICE_URL = "http://localhost:8003/evolution_core"

# --- APP REQUEST MODEL ---
class AppRequest(BaseModel):
    command: str
    user_role: str          # 'owner', 'creator', 'guest'
    mfa_verified: bool      # 98% Voice Match Status
    attachments: list = []  # इमेजेस या फाइल्स (अगर हों)

# ----------------- ROUTING LOGIC (कमांड को सही जगह भेजना) -----------------

@app.post("/jarvis/gateway")
async def handle_incoming_request(request: AppRequest):
    try:
        command_lower = request.command.lower()
        print(f"[Gateway] Incoming Command from {request.user_role}: {request.command}")

        # 1. MEMORY STORAGE (हर कमांड सबसे पहले सेव होगा)
        requests.post(EVOLUTION_SERVICE_URL, json={
            "sender_role": request.user_role,
            "action": "log_memory",
            "data": request.command
        })

        # 2. MEDIA ROUTING (अगर वीडियो/फोटो बनानी है)
        if any(word in command_lower for word in ["video", "reel", "photo", "story"]):
            # ऐप से जो रेफरेंस इमेज आई है, उसे मीडिया स्टूडियो को पास करना
            ref_image = request.attachments[0] if request.attachments else "default_face.jpg"
            media_response = requests.post(MEDIA_SERVICE_URL, json={
                "script": request.command,
                "reference_image_url": ref_image,
                "creator_mode": request.user_role == "creator"
            })
            return media_response.json()

        # 3. SOCIAL AUTOMATION ROUTING (अगर पोस्ट करना है)
        elif any(word in command_lower for word in ["post", "upload", "share on"]):
            # बाय-डिफ़ॉल्ट इंस्टाग्राम और व्हाट्सएप पर भेजने का लॉजिक
            social_response = requests.post(SOCIAL_SERVICE_URL, json={
                "media_path": "latest_generated_video.mp4",
                "platforms": ["instagram", "whatsapp"],
                "custom_instructions": request.command
            })
            return social_response.json()

        # 4. DEFAULT ROUTING TO AI BRAIN (बाकी सभी लॉजिकल सवालों के लिए)
        else:
            brain_response = requests.post(BRAIN_SERVICE_URL, json={
                "command": request.command,
                "user_role": request.user_role,
                "mfa_verified": request.mfa_verified
            })
            return brain_response.json()

    except Exception as e:
        # अगर कोई भी सिस्टम डाउन हो तो मेन गेटवे ऐप को क्रैश नहीं होने देगा
        print(f"[Gateway Error] {str(e)}")
        raise HTTPException(status_code=500, detail="J.A.R.V.I.S Backend Error. Connection Failed.")

# ----------------- SERVER START -----------------
if __name__ == "__main__":
    import uvicorn
    # यह पोर्ट 8080 है, जिसे हम फ्लटर ऐप में डालेंगे
    print("J.A.R.V.I.S Master Gateway is ACTIVE on Port 8080...")
    # uvicorn main_gateway:app --host 0.0.0.0 --port 8080
  
