# Multi-stage, flexible Dockerfile for Finviz Scanner Frontend
# Supports development, production, testing, and SSL configurations
ARG BUILD_ENV=production

# Build stage
FROM nginx:alpine AS base

# Install required packages
RUN apk add --no-cache gettext curl openssl && \
    rm -rf /var/cache/apk/*

# Copy HTML content
COPY frontend.html /usr/share/nginx/html/index.html

# Copy all nginx configuration files
COPY nginx.conf.template /etc/nginx/
COPY nginx.conf.dev /etc/nginx/
COPY nginx.conf.standalone /etc/nginx/
COPY nginx.conf.http-only /etc/nginx/
COPY nginx.conf.test /etc/nginx/

# Create comprehensive startup script that handles all environments
RUN printf '#!/bin/sh\n\
# Environment Configuration\n\
export DOMAIN_NAME=${DOMAIN_NAME:-localhost}\n\
export BACKEND_HOST=${BACKEND_HOST:-backend}\n\
export BACKEND_PORT=${BACKEND_PORT:-8000}\n\
export BUILD_ENV=${BUILD_ENV:-production}\n\
export STANDALONE_MODE=${STANDALONE_MODE:-false}\n\
export SSL_MODE=${SSL_MODE:-auto}\n\
\n\
echo "=== Finviz Scanner Frontend Starting ==="\n\
echo "Build Environment: $BUILD_ENV"\n\
echo "Domain: $DOMAIN_NAME"\n\
echo "Backend: $BACKEND_HOST:$BACKEND_PORT"\n\
echo "Standalone Mode: $STANDALONE_MODE"\n\
echo "SSL Mode: $SSL_MODE"\n\
echo "=========================================="\n\
\n\
# Choose configuration based on BUILD_ENV\n\
case "$BUILD_ENV" in\n\
  "development")\n\
    echo "Using DEVELOPMENT configuration"\n\
    if [ -f "/etc/nginx/nginx.conf.dev" ]; then\n\
      cp /etc/nginx/nginx.conf.dev /etc/nginx/nginx.conf\n\
    else\n\
      echo "Development config not found, using basic HTTP config"\n\
      generate_basic_config\n\
    fi\n\
    ;;\n\
  "test")\n\
    echo "Using TEST configuration (standalone)"\n\
    if [ -f "/etc/nginx/nginx.conf.test" ]; then\n\
      cp /etc/nginx/nginx.conf.test /etc/nginx/nginx.conf\n\
    else\n\
      generate_test_config\n\
    fi\n\
    ;;\n\
  "production")\n\
    echo "Using PRODUCTION configuration"\n\
    configure_production\n\
    ;;\n\
  *)\n\
    echo "Unknown BUILD_ENV: $BUILD_ENV, defaulting to production"\n\
    configure_production\n\
    ;;\n\
esac\n\
\n\
# Function to configure production environment\n\
configure_production() {\n\
  if [ "$STANDALONE_MODE" = "true" ]; then\n\
    echo "Configuring STANDALONE mode"\n\
    if [ -f "/etc/nginx/nginx.conf.standalone" ]; then\n\
      envsubst "\\$DOMAIN_NAME" < /etc/nginx/nginx.conf.standalone > /etc/nginx/nginx.conf\n\
    else\n\
      generate_standalone_config\n\
    fi\n\
  else\n\
    echo "Configuring FULL mode with backend integration"\n\
    configure_ssl_and_backend\n\
  fi\n\
}\n\
\n\
# Function to handle SSL and backend configuration\n\
configure_ssl_and_backend() {\n\
  # Auto-detect SSL certificates if SSL_MODE is auto\n\
  if [ "$SSL_MODE" = "auto" ]; then\n\
    SSL_CERT_PATH="/etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem"\n\
    SSL_KEY_PATH="/etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem"\n\
    \n\
    if [ -f "$SSL_CERT_PATH" ] && [ -f "$SSL_KEY_PATH" ]; then\n\
      echo "✓ SSL certificates found - enabling HTTPS"\n\
      SSL_MODE="enabled"\n\
    else\n\
      echo "⚠ SSL certificates not found - using HTTP only"\n\
      SSL_MODE="disabled"\n\
    fi\n\
  fi\n\
  \n\
  # Configure based on SSL mode\n\
  if [ "$SSL_MODE" = "enabled" ] || [ "$SSL_MODE" = "letsencrypt" ] || [ "$SSL_MODE" = "selfsigned" ]; then\n\
    echo "Configuring HTTPS mode with SSL"\n\
    if [ -f "/etc/nginx/nginx.conf.template" ]; then\n\
      envsubst "\\$DOMAIN_NAME \\$BACKEND_HOST \\$BACKEND_PORT" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf\n\
    else\n\
      generate_https_config\n\
    fi\n\
  else\n\
    echo "Configuring HTTP-only mode"\n\
    if [ -f "/etc/nginx/nginx.conf.http-only" ]; then\n\
      envsubst "\\$DOMAIN_NAME \\$BACKEND_HOST \\$BACKEND_PORT" < /etc/nginx/nginx.conf.http-only > /etc/nginx/nginx.conf\n\
    else\n\
      generate_http_config\n\
    fi\n\
  fi\n\
}\n\
\n\
# Fallback configuration generators\n\
generate_basic_config() {\n\
  cat > /etc/nginx/nginx.conf << EOF\n\
events { worker_connections 1024; }\n\
http {\n\
  include /etc/nginx/mime.types;\n\
  default_type application/octet-stream;\n\
  server {\n\
    listen 80;\n\
    server_name _;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    location /health { return 200 "healthy\\n"; add_header Content-Type text/plain; }\n\
    location / { try_files \\$uri \\$uri/ /index.html; }\n\
  }\n\
}\n\
EOF\n\
}\n\
\n\
generate_test_config() {\n\
  cat > /etc/nginx/nginx.conf << EOF\n\
events { worker_connections 512; }\n\
http {\n\
  include /etc/nginx/mime.types;\n\
  server {\n\
    listen 80;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    location /health { return 200 "test-ok\\n"; add_header Content-Type text/plain; }\n\
    location / { try_files \\$uri \\$uri/ /index.html; }\n\
  }\n\
}\n\
EOF\n\
}\n\
\n\
generate_standalone_config() {\n\
  cat > /etc/nginx/nginx.conf << EOF\n\
events { worker_connections 1024; }\n\
http {\n\
  include /etc/nginx/mime.types;\n\
  server {\n\
    listen 80;\n\
    server_name $DOMAIN_NAME _;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    location /health { return 200 "standalone-ok\\n"; add_header Content-Type text/plain; }\n\
    location / { try_files \\$uri \\$uri/ /index.html; }\n\
  }\n\
}\n\
EOF\n\
}\n\
\n\
generate_http_config() {\n\
  cat > /etc/nginx/nginx.conf << EOF\n\
events { worker_connections 1024; }\n\
http {\n\
  include /etc/nginx/mime.types;\n\
  gzip on;\n\
  server {\n\
    listen 80;\n\
    server_name $DOMAIN_NAME _;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    location /health { return 200 "http-ok\\n"; add_header Content-Type text/plain; }\n\
    location /api/ {\n\
      proxy_pass http://$BACKEND_HOST:$BACKEND_PORT/;\n\
      proxy_set_header Host \\$host;\n\
      proxy_set_header X-Real-IP \\$remote_addr;\n\
    }\n\
    location / { try_files \\$uri \\$uri/ /index.html; }\n\
  }\n\
}\n\
EOF\n\
}\n\
\n\
# Validate and start nginx\n\
echo "Testing nginx configuration..."\n\
if nginx -t; then\n\
  echo "✓ Nginx configuration is valid"\n\
  echo "Starting nginx in $BUILD_ENV mode..."\n\
  exec nginx -g "daemon off;"\n\
else\n\
  echo "✗ Nginx configuration test failed"\n\
  nginx -t\n\
  echo "Configuration preview:"\n\
  head -20 /etc/nginx/nginx.conf\n\
  exit 1\n\
fi\n' > /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

# Development stage (lightweight)
FROM base AS development
ENV BUILD_ENV=development
EXPOSE 80
HEALTHCHECK --interval=15s --timeout=3s --start-period=5s --retries=2 \
    CMD curl -f http://localhost/health || exit 1

# Test stage (minimal)
FROM base AS test
ENV BUILD_ENV=test
ENV STANDALONE_MODE=true
EXPOSE 80
HEALTHCHECK --interval=5s --timeout=2s --start-period=5s --retries=2 \
    CMD curl -f http://localhost/health || exit 1

# Production stage (optimized)
FROM base AS production
ENV BUILD_ENV=production

# Create non-root user for security
RUN addgroup -g 1000 nginxuser && \
    adduser -D -s /bin/sh -u 1000 -G nginxuser nginxuser

# Set proper permissions
RUN chown -R nginxuser:nginxuser /usr/share/nginx/html /var/log/nginx /var/cache/nginx /etc/nginx

EXPOSE 80 443
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Use non-root user in production
USER nginxuser

# Default to production stage
FROM ${BUILD_ENV} AS final
CMD ["/docker-entrypoint.sh"]
