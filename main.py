from fastapi import FastAPI, Depends, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from core.config import settings
from core.security import verify_creator

# इन फाइलों को हम आगे बनाएंगे (ये आपके पुराने PDF वाले इंजन्स हैं)
# from services.call_manager import CallManagerService
# from services.pinecone_service import PineconeMemory

@asynccontextmanager
async def lifespan(app: FastAPI):
    print(f"🚀 {settings.PROJECT_NAME} v{settings.VERSION} INITIALIZING...")
    print("🔒 GOD MODE SECURED FOR: Mani Pandey")
    
    # यहाँ आपके बैकग्राउंड टास्क स्टार्ट होंगे (जैसे कॉल्स सुनना और मेमोरी लोड करना)
    # await PineconeMemory.initialize()
    # await CallManagerService.start_listening()
    
    yield
    print("🛑 ZARVISH SHUTTING DOWN...")

app = FastAPI(title=settings.PROJECT_NAME, version=settings.VERSION, lifespan=lifespan)

# CORS Setup - ताकि Flutter App आसानी से कनेक्ट हो सके
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def system_status():
    return {
        "status": "Online",
        "system": "Zarvish 4.0",
        "creator": "Mani Pandey",
        "message": "Awaiting Command."
    }

# गॉड-मोड टेस्ट एंडपॉइंट
@app.get("/api/god-mode", dependencies=[Depends(verify_creator)])
async def god_mode_test():
    return {"message": "Welcome back, Creator. Root access granted."}

# आगे चलकर हम यहाँ सारे राउट्स (Chat, Media, Vault) को लिंक करेंगे
# app.include_router(chat.router, prefix="/api/chat", dependencies=[Depends(verify_creator)])
# app.include_router(media.router, prefix="/api/media", dependencies=[Depends(verify_creator)])
