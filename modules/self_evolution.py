import os
import json
import datetime
import requests
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

# ----------------- J.A.R.V.I.S SELF-EVOLUTION & MEMORY ENGINE -----------------
app = FastAPI(title="J.A.R.V.I.S Evolution Core", version="4.0.0")

# --- MEMORY STORAGE (Local JSON for Testing/Scaling) ---
MEMORY_FILE = "data/memory_store.json"

class MemoryRequest(BaseModel):
    query_time: str = None  # जैसे "17:00" या "5:00 PM"
    sender_role: str        # 'owner', 'creator', 'guest'
    action: str             # 'query_memory', 'evolve_code'
    data: str = None        # नई कमांड या कोड

# --- MEMORY MANAGEMENT ---
def save_memory(role: str, message: str):
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    memory_entry = {"time": timestamp, "role": role, "message": message}
    
    # मेमोरी लॉक: गेस्ट की मेमोरी 24 घंटे बाद क्लियर करना
    if role == "guest":
        memory_entry["expiry"] = (datetime.datetime.now() + datetime.timedelta(hours=24)).isoformat()
    
    # डेटा स्टोर में Append करना
    if not os.path.exists("data"): os.makedirs("data")
    data = []
    if os.path.exists(MEMORY_FILE):
        with open(MEMORY_FILE, 'r') as f: data = json.load(f)
    data.append(memory_entry)
    with open(MEMORY_FILE, 'w') as f: json.dump(data, f)

def get_memory_at(target_time: str):
    """समय के आधार पर चैट्स रिकॉल करना"""
    if not os.path.exists(MEMORY_FILE): return "No memory found."
    with open(MEMORY_FILE, 'r') as f: data = json.load(f)
    
    # उस समय के आसपास की बातचीत ढूंढना
    for entry in data:
        if target_time in entry["time"]:
            return f"At {entry['time']}, you said: '{entry['message']}'"
    return "उस समय कोई बातचीत रिकॉर्ड नहीं हुई।"

# --- SELF-EVOLUTION (GITHUB INTEGRATION) ---
def evolve_system(new_code: str):
    """गिटहब रिपॉजिटरी में बदलाव करने के लिए ऑटो-इवोल्यूशन"""
    print("[Self-Evolution] गिटहब पर नया कोड इंजेक्ट किया जा रहा है...")
    # यहाँ गिटहब API के जरिए कोड कमिट होगा
    return "System evolved successfully."

# ----------------- MAIN API ENDPOINT -----------------

@app.post("/evolution_core")
async def evolution_core(request: MemoryRequest):
    # 1. टाइम-स्टैम्प्ड मेमोरी रिकॉल
    if request.action == "query_memory":
        return {"result": get_memory_at(request.query_time)}

    # 2. क्रिएटर-ओनली फीचर: सेल्फ-इवोल्यूशन
    if request.action == "evolve_code":
        if request.sender_role != "creator":
            raise HTTPException(status_code=403, detail="Only creator can evolve the brain.")
        return {"result": evolve_system(request.data)}

    # 3. मेमोरी में सब कुछ सेव करना (Real-time logging)
    save_memory(request.sender_role, request.data)
    return {"status": "memory_saved"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8003)
    
# --- THE BRIDGE FOR MAIN.PY ---
class EvolutionEngine:
    def health_check(self):
        return {
            "status": "success", 
            "message": "Evolution Engine is active and monitoring.", 
            "version": "J.A.R.V.I.S 2.0"
        }
        
