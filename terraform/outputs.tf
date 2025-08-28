# API CloudFront URL
output "api_cloudfront_url" {
  description = "URL of the API CloudFront distribution"
  value       = "https://${aws_cloudfront_distribution.api.domain_name}"
}

# EC2 Instance Public IP
output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_eip.ec2.public_ip
}

# EC2 Instance DNS Name
output "ec2_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_eip.ec2.public_dns
}

# Frontend CloudFront URL
output "frontend_url" {
  description = "URL of the frontend CloudFront distribution"
  value       = "https://${aws_cloudfront_distribution.frontend.domain_name}"
}

# Images CloudFront URL
output "images_cloudfront_url" {
  description = "URL of the images CloudFront distribution"
  value       = "https://${aws_cloudfront_distribution.images.domain_name}"
}

# RDS Endpoint
output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}

# S3 Bucket Names
output "images_bucket_name" {
  description = "Name of the images S3 bucket"
  value       = aws_s3_bucket.images.bucket
}

output "dev_images_bucket_name" {
  description = "Name of the development images S3 bucket"
  value       = aws_s3_bucket.dev_images.bucket
}

output "frontend_bucket_name" {
  description = "Name of the frontend S3 bucket"
  value       = aws_s3_bucket.frontend.bucket
}