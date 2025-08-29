# S3 Bucket for Images (Production)
resource "aws_s3_bucket" "images" {
  bucket = "${local.name_prefix}-prod-images"

  tags = local.common_tags
  force_destroy = true

}

# S3 Bucket for Images (Development)
resource "aws_s3_bucket" "dev_images" {
  bucket = "breadnotes-dev-images"

  tags = merge(local.common_tags, {
    Environment = "dev"
  })
  force_destroy = true

}

# S3 Bucket Versioning (Production)
resource "aws_s3_bucket_versioning" "images" {
  bucket = aws_s3_bucket.images.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Versioning (Development)
resource "aws_s3_bucket_versioning" "dev_images" {
  bucket = aws_s3_bucket.dev_images.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Server Side Encryption (Production)
resource "aws_s3_bucket_server_side_encryption_configuration" "images" {
  bucket = aws_s3_bucket.images.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket Server Side Encryption (Development)
resource "aws_s3_bucket_server_side_encryption_configuration" "dev_images" {
  bucket = aws_s3_bucket.dev_images.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket Public Access Block (Production)
resource "aws_s3_bucket_public_access_block" "images" {
  bucket = aws_s3_bucket.images.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 Bucket Public Access Block (Development)
resource "aws_s3_bucket_public_access_block" "dev_images" {
  bucket = aws_s3_bucket.dev_images.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 Bucket Policy for CloudFront (Production)
resource "aws_s3_bucket_policy" "images" {
  bucket = aws_s3_bucket.images.id

  policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = aws_cloudfront_origin_access_identity.images.iam_arn
      }
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.images.arn}/*"
    }]
  })

  depends_on = [aws_s3_bucket_public_access_block.images]
}

# S3 Bucket Policy for Development (Public access for simplicity)
resource "aws_s3_bucket_policy" "dev_images" {
  bucket = aws_s3_bucket.dev_images.id

  policy = jsonencode({
    Statement = [{
      Sid    = "PublicReadGetObject"
      Effect = "Allow"
      Principal = "*"
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.dev_images.arn}/*"
    }]
  })

  depends_on = [aws_s3_bucket_public_access_block.dev_images]
}

# S3 Bucket for Frontend
resource "aws_s3_bucket" "frontend" {
  bucket = "${local.name_prefix}-prod-frontend"

  tags = local.common_tags
  force_destroy = true
}


# S3 Bucket Server Side Encryption for Frontend
resource "aws_s3_bucket_server_side_encryption_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket Public Access Block for Frontend
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 Bucket Policy for Frontend CloudFront
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = aws_cloudfront_origin_access_identity.frontend.iam_arn
      }
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.frontend.arn}/*"
    }]
  })

  depends_on = [aws_s3_bucket_public_access_block.frontend]
}