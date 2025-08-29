#!/bin/bash
# User data script for EC2 instance initialization

# Update system
yum update -y

# Install required packages
yum install -y git docker

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group
usermod -a -G docker ec2-user

# Create application directory
mkdir -p /opt/breadnotes
cd /opt/breadnotes

# Create breadnotes user
useradd -r -s /bin/false breadnotes
chown breadnotes:breadnotes /opt/breadnotes

# Install systemd service (placeholder - will be updated by deployment)
cat > /etc/systemd/system/breadnotes.service << 'EOF'
[Unit]
Description=BreadNotes FastAPI Application
After=network.target

[Service]
Type=exec
User=breadnotes
Group=breadnotes
WorkingDirectory=/opt/breadnotes/api
Environment=PATH=/opt/breadnotes/.venv/bin
ExecStart=/opt/breadnotes/.venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# Enable service (but don't start yet - will be started by deployment)
systemctl enable breadnotes

# Create log directory
mkdir -p /var/log/breadnotes
chown breadnotes:breadnotes /var/log/breadnotes

# Signal that user data script has completed
echo "User data script completed successfully" | logger -t breadnotes-setup