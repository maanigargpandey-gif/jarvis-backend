from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from core.config import settings
from api.routes import router as api_router
from memory import jarvis_memory

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="Backend API for Zarvish OS Frontend Binding"
)

# CORS Setup - Very Important for Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def health_check():
    return {
        "status": "Online", 
        "os": settings.PROJECT_NAME, 
        "creator": settings.CREATOR.name,
        "memory_status": jarvis_memory.db_status
    }

# Connect Routes
app.include_router(api_router, prefix=settings.API_V1_STR)

@app.on_event("startup")
async def startup_event():
    print("="*50)
    print(f"🚀 {settings.PROJECT_NAME} Booting Up...")
    print(f"👑 Root Creator Locked: {settings.CREATOR.name}")
    print("🌐 Multi-Agent Core (MoA) Online")
    print("="*50)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=7860, reload=True)
    
