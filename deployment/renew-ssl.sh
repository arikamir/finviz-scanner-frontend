#!/bin/bash

# SSL Certificate Renewal Script for Finviz ATR Scanner
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log "🔄 Starting SSL certificate renewal process..."

# Check if certbot configuration exists
if [[ ! -d "./certbot/conf" ]]; then
    error "❌ Certbot configuration not found. Run setup-letsencrypt.sh first."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    error "❌ docker-compose not found. Please install docker-compose."
    exit 1
fi

# Renew certificates
log "🔄 Attempting to renew SSL certificates..."
if docker-compose run --rm certbot renew; then
    success "✅ Certificate renewal successful"
    
    # Test nginx configuration before reload
    log "🧪 Testing nginx configuration..."
    if docker-compose exec frontend nginx -t; then
        log "🔄 Reloading nginx configuration..."
        docker-compose exec frontend nginx -s reload
        success "✅ Nginx configuration reloaded successfully"
        
        # Test HTTPS connection
        if [[ -f ".env" ]]; then
            source .env
            if [[ -n "$DOMAIN_NAME" ]]; then
                log "🧪 Testing HTTPS connection to $DOMAIN_NAME..."
                if curl -f -s "https://$DOMAIN_NAME/health" > /dev/null; then
                    success "✅ HTTPS connection test passed"
                else
                    warn "⚠️  HTTPS connection test failed - check configuration"
                fi
            fi
        fi
    else
        error "❌ Nginx configuration test failed"
        error "❌ Not reloading nginx - check configuration"
        exit 1
    fi
else
    warn "⚠️  Certificate renewal was not needed or failed"
    log "ℹ️  Certificates are usually renewed automatically 30 days before expiration"
fi

# Show certificate status
log "📋 Certificate status:"
if [[ -f ".env" ]]; then
    source .env
    if [[ -n "$DOMAIN_NAME" && -f "./certbot/conf/live/$DOMAIN_NAME/fullchain.pem" ]]; then
        EXPIRY=$(openssl x509 -enddate -noout -in "./certbot/conf/live/$DOMAIN_NAME/fullchain.pem" | cut -d= -f2)
        log "📅 Certificate expires: $EXPIRY"
        
        # Calculate days until expiration
        EXPIRY_EPOCH=$(date -d "$EXPIRY" +%s)
        CURRENT_EPOCH=$(date +%s)
        DAYS_LEFT=$(( (EXPIRY_EPOCH - CURRENT_EPOCH) / 86400 ))
        
        if [[ $DAYS_LEFT -gt 30 ]]; then
            success "✅ Certificate is valid for $DAYS_LEFT more days"
        elif [[ $DAYS_LEFT -gt 7 ]]; then
            warn "⚠️  Certificate expires in $DAYS_LEFT days"
        else
            error "❌ Certificate expires in $DAYS_LEFT days - renewal needed!"
        fi
    fi
fi

success "🎉 SSL renewal process completed!"
