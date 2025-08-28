from typing import Optional

from authlib.integrations.starlette_client import OAuth, OAuthError
from sqlalchemy.orm import Session
from starlette.middleware.sessions import SessionMiddleware

from ..models.user import User
from .config import settings
from .database import get_db

oauth = OAuth()
oauth.register(
    name="google",
    client_id=settings.google_client_id,
    client_secret=settings.google_client_secret,
    server_metadata_url="https://accounts.google.com/.well-known/openid-configuration",
    client_kwargs={"scope": "openid email profile"},
)


def get_current_user(request, db: Session) -> Optional[User]:
    user_id = request.session.get("user_id")
    if not user_id:
        return None

    return db.query(User).filter(User.id == user_id).first()


def create_or_update_user(db: Session, google_user_info: dict) -> User:
    user = db.query(User).filter(User.google_id == google_user_info["sub"]).first()

    if user:
        user.email = google_user_info["email"]
        user.name = google_user_info["name"]
        user.profile_picture = google_user_info.get("picture")
    else:
        user = User(
            email=google_user_info["email"],
            name=google_user_info["name"],
            google_id=google_user_info["sub"],
            profile_picture=google_user_info.get("picture"),
        )
        db.add(user)

    db.commit()
    db.refresh(user)
    return user
