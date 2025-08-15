# Troubleshooting Guide

Common issues and their solutions when implementing MCP servers with Claude.ai.

!!! warning "Debug First"
    Always check logs first: `sudo journalctl -u your-mcp-service -f`

## Connection Issues

### "Error connecting to MCP server" in Claude.ai

#### Common Causes & Solutions

**Server not running:**
```bash
sudo systemctl status mcp-hello
sudo systemctl restart mcp-hello
```

**Wrong port configuration:**
```bash
# Check server port
sudo netstat -tlnp | grep python

# Verify nginx proxy_pass matches
grep proxy_pass /etc/nginx/sites-available/mcp.yourdomain.com
```

**HTTP Basic Auth blocking:**
```bash
# Remove any auth_basic from nginx config
grep -i auth_basic /etc/nginx/sites-available/mcp.yourdomain.com
# Should return nothing
```

### "502 Bad Gateway" Error

**Server not responding:**
```bash
# Test server directly
curl http://127.0.0.1:8087/mcp/

# Check server logs
sudo journalctl -u mcp-hello -n 50
```

**IPv6 connection issues:**
```bash
# Verify nginx uses IPv4
grep proxy_pass /etc/nginx/sites-available/mcp.yourdomain.com
# Should be: proxy_pass http://127.0.0.1:8087;
```

### "404 Not Found" Error

**Wrong URL path:**
```bash
# Correct: https://mcp.yourdomain.com/mcp/
# Wrong: https://mcp.yourdomain.com/mcp (no trailing slash)
```

## CORS Issues

### Test CORS headers:
```bash
curl -H "Origin: https://claude.ai" \
     -H "Access-Control-Request-Method: POST" \
     -X OPTIONS \
     https://mcp.yourdomain.com/mcp/
```

### Missing CORS headers solution:
```nginx
add_header 'Access-Control-Allow-Origin' 'https://claude.ai' always;
add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
add_header 'Access-Control-Allow-Headers' 'Content-Type, Authorization, Last-Event-ID' always;

if ($request_method = 'OPTIONS') {
    return 204;
}
```

## Tool Issues

### Tools not appearing in Claude.ai

**Test tools endpoint:**
```bash
curl -X POST https://mcp.yourdomain.com/mcp/ \
     -H "Content-Type: application/json" \
     -d '{"jsonrpc":"2.0","method":"tools/list","id":1}'
```

**Verify tool registration:**
```python
@app.list_tools()
async def list_tools() -> list[types.Tool]:
    return [
        types.Tool(
            name="hello",
            description="Say hello",
            inputSchema={"type": "object", "properties": {}}
        )
    ]
```

## Quick Debug Commands

```bash
# Service status
sudo systemctl status mcp-hello

# Recent logs
sudo journalctl -u mcp-hello -n 20

# Test endpoint
curl -I https://mcp.yourdomain.com/mcp/

# Monitor connections
sudo tail -f /var/log/nginx/mcp.yourdomain.com.access.log
```

## Performance Issues

### High CPU usage:
```bash
# Monitor process
top -p $(pgrep -f mcp-server)

# Check for infinite loops
sudo journalctl -u mcp-hello -f | grep ERROR
```

### Memory leaks:
```python
# Add memory monitoring
import gc
gc.collect()  # Force garbage collection
```

For more detailed troubleshooting, see the [Deep Guide](deep-guide.md).