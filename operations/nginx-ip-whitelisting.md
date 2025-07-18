# Nginx IP Whitelisting for Internal Tests

## Overview
This guide explains how to configure nginx to allow internal browser tests without HTTP authentication while maintaining security for external access.

## Solution: `satisfy any` Directive

The nginx `satisfy any` directive allows access if **either** condition is met:
1. Request comes from a whitelisted IP
2. User provides valid HTTP auth credentials

## Implementation

### 1. Basic Configuration

```nginx
location / {
    # Allow access via IP whitelist OR authentication
    satisfy any;
    
    # IP Whitelist
    allow 127.0.0.1;          # localhost
    allow ::1;                # localhost IPv6  
    allow 157.180.28.186;     # Server's public IP
    allow 172.17.0.0/16;      # Docker networks
    deny all;                 # Block all other IPs
    
    # HTTP Authentication (fallback)
    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/auth/.htpasswd;
    
    try_files $uri $uri/ =404;
}
```

### 2. Finding Your Server's IP

```bash
# Public IP
curl -s ifconfig.me

# All IPs
hostname -I

# Docker network IPs
docker network inspect bridge | grep Subnet
```

### 3. Common IP Ranges to Whitelist

- `127.0.0.1` - Localhost IPv4
- `::1` - Localhost IPv6
- `10.0.0.0/8` - Private network class A
- `172.16.0.0/12` - Private network class B (includes Docker)
- `192.168.0.0/16` - Private network class C
- Your server's public IP

### 4. Testing the Configuration

```bash
# Test nginx configuration
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx

# Test from server (should work without auth)
curl -I https://kaut.to/

# Test from Docker container
docker run --rm alpine/curl curl -I https://kaut.to/

# Check nginx access logs
tail -f /var/log/nginx/kaut.to-access.log
```

## Use Cases

### Browser Testing with Selenium
```python
# With IP whitelisting, no auth needed from server
driver.get("https://kaut.to/test")
# Works without authentication!
```

### Internal API Calls
```bash
# From whitelisted IP
curl https://kaut.to/api/health
# 200 OK

# From external IP
curl https://kaut.to/api/health
# 401 Unauthorized
```

## Security Considerations

1. **Verify IPs**: Always verify the IPs you're whitelisting
2. **Minimal Whitelist**: Only whitelist necessary IPs
3. **Monitor Access**: Check logs regularly for unauthorized attempts
4. **Use HTTPS**: Always use SSL/TLS even for internal traffic

## Troubleshooting

### Still Getting 401 Unauthorized
1. Check if your IP is correctly whitelisted
2. Verify nginx was reloaded after changes
3. Check for typos in IP addresses
4. Look for conflicting auth configurations

### Docker Containers Can't Access
1. Find Docker network range: `docker network inspect bridge`
2. Add the subnet to whitelist (usually `172.17.0.0/16`)
3. Consider using `host` network mode for testing

### Debugging Access
```bash
# Check what IP nginx sees
tail -f /var/log/nginx/kaut.to-access.log | grep -E '(401|200)'

# Test with specific IP
curl -H "X-Real-IP: 127.0.0.1" https://kaut.to/
```

## Example: Complete Site Configuration

```nginx
server {
    listen 443 ssl;
    server_name kaut.to;
    
    # Default: require auth OR whitelist
    location / {
        satisfy any;
        include /etc/nginx/snippets/ip-whitelist.conf;
        auth_basic "Restricted";
        auth_basic_user_file /etc/nginx/auth/.htpasswd;
        try_files $uri $uri/ =404;
    }
    
    # API: same protection
    location /api {
        satisfy any;
        include /etc/nginx/snippets/ip-whitelist.conf;
        auth_basic "API Access";
        auth_basic_user_file /etc/nginx/auth/.htpasswd;
        proxy_pass http://localhost:8001;
    }
    
    # Public endpoint: no auth
    location /health {
        auth_basic off;
        return 200 "OK";
    }
}
```

## Create Reusable Whitelist

Save common IPs in `/etc/nginx/snippets/ip-whitelist.conf`:
```nginx
# Server itself
allow 127.0.0.1;
allow ::1;
allow 157.180.28.186;

# Docker networks
allow 172.16.0.0/12;

# Deny others
deny all;
```

Then include in any location:
```nginx
location /protected {
    satisfy any;
    include /etc/nginx/snippets/ip-whitelist.conf;
    auth_basic "Protected";
    auth_basic_user_file /etc/nginx/auth/.htpasswd;
}
```