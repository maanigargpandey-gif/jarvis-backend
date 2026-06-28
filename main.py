from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

# Core Config
from core.config import settings

# Importing all routes
from api.routes import chat, media, system, vault

@asynccontextmanager
async def lifespan(app: FastAPI):
    print(f"🚀 [GOD MODE INIT] {settings.PROJECT_NAME} v{settings.VERSION} STARTING...")
    print("🔒 IDENTITY LOCKED TO: Mani Pandey")
    # Yahan hum future me Pinecone ya Call manager ke background tasks start kar sakte hain
    yield
    print("🛑 ZARVISH SHUTTING DOWN...")

app = FastAPI(title=settings.PROJECT_NAME, version=settings.VERSION, lifespan=lifespan)

# CORS Middleware (Flutter App ke liye)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# API Routes ko app mein jodna
app.include_router(chat.router, prefix="/api/chat", tags=["AI Brain"])
app.include_router(media.router, prefix="/api/media", tags=["Creative Studio"])
app.include_router(system.router, prefix="/api/system", tags=["System V8 Engines"])
app.include_router(vault.router, prefix="/api/vault", tags=["Nexus Vault"])

@app.get("/")
async def root_status():
    return {
        "status": "Online",
        "system": "Zarvish 4.0 God-Mode",
        "creator": "Mani Pandey",
        "message": "Backend fully armed and operational."
    }
    
