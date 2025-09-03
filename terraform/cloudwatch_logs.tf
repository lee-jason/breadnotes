# Set retention policy for App Runner logs
resource "aws_cloudwatch_log_group" "apprunner_logs" {
  name              = "/aws/apprunner/${local.name_prefix}-api/application"
  retention_in_days = 7  # Keep logs for 7 days only
  
  tags = local.common_tags
}

# Set retention for App Runner service logs  
resource "aws_cloudwatch_log_group" "apprunner_service_logs" {
  name              = "/aws/apprunner/${local.name_prefix}-api/service"
  retention_in_days = 7  # Keep logs for 7 days only
  
  tags = local.common_tags
}