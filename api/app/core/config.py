import os
from typing import Optional

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    database_url: str = "sqlite:///./breadnotes.db"
    google_client_id: str = ""
    google_client_secret: str = ""
    secret_key: str = "dev-secret-key-change-in-production"
    aws_access_key_id: Optional[str] = None
    aws_secret_access_key: Optional[str] = None
    aws_region: str = "us-east-1"
    s3_bucket_name: str = "breadnotes-images"
    cloudfront_domain: Optional[str] = None
    frontend_url: str = "http://localhost:3000"

    class Config:
        env_file = ".env"


settings = Settings()
