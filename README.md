# Finviz Scanner Frontend

A modern web interface for the Finviz ATR Swing Scanner with responsive design and consolidated Docker support.

## 🚀 Overview

This repository contains the frontend web application and Docker configurations for the Finviz Scanner project. The backend API is maintained in a [separate repository](https://github.com/arikamir/finviz-scanner).

## 📁 Repository Structure

```
frontend/
├── frontend.html                   # Main web application
├── auth-test.html                  # Authentication testing page
├── README.md                       # This file
├── Makefile                        # Build and deployment commands
├── package.json                    # Node.js configuration and scripts
├── .gitignore                      # Git ignore rules
├── .dockerignore                   # Docker build context exclusions
├── 
├── Docker Configuration:
├── Dockerfile                      # Consolidated multi-stage Dockerfile
├── docker-compose.yml              # Production deployment
├── docker-compose.dev.yml          # Development environment  
├── docker-compose.test.yml         # Testing environment
├── Dockerfile.frontend.dev         # Development container
├── Dockerfile.frontend.prod        # Optimized production container
├── Dockerfile.frontend.test        # CI testing container
├── nginx.conf.template             # Production nginx configuration
├── nginx.conf.dev                  # Development nginx config
├── nginx.conf.test                 # Testing nginx config (standalone)
├── 
├── CI/CD & Code Quality:
├── .github/workflows/ci.yml        # GitHub Actions CI/CD pipeline
├── .htmlhintrc                     # HTML validation rules
├── .stylelintrc.json              # CSS linting configuration
├── .eslintrc.json                 # JavaScript linting rules
├── GITHUB_COPILOT_INSTRUCTIONS.md  # Development workflow guide
```

## ✨ Key Features

### 🎨 User Interface
- **Modern Design**: Clean, professional interface with gradient backgrounds
- **Responsive Layout**: Works perfectly on desktop, tablet, and mobile
- **Interactive Elements**: Hover effects, loading states, and smooth transitions
- **Fast Loading**: Optimized static assets with nginx compression

### 📊 Stock Analysis Features
- **Real-time Scanning**: Connect to backend API for live stock data
- **ATR-based Analysis**: Advanced swing trading setup identification
- **Risk/Reward Ratios**: Calculate optimal entry and exit points
- **Market Trend Display**: Visual indicators for market conditions

### 🐳 Docker Support
- **Consolidated Dockerfile**: Single, multi-stage Dockerfile for all environments
- **Multi-environment Builds**: Development, production, and testing containers
- **Multi-architecture**: Supports both AMD64 and ARM64 platforms
- **Nginx Integration**: High-performance web server with SSL support
- **Health Checks**: Built-in container health monitoring
- **Environment Variables**: Flexible configuration for different deployments

## 🚀 Quick Start

### Using Makefile (Recommended)

The easiest way to work with the frontend is using the provided Makefile:

```bash
# Development
make dev           # Build and run development environment
make run-dev       # Run development (http://localhost:8080)

# Production  
make deploy        # Build and run production environment
make run-prod      # Run production (http://localhost:80)

# Testing
make run-test      # Run test environment (http://localhost:9080)

# Utilities
make help          # Show all available commands
make test          # Run health checks on all environments
make logs-dev      # Show development logs
make clean         # Clean up all Docker resources
```

### Manual Docker Commands

1. **Development environment:**
   ```bash
   docker-compose -f docker-compose.dev.yml up -d
   # Visit http://localhost:8080
   ```

2. **Production deployment:**
   ```bash
   docker-compose up -d
   # Visit http://localhost:80
   ```

3. **Testing environment:**
   ```bash
   docker-compose -f docker-compose.test.yml up -d
   # Visit http://localhost:9080
   ```

### Local Development (No Docker)

1. **Open the HTML file directly:**
   ```bash
   open frontend.html
   ```

2. **Or use a simple HTTP server:**
   ```bash
   python -m http.server 8080
   # Then visit http://localhost:8080/frontend.html
   ```

## ⚙️ Configuration

### Environment Variables

The consolidated Dockerfile supports multiple environment variables for flexible deployment:

| Variable | Default | Description |
|----------|---------|-------------|
| `BUILD_ENV` | `production` | Build environment: `development`, `production`, or `test` |
| `DOMAIN_NAME` | `localhost` | Domain name for nginx configuration |
| `BACKEND_HOST` | `backend` | Backend API hostname |
| `BACKEND_PORT` | `8000` | Backend API port |
| `STANDALONE_MODE` | `false` | Run without backend (frontend-only) |
| `SSL_MODE` | `auto` | SSL configuration: `auto`, `enabled`, `disabled`, `letsencrypt`, `selfsigned` |

### Build Targets

The Dockerfile includes three build targets:

1. **development**: Lightweight, fast startup, development tools included
2. **test**: Minimal configuration for CI/CD testing
3. **production**: Optimized, security-hardened, non-root user

### SSL Configuration

The frontend supports multiple SSL modes:

- **auto**: Automatically detects available SSL certificates
- **enabled**: Forces HTTPS with Let's Encrypt certificates
- **disabled**: HTTP-only mode
- **letsencrypt**: Use Let's Encrypt certificates
- **selfsigned**: Use self-signed certificates for local testing

## 🔧 Development

### Prerequisites
- Node.js 18+ (for linting tools)
- Docker (for containerization)
- Modern web browser

### Development Workflow

1. **Install development tools:**
   ```bash
   npm install -g htmlhint stylelint eslint
   ```

2. **Start development environment:**
   ```bash
   make dev
   # or manually:
   # docker-compose -f docker-compose.dev.yml up -d
   ```

3. **Validate code:**
   ```bash
   htmlhint --config .htmlhintrc frontend.html
   stylelint "**/*.css" --config .stylelintrc.json  
   eslint "**/*.js" --config .eslintrc.json
   ```

4. **Run tests:**
   ```bash
   make test
   ```

### File Structure for Development

```
frontend/
├── frontend.html          # Main application (edit this)
├── Dockerfile            # Consolidated multi-stage build
├── Makefile              # Development commands
├── docker-compose*.yml   # Environment-specific configurations
└── nginx.conf.*          # Nginx configurations for different modes
```

### Version Management

This project follows [Semantic Versioning](https://semver.org/):

```bash
# Check current version
npm run version:current

# Bump version
npm run version:patch    # 1.0.0 → 1.0.1 (bug fixes)
npm run version:minor    # 1.0.0 → 1.1.0 (new features)
npm run version:major    # 1.0.0 → 2.0.0 (breaking changes)

# Create release tag
npm run version:tag
git push origin frontend-v$(npm run version:current --silent)
```

See [SEMANTIC_VERSIONING.md](../SEMANTIC_VERSIONING.md) for detailed guidelines.

### CI/CD Pipeline

The repository includes a comprehensive CI/CD pipeline with:

- ✅ **Code Validation**: HTML, CSS, and JavaScript linting
- ✅ **Security Scanning**: Automated security audits
- ✅ **Docker Builds**: Multi-architecture container builds
- ✅ **Container Testing**: Standalone frontend testing
- ✅ **Docker Hub Publishing**: Automated image publishing

## 🌐 API Integration

The frontend connects to the backend API for:

- Stock data scanning and analysis
- Real-time market trend updates
- Historical ATR calculations
- Trading setup recommendations

**Backend Repository**: [finviz-scanner](https://github.com/arikamir/finviz-scanner)

## 📱 Browser Support

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run validation tools
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🔗 Links

- **Backend API**: [finviz-scanner](https://github.com/arikamir/finviz-scanner)
- **Docker Hub**: [arikamir/finviz-scanner-frontend](https://hub.docker.com/r/arikamir/finviz-scanner-frontend)
- **CI/CD Status**: [![CI](https://github.com/arikamir/finviz-scanner-frontend/actions/workflows/ci.yml/badge.svg)](https://github.com/arikamir/finviz-scanner-frontend/actions/workflows/ci.yml)
