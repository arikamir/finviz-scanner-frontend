# Finviz ATR Scanner - Docker Deployment

This directory contains Docker configurations for running the Finviz ATR Scanner as containerized services.

## Architecture

- **Backend**: FastAPI application serving the trading analysis API
- **Frontend**: Nginx serving the web interface
- **Network**: Both containers communicate via Docker bridge network

## Quick Start

### 1. Build and Start
```bash
./docker-manage.sh build
./docker-manage.sh up
```

### 2. Access the Application
- **Web Interface**: http://localhost
- **API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs

### 3. View Logs
```bash
./docker-manage.sh logs
```

### 4. Stop the Application
```bash
./docker-manage.sh down
```

## Docker Management Commands

| Command | Description |
|---------|-------------|
| `./docker-manage.sh build` | Build Docker images |
| `./docker-manage.sh up` | Start the application |
| `./docker-manage.sh down` | Stop the application |
| `./docker-manage.sh logs` | View application logs |
| `./docker-manage.sh status` | Show container status |
| `./docker-manage.sh restart` | Restart the application |
| `./docker-manage.sh clean` | Clean up all resources |

## Manual Docker Commands

If you prefer to use Docker commands directly:

### Build Images
```bash
docker build -f Dockerfile.backend -t finviz-scanner-backend:latest .
docker build -f Dockerfile.frontend -t finviz-scanner-frontend:latest .
```

### Run with Docker Compose
```bash
docker-compose up -d
docker-compose logs -f
docker-compose down
```

### Run Individual Containers
```bash
# Backend
docker run -d --name finviz-backend -p 8000:8000 finviz-scanner-backend:latest

# Frontend
docker run -d --name finviz-frontend -p 80:80 finviz-scanner-frontend:latest
```

## Configuration

### Environment Variables
The backend supports these environment variables:
- `PYTHONUNBUFFERED=1` - Ensure Python output is not buffered
- `TZ=UTC` - Set timezone

### Port Configuration
- Backend API: Port 8000
- Frontend Web: Port 80

### Health Checks
Both containers include health checks:
- Backend: `GET /health`
- Frontend: `GET /health`

## Volumes

### Logs
Application logs are mounted to `./logs` directory:
```bash
docker-compose logs backend
docker-compose logs frontend
```

## Security Features

### Backend Container
- Runs as non-root user (`appuser`)
- Minimal Python slim image
- Only necessary dependencies installed

### Frontend Container
- Nginx Alpine image (minimal footprint)
- Security headers configured
- Gzip compression enabled

## Troubleshooting

### Check Container Status
```bash
docker-compose ps
```

### View Container Logs
```bash
docker-compose logs backend
docker-compose logs frontend
```

### Restart Services
```bash
docker-compose restart
```

### Access Container Shell
```bash
docker-compose exec backend bash
docker-compose exec frontend sh
```

### Network Issues
If the frontend can't connect to the backend:
1. Ensure both containers are running
2. Check that backend health check passes
3. Verify network connectivity

## Development

### Local Development vs Docker
- **Local**: Use `uvicorn finviz_api:app --reload` for development
- **Docker**: Use for production-like testing and deployment

### Updating Code
After code changes:
1. Rebuild images: `./docker-manage.sh build`
2. Restart containers: `./docker-manage.sh restart`

## Performance

### Resource Requirements
- **Memory**: ~500MB total (backend: ~300MB, frontend: ~20MB)
- **CPU**: Minimal during idle, moderate during scans
- **Storage**: ~1GB for images and logs

### Scaling
For high traffic, consider:
- Multiple backend replicas
- Load balancer in front of frontend
- External database for caching results
