# HTTPS Setup with Let's Encrypt

This guide helps you set up free SSL certificates using Let's Encrypt for your Finviz ATR Scanner.

## Prerequisites

1. **Domain Name**: You need a domain pointing to your server's public IP
2. **Open Ports**: Ports 80 and 443 must be accessible from the internet
3. **Docker**: Docker and docker-compose must be installed

## Quick Setup

### 1. Get a Domain
- Purchase a domain or use a free service like:
  - [Freenom](https://freenom.com) (free domains)
  - [Cloudflare](https://cloudflare.com) (paid domains)
  - [Namecheap](https://namecheap.com) (paid domains)

### 2. Point Domain to Your Server
Create an **A record** in your DNS settings:
```
Type: A
Name: @ (or your subdomain)
Value: YOUR_SERVER_PUBLIC_IP
TTL: 300 (or Auto)
```

For subdomains:
```
Type: A
Name: finviz (for finviz.yourdomain.com)
Value: YOUR_SERVER_PUBLIC_IP
```

### 3. Setup SSL Certificate
```bash
# Run the Let's Encrypt setup
./setup-letsencrypt.sh --domain yourdomain.com --email your@email.com

# For subdomain
./setup-letsencrypt.sh --domain finviz.yourdomain.com --email your@email.com

# For testing (staging certificates)
./setup-letsencrypt.sh --domain yourdomain.com --email your@email.com --staging
```

### 4. Access Your Application
After successful setup:
- **HTTPS Frontend**: `https://yourdomain.com`
- **HTTPS API**: `https://yourdomain.com:8000`
- **API Docs**: `https://yourdomain.com:8000/docs`

## Certificate Management

### Auto-Renewal
Certificates auto-renew, but you can set up a cron job for safety:

```bash
# Edit crontab
crontab -e

# Add this line (runs daily at noon)
0 12 * * * /path/to/your/project/renew-ssl.sh >> /var/log/ssl-renewal.log 2>&1
```

### Manual Renewal
```bash
# Test renewal (dry run)
./renew-ssl.sh

# Force renewal
docker-compose run --rm certbot renew --force-renewal
```

### Check Certificate Status
```bash
# View certificate expiration
openssl x509 -enddate -noout -in ./certbot/conf/live/yourdomain.com/fullchain.pem

# Check certificate details
docker-compose run --rm certbot certificates
```

## Troubleshooting

### Domain Not Resolving
```bash
# Check DNS resolution
dig yourdomain.com
nslookup yourdomain.com

# Should return your server's IP
```

### Port 80/443 Not Accessible
```bash
# Check if ports are open
sudo netstat -tlnp | grep :80
sudo netstat -tlnp | grep :443

# Test from external service
curl -I http://yourdomain.com/health
```

### Certificate Request Failed
```bash
# Check certbot logs
docker-compose logs certbot

# Common issues:
# 1. Domain doesn't point to server
# 2. Port 80 blocked by firewall
# 3. Another service using port 80
# 4. Rate limiting (use --staging for testing)
```

### Nginx Configuration Issues
```bash
# Test nginx config
docker-compose exec frontend nginx -t

# Reload nginx
docker-compose exec frontend nginx -s reload

# Check nginx logs
docker-compose logs frontend
```

## Free Domain Services

### Option 1: Freenom (Free)
1. Go to [freenom.com](https://freenom.com)
2. Search for available domains (.tk, .ml, .ga, .cf)
3. Register free domain
4. Set DNS A record to your server IP

### Option 2: DuckDNS (Free Subdomain)
1. Go to [duckdns.org](https://duckdns.org)
2. Create account and subdomain
3. Set IP to your server
4. Use: `yourname.duckdns.org`

### Option 3: No-IP (Free Subdomain)
1. Go to [noip.com](https://noip.com)
2. Create free hostname
3. Set to your server IP
4. Use: `yourname.ddns.net`

## Security Notes

- Certificates are valid for 90 days and auto-renew
- Let's Encrypt has rate limits (5 certificates per domain per week)
- Use `--staging` flag for testing to avoid rate limits
- Keep your email updated for expiration notifications

## Production Considerations

For production deployments:

1. **Firewall**: Configure UFW or iptables
2. **Monitoring**: Set up SSL certificate monitoring
3. **Backup**: Backup certificate files
4. **Load Balancer**: Use nginx or HAProxy for multiple instances
5. **CDN**: Consider Cloudflare for additional protection

## Examples

### Complete Setup Example
```bash
# 1. Setup domain: mytrader.duckdns.org -> YOUR_SERVER_IP

# 2. Run setup
./setup-letsencrypt.sh --domain mytrader.duckdns.org --email trader@gmail.com

# 3. Access application
# https://mytrader.duckdns.org
```

### Multiple Domains
```bash
# Setup for multiple domains/subdomains
./setup-letsencrypt.sh --domain api.mytrader.com --email admin@mytrader.com
./setup-letsencrypt.sh --domain app.mytrader.com --email admin@mytrader.com
```
