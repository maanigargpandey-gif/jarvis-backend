import os
import subprocess
from modules.ai_brain import execute_god_brain

async def build_flutter_app(idea: str, api_keys: dict, platform: str = "android"):
    # 1. AI को प्रॉम्प्ट देना (आपका वाला लॉजिक सेम है)
    system_prompt = f"""
    Write the COMPLETE, single-file Flutter 'main.dart' code for this app idea: {idea}.
    Requirements:
    - Use a dark/cyberpunk theme with neon accents.
    - If a 'chatting screen' is requested, build a sleek UI with message bubbles.
    - DO NOT output any markdown, explanations, or text. ONLY output the raw Dart code.
    """
    
    brain_response = await execute_god_brain(system_prompt, "Groq", api_keys)

    if brain_response.get("status") == "error":
        return {"status": "error", "message": "Failed to generate app code"}

    flutter_code = brain_response["output"]

    # 2. अब यहाँ से असली काम शुरू होता है (File Writing & Building)
    try:
        # फोल्डर चेक करना
        os.makedirs("frontend/lib", exist_ok=True)
        
        # कोड को फाइल में लिखना
        with open("frontend/lib/main.dart", "w") as f:
            f.write(flutter_code)
            
        # 3. APK बिल्ड करना (यह आपके सिस्टम पर 'flutter' कमांड चलाएगा)
        # नोट: यह प्रोसेस में थोड़ा समय लेगा
                # 3. APK या IPA बिल्ड करना (प्लेटफॉर्म के हिसाब से)
        if platform == "ios":
            cmd = ["flutter", "build", "ipa", "--release"]
        else:
            cmd = ["flutter", "build", "apk", "--release"]
            
        build_process = subprocess.run(
            cmd, 
            cwd="frontend", 
            capture_output=True, 
            text=True
        )
        

        if build_process.returncode == 0:
            return {
                "status": "success",
                "message": "APK built successfully!",
                "apk_path": "frontend/build/app/outputs/flutter-apk/app-release.apk"
            }
        else:
            return {
                "status": "error",
                "message": f"Build failed: {build_process.stderr}"
            }

    except Exception as e:
        return {"status": "error", "message": str(e)}
        
