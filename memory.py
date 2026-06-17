# याददाश्त और नए कोड के बदलावों को अस्थायी रूप से सहेजने का डिब्बा
user_memory = {}
staged_code = {}

def save_memory(user_id: str, key: str, value: str):
    if user_id not in user_memory:
        user_memory[user_id] = {}
    user_memory[user_id][key] = value

def get_memory(user_id: str):
    return user_memory.get(user_id, {})

def stage_change(feature_name: str, code_content: str):
    staged_code[feature_name] = code_content

def get_staged_changes():
    return staged_code

def clear_staged_changes():
    staged_code.clear()
  
