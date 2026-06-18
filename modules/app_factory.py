import os
import subprocess
import logging

logger = logging.getLogger(__name__)

async def build_flutter_app(idea: str, api_keys: dict, platform: str = "android"):
    from modules.ai_brain import execute_llm_logic
    
    system_prompt = f"""Write the COMPLETE, single-file Flutter 'main.dart' code for this app idea: {idea}. 
    Requirements: Use a dark/cyberpunk theme with neon accents. DO NOT output any markdown, explanations, or text. ONLY output the raw Dart code."""
    
    brain_response = await execute_llm_logic(system_prompt, "Groq", api_keys)
    
    if brain_response.get("status") == "error":
        return {"status": "error", "message": "Failed to generate app code"}
        
    flutter_code = brain_response["output"]
    
    try:
        os.makedirs("frontend/lib", exist_ok=True)
        with open("frontend/lib/main.dart", "w") as f:
            f.write(flutter_code)
            
        cmd = ["flutter", "build", "ipa" if platform == "ios" else "apk", "--release"]
        
        logger.info(f"Running build command: {cmd}")
        build_process = subprocess.run(cmd, cwd="frontend", capture_output=True, text=True)
        
        if build_process.returncode == 0:
            return {
                "status": "success",
                "message": "APK built successfully!",
                "delivery": {
                    "download_url": "/download-apk/app-release.apk",
                    "file_path": "frontend/build/app/outputs/flutter-apk/app-release.apk"
                }
            }
        else:
            return {"status": "error", "message": f"Build failed: {build_process.stderr}"}
            
    except Exception as e:
        return {"status": "error", "message": str(e)}
        
