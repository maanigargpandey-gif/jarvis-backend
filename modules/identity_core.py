import json
import os

class IdentityCore:
    def __init__(self, config_path="data/owner_profile.json"):
        self.config_path = config_path
        self.ensure_data_dir()

    def ensure_data_dir(self):
        if not os.path.exists("data"):
            os.makedirs("data")

    def register_owner(self, name, face_id, voice_print, pin):
        """पहली बार सेटअप के समय ओनर का डेटा सेव करना"""
        owner_data = {
            "name": name,
            "face_id": face_id,  # यहाँ तुम्हारा फेस एनक्रिप्शन होगा
            "voice_print": voice_print,
            "pin": pin,
            "status": "BOUND"
        }
        with open(self.config_path, "w") as f:
            json.dump(owner_data, f, indent=4)
        return True

    def get_owner(self):
        """सिस्टम ओनर की जानकारी वापस लाएगा"""
        if os.path.exists(self.config_path):
            with open(self.config_path, "r") as f:
                return json.load(f)
        return None

# यह चेक करेगा कि क्या ओनर पहले से सेट है
identity = IdentityCore()
