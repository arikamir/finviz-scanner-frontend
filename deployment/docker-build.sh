#!/bin/bash

# Finviz ATR Scanner - Docker Build Script
set -e

echo "🐳 Building Finviz ATR Scanner Docker Images"
echo "============================================="

# Create logs directory
mkdir -p logs

echo "📦 Building backend image..."
docker build -f Dockerfile.backend -t finviz-scanner-backend:latest .

echo "📦 Building frontend image..."
docker build -f Dockerfile.frontend -t finviz-scanner-frontend:latest .

echo "✅ Docker images built successfully!"
echo ""
echo "To run the application:"
echo "  docker-compose up -d"
echo ""
echo "To view logs:"
echo "  docker-compose logs -f"
echo ""
echo "To stop the application:"
echo "  docker-compose down"
