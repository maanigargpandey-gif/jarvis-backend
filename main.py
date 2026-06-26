import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from core.config import settings
from api.routes import auth, chat, admin, social, vault, memory
from services.pinecone_service import PineconeService

@asynccontextmanager
async def lifespan(app: FastAPI):
    print("=" * 60)
    print(f"🚀 {settings.PROJECT_NAME} v{settings.VERSION} Booting...")
    print(f"👑 Root Creator: {settings.CREATOR_NAME}")
    print("🧠 Pinecone Memory: Initializing...")
    await PineconeService.initialize()
    print("✅ All Systems Online")
    print("=" * 60)
    yield
    await PineconeService.cleanup()

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="Enterprise AI Productivity Assistant Backend",
    lifespan=lifespan
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix=f"{settings.API_V1}/auth", tags=["Auth"])
app.include_router(chat.router, prefix=f"{settings.API_V1}/chat", tags=["Chat"])
app.include_router(admin.router, prefix=f"{settings.API_V1}/admin", tags=["Admin"])
app.include_router(social.router, prefix=f"{settings.API_V1}/social", tags=["Social"])
app.include_router(vault.router, prefix=f"{settings.API_V1}/vault", tags=["Vault"])
app.include_router(memory.router, prefix=f"{settings.API_V1}/memory", tags=["Memory"])

@app.get("/")
async def health_check():
    return {
        "status": "Online",
        "os": settings.PROJECT_NAME,
        "version": settings.VERSION,
        "creator": settings.CREATOR_NAME,
        "memory_status": await PineconeService.get_status()
    }

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=7860, reload=True)
  
