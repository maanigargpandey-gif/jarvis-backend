from twilio.rest import Client
from core.config import settings

class CallManager:
    @staticmethod
    async def check_active_calls():
        try:
            if not settings.TWILIO_ACCOUNT_SID:
                return {"status": "warning", "message": "Twilio Credentials Missing in .env"}
                
            client = Client(settings.TWILIO_ACCOUNT_SID, settings.TWILIO_AUTH_TOKEN)
            
            # Fetching in-progress calls
            calls = client.calls.list(status='in-progress', limit=5)
            
            if not calls:
                return {"status": "success", "message": "No active calls detected at the moment."}
                
            active_list = [{"from": c.from_, "to": c.to} for c in calls]
            return {
                "status": "success", 
                "action": "monitoring",
                "active_calls": active_list,
                "message": f"Intercepting {len(active_list)} active calls."
            }
        except Exception as e:
            return {"status": "error", "message": f"Call Manager Error: {str(e)}"}
          
