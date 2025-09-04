# Generate random password for Aurora
resource "random_password" "db_password" {
  length   = 32
  special  = false
  upper    = true
  lower    = true
  numeric  = true
}

# Store Aurora password in Parameter Store
resource "aws_ssm_parameter" "db_password" {
  name        = "BREADNOTES_DB_PASSWORD"
  type        = "SecureString"
  value       = random_password.db_password.result
  description = "Database password for BreadNotes Aurora instance"
  
  tags = local.common_tags
}

# Aurora Subnet Group using default VPC subnets
resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db-subnet-group"
  })
}

# Aurora Serverless v2 Cluster
resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "${local.name_prefix}-aurora-cluster"
  engine                 = "aurora-postgresql"
  engine_mode           = "provisioned"
  engine_version        = "15.4"
  
  # Database configuration
  database_name  = "breadnotes"
  master_username = var.db_username
  master_password = random_password.db_password.result
  
  # Network
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  
  # Serverless v2 scaling
  serverlessv2_scaling_configuration {
    max_capacity = 1.0    # 1 ACU max (very small)
    min_capacity = 0.5    # 0.5 ACU min (smallest possible)
    seconds_until_auto_pause = 300  # Auto-pause after 5 minutes of inactivity
  }
  
  # Security
  storage_encrypted = true
  
  # Cost optimization
  deletion_protection = true  # Set to true for production
  skip_final_snapshot = false  # Set to false for production
  final_snapshot_identifier = "${local.name_prefix}-aurora-final-snapshot"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-aurora-cluster"
  })
}

# Aurora Serverless v2 Instance
resource "aws_rds_cluster_instance" "aurora" {
  count              = 1
  identifier         = "${local.name_prefix}-aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.aurora.engine
  engine_version     = aws_rds_cluster.aurora.engine_version
  
  # Monitoring (optional - adds cost)
  monitoring_interval = 0  # Disable enhanced monitoring to save cost

  publicly_accessible = true

  tags = local.common_tags
}