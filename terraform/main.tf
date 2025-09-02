terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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

variable "db_password" {
  description = "RDS password"
  type        = string
  sensitive   = true
}

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