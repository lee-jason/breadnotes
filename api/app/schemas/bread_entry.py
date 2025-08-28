from pydantic import BaseModel
from typing import Optional
from datetime import datetime
import uuid

class BreadEntryCreate(BaseModel):
    title: str
    notes: Optional[str] = None

class BreadEntryResponse(BaseModel):
    id: uuid.UUID
    title: str
    notes: Optional[str] = None
    image_url: Optional[str] = None
    user_id: uuid.UUID
    created_at: datetime
    updated_at: Optional[datetime] = None
    user: "UserResponse"

    class Config:
        from_attributes = True

from .user import UserResponse
BreadEntryResponse.model_rebuild()