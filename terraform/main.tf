terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    supabase = {
      source  = "supabase/supabase"
      version = "~> 1.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.21"
    }
  }

    
  backend "s3" {
    # Note: bucket name will be set via terraform init -backend-config
    key    = "breadnotes-terraform/terraform.tfstate"
    bucket = "terraform-state-jasonl"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# Supabase provider configuration
provider "supabase" {
  access_token = var.SUPABASE_ACCESS_TOKEN
}

# PostgreSQL provider for managing database objects
provider "postgresql" {
  host     = supabase_project.breadnotes.database_host
  port     = 5432
  database = "breadnotes"
  username = "breadnotes"
  password = random_password.supabase_db_password.result
}

# Provider for us-east-1 (required for ACM certificates used with CloudFront)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "breadnotes"
}

variable "db_username" {
  description = "RDS username"
  type        = string
  default     = "breadnotes"
}

variable "SUPABASE_ACCESS_TOKEN" {
  description = "Supabase access token"
  type        = string
  sensitive   = true
}

variable "SUPABASE_ORG_ID" {
  description = "Supabase organization ID"
  type        = string
}

# RDS password now auto-generated and stored in Parameter Store

# Sensitive variables moved to AWS Parameter Store
# Create these parameters manually or via terraform:
# - BREADNOTES_GOOGLE_CLIENT_ID
# - BREADNOTES_GOOGLE_CLIENT_SECRET  
# - BREADNOTES_SECRET_KEY
# - BREADNOTES_AWS_ACCESS_KEY_ID
# - BREADNOTES_AWS_SECRET_ACCESS_KEY
# - BREADNOTES_FRONTEND_URL

# Local values
locals {
  name_prefix = var.project_name
  common_tags = {
    Project   = var.project_name
    ManagedBy = "terraform"
  }
}