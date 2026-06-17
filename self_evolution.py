import httpx
from bs4 import BeautifulSoup
from memory import stage_change

async def read_chat_link(url: str) -> str:
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get(url, timeout=10.0)
            if response.status_code != 200:
                return f"Error fetching URL: Status {response.status_code}"
            
            # HTML में से फालतू कचरा साफ करके केवल काम का टेक्स्ट निकालना
            soup = BeautifulSoup(response.text, 'html.parser')
            for script in soup(["script", "style"]):
                script.decompose()
            return soup.get_text(separator=' ', strip=True)
    except Exception as e:
        return f"Failed to read link due to exception: {str(e)}"

def analyze_chat_gaps(chat_text: str, current_code: str) -> dict:
    detected_gaps = []
    proposed_code = ""
    
    # यहाँ एआई चैट का विश्लेषण करता है (उदाहरण स्वरूप म्यूजिक राउट चेकर)
    if "म्यूजिक" in chat_text or "music" in chat_text.lower():
        detected_gaps.append("Enhanced Music Streaming Engine")
        proposed_code = """
@app.post("/route-music-addon")
async def music_addon_route(data: dict):
    return {"status": "success", "message": "Playing high-fidelity streaming audio via autonomous engine"}
"""
    
    if not detected_gaps:
        detected_gaps.append("Dynamic Custom Feature")
        proposed_code = """
@app.post("/dynamic-custom-route")
async def dynamic_route(data: dict):
    return {"status": "success", "data": "Custom autonomous payload executed successfully"}
"""
        
    # कोड को सीधे फाइल में न लिखकर स्टेजिंग एरिया में सुरक्षित रखना (अनुमति कवच)
    stage_change("dynamic_upgrade", proposed_code)
    
    return {
        "gaps_found": detected_gaps,
        "summary": f"Found {len(detected_gaps)} new system upgrade features from chat log."
    }

def apply_staged_code(file_path: str, code_to_append: str):
    with open(file_path, "a") as f:
        f.write("\n" + code_to_append + "\n")
      
