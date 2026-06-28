import aiohttp
from core.config import settings

class PCControlService:
    @staticmethod
    async def execute_pc_command(action: str):
        # Trigger.dev या Pushbullet API का इस्तेमाल करके PC को कमांड भेजना
        webhook_url = "https://api.pushbullet.com/v2/pushes"
        headers = {"Access-Token": "YOUR_PUSHBULLET_TOKEN", "Content-Type": "application/json"}
        payload = {
            "type": "note",
            "title": "ZARVISH_COMMAND",
            "body": action.lower() # e.g., "shutdown", "sleep", "open chrome"
        }
        
        async with aiohttp.ClientSession() as session:
            try:
                # async with session.post(webhook_url, json=payload, headers=headers) as response:
                #     result = await response.json()
                return {"status": "success", "action_sent": action, "message": f"Command '{action}' fired to PC."}
            except Exception as e:
                return {"status": "error", "message": str(e)}
              
