# Finviz Scanner Frontend

A modern web interface for the Finviz ATR Swing Scanner with responsive design and Docker support.

## 🚀 Overview

This repository contains the frontend web application and Docker configurations for the Finviz Scanner project. The backend API is maintained in a [separate repository](https://github.com/arikamir/finviz-scanner).

## 📁 Repository Structure

```
frontend/
├── frontend.html                   # Main web application
├── auth-test.html                  # Authentication testing page
├── README.md                       # This file
├── package.json                    # Node.js configuration and scripts
├── .gitignore                      # Git ignore file
├── 
├── Docker Configuration:
├── Dockerfile.frontend             # Production frontend container
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
- **Multi-environment Builds**: Development, production, and testing containers
- **Multi-architecture**: Supports both AMD64 and ARM64 platforms
- **Nginx Integration**: High-performance web server with SSL support
- **Health Checks**: Built-in container health monitoring

## 🚀 Quick Start

### Local Development

1. **Open the HTML file directly:**
   ```bash
   open frontend.html
   ```

2. **Or use a simple HTTP server:**
   ```bash
   python -m http.server 8080
   # Then visit http://localhost:8080/frontend.html
   ```

### Docker Development

1. **Build and run development container:**
   ```bash
   docker build -f Dockerfile.frontend.dev -t finviz-frontend:dev .
   docker run -p 8080:80 finviz-frontend:dev
   ```

2. **Visit the application:**
   ```
   http://localhost:8080
   ```

### Production Deployment

1. **Build production container:**
   ```bash
   docker build -f Dockerfile.frontend.prod -t finviz-frontend:prod .
   ```

2. **Run with environment variables:**
   ```bash
   docker run -p 80:80 -p 443:443 \
     -e DOMAIN_NAME=your-domain.com \
     finviz-frontend:prod
   ```

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

2. **Validate code:**
   ```bash
   htmlhint --config .htmlhintrc frontend.html
   stylelint "**/*.css" --config .stylelintrc.json
   eslint "**/*.js" --config .eslintrc.json
   ```

3. **Test with Docker:**
   ```bash
   docker build -f Dockerfile.frontend.test -t finviz-frontend:test .
   docker run -p 8080:80 finviz-frontend:test
   ```

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
