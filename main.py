from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from core.config import settings
from api.routes import router as api_router

# Initialize the God-Mode App
app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="Backend API for Zarvish OS Frontend Binding"
)

# CRITICAL FOR FLUTTER CONNECTION: Enable CORS so your mobile app can talk to the server
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific app domains
    allow_credentials=True,
    allow_methods=["*"],  # Allows GET, POST, PUT, DELETE etc.
    allow_headers=["*"],
)

# Include all the API endpoints from api/routes.py
app.include_router(api_router, prefix=settings.API_V1_STR)

# Print startup sequence to console
@app.on_event("startup")
async def startup_event():
    print("="*50)
    print(f"🚀 {settings.PROJECT_NAME} Booting Up...")
    print(f"👑 Root Creator Locked: {settings.CREATOR.name}")
    print(f"📧 Authorized Email: {settings.CREATOR.email}")
    print("🌐 Multi-Agent Core (MoA) Online")
    print("="*50)

if __name__ == "__main__":
    import uvicorn
    # This runs the server locally if you run 'python main.py'
    uvicorn.run("main:app", host="0.0.0.0", port=7860, reload=True)
    
