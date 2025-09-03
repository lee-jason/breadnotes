from app.core.logging import logger
from fastapi import APIRouter, Depends, HTTPException, Request
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session

from ..core.auth import create_or_update_user, get_current_user, oauth
from ..core.config import settings
from ..core.database import get_db

router = APIRouter(prefix="/auth", tags=["authentication"])


@router.get("/login")
async def login(request: Request):
    if not settings.google_client_id or not settings.google_client_secret:
        raise HTTPException(status_code=503, detail="OAuth not configured")

    redirect_uri = request.url_for("auth_callback")
    logger.info(f"Initial redirect URI: {redirect_uri}")
    if settings.environment == "production":
        redirect_uri = redirect_uri.replace("http://", "https://")
        logger.info(f"Production redirect URI: {redirect_uri}")
        redirect_uri = "https://api.breadnotes.jasonjl.me/api/auth/callback"
        logger.info(f"Overridden redirect URI: {redirect_uri}")
    return await oauth.google.authorize_redirect(request, redirect_uri)


@router.get("/callback")
async def auth_callback(request: Request, db: Session = Depends(get_db)):
    if not settings.google_client_id or not settings.google_client_secret:
        raise HTTPException(status_code=503, detail="OAuth not configured")

    try:
        token = await oauth.google.authorize_access_token(request)
        user_info = token.get("userinfo")

        if not user_info:
            user_info = await oauth.google.get(
                "https://www.googleapis.com/oauth2/v1/userinfo", token=token
            )
            user_info = user_info.json()

        user = create_or_update_user(db, user_info)
        request.session["user_id"] = str(user.id)

        return RedirectResponse(url=settings.frontend_url)

    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Authentication failed: {str(e)}")


@router.get("/logout")
async def logout(request: Request):
    request.session.clear()
    return RedirectResponse(url=settings.frontend_url)


@router.get("/me")
async def get_current_user_info(request: Request, db: Session = Depends(get_db)):
    user = get_current_user(request, db)
    if not user:
        raise HTTPException(status_code=401, detail="Not authenticated")

    return {
        "id": user.id,
        "email": user.email,
        "name": user.name,
        "profile_picture": user.profile_picture,
    }
