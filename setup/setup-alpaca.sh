#!/bin/bash

# Alpaca API Setup Script
echo "🔧 Setting up Alpaca API credentials..."

# Create .env file with provided credentials
cat > .env << 'EOF'
# Alpaca API Configuration
ALPACA_API_KEY=PKCRSCO8D5IARNS3VESK
ALPACA_SECRET_KEY=pvqWlJpGDP9fEy9jN7qnfs0Hve0XNaIeI3sY9IIU
ALPACA_BASE_URL=https://paper-api.alpaca.markets/v2

# Additional Configuration
RATE_LIMIT_REQUESTS=200
RATE_LIMIT_WINDOW=60
EOF

echo "✅ Created .env file with Alpaca credentials"
echo "📋 Configuration:"
echo "   - API Key: PKCRSCO8D5IARNS3VESK"
echo "   - Base URL: https://paper-api.alpaca.markets/v2"
echo "   - Environment: Paper Trading (Safe for testing)"

echo ""
echo "🚀 Next steps:"
echo "1. Source the environment: source .env"
echo "2. Restart containers: docker-compose down && docker-compose up -d"
echo "3. Test the API: curl https://amir-trader.duckdns.org/debug"

echo ""
echo "📖 The system is now configured for Alpaca API!"
