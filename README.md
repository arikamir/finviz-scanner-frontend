# Finviz Scanner Frontend

A modern web interface for the Finviz ATR Swing Scanner with Gmail authentication and responsive design.

## 🚀 Overview

This repository contains the frontend web application, Docker configurations, and deployment infrastructure for the Finviz Scanner project. The backend API is maintained in a [separate repository](https://github.com/arikamir/finviz-scanner).

## 📁 Repository Structure

```
frontend/
├── frontend.html                   # Main web application
├── auth-test.html                  # Authentication testing page
├── GITHUB_COPILOT_INSTRUCTIONS.md  # Development workflow guide
├── GMAIL_LOGIN_SETUP.md            # Authentication setup guide
├── GMAIL_AUTH_IMPLEMENTATION.md    # Technical implementation details
├── README.md                       # This file
├── .env.auth.example              # Authentication configuration template
├── .gitignore                      # Git ignore file
├── 
├── Docker Configuration:
├── docker-compose.yml              # Main Docker setup
├── docker-compose.prod.yml         # Production configuration
├── docker-compose.override.yml     # Development overrides
├── Dockerfile.frontend             # Frontend container
├── Dockerfile.frontend.dev         # Development container
├── Dockerfile.frontend.prod        # Production container
├── Dockerfile.certbot              # SSL certificate automation
├── nginx.conf.template             # Nginx configuration
├── nginx.conf.dev                  # Development Nginx config
├── 
├── Deployment & Setup:
├── deployment/                     # Deployment scripts
│   ├── docker-build.sh            # Build Docker images
│   ├── docker-manage.sh           # Container management
│   ├── setup-letsencrypt.sh       # SSL certificate setup
│   ├── renew-ssl.sh               # SSL renewal automation
│   └── get-domain.sh              # Domain configuration
├── setup/                          # Environment setup scripts
│   ├── setup-alpaca.sh            # Trading API setup
│   └── setup-env.fish             # Development environment
├── 
├── Documentation:
├── docs/                           # Project documentation
│   ├── README-Docker.md           # Docker setup guide
│   ├── HTTPS-SETUP.md             # SSL configuration
│   ├── ALPACA_SETUP.md            # Trading API integration
│   └── SYSTEM_READY.md            # System status overview
├── 
├── Generated/Runtime Files:
├── certbot/                        # SSL certificates (generated)
└── logs/                           # Application logs
```

## ✨ Key Features

### 🔐 Authentication
- **Gmail OAuth Integration**: Secure login with Google accounts
- **Session Management**: Persistent authentication across sessions
- **Token Validation**: JWT token verification and auto-renewal
- **User Profile Display**: Shows user avatar and name when logged in

### 🎨 User Interface
- **Modern Design**: Clean, professional interface with gradient backgrounds
- **Responsive Layout**: Works perfectly on desktop, tablet, and mobile
- **Interactive Elements**: Hover effects, loading states, and smooth transitions
- **Dark/Light Theme Support**: (ready for implementation)

### 📊 Stock Analysis Features
- **Real-time Scanning**: Analyzes stocks from Finviz screener URLs
- **ATR-based Analysis**: Advanced technical analysis using Average True Range
- **Risk Management**: Built-in position sizing and risk calculation
- **Trading Signals**: Clear buy/sell signals with entry/exit points
- **Market Trend Analysis**: Overall market condition assessment

### 🐳 Docker & Deployment
- **Containerized Architecture**: Full Docker support for easy deployment
- **SSL/HTTPS Support**: Automated Let's Encrypt certificate management
- **Production Ready**: Nginx reverse proxy with security headers
- **Development Environment**: Hot-reload capable development setup

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- Google OAuth Client ID (see setup guide)
- Domain name (for production HTTPS)

### Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/arikamir/finviz-scanner-frontend.git
   cd finviz-scanner-frontend
   ```

2. **Set up Gmail authentication**
   ```bash
   # Follow the detailed guide
   open GMAIL_LOGIN_SETUP.md
   
   # Test authentication
   open auth-test.html
   ```

3. **Start development environment**
   ```bash
   # Start with Docker
   docker-compose up -d
   
   # Or open directly in browser for frontend-only testing
   open frontend.html
   ```

4. **Access the application**
   - Frontend: http://localhost:3000
   - API Documentation: http://localhost:8000/docs (if backend is running)

### Production Deployment

1. **Configure environment**
   ```bash
   cp .env.auth.example .env.auth
   # Edit .env.auth with your production values
   ```

2. **Set up SSL certificates**
   ```bash
   ./deployment/setup-letsencrypt.sh your-domain.com
   ```

3. **Deploy with production configuration**
   ```bash
   docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
   ```

## 🔧 Configuration

### Gmail Authentication Setup

1. **Google Cloud Console Setup**
   - Create OAuth 2.0 Client ID
   - Add authorized JavaScript origins
   - Configure redirect URIs

2. **Frontend Configuration**
   - Update `GOOGLE_CLIENT_ID` in `frontend.html`
   - Test with `auth-test.html`

3. **Backend Integration**
   - Ensure backend API supports authentication
   - Configure CORS settings

**📖 Detailed Guide**: See [GMAIL_LOGIN_SETUP.md](GMAIL_LOGIN_SETUP.md)

### Environment Variables

```bash
# Authentication Configuration
GOOGLE_CLIENT_ID=your-google-oauth-client-id
GOOGLE_CLIENT_SECRET=your-google-oauth-secret

# Application Settings
AUTH_REQUIRED=true
AUTH_SESSION_TIMEOUT=3600

# Development Settings
DEV_MODE=true
DEV_SKIP_AUTH=false
```

## 🧪 Testing

### Authentication Testing
```bash
# Open the dedicated test page
open auth-test.html

# Test authentication flow
# 1. Click "Sign in with Google"
# 2. Complete OAuth flow
# 3. Verify user information display
# 4. Test logout functionality
```

### Frontend Testing
```bash
# Test main application
open frontend.html

# Test without backend (mock mode)
# Should show authentication overlay

# Test with backend running
docker-compose up -d
# Should allow full functionality after login
```

### Cross-Browser Testing
- Chrome/Chromium (primary)
- Firefox
- Safari (macOS)
- Edge
- Mobile browsers

## 🔗 API Integration

This frontend connects to the Finviz Scanner API backend:

- **Backend Repository**: https://github.com/arikamir/finviz-scanner
- **API Documentation**: http://localhost:8000/docs (when running)
- **Health Check**: http://localhost:8000/health

### Authentication Headers
```javascript
headers: {
    'Authorization': `Bearer ${authToken}`,
    'X-User-Email': currentUser.email,
    'Content-Type': 'application/json'
}
```

## 🛠️ Development Workflow

### Branching Strategy
- `main` - Protected production branch
- `feature/*` - New features
- `bugfix/*` - Bug fixes
- `enhancement/*` - Improvements
- `auth/*` - Authentication changes

### GitHub Copilot Integration
This project follows specific guidelines for GitHub Copilot usage:

**📋 Development Guide**: See [GITHUB_COPILOT_INSTRUCTIONS.md](GITHUB_COPILOT_INSTRUCTIONS.md)

### Pull Request Process
1. Create feature branch
2. Implement changes with Copilot assistance
3. Test across browsers and devices
4. Create pull request with comprehensive testing checklist
5. Code review and automated checks
6. Merge after approval

## 📚 Documentation

- **[GITHUB_COPILOT_INSTRUCTIONS.md](GITHUB_COPILOT_INSTRUCTIONS.md)** - Development workflow and Copilot guidelines
- **[GMAIL_LOGIN_SETUP.md](GMAIL_LOGIN_SETUP.md)** - Complete authentication setup guide
- **[GMAIL_AUTH_IMPLEMENTATION.md](GMAIL_AUTH_IMPLEMENTATION.md)** - Technical implementation details
- **[docs/README-Docker.md](docs/README-Docker.md)** - Docker setup and configuration
- **[docs/HTTPS-SETUP.md](docs/HTTPS-SETUP.md)** - SSL certificate configuration
- **[docs/ALPACA_SETUP.md](docs/ALPACA_SETUP.md)** - Trading API integration

## 🔒 Security Considerations

### Frontend Security
- **OAuth Token Handling**: Secure storage and transmission
- **XSS Prevention**: Input sanitization and CSP headers
- **CSRF Protection**: Token-based request validation
- **HTTPS Enforcement**: SSL/TLS encryption for all traffic

### Authentication Security
- **Google OAuth 2.0**: Industry-standard authentication
- **JWT Token Validation**: Server-side token verification
- **Session Management**: Secure session handling
- **Auto-logout**: Automatic logout on token expiration

## 🚀 Performance Optimization

### Frontend Performance
- **Optimized Assets**: Minified CSS and JavaScript
- **Responsive Images**: Proper image sizing and formats
- **Caching Strategy**: Browser and CDN caching
- **Lazy Loading**: Deferred loading of non-critical resources

### Docker Optimization
- **Multi-stage Builds**: Optimized container images
- **Layer Caching**: Efficient Docker layer utilization
- **Resource Limits**: Proper memory and CPU allocation

## 🤝 Contributing

1. **Read the Guidelines**: See [GITHUB_COPILOT_INSTRUCTIONS.md](GITHUB_COPILOT_INSTRUCTIONS.md)
2. **Create Feature Branch**: `git checkout -b feature/your-feature`
3. **Follow Testing Checklist**: Comprehensive browser and device testing
4. **Submit Pull Request**: Use the provided template
5. **Code Review**: Address feedback and pass all checks

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Issues**: Create issues for bugs or feature requests
- **Documentation**: Check the docs/ directory for detailed guides
- **Authentication**: See [GMAIL_LOGIN_SETUP.md](GMAIL_LOGIN_SETUP.md) for auth issues
- **Deployment**: See [docs/README-Docker.md](docs/README-Docker.md) for deployment issues

## 🔗 Related Projects

- **Backend API**: [finviz-scanner](https://github.com/arikamir/finviz-scanner)
- **API Documentation**: Available at `/docs` endpoint when backend is running

---

**Built with ❤️ using GitHub Copilot and modern web technologies**
