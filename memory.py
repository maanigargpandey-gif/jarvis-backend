import datetime

class InfiniteMemory:
    def __init__(self):
        self.db_status = "Vector Memory Engine (Active)"
        self.short_term_memory = []
        
    def save_context(self, user_query: str, ai_response: str):
        context = {
            "query": user_query,
            "response": ai_response,
            "timestamp": str(datetime.datetime.now())
        }
        self.short_term_memory.append(context)
        print(f"🧠 [Memory Saved]: {user_query[:30]}...")

jarvis_memory = InfiniteMemory()
