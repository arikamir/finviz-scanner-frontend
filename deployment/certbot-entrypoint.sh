#!/bin/sh

# Certbot entrypoint script
set -e

# Read environment variables
DOMAIN_NAME=${DOMAIN_NAME:-localhost}
EMAIL=${EMAIL:-admin@example.com}
STAGING=${STAGING:-false}

echo "🔐 Certbot SSL Certificate Setup"
echo "================================"
echo "Domain: $DOMAIN_NAME"
echo "Email: $EMAIL"
echo "Staging: $STAGING"
echo ""

# Build certbot command
CERTBOT_CMD="certonly --webroot --webroot-path=/var/www/certbot --email $EMAIL --agree-tos --no-eff-email -d $DOMAIN_NAME"

# Add staging flag if needed
if [ "$STAGING" = "true" ]; then
    CERTBOT_CMD="$CERTBOT_CMD --staging"
    echo "⚠️  Using Let's Encrypt STAGING environment"
fi

echo "� Running: certbot $CERTBOT_CMD"
echo ""

# Execute certbot
exec certbot $CERTBOT_CMD
