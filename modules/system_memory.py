import time, json, os

def manage_memory(action, role, details):
    # पुराना लॉजिक (Save/Retrieve) बरकरार है
    if action == "save":
        # ... (पुराना save लॉजिक यहाँ रखो)
        return {"status": "success", "message": "Memory saved."}
    
    # नया फीचर: कैलकुलेटर
    elif action == "calc":
        try:
            expr = details.get("expression")
            result = eval(expr) # सेफ इवैल्यूएशन के लिए यहाँ अपनी लॉजिक बढ़ा सकते हो
            return {"status": "success", "result": str(result)}
        except:
            return {"status": "error", "message": "Invalid calculation."}

    # नया फीचर: टाइमर
    elif action == "timer":
        duration = int(details.get("seconds", 0))
        # यहाँ बैकग्राउंड में टाइमर चलेगा
        return {"status": "success", "message": f"Timer set for {duration} seconds."}
    
    return {"status": "error", "message": "Action not found."}
