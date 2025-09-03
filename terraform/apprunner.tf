# IAM Role for App Runner to access ECR
resource "aws_iam_role" "apprunner_ecr_access" {
  name = "${local.name_prefix}-apprunner-ecr-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

# Attach ECR access policy to the role
resource "aws_iam_role_policy_attachment" "apprunner_ecr_access" {
  role       = aws_iam_role.apprunner_ecr_access.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

# IAM Role for App Runner service (application runtime)
resource "aws_iam_role" "apprunner_instance" {
  name = "${local.name_prefix}-apprunner-instance"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

# Policy for App Runner instance to access S3 and SSM parameters
resource "aws_iam_policy" "apprunner_instance" {
  name        = "${local.name_prefix}-apprunner-instance"
  description = "Policy for App Runner instance to access AWS services"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${aws_s3_bucket.images.arn}/*",
          "${aws_s3_bucket.dev_images.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.images.arn,
          aws_s3_bucket.dev_images.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = [
          "arn:aws:ssm:${var.aws_region}:*:parameter/BREADNOTES_*"
        ]
      }
    ]
  })

  tags = local.common_tags
}

# Attach the policy to the App Runner instance role
resource "aws_iam_role_policy_attachment" "apprunner_instance" {
  role       = aws_iam_role.apprunner_instance.name
  policy_arn = aws_iam_policy.apprunner_instance.arn
}

# Minimal Auto Scaling Configuration for cost control
resource "aws_apprunner_auto_scaling_configuration_version" "minor" {
  auto_scaling_configuration_name = "${local.name_prefix}-minor-scaling"
  
  # Minimize instances for cost control
  max_concurrency = 25    # Requests per instance (default: 100)
  max_size        = 1    # Maximum number of instances (default: 25)
  min_size        = 1    # Minimum number of instances (can scale to zero!)

  tags = local.common_tags
}

# App Runner Service
resource "aws_apprunner_service" "api" {
  service_name = "${local.name_prefix}-api"

  source_configuration {
    image_repository {
      image_identifier      = "${aws_ecr_repository.api.repository_url}:latest"
      image_configuration {
        port = "8000"
        
        runtime_environment_variables = {
          ENVIRONMENT = "production"
          AWS_REGION = var.aws_region
          S3_BUCKET_NAME = aws_s3_bucket.images.bucket
          CLOUDFRONT_DOMAIN = aws_cloudfront_distribution.images.domain_name
          DB_HOST = aws_rds_cluster.aurora.endpoint
          DB_NAME = "breadnotes"
          DB_USER = var.db_username
        }

        runtime_environment_secrets = {
          DB_PASSWORD = aws_ssm_parameter.db_password.name
          GOOGLE_CLIENT_ID = aws_ssm_parameter.google_client_id.name
          GOOGLE_CLIENT_SECRET = aws_ssm_parameter.google_client_secret.name
          SECRET_KEY = aws_ssm_parameter.secret_key.name
          AWS_ACCESS_KEY_ID = aws_ssm_parameter.aws_access_key_id.name
          AWS_SECRET_ACCESS_KEY = aws_ssm_parameter.aws_secret_access_key.name
          FRONTEND_URL = aws_ssm_parameter.frontend_url.name
        }
      }
      image_repository_type = "ECR"
    }

    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr_access.arn
    }
    
    auto_deployments_enabled  = false
  }

  instance_configuration {
    cpu               = "0.25 vCPU"
    memory            = "0.5 GB"
    instance_role_arn = aws_iam_role.apprunner_instance.arn
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.minor.arn

  health_check_configuration {
    healthy_threshold   = 1
    interval            = 20 
    path                = "/api/health"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 5
  }

  tags = local.common_tags
}

# Custom domain association for App Runner
resource "aws_apprunner_custom_domain_association" "api" {
  domain_name = "api.breadnotes.jasonjl.me"
  service_arn = aws_apprunner_service.api.arn
}
