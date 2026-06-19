import os
import logging

logger = logging.getLogger(__name__)

async def build_flutter_app(idea: str, api_keys: dict, platform: str = "android"):
    from modules.ai_brain import execute_llm_logic
    
    # 1. तुम्हारे सभी 6 कोर फीचर्स का मास्टर सिस्टम प्रॉम्प्ट (जो कभी मिस नहीं होगा)
    system_prompt = f"""Write the COMPLETE, single-file Flutter 'main.dart' code for this app idea: {idea}. 
    Requirements (STRICT): 
    1. UI Theme: Dark Cyberpunk aesthetic with neon green/cyan accents.
    2. Security: A secure Login & Authentication screen at startup.
    3. Role-Based Access Control (RBAC): Distinct 'Creator/God-Mode' dashboard and a highly restricted 'Standard/Guest Mode' view.
    4. Single Creator Constraint: Logic to check if the Creator role is active on another session/device, forcing any duplicate sessions into restricted Guest Mode automatically.
    5. Creator Features Dashboard: Must include UI hooks/tabs for AI Chat, Media Studio, Document Forge, App Builder, and System Settings.
    6. Standard User View: Only a basic, highly restricted chat interface with zero administrative tools.
    DO NOT output any markdown blocks (like ```dart), explanations, or notes. Output ONLY the raw, valid Dart/Flutter code."""
    
    # AI ब्रेन (Llama 3.3) से कोड जनरेट करवाना
    brain_response = await execute_llm_logic(system_prompt, "Groq", api_keys)
    
    if brain_response.get("status") == "error":
        return {"status": "error", "message": f"AI Brain Error: {brain_response.get('message')}"}
        
    flutter_code = brain_response.get("output", "")
    
    # 2. क्लीनिंग लॉजिक: अगर AI ने गलती से कोड ब्लॉक्स (```dart) लगा दिए हों, तो उन्हें हटाना
    if "```" in flutter_code:
        parts = flutter_code.split("```")
        if len(parts) > 1:
            flutter_code = parts[1]
            if flutter_code.startswith("dart"):
                flutter_code = flutter_code[4:]
    
    flutter_code = flutter_code.strip()
    
    try:
        # 3. पुराना फीचर वापस लॉक किया: लोकल डायरेक्टरी में main.dart फाइल को ऑटोमैटिकली सेव करना
        os.makedirs("frontend/lib", exist_ok=True)
        file_path = "frontend/lib/main.dart"
        with open(file_path, "w", encoding="utf-8") as f:
            f.write(flutter_code)
            
        logger.info(f"Successfully generated and wrote Flutter code to {file_path}")
        
        # 4. रिस्पॉन्स डिलीवरी: यह तुम्हें कन्फर्मेशन मैसेज भी देगा, फीचर्स की लिस्ट भी और कोड भी
        return {
            "status": "success",
            "message": "Jarvis has successfully generated the complete Flutter app code and saved it directly to frontend/lib/main.dart!",
            "features_secured": [
                "Dark Cyberpunk Theme Locked",
                "Secure Login System Locked",
                "Role-Based Access (Creator vs Guest) Locked",
                "Single Creator Session Restriction Locked",
                "God-Mode Dashboard Tools Locked",
                "Restricted Guest Chat Locked"
            ],
            "flutter_code": flutter_code
        }
            
    except Exception as e:
        logger.error(f"Failed to write main.dart file: {str(e)}")
        return {"status": "error", "message": f"File system error while saving code: {str(e)}"}
        
