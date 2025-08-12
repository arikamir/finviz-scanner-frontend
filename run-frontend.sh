#!/bin/bash

# Frontend deployment script for Finviz Scanner
# Usage: ./run-frontend.sh [domain_name] [--standalone]

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Parse arguments
DOMAIN_NAME=""
STANDALONE_MODE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --standalone)
            STANDALONE_MODE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [domain_name] [--standalone]"
            echo ""
            echo "Options:"
            echo "  domain_name     Domain name for the frontend (default: localhost)"
            echo "  --standalone    Run in standalone mode (no backend required)"
            echo "  --help, -h      Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                                    # Run with localhost"
            echo "  $0 amir-trader.duckdns.org          # Run with custom domain"
            echo "  $0 --standalone                      # Run standalone mode"
            echo "  $0 example.com --standalone          # Run standalone with custom domain"
            exit 0
            ;;
        *)
            if [[ -z "$DOMAIN_NAME" ]]; then
                DOMAIN_NAME="$1"
            else
                echo -e "${RED}[ERROR]${NC} Unknown argument: $1"
                exit 1
            fi
            shift
            ;;
    esac
done

# Set default domain if not provided
DOMAIN_NAME="${DOMAIN_NAME:-${DOMAIN_NAME:-localhost}}"

echo -e "${GREEN}[INFO]${NC} Starting Finviz Scanner Frontend"
echo -e "${GREEN}[INFO]${NC} Domain: $DOMAIN_NAME"

if [[ "$STANDALONE_MODE" == true ]]; then
    echo -e "${YELLOW}[INFO]${NC} Running in STANDALONE mode (no backend required)"
else
    echo -e "${BLUE}[INFO]${NC} Running in FULL mode (requires backend service)"
fi

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
