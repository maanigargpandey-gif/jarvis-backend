import hashlib
import hmac
import time
from core.config import settings

class SecurityManager:
    @staticmethod
    def generate_signature(data: str, timestamp: int) -> str:
        message = f"{data}:{timestamp}:{settings.SECRET_KEY}"
        return hmac.new(
            settings.SECRET_KEY.encode(),
            message.encode(),
            hashlib.sha256
        ).hexdigest()
    
    @staticmethod
    def validate_signature(data: str, timestamp: int, signature: str) -> bool:
        expected = SecurityManager.generate_signature(data, timestamp)
        if abs(time.time() - timestamp) > 300:
            return False
        return hmac.compare_digest(expected, signature)
    
    @staticmethod
    def hash_sensitive_data(data: str) -> str:
        salt = settings.SECRET_KEY.encode()
        return hashlib.pbkdf2_hmac('sha256', data.encode(), salt, 100000).hex()
      
