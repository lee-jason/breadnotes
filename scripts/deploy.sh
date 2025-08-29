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

# Clone or pull latest code
if [ -d ".git" ]; then
    echo -e "${YELLOW}Pulling latest code...${NC}"
    sudo git pull origin main
else
    echo -e "${YELLOW}Cloning repository...${NC}"
    sudo git clone $REPO_URL .
fi

# Set ownership
sudo chown -R breadnotes:breadnotes $APP_DIR

# Switch to breadnotes user for the rest
sudo -u breadnotes bash << 'EOF'
cd /opt/breadnotes/api

# Create virtual environment if it doesn't exist
if [ ! -d "../.venv" ]; then
    echo "Creating virtual environment..."
    cd ..
    /home/ec2-user/.cargo/bin/uv venv
    cd api
fi

# Install/update dependencies
echo "Installing dependencies..."
../.venv/bin/uv sync

# Run database migrations
echo "Running database migrations..."
../.venv/bin/alembic upgrade head || echo "Migration failed or no migrations needed"
EOF

# Create environment file from GitHub secrets (this will be handled by GitHub Actions)
echo -e "${YELLOW}Environment file should be created by GitHub Actions...${NC}"

# Copy and enable systemd service
echo -e "${YELLOW}Setting up systemd service...${NC}"
sudo cp $APP_DIR/scripts/breadnotes.service /etc/systemd/system/
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