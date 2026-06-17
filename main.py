import os
from fastapi import FastAPI, Depends, Body, HTTPException
from auth import verify_pin
from memory import save_memory, get_memory, get_staged_changes, clear_staged_changes
from self_evolution import read_chat_link, analyze_chat_gaps, apply_staged_code

app = FastAPI(title="Jarvis Autonomous Backend Server")

@app.get("/")
async def root():
    return {"status": "online", "message": "Jarvis Brain is fully active and permanently live"}

# 13-रूट्स गेटकीपर मुख्य एंडपॉइंट
@app.post("/jarvis-input")
async def jarvis_gatekeeper(data: dict = Body(...), pin: str = Depends(verify_pin)):
    message = data.get("message", "")
    user_id = data.get("user_id", "mani_01")
    
    # इनपुट को याददाश्त में सेव करना
    save_memory(user_id, "last_input", message)
    
    # 13-रूट्स का कोर इंजन
    route_id = 0
    action = "General Conversation Mode"
    
    msg_lower = message.lower()
    if "म्यूजिक" in msg_lower or "music" in msg_lower:
        route_id = 10
        action = "Music Stream"
    elif "सर्च" in msg_lower or "search" in msg_lower:
        route_id = 5
        action = "Global Internet Search"
    elif "डेटा" in msg_lower or "data" in msg_lower:
        route_id = 8
        action = "Data Analysis Mode"
    
    return {
        "route_id": route_id,
        "action": action,
        "user_memory": get_memory(user_id),
        "status": "processed"
    }

# ऑटोमेशन स्टेप 1: लिंक का एनालिसिस करना
@app.post("/evolve/analyze")
async def evolve_analyze(payload: dict = Body(...), pin: str = Depends(verify_pin)):
    url = payload.get("url")
    if not url:
        raise HTTPException(status_code=400, detail="Missing link URL in request body")
        
    chat_content = await read_chat_link(url)
    
    with open("main.py", "r") as f:
        current_code = f.read()
        
    analysis_result = analyze_chat_gaps(chat_content, current_code)
    return {
        "status": "success",
        "summary": analysis_result["summary"],
        "gaps_detected": analysis_result["gaps_found"],
        "message": "Features staged into memory. Please call /evolve/approve with true to deploy."
    }

# ऑटोमेशन स्टेप 2: अनुमति कवच (यूजर का 'Yes' बटन)
@app.post("/evolve/approve")
async def evolve_approve(payload: dict = Body(...), pin: str = Depends(verify_pin)):
    approve = payload.get("approve", False)
    if not approve:
        return {"status": "cancelled", "message": "Evolution deployment rejected by user authorization."}
        
    staged = get_staged_changes()
    if not staged:
        raise HTTPException(status_code=404, detail="No pending staged modifications found in memory")
        
    # स्टेजिंग एरिया से कोड निकालकर मुख्य सर्वर फाइल में जोड़ना
    for feature, code_block in staged.items():
        apply_staged_code("main.py", code_block)
        
    clear_staged_changes()
    return {
        "status": "success",
        "message": "System successfully evolved! New custom endpoints are now live automatically."
    }
  
