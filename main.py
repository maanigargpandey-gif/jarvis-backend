import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

# 🔌 तुम्हारे सातों हथियार (Modules) यहाँ मेन बोर्ड से जुड़ रहे हैं
from modules.ai_brain import execute_god_brain
from modules.app_factory import build_flutter_app
from modules.media_studio import generate_media
from modules.document_forge import create_document
from modules.social_vault import manage_social_task
from modules.security_core import run_security_protocol
from modules.system_memory import manage_memory
from modules.identity_core import identity
app = FastAPI(title="Jarvis God-Mode: The Ultimate OS")

# 🧠 THE VAULT (API Keys)
system_vault = {
    "api_keys": {
        "Groq": os.getenv("Jarvis_Logic", ""),
        "HuggingFace_Uncensored": os.getenv("HF_KEY", "free_mode_active")
    },
    "active_provider": "Groq"
}

class Command(BaseModel):
    action: str
    role: str
    details: dict

@app.post("/ultimate-jarvis")
async def ultimate_jarvis(cmd: Command):
    # 🚫 SECURITY GATE: गेस्ट को सिर्फ बेसिक चैट और अपनी 24 घंटे वाली मेमोरी की परमिशन है
    if cmd.role == "guest" and cmd.action not in ["god_prompt", "save_memory", "retrieve_memory"]:
        raise HTTPException(status_code=403, detail="ACCESS DENIED: Guest mode restricted.")

    # 🛡️ 1. SECURITY CORE (लॉगिन & डिवाइस स्कैन)
    if cmd.action in ["login", "system_scan"]:
        return await run_security_protocol(cmd.action, cmd.role, cmd.details)

    # 🧠 2. SYSTEM MEMORY (अनलिमिटेड vs 24 घंटे)
    if cmd.action in ["save_memory", "retrieve_memory"]:
        mem_action = "save" if cmd.action == "save_memory" else "retrieve"
        data = cmd.details.get("data")
        return await manage_memory(mem_action, cmd.role, data)

    # 🤖 3. AI BRAIN (अनसेंसर्ड नोड)
    if cmd.action == "god_prompt":
        prompt = cmd.details.get("task")
        return await execute_god_brain(prompt, system_vault["active_provider"], system_vault["api_keys"])

    # 🏭 4. APP FACTORY (APK और Flutter कोड)
    if cmd.action == "build_apk":
        app_idea = cmd.details.get("idea")
        return await build_flutter_app(app_idea, system_vault["api_keys"])

    # 🎬 5. MEDIA STUDIO (फेशियल कंसिस्टेंसी & रील्स)
    if cmd.action in ["create_image", "create_reel"]:
        media_type = "image" if cmd.action == "create_image" else "reel"
        return await generate_media(media_type, cmd.details, system_vault["api_keys"])

    # 📂 6. DOCUMENT FORGE (PDF & Forms)
    if cmd.action == "generate_doc":
        doc_type = cmd.details.get("type")
        return await create_document(doc_type, cmd.details)

    # 📱 7. SOCIAL VAULT (ऑटो-पोस्ट & पासवर्ड)
    if cmd.action in ["auto_post", "recover_password"]:
        platform = cmd.details.get("platform")
        return await manage_social_task(cmd.action, platform, cmd.details, system_vault)

    return {"status": "error", "message": "Command not recognized by Jarvis OS."}
    
