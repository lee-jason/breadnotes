import logging

from app.core.config import settings
from app.core.logging import logger
from app.routers import auth, bread_entries
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from mangum import Mangum
from starlette.middleware.sessions import SessionMiddleware

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
    return {"status": "healthy", "message": "BreadNotes API is running"}


@app.get("/")
async def root():
    logger.info(f"Root endpoint called - Environment: {settings.environment}")
    logger.info(f"Database host: {settings.db_host}")
    return {"message": "Welcome to BreadNotes API"}


@app.get("/debug/env")
async def debug_env():
    """Debug endpoint to check environment variables (remove after debugging)"""
    return {
        "environment": settings.environment,
        "db_host": settings.db_host,
        "google_client_id_set": settings.google_client_id,
        "google_client_secret_set": settings.google_client_secret[10:],
        "frontend_url": settings.frontend_url,
    }


handler = Mangum(app)

if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
