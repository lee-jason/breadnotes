import uuid
from typing import Optional

import boto3
from botocore.exceptions import ClientError
from fastapi import UploadFile

from ..core.config import settings

s3_client = (
    boto3.client(
        "s3",
        aws_access_key_id=settings.aws_access_key_id,
        aws_secret_access_key=settings.aws_secret_access_key,
        region_name=settings.aws_region,
    )
    if settings.aws_access_key_id and settings.aws_secret_access_key
    else None
)


async def upload_image(file: UploadFile, user_id: uuid.UUID) -> Optional[str]:
    if not s3_client:
        return None

    if not file.content_type or not file.content_type.startswith("image/"):
        raise ValueError("File must be an image")

    file_extension = file.filename.split(".")[-1] if "." in file.filename else "jpg"
    file_key = f"images/{user_id}/{uuid.uuid4()}.{file_extension}"

    try:
        file_content = await file.read()

        s3_client.put_object(
            Bucket=settings.s3_bucket_name,
            Key=file_key,
            Body=file_content,
            ContentType=file.content_type,
        )

        if settings.cloudfront_domain:
            return f"https://{settings.cloudfront_domain}/{file_key}"
        else:
            return f"https://{settings.s3_bucket_name}.s3.{settings.aws_region}.amazonaws.com/{file_key}"

    except ClientError as e:
        raise ValueError(f"Failed to upload image: {str(e)}")
    except Exception as e:
        raise ValueError(f"Unexpected error during upload: {str(e)}")
