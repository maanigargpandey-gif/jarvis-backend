from pydantic import BaseModel
from typing import Optional
from enum import Enum

class UserRole(str, Enum):
    GUEST = "guest"
    CREATOR = "creator"
    ADMIN = "admin"

class AccessLevel(str, Enum):
    RESTRICTED = "restricted"
    STANDARD = "standard"
    GOD_MODE = "god_mode"

class User(BaseModel):
    id: str
    role: UserRole
    access_level: AccessLevel
    email: Optional[str] = None
    phone: Optional[str] = None
    is_authenticated: bool = False
    mfa_completed: bool = False

class CreatorUser(User):
    role: UserRole = UserRole.CREATOR
    access_level: AccessLevel = AccessLevel.GOD_MODE
    name: str = "Mani Pandey"
  
