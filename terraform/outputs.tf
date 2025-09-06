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

# Certificate ARN
output "wildcard_certificate_arn" {
  description = "ARN of the wildcard SSL certificate"
  value       = aws_acm_certificate.wildcard.arn
}

# Custom domain URLs
output "api_custom_domain_url" {
  description = "Custom domain URL for the API"
  value       = "https://api.breadnotes.jasonjl.me"
}

output "frontend_custom_domain_url" {
  description = "Custom domain URL for the frontend"
  value       = "https://breadnotes.jasonjl.me"
}