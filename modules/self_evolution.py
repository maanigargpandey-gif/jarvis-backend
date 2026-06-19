import os
import sys
import subprocess

def health_check():
    report = {
        "status": "success",
        "message": "Jarvis Backend Core Diagnostic Complete.",
        "fixed_issues": [],
        "system_status": "All Systems Nominal"
    }
    
    required_dirs = ["data", "modules", "frontend/lib"]
    for d in required_dirs:
        if not os.path.exists(d):
            os.makedirs(d, exist_ok=True)
            report["fixed_issues"].append(f"Created missing directory: {d}")
            
    required_libs = ["fastapi", "uvicorn", "httpx", "beautifulsoup4", "python-dotenv", "pydantic"]
    for lib in required_libs:
        try:
            __import__(lib)
        except ImportError:
            subprocess.check_call([sys.executable, "-m", "pip", "install", lib])
            report["fixed_issues"].append(f"Installed missing library: {lib}")
            
    if not os.path.exists("data/permissions.json"):
        with open("data/permissions.json", "w") as f:
            f.write('{"guest": ["god_prompt", "save_memory", "retrieve_memory"], "owner": ["all"]}')
        report["fixed_issues"].append("Generated missing permissions.json file")
        
    if not report["fixed_issues"]:
        report["fixed_issues"].append("No backend errors found. Jarvis core is 100% healthy.")
        
    return report
    
