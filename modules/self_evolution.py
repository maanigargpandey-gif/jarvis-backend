import os
import sys
import subprocess
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def health_check():
    logger.info("SYSTEM DIAGNOSTIC STARTING...")
    
    # डायरेक्टरी चेक (ताकि कोई फोल्डर मिसिंग न हो)
    required_dirs = ["data", "modules", "frontend/lib"]
    for d in required_dirs:
        if not os.path.exists(d):
            logger.warning(f"Creating missing directory: {d}")
            os.makedirs(d, exist_ok=True)
            
    # लाइब्रेरी डिपेंडेंसी चेक
    required_libs = ["fastapi", "uvicorn", "httpx", "beautifulsoup4", "python-dotenv", "pydantic"]
    for lib in required_libs:
        try:
            __import__(lib)
        except ImportError:
            logger.error(f"Missing Library: {lib}. Auto-repairing now...")
            subprocess.check_call([sys.executable, "-m", "pip", "install", lib])
            
    # परमिशन फाइल जनरेशन
    if not os.path.exists("data/permissions.json"):
        with open("data/permissions.json", "w") as f:
            f.write('{"guest": ["god_prompt", "save_memory", "retrieve_memory"], "owner": ["all"]}')
            
    logger.info("SYSTEM DIAGNOSTIC COMPLETE: ALL SYSTEMS NOMINAL.")
    
