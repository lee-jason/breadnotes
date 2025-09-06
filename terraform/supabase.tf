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
resource "aws_ssm_parameter" "supabase_url" {
  name        = "BREADNOTES_DB_HOST"
  type        = "SecureString"
  value       = "PLACEHOLDER"
  description = "Supabase database URL for BreadNotes"
  
  tags = local.common_tags
}

# resource "aws_ssm_parameter" "supabase_anon_key" {
#   name        = "BREADNOTES_SUPABASE_ANON_KEY"
#   type        = "SecureString"
#   value       = supabase_project.breadnotes.anon_key
#   description = "Supabase anonymous key for BreadNotes"
  
#   tags = local.common_tags
# }

# resource "aws_ssm_parameter" "supabase_service_role_key" {
#   name        = "BREADNOTES_SUPABASE_SERVICE_ROLE_KEY"
#   type        = "SecureString"
#   value       = supabase_project.breadnotes.service_role_key
#   description = "Supabase service role key for BreadNotes"
  
#   tags = local.common_tags
# }

# # Configure project settings (optional)
# resource "supabase_settings" "breadnotes" {
#   project_ref = supabase_project.breadnotes.id
  
#   api = {
#     db_schema            = "public"
#     db_extra_search_path = "public"
#     max_rows             = 1000
#   }
  
#   auth = {
#     enable_signup         = true
#     enable_confirmations  = true
#     enable_phone_auth     = false
#     enable_phone_confirmations = false
#   }
# }

# Outputs for reference
output "supabase_project_id" {
  description = "Supabase project ID"
  value       = supabase_project.breadnotes.id
  sensitive   = false
}
