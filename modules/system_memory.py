import time

# 🧠 सिस्टम का डेटाबेस (अस्थायी मेमोरी)
memory_vault = {
    "owner": [],
    "creator": [],
    "guest": []
}

async def manage_memory(action: str, role: str, data: str = None):
    current_time = time.time()
    
    # 1. डेटा सेव करना
    if action == "save":
        entry = {"timestamp": current_time, "data": data}
        memory_vault[role].append(entry)
        
        duration = "UNLIMITED" if role in ["owner", "creator"] else "24 HOURS"
        return {"status": "success", "message": f"Memory saved securely. Retention: {duration}"}

    # 2. डेटा वापस निकालना और गेस्ट की मेमोरी साफ करना
    elif action == "retrieve":
        # ऑटो-क्लीनअप: गेस्ट की 24 घंटे (86400 सेकंड) से पुरानी बातें डिलीट कर दो
        valid_guest_memories = [
            mem for mem in memory_vault["guest"] 
            if (current_time - mem["timestamp"]) < 86400
        ]
        memory_vault["guest"] = valid_guest_memories

        return {
            "status": "success",
            "role": role.upper(),
            "active_memories": [mem["data"] for mem in memory_vault[role]]
        }
        
    return {"status": "error", "message": "Unknown memory action."}
  
