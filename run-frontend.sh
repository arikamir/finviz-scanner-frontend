#!/bin/bash

# Frontend deployment script for Finviz Scanner
# Usage: ./run-frontend.sh [domain_name]

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Get domain name from argument or environment
DOMAIN_NAME="${1:-${DOMAIN_NAME:-localhost}}"

echo -e "${GREEN}[INFO]${NC} Starting Finviz Scanner Frontend"
echo -e "${GREEN}[INFO]${NC} Domain: $DOMAIN_NAME"

# Load environment variables if .env.prod exists
if [[ -f ".env.prod" ]]; then
    echo -e "${GREEN}[INFO]${NC} Loading environment from .env.prod"
    set -a
    source .env.prod
    set +a
    # Override domain if provided as argument
    export DOMAIN_NAME="${1:-${DOMAIN_NAME:-localhost}}"
fi

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}[ERROR]${NC} Docker is not running"
    exit 1
fi

# Build and run the container
echo -e "${GREEN}[INFO]${NC} Building frontend container..."

# Option 1: Using docker-compose (recommended)
if command -v docker-compose >/dev/null 2>&1; then
    echo -e "${GREEN}[INFO]${NC} Using docker-compose..."
    DOMAIN_NAME="$DOMAIN_NAME" docker-compose up --build -d
    
    echo -e "${GREEN}[SUCCESS]${NC} Frontend started successfully!"
    echo -e "${GREEN}[INFO]${NC} Frontend available at: http://$DOMAIN_NAME"
    
    # Show logs
    echo -e "${YELLOW}[INFO]${NC} Showing logs (press Ctrl+C to exit)..."
    docker-compose logs -f
else
    # Option 2: Using docker run directly
    echo -e "${GREEN}[INFO]${NC} Using docker run..."
    
    # Build the image
    docker build -f Dockerfile.frontend.prod -t finviz-scanner-frontend .
    
    # Stop existing container if running
    docker stop finviz-frontend 2>/dev/null || true
    docker rm finviz-frontend 2>/dev/null || true
    
    # Run the container
    docker run -d \
        --name finviz-frontend \
        -p 80:80 \
        -p 443:443 \
        -e DOMAIN_NAME="$DOMAIN_NAME" \
        --restart unless-stopped \
        finviz-scanner-frontend
    
    echo -e "${GREEN}[SUCCESS]${NC} Frontend started successfully!"
    echo -e "${GREEN}[INFO]${NC} Frontend available at: http://$DOMAIN_NAME"
    
    # Show logs
    echo -e "${YELLOW}[INFO]${NC} Showing logs (press Ctrl+C to exit)..."
    docker logs -f finviz-frontend
fi
