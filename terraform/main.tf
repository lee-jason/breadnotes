terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
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



variable "ec2_public_key" {
  description = "Public key for EC2 SSH access"
  type        = string
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

variable "google_client_id" {
  description = "Google OAuth client ID"
  type        = string
}

variable "google_client_secret" {
  description = "Google OAuth client secret"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "Application secret key"
  type        = string
  sensitive   = true
}

# Local values
locals {
  name_prefix = var.project_name
  common_tags = {
    Project   = var.project_name
    ManagedBy = "terraform"
  }
}