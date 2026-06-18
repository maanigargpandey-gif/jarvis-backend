import time
import json
import os

# डेटा लोड करना
def load_memory():
    if os.path.exists("data/memory.json"):
        with open("data/memory.json", "r") as f:
            return json.load(f)
    return {"owner": [], "creator": [], "guest": []}

memory_vault = load_memory()

def save_memory():
    with open("data/memory.json", "w") as f:
        json.dump(memory_vault, f)

async def manage_memory(action: str, role: str, data: str = None):
    current_time = time.time()
    
    if action == "save":
        entry = {'timestamp': current_time, 'data': data}
        memory_vault[role].append(entry)
        save_memory() # डेटा सेव कर लिया!
        duration = "UNLIMITED" if role in ["owner", "creator"] else "24 HOURS"
        return {"status": "success", "message": f"Memory saved securely. Retention: {duration}"}

    elif action == "retrieve":
        # ऑटो-क्लीनअप (सिर्फ गेस्ट के लिए)
        valid_guest_memories = [
            mem for mem in memory_vault["guest"]
            if (current_time - mem['timestamp']) < 86400
        ]
        memory_vault["guest"] = valid_guest_memories
        save_memory() # क्लीनअप के बाद सेव
        
        return {
            "status": "success",
            "role": role.upper(),
            "active_memories": [mem['data'] for mem in memory_vault[role]]
        }
    return {"status": "error", "message": "Unknown memory action."}
    
