# ACM Certificate for *.jasonjl.me (must be in us-east-1 for CloudFront)
resource "aws_acm_certificate" "wildcard" {
  provider          = aws.us_east_1
  domain_name       = "jasonjl.me"
  validation_method = "DNS"

  subject_alternative_names = [
    "*.jasonjl.me",
    "*.breadnotes.jasonjl.me"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-wildcard-cert"
  })
}

# Output the DNS validation records that need to be created manually
output "certificate_validation_records" {
  description = "DNS records to create in your domain provider for certificate validation"
  value = {
    for dvo in aws_acm_certificate.wildcard.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      value  = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
}