# Create Parameter Store parameters with placeholders
resource "aws_ssm_parameter" "google_client_id" {
  name  = "BREADNOTES_GOOGLE_CLIENT_ID"
  type  = "SecureString"
  value = "CHANGEME_GOOGLE_CLIENT_ID"
  description = "Google OAuth client ID for BreadNotes"
  
  tags = local.common_tags
  
  lifecycle {
    ignore_changes = [value]  # Don't overwrite manual updates
  }
}

resource "aws_ssm_parameter" "google_client_secret" {
  name  = "BREADNOTES_GOOGLE_CLIENT_SECRET"
  type  = "SecureString"
  value = "CHANGEME_GOOGLE_CLIENT_SECRET"
  description = "Google OAuth client secret for BreadNotes"
  
  tags = local.common_tags
  
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "secret_key" {
  name  = "BREADNOTES_SECRET_KEY"
  type  = "SecureString"
  value = "CHANGEME_SECRET_KEY"
  description = "Application secret key for BreadNotes"
  
  tags = local.common_tags
  
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "aws_access_key_id" {
  name  = "BREADNOTES_AWS_ACCESS_KEY_ID"
  type  = "SecureString"
  value = "CHANGEME_AWS_ACCESS_KEY_ID"
  description = "AWS Access Key ID for BreadNotes S3 access"
  
  tags = local.common_tags
  
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "aws_secret_access_key" {
  name  = "BREADNOTES_AWS_SECRET_ACCESS_KEY"
  type  = "SecureString"
  value = "CHANGEME_AWS_SECRET_ACCESS_KEY"
  description = "AWS Secret Access Key for BreadNotes S3 access"
  
  tags = local.common_tags
  
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "frontend_url" {
  name  = "BREADNOTES_FRONTEND_URL"
  type  = "SecureString"
  value = "CHANGEME_FRONTEND_URL"
  description = "Frontend URL for CORS and OAuth redirects"
  
  tags = local.common_tags
  
  lifecycle {
    ignore_changes = [value]
  }
}