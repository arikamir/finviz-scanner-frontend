#!/bin/bash

# Environment setup script for fish shell users
echo "🔧 Setting up environment variables for trading system..."

# Set environment variables for fish shell
set -x ALPACA_API_KEY PKCRSCO8D5IARNS3VESK
set -x ALPACA_SECRET_KEY pvqWlJpGDP9fEy9jN7qnfs0Hve0XNaIeI3sY9IIU
set -x ALPACA_BASE_URL https://paper-api.alpaca.markets/v2
set -x DOMAIN_NAME amir-trader.duckdns.org

echo "✅ Environment variables set:"
echo "   - ALPACA_API_KEY: $ALPACA_API_KEY"
echo "   - DOMAIN_NAME: $DOMAIN_NAME"
echo ""
echo "🚀 You can now run: docker-compose up -d"
