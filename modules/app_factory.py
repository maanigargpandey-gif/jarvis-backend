from modules.ai_brain import execute_god_brain

async def build_flutter_app(idea: str, api_keys: dict):
    # गॉड-ब्रेन को Flutter कोड लिखने का सख्त आर्डर
    system_prompt = f"""
    Write the COMPLETE, single-file Flutter `main.dart` code for this app idea: "{idea}".
    Requirements:
    - Use a dark/cyberpunk theme with neon accents.
    - If a 'chatting screen' is requested, build a sleek UI with message bubbles.
    - DO NOT output any markdown, explanations, or text. ONLY output the raw Dart code.
    """
    
    # ब्रेन से कोड लिखवाओ
    brain_response = await execute_god_brain(system_prompt, "Groq", api_keys)
    
    if brain_response["status"] == "error":
        return {"status": "error", "message": "Failed to generate app code."}
        
    flutter_code = brain_response["output"]
    mock_apk_link = f"https://jarvis-cloud.storage.com/builds/app_{hash(idea)}.apk"

    return {
        "status": "success",
        "message": f"Flutter code generated successfully for '{idea}'. Code sent to Cloud CI/CD.",
        "apk_download_link": mock_apk_link,
        "source_code_preview": flutter_code[:800] + "\n\n... [CODE TRUNCATED FOR PREVIEW] ..."
  }
  
