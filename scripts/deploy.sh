#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting BreadNotes deployment...${NC}"

# Configuration
APP_DIR="/opt/breadnotes"
SERVICE_NAME="breadnotes"
REPO_URL="https://github.com/lee-jason/breadnotes.git"  # Update with your actual repo URL

# Create application directory if it doesn't exist
sudo mkdir -p $APP_DIR
cd $APP_DIR

# Stop the service if running
echo -e "${YELLOW}Stopping service...${NC}"
sudo systemctl stop $SERVICE_NAME || true

# Load the Docker image
echo -e "${YELLOW}Loading Docker image...${NC}"
sudo docker load < /tmp/breadnotes-api.tar.gz

# Clean up any old containers
echo -e "${YELLOW}Cleaning up old containers...${NC}"
sudo docker stop breadnotes-api || true
sudo docker rm breadnotes-api || true

# Run database migrations using the Docker image
echo -e "${YELLOW}Running database migrations...${NC}"
sudo docker run --rm --env-file /opt/breadnotes/.env breadnotes-api alembic upgrade head || echo "Migration failed or no migrations needed"

# Create systemd service file directly
echo -e "${YELLOW}Setting up systemd service...${NC}"
sudo tee /etc/systemd/system/breadnotes.service > /dev/null << 'EOF'
[Unit]
Description=BreadNotes FastAPI Application
After=network.target docker.service
Requires=docker.service

[Service]
Type=exec
User=root
Group=docker
WorkingDirectory=/opt/breadnotes
EnvironmentFile=/opt/breadnotes/.env
ExecStartPre=/usr/bin/docker stop breadnotes-api || true
ExecStartPre=/usr/bin/docker rm breadnotes-api || true
ExecStart=/usr/bin/docker run --name breadnotes-api --rm --env-file /opt/breadnotes/.env -p 8000:8000 breadnotes-api
ExecStop=/usr/bin/docker stop breadnotes-api
Restart=always
RestartSec=3
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME

# Start the service
echo -e "${YELLOW}Starting service...${NC}"
sudo systemctl start $SERVICE_NAME

# Check service status
sleep 3
if sudo systemctl is-active --quiet $SERVICE_NAME; then
    echo -e "${GREEN}✓ Service is running successfully${NC}"
    
    # Health check
    echo -e "${YELLOW}Performing health check...${NC}"
    if curl -f http://localhost:8000/health > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Health check passed${NC}"
    else
        echo -e "${YELLOW}⚠ Health check endpoint not responding (this might be normal if /health doesn't exist)${NC}"
    fi
else
    echo -e "${RED}✗ Service failed to start${NC}"
    sudo systemctl status $SERVICE_NAME --no-pager -l
    exit 1
fi

echo -e "${GREEN}Deployment completed successfully!${NC}"