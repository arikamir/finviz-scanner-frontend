#!/bin/bash

# Let's Encrypt SSL Certificate Setup for Finviz ATR Scanner
set -e

# Configuration
DOMAIN_NAME=""
EMAIL=""
STAGING=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_help() {
    echo "🔐 Let's Encrypt SSL Certificate Setup"
    echo "====================================="
    echo ""
    echo "Usage: $0 --domain <domain> --email <email> [options]"
    echo ""
    echo "Required arguments:"
    echo "  --domain DOMAIN    Your domain name (e.g., myapp.example.com)"
    echo "  --email EMAIL      Your email address for Let's Encrypt notifications"
    echo ""
    echo "Optional arguments:"
    echo "  --staging          Use Let's Encrypt staging environment (for testing)"
    echo "  --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --domain finviz.example.com --email admin@example.com"
    echo "  $0 --domain finviz.example.com --email admin@example.com --staging"
    echo ""
    echo "Prerequisites:"
    echo "  - Domain must point to this server's public IP"
    echo "  - Ports 80 and 443 must be open"
    echo "  - Docker and docker-compose must be installed"
}

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --domain)
            DOMAIN_NAME="$2"
            shift 2
            ;;
        --email)
            EMAIL="$2"
            shift 2
            ;;
        --staging)
            STAGING=true
            shift
            ;;
        --help)
            print_help
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            print_help
            exit 1
            ;;
    esac
done

# Validate required arguments
if [[ -z "$DOMAIN_NAME" ]]; then
    error "Domain name is required. Use --domain <domain>"
    print_help
    exit 1
fi

if [[ -z "$EMAIL" ]]; then
    error "Email address is required. Use --email <email>"
    print_help
    exit 1
fi

log "Setting up Let's Encrypt SSL certificate for domain: $DOMAIN_NAME"
log "Email: $EMAIL"
if [[ "$STAGING" == true ]]; then
    warn "Using Let's Encrypt STAGING environment (certificates will not be trusted)"
fi

# Check if domain resolves to this server
log "Checking DNS resolution for $DOMAIN_NAME..."
DOMAIN_IP=$(dig +short "$DOMAIN_NAME" | tail -n1)
if [[ -z "$DOMAIN_IP" ]]; then
    error "Domain $DOMAIN_NAME does not resolve to an IP address"
    error "Please ensure your domain's DNS A record points to this server's public IP"
    exit 1
fi

log "Domain resolves to: $DOMAIN_IP"

# Create necessary directories
log "Creating certificate directories..."
mkdir -p ./certbot/conf
mkdir -p ./certbot/www
mkdir -p ./certbot/logs

# Create environment file for docker-compose
log "Creating environment configuration..."
cat > .env << EOF
# Domain configuration for Let's Encrypt
DOMAIN_NAME=$DOMAIN_NAME
EMAIL=$EMAIL
STAGING=$STAGING
EOF

# Create certbot docker-compose override
log "Creating certbot configuration..."
cat > docker-compose.override.yml << EOF
version: '3.8'

services:
  # Nginx with Let's Encrypt support
  frontend:
    environment:
      - DOMAIN_NAME=$DOMAIN_NAME
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./certbot/conf:/etc/letsencrypt
      - ./certbot/www:/var/www/certbot
    command: /bin/sh -c "envsubst '\$\$DOMAIN_NAME' < /etc/nginx/nginx.conf > /tmp/nginx.conf && exec nginx -g 'daemon off;'"

  # Certbot for SSL certificate management
  certbot:
    image: certbot/certbot
    container_name: finviz-certbot
    volumes:
      - ./certbot/conf:/etc/letsencrypt
      - ./certbot/www:/var/www/certbot
      - ./certbot/logs:/var/log/letsencrypt
    command: certonly --webroot --webroot-path=/var/www/certbot --email $EMAIL --agree-tos --no-eff-email -d $DOMAIN_NAME \$(if [ "\$STAGING" = "true" ]; then echo "--staging"; fi)
    depends_on:
      - frontend
    networks:
      - finviz-network
EOF

log "Starting nginx for certificate verification..."
docker-compose up -d frontend

# Wait for nginx to be ready
log "Waiting for nginx to be ready..."
sleep 10

# Test that nginx is responding
log "Testing nginx accessibility..."
if ! curl -f "http://$DOMAIN_NAME/health" > /dev/null 2>&1; then
    error "Cannot reach http://$DOMAIN_NAME/health"
    error "Please ensure:"
    error "  1. Your domain points to this server's public IP"
    error "  2. Port 80 is open and accessible"
    error "  3. No other service is using port 80"
    exit 1
fi

success "Nginx is accessible at http://$DOMAIN_NAME"

# Request SSL certificate
log "Requesting SSL certificate from Let's Encrypt..."
docker-compose run --rm certbot

# Check if certificate was issued
if [[ -f "./certbot/conf/live/$DOMAIN_NAME/fullchain.pem" ]]; then
    success "SSL certificate issued successfully!"
    
    # Restart nginx with SSL
    log "Restarting nginx with SSL configuration..."
    docker-compose restart frontend
    
    # Test HTTPS
    log "Testing HTTPS connection..."
    sleep 5
    if curl -f -k "https://$DOMAIN_NAME/health" > /dev/null 2>&1; then
        success "HTTPS is working correctly!"
        echo ""
        success "🎉 Setup complete! Your application is now available at:"
        success "    https://$DOMAIN_NAME"
        success "    https://$DOMAIN_NAME:8000 (API)"
        echo ""
        log "Certificate will auto-renew. Check renewal with:"
        log "    docker-compose run --rm certbot renew --dry-run"
    else
        warn "HTTPS connection failed. Check nginx logs:"
        warn "    docker-compose logs frontend"
    fi
else
    error "SSL certificate was not issued. Check certbot logs:"
    error "    docker-compose logs certbot"
    exit 1
fi

# Create renewal script
log "Creating automatic renewal script..."
cat > renew-ssl.sh << 'EOF'
#!/bin/bash
# SSL Certificate Renewal Script
echo "🔄 Renewing SSL certificates..."
docker-compose run --rm certbot renew
if [ $? -eq 0 ]; then
    echo "✅ Certificate renewal successful"
    echo "🔄 Reloading nginx..."
    docker-compose exec frontend nginx -s reload
    echo "✅ Nginx reloaded"
else
    echo "❌ Certificate renewal failed"
    exit 1
fi
EOF

chmod +x renew-ssl.sh

success "Setup completed successfully!"
echo ""
log "Next steps:"
log "  1. Add to crontab for automatic renewal:"
log "     0 12 * * * /path/to/this/directory/renew-ssl.sh"
log "  2. Test renewal: ./renew-ssl.sh"
log "  3. Monitor logs: docker-compose logs -f"
