# Alpaca API Integration

This trading system now uses Alpaca's reliable market data API as the primary data source, with yfinance as a fallback.

## Setup Instructions

### 1. Get Alpaca API Credentials

1. Go to [Alpaca Markets](https://alpaca.markets/)
2. Sign up for a free account
3. Navigate to your API Keys section in the dashboard
4. Generate new API keys (use **Paper Trading** for testing)

### 2. Configure API Keys

Run the setup script:

```bash
./setup-alpaca.sh
```

Or manually create a `.env` file:

```bash
# .env file
ALPACA_API_KEY=your_api_key_here
ALPACA_SECRET_KEY=your_secret_key_here
```

### 3. Apply Environment Variables

```bash
# Load environment variables
source .env

# Restart containers with new configuration
docker-compose down
docker-compose up -d
```

### 4. Test the Integration

```bash
# Test the debug endpoint
curl https://amir-trader.duckdns.org/api/debug

# Or locally
curl http://localhost:8000/debug
```

## Features

✅ **Alpaca Market Data**: Primary reliable data source  
✅ **Rate Limiting**: Built-in request throttling  
✅ **Fallback Support**: Automatic fallback to yfinance if needed  
✅ **Error Handling**: Comprehensive error handling and retry logic  
✅ **Environment Variables**: Secure credential management  

## API Endpoints

- `GET /debug` - Test data source connectivity
- `POST /scan` - Run stock screening analysis  
- `GET /market-trend` - Get market trend analysis
- `GET /health` - Service health check

## Troubleshooting

### No data returned
- Check that your Alpaca API credentials are correct
- Verify the `.env` file exists and is loaded
- Check container logs: `docker logs finviz-api`

### Authentication errors
- Make sure you're using the correct Paper Trading API keys
- Regenerate API keys if needed
- Check for any special characters in the keys

### Rate limiting
- Alpaca has generous rate limits but they exist
- The system automatically handles rate limiting with delays
- Consider upgrading your Alpaca plan for higher limits if needed
