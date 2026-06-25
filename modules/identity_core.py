from core.config import settings

class CreatorLogic:
    def __init__(self):
        self.is_god_mode_active = True
        
    def verify_access(self, token: str) -> bool:
        # Matches the token with "1005@Maani"
        return token == settings.CREATOR.master_pass

identity = CreatorLogic()
