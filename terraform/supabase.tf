# Generate random password for Supabase database
resource "random_password" "supabase_db_password" {
  length   = 32
  special  = false
  upper    = true
  lower    = true
  numeric  = true
}

# Store Supabase database password in Parameter Store
resource "aws_ssm_parameter" "db_password"  {
  name        = "BREADNOTES_DB_PASSWORD"
  type        = "SecureString"
  value       = random_password.supabase_db_password.result
  description = "Database password for BreadNotes Supabase instance"
  
  tags = local.common_tags
}

# Create Supabase project
resource "supabase_project" "breadnotes" {
  organization_id   = var.SUPABASE_ORG_ID
  name             = "breadnotes"
  database_password = random_password.supabase_db_password.result
  region           = "us-east-1"
}

# Store Supabase project details in Parameter Store
resource "aws_ssm_parameter" "db_host" {
  name        = "BREADNOTES_DB_HOST"
  type        = "SecureString"
  value       = "PLACEHOLDER"
  description = "DB Host"
  
  tags = local.common_tags

  lifecycle {
    ignore_changes = [value]
  }
}

# Store Supabase project details in Parameter Store
resource "aws_ssm_parameter" "db_user" {
  name        = "BREADNOTES_DB_USER"
  type        = "SecureString"
  value       = "PLACEHOLDER"
  description = "DB User"

  tags = local.common_tags

  lifecycle {
    ignore_changes = [value]
  }
}

# Store Supabase project details in Parameter Store
resource "aws_ssm_parameter" "db_name" {
  name        = "BREADNOTES_DB_NAME"
  type        = "SecureString"
  value       = "PLACEHOLDER"
  description = "DB Name"

  tags = local.common_tags

  lifecycle {
    ignore_changes = [value]
  }
}