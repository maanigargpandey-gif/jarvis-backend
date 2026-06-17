import os
from fastapi import Header, HTTPException, Depends
from dotenv import load_dotenv

load_dotenv()

# अगर .env में पिन न मिले, तो डिफ़ॉल्ट '1234' काम करेगा
VALID_PIN = os.getenv("X_PIN", "1234")

def verify_pin(x_pin: str = Header(..., alias="x-pin")):
    if x_pin != VALID_PIN:
        raise HTTPException(status_code=401, detail="Invalid Security PIN")
    return x_pin
  
