import os
import subprocess
from modules.config import Config

async def build_flutter_app(idea: str, api_keys: dict, platform: str = "android"):
    from modules.ai_brain import execute_llm_logic
    
    system_prompt = f"""Write the COMPLETE, single-file Flutter 'main.dart' code for this app idea: {idea}. 
    Requirements: 
    1. Dark Cyberpunk theme with neon accents.
    2. Secure Login Screen at startup.
    3. Role-Based Access UI: Distinct 'Creator/God-Mode' dashboard (with AI Chat, Media Tools, Document Forge) and a highly restricted 'Standard/Guest Mode' chat view.
    4. Single Creator Constraint: Include logic checking if the Creator role is active elsewhere, forcing secondary sessions into Guest Mode.
    DO NOT output any markdown, explanations, or text. ONLY output the raw Dart code."""
    
    brain_response = await execute_llm_logic(system_prompt, "Groq", api_keys)
    
    if brain_response.get("status") == "error":
        return {"status": "error", "message": f"AI Brain Error: {brain_response.get('message')}"}
        
    flutter_code = brain_response.get("output", "")
    
    try:
        os.makedirs("frontend/lib", exist_ok=True)
        with open("frontend/lib/main.dart", "w") as f:
            f.write(flutter_code)
            
        cmd = ["flutter", "build", "ipa" if platform == "ios" else "apk", "--release"]
        build_process = subprocess.run(cmd, cwd="frontend", capture_output=True, text=True)
        
        if build_process.returncode == 0:
            return {
                "status": "success",
                "message": "APK built successfully!",
                "delivery": {
                    "download_url": "/download-apk/app-release.apk"
                }
            }
        else:
            return {"status": "error", "message": f"Flutter Build failed: {build_process.stderr}"}
            
    except Exception as e:
        return {"status": "error", "message": str(e)}
        
