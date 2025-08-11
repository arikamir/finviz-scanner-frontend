#!/bin/bash

# Free Domain Finder and Registration Guide for Amir
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🌐 Free Domain Options for Amir${NC}"
echo "=================================="
echo ""

echo -e "${GREEN}📋 Suggested Domain Names:${NC}"
echo ""

# Function to check domain availability (mock - you'd need to actually check)
suggest_domains() {
    echo -e "${YELLOW}🎯 Top Recommendations:${NC}"
    echo "   1. amir-trader.duckdns.org       (DuckDNS - Instant & Free)"
    echo "   2. amirfinance.duckdns.org       (DuckDNS - Instant & Free)"
    echo "   3. amir-scanner.duckdns.org      (DuckDNS - Instant & Free)"
    echo "   4. amirtrading.ddns.net          (No-IP - Free)"
    echo "   5. amir-finviz.ddns.net          (No-IP - Free)"
    echo ""
    
    echo -e "${YELLOW}🆓 Freenom Options (.tk, .ml, .ga, .cf):${NC}"
    echo "   • amirtrader.tk"
    echo "   • amirfinance.ml" 
    echo "   • amir-scanner.ga"
    echo "   • amirfx.cf"
    echo "   • tradingamir.tk"
    echo "   • finvizamir.ml"
    echo ""
    
    echo -e "${YELLOW}⚡ Dynamic DNS (Free Subdomains):${NC}"
    echo "   • amir-analytics.hopto.org       (No-IP)"
    echo "   • amirstock.zapto.org            (No-IP)"
    echo "   • amir-markets.servebeer.com     (No-IP)"
    echo ""
}

suggest_domains

echo -e "${GREEN}🚀 Quick Setup Guide:${NC}"
echo ""

echo -e "${BLUE}Option 1: DuckDNS (Recommended - Instant)${NC}"
echo "----------------------------------------"
echo "1. Go to: https://www.duckdns.org"
echo "2. Sign in with Google/GitHub/Reddit"
echo "3. Create subdomain: 'amir-trader' (or your choice)"
echo "4. Set current IP to your server's public IP"
echo "5. Use domain: amir-trader.duckdns.org"
echo ""

echo -e "${BLUE}Option 2: No-IP (Free)${NC}"
echo "---------------------"
echo "1. Go to: https://www.noip.com"
echo "2. Create free account"
echo "3. Create hostname: 'amirtrading.ddns.net'"
echo "4. Set IP to your server"
echo "5. Confirm via email"
echo ""

echo -e "${BLUE}Option 3: Freenom (Free Domains)${NC}"
echo "-------------------------------"
echo "1. Go to: https://freenom.com"
echo "2. Search for: 'amirtrader'"
echo "3. Select available extension (.tk, .ml, .ga, .cf)"
echo "4. Register for free (12 months)"
echo "5. Set DNS A record to your server IP"
echo ""

echo -e "${RED}⚠️  Important Notes:${NC}"
echo "• You need your server's PUBLIC IP address"
echo "• Ports 80 and 443 must be open"
echo "• DNS propagation can take 5-60 minutes"
echo ""

# Function to get public IP
get_public_ip() {
    echo -e "${BLUE}🔍 Finding your public IP address...${NC}"
    
    # Try multiple methods to get public IP
    PUBLIC_IP=""
    
    # Method 1: curl
    if command -v curl &> /dev/null; then
        PUBLIC_IP=$(curl -s https://api.ipify.org 2>/dev/null || curl -s https://icanhazip.com 2>/dev/null || curl -s https://ipecho.net/plain 2>/dev/null)
    fi
    
    # Method 2: wget if curl failed
    if [[ -z "$PUBLIC_IP" ]] && command -v wget &> /dev/null; then
        PUBLIC_IP=$(wget -qO- https://api.ipify.org 2>/dev/null || wget -qO- https://icanhazip.com 2>/dev/null)
    fi
    
    # Method 3: dig
    if [[ -z "$PUBLIC_IP" ]] && command -v dig &> /dev/null; then
        PUBLIC_IP=$(dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null)
    fi
    
    if [[ -n "$PUBLIC_IP" ]]; then
        echo -e "${GREEN}✅ Your public IP address: $PUBLIC_IP${NC}"
        echo -e "${YELLOW}📝 Use this IP when setting up your domain DNS record${NC}"
    else
        echo -e "${RED}❌ Could not detect public IP automatically${NC}"
        echo -e "${YELLOW}💡 You can find it manually at: https://whatismyipaddress.com${NC}"
    fi
    echo ""
}

get_public_ip

echo -e "${GREEN}🎯 My Recommendation for You:${NC}"
echo ""
echo -e "${YELLOW}Go with DuckDNS: amir-trader.duckdns.org${NC}"
echo ""
echo "Why DuckDNS?"
echo "✅ Instant setup (no waiting)"
echo "✅ Reliable and stable"
echo "✅ No ads or restrictions"
echo "✅ Works great with Let's Encrypt"
echo "✅ Simple management interface"
echo ""

echo -e "${BLUE}📋 Next Steps After Getting Domain:${NC}"
echo "1. Get your domain (suggested: amir-trader.duckdns.org)"
echo "2. Point it to your server IP: $PUBLIC_IP"
echo "3. Wait 5-10 minutes for DNS propagation"
echo "4. Run: ./setup-letsencrypt.sh --domain YOUR_DOMAIN --email YOUR_EMAIL"
echo ""

# Create a quick registration helper
echo -e "${GREEN}🔗 Quick Registration Links:${NC}"
echo ""
echo "DuckDNS:  https://www.duckdns.org"
echo "No-IP:    https://www.noip.com/sign-up"
echo "Freenom:  https://freenom.com"
echo ""

echo -e "${BLUE}💡 Pro Tip:${NC}"
echo "If you can't decide, start with DuckDNS 'amir-trader.duckdns.org'"
echo "It's the fastest and most reliable option for development and testing!"
