# RDS Subnet Group using default VPC subnets
resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db-subnet-group"
  })
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "main" {
  identifier = "${local.name_prefix}-postgres"

  # Database configuration
  engine         = "postgres"
  instance_class = "db.t3.micro"

  # Storage
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2"
  storage_encrypted     = true

  # Database details
  db_name  = "breadnotes"
  username = var.db_username
  password = var.db_password

  # Network
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  publicly_accessible    = true  # Using default VPC public subnets

  # Backup
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"

  # Deletion protection
  deletion_protection = false # Set to true for production
  skip_final_snapshot = true  # Set to false for production

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-postgres"
  })
}