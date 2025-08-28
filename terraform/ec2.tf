# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "random_string" "keypair_suffix" {
  length  = 6
  special = false
  upper   = false
}

# Key Pair for EC2 access
resource "aws_key_pair" "main" {
  key_name   = "${local.name_prefix}-keypair-${random_string.keypair_suffix.result}"
  public_key = var.ec2_public_key

  tags = local.common_tags
}

# Elastic IP for EC2 instance
resource "aws_eip" "ec2" {
  domain = "vpc"
  
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-ec2-eip"
  })
}

# EC2 Instance
resource "aws_instance" "api_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"  # Free tier eligible
  key_name      = aws_key_pair.main.key_name

  vpc_security_group_ids = [aws_security_group.ec2.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  # User data script for initial setup
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    aws_region     = var.aws_region
    s3_bucket_name = aws_s3_bucket.dev_images.bucket
  }))

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-api-server"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Associate Elastic IP with EC2 instance
resource "aws_eip_association" "ec2" {
  instance_id   = aws_instance.api_server.id
  allocation_id = aws_eip.ec2.id
}