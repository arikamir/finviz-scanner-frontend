#!/bin/bash

# Finviz ATR Scanner - Docker Management Script
set -e

case "$1" in
    "build")
        echo "🐳 Building Docker images..."
        ./docker-build.sh
        ;;
    "up")
        echo "🚀 Starting Finviz ATR Scanner..."
        docker-compose up -d
        echo ""
        echo "✅ Application started!"
        echo "📊 Frontend: http://localhost"
        echo "🔌 API: http://localhost:8000"
        echo "📚 API Docs: http://localhost:8000/docs"
        ;;
    "down")
        echo "🛑 Stopping Finviz ATR Scanner..."
        docker-compose down
        echo "✅ Application stopped!"
        ;;
    "logs")
        echo "📋 Showing application logs..."
        docker-compose logs -f
        ;;
    "status")
        echo "📊 Application Status:"
        docker-compose ps
        ;;
    "restart")
        echo "🔄 Restarting Finviz ATR Scanner..."
        docker-compose restart
        echo "✅ Application restarted!"
        ;;
    "clean")
        echo "🧹 Cleaning up Docker resources..."
        docker-compose down -v
        docker image rm finviz-scanner-backend:latest finviz-scanner-frontend:latest 2>/dev/null || true
        echo "✅ Cleanup complete!"
        ;;
    *)
        echo "Finviz ATR Scanner - Docker Management"
        echo "======================================"
        echo ""
        echo "Usage: $0 {build|up|down|logs|status|restart|clean}"
        echo ""
        echo "Commands:"
        echo "  build     - Build Docker images"
        echo "  up        - Start the application"
        echo "  down      - Stop the application"
        echo "  logs      - View application logs"
        echo "  status    - Show container status"
        echo "  restart   - Restart the application"
        echo "  clean     - Stop and remove all containers/images"
        echo ""
        echo "Examples:"
        echo "  $0 build    # Build images"
        echo "  $0 up       # Start application"
        echo "  $0 logs     # View logs"
        echo "  $0 down     # Stop application"
        exit 1
        ;;
esac
