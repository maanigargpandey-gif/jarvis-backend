import os
import sys
import subprocess
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def health_check():
    logger.info("SYSTEM DIAGNOSTIC STARTING...")
    report = {
        "status": "success",
        "message": "Jarvis Backend Core Diagnostic Complete.",
        "fixed_issues": [],
        "system_status": "All Systems Nominal"
    }
    
    # 1. डायरेक्टरी चेक
    required_dirs = ["data", "modules", "frontend/lib"]
    for d in required_dirs:
        if not os.path.exists(d):
            os.makedirs(d, exist_ok=True)
            report["fixed_issues"].append(f"Created missing directory: {d}")
            
    # 2. लाइब्रेरी चेक
    required_libs = ["fastapi", "uvicorn", "httpx", "beautifulsoup4", "python-dotenv", "pydantic"]
    for lib in required_libs:
        try:
            __import__(lib)
        except ImportError:
            subprocess.check_call([sys.executable, "-m", "pip", "install", lib])
            report["fixed_issues"].append(f"Installed missing library: {lib}")
            
    # 3. परमिशन फाइल चेक
    if not os.path.exists("data/permissions.json"):
        with open("data/permissions.json", "w") as f:
            f.write('{"guest": ["god_prompt", "save_memory", "retrieve_memory"], "owner": ["all"]}')
        report["fixed_issues"].append("Generated missing permissions.json file")
            
    # अगर कोई एरर नहीं मिला
    if not report["fixed_issues"]:
        report["fixed_issues"].append("No backend errors found. Jarvis core is 100% healthy.")
        
    return report
    
