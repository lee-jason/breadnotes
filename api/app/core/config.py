import os
from typing import Optional

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    # Database component parts
    db_host: str = "localhost"
    db_name: str = "breadnotes"
    db_user: str = "breadnotes"
    db_password: str = "breadnotes_dev"
    
    # Other settings
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

    @property
    def database_url(self) -> str:
        """Construct database URL from components"""
        return f"postgresql://{self.db_user}:{self.db_password}@{self.db_host}/{self.db_name}"


settings = Settings()
