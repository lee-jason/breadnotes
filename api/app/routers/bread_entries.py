from fastapi import APIRouter, Depends, HTTPException, Request, UploadFile, File, Form
from sqlalchemy.orm import Session
from typing import List, Optional
import uuid

from ..core.database import get_db
from ..core.auth import get_current_user
from ..models.bread_entry import BreadEntry
from ..schemas.bread_entry import BreadEntryCreate, BreadEntryResponse
from ..services.s3_service import upload_image

router = APIRouter(prefix="/bread-entries", tags=["bread-entries"])

@router.post("/", response_model=BreadEntryResponse)
async def create_bread_entry(
    title: str = Form(...),
    notes: Optional[str] = Form(None),
    image: Optional[UploadFile] = File(None),
    request: Request = None,
    db: Session = Depends(get_db)
):
    user = get_current_user(request, db)
    if not user:
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    image_url = None
    if image:
        image_url = await upload_image(image, user.id)
    
    bread_entry = BreadEntry(
        title=title,
        notes=notes,
        image_url=image_url,
        user_id=user.id
    )
    
    db.add(bread_entry)
    db.commit()
    db.refresh(bread_entry)
    
    return bread_entry

@router.get("/", response_model=List[BreadEntryResponse])
async def get_user_bread_entries(
    request: Request,
    db: Session = Depends(get_db),
    skip: int = 0,
    limit: int = 100
):
    user = get_current_user(request, db)
    if not user:
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    entries = db.query(BreadEntry).filter(
        BreadEntry.user_id == user.id
    ).offset(skip).limit(limit).all()
    
    return entries

@router.get("/recent", response_model=List[BreadEntryResponse])
async def get_recent_bread_entries(
    db: Session = Depends(get_db),
    limit: int = 10
):
    entries = db.query(BreadEntry).order_by(
        BreadEntry.created_at.desc()
    ).limit(limit).all()
    
    return entries

@router.get("/{entry_id}", response_model=BreadEntryResponse)
async def get_bread_entry(
    entry_id: uuid.UUID,
    request: Request,
    db: Session = Depends(get_db)
):
    user = get_current_user(request, db)
    if not user:
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    entry = db.query(BreadEntry).filter(
        BreadEntry.id == entry_id,
        BreadEntry.user_id == user.id
    ).first()
    
    if not entry:
        raise HTTPException(status_code=404, detail="Bread entry not found")
    
    return entry

@router.put("/{entry_id}", response_model=BreadEntryResponse)
async def update_bread_entry(
    entry_id: uuid.UUID,
    title: str = Form(...),
    notes: Optional[str] = Form(None),
    image: Optional[UploadFile] = File(None),
    request: Request = None,
    db: Session = Depends(get_db)
):
    user = get_current_user(request, db)
    if not user:
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    entry = db.query(BreadEntry).filter(
        BreadEntry.id == entry_id,
        BreadEntry.user_id == user.id
    ).first()
    
    if not entry:
        raise HTTPException(status_code=404, detail="Bread entry not found")
    
    entry.title = title
    entry.notes = notes
    
    if image:
        image_url = await upload_image(image, user.id)
        entry.image_url = image_url
    
    db.commit()
    db.refresh(entry)
    
    return entry

@router.delete("/{entry_id}")
async def delete_bread_entry(
    entry_id: uuid.UUID,
    request: Request,
    db: Session = Depends(get_db)
):
    user = get_current_user(request, db)
    if not user:
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    entry = db.query(BreadEntry).filter(
        BreadEntry.id == entry_id,
        BreadEntry.user_id == user.id
    ).first()
    
    if not entry:
        raise HTTPException(status_code=404, detail="Bread entry not found")
    
    db.delete(entry)
    db.commit()
    
    return {"message": "Bread entry deleted successfully"}