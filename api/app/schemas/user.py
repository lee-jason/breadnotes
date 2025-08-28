from pydantic import BaseModel
from typing import Optional
from datetime import datetime
import uuid

class UserResponse(BaseModel):
    id: uuid.UUID
    email: str
    name: str
    profile_picture: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True