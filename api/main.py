import logging

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from mangum import Mangum
from starlette.middleware.sessions import SessionMiddleware

from app.core.config import settings
from app.core.database import get_db
from app.core.logging import logger
from app.models.bread_entry import BreadEntry
from app.routers import auth, bread_entries

app = FastAPI(
    title="BreadNotes API",
    description="A bread journaling application API",
    version="1.0.0",
)

app.add_middleware(SessionMiddleware, secret_key=settings.secret_key)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[settings.frontend_url, "http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/api")
app.include_router(bread_entries.router, prefix="/api")


@app.get("/api/health")
async def health_check():
    try:
        db = next(get_db())
        # Simple query to keep database connection active
        db.execute("SELECT 1").scalar()
        db.close()
        database_status = "connected"
    except Exception as e:
        logger.warning(f"Database ping failed: {str(e)}")
        database_status = "disconnected"

    return {"status": "healthy", "message": "BreadNotes API is running", "database": database_status}


@app.get("/")
async def root():
    logger.info(f"Root endpoint called - Environment: {settings.environment}")
    logger.info(f"Database host: {settings.db_host}")
    return {"message": "Welcome to BreadNotes API"}


handler = Mangum(app)

if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
