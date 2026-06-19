import os
import shutil
from datetime import datetime

class NexusVault:
    def __init__(self, base_path="./nexus_vault_storage"):
        self.base_path = base_path
        self.categories = {
            "PDF": "PDF_Archives",
            "EXCEL": "Excel_Spreadsheets",
            "VIDEO": "Rendered_Videos",
            "IMAGE": "Photo_Studio",
            "NOTES": "Creator_Notes"
        }
        self._initialize_vault()

    def _initialize_vault(self):
        """वॉल्ट के सारे सिक्योर फोल्डर्स बनाना"""
        if not os.path.exists(self.base_path):
            os.makedirs(self.base_path)
        
        for folder in self.categories.values():
            folder_path = os.path.join(self.base_path, folder)
            if not os.path.exists(folder_path):
                os.makedirs(folder_path)

    def save_to_nexus(self, file_path: str, file_type: str, custom_name: str = None):
        """वन-टैप सेविंग फीचर: फाइल्स को सही जगह सेव करना"""
        if file_type not in self.categories:
            return {"status": "Error", "message": "Invalid File Type for Nexus Vault"}

        target_folder = os.path.join(self.base_path, self.categories[file_type])
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # नाम सेट करना
        if not custom_name:
            file_extension = file_path.split('.')[-1]
            custom_name = f"Jarvis_{file_type}_{timestamp}.{file_extension}"
            
        target_path = os.path.join(target_folder, custom_name)
        
        try:
            shutil.copy2(file_path, target_path)
            return {"status": "Success", "saved_at": target_path}
        except Exception as e:
            return {"status": "Failed", "error": str(e)}

    def add_creator_note(self, note_text: str):
        """क्रिएटर के नोट्स को वॉल्ट में सेव करना"""
        target_folder = os.path.join(self.base_path, self.categories["NOTES"])
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        file_path = os.path.join(target_folder, f"Note_{timestamp}.txt")
        
        with open(file_path, "w") as f:
            f.write(note_text)
        return {"status": "Note Saved Securely"}
      
