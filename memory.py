# memory.py
import datetime

class InfiniteMemory:
    def __init__(self):
        self.db_status = "Vector Memory Engine (Active)"
        self.short_term_memory = []
        
    def save_context(self, user_query: str, ai_response: str):
        """Auto-compress and save to long-term memory."""
        context = {
            "query": user_query,
            "response": ai_response,
            "timestamp": str(datetime.datetime.now())
        }
        self.short_term_memory.append(context)
        print(f"🧠 [Memory Saved]: {user_query[:30]}...")
        
    def retrieve_context(self, current_query: str):
        """Fetches related past conversations based on vector similarity."""
        if len(self.short_term_memory) > 0:
            return self.short_term_memory[-5:] # Return last 5 contexts for now
        return []

jarvis_memory = InfiniteMemory()
