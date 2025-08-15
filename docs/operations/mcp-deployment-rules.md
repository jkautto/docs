# MCP Deployment Rules (MANDATORY)

**Critical Discovery Date**: August 15, 2025  
**Priority**: CRITICAL - Prevents #1 cause of MCP deployment failures

## The 307 Redirect Bug

### Root Cause
Claude.ai accesses `/mcp` but Starlette `Mount("/mcp", app=handle_mcp)` only handles `/mcp/`, causing 307 redirects that break connections completely.

### Evidence Pattern
```
nginx logs: "POST /mcp HTTP/1.1" 307 0 "-" "Claude-User"
```

## MANDATORY Deployment Checklist

### 1. Server Code Requirements (CRITICAL)
- ✅ **ALWAYS**: `Mount("/", app=handle_mcp)` 
- ❌ **NEVER**: `Mount("/mcp", app=handle_mcp)`
- ✅ nginx proxy: `proxy_pass http://127.0.0.1:PORT/;`

### 2. Validation Tests (MANDATORY)
```bash
# Test both paths return HTTP 400 (not 307)
curl -H "Accept: text/event-stream" https://mcp.domain.com/mcp
curl -H "Accept: text/event-stream" https://mcp.domain.com/mcp/

# Expected response:
{"jsonrpc":"2.0","id":"server-error","error":{"code":-32600,"message":"Bad Request: Missing session ID"}}
```

### 3. Log Monitoring (MANDATORY)
```bash
# Check for Claude.ai connections
tail -f /var/log/nginx/mcp.domain.com.access.log | grep Claude-User

# Detect 307 redirects (should be EMPTY)
grep "307.*Claude-User" /var/log/nginx/mcp.domain.com.access.log
```

### 4. Health Patterns
- ✅ **Working**: `"POST /mcp HTTP/1.1" 200` in nginx logs
- ❌ **Broken**: `"POST /mcp HTTP/1.1" 307` in nginx logs

## DevOps Enforcement

### Pre-Deployment Code Review
```bash
# Should return EMPTY (no path-specific mounts)
grep -n "Mount(" /path/to/mcp/server.py | grep -v 'Mount("/"'
```

### Rollback Triggers
- Any 307 redirects detected
- Connection failures from Claude.ai
- Path-specific mounts in code

## Working Example Pattern

```python
from mcp.server.lowlevel import Server
from mcp.server.streamable_http_manager import StreamableHTTPSessionManager
from starlette.applications import Starlette
from starlette.routing import Mount

app = Server("server-name")

# Add tools...

def create_app():
    session_manager = StreamableHTTPSessionManager(app=app, json_response=False)
    async def handle_mcp(scope, receive, send):
        await session_manager.handle_request(scope, receive, send)
    
    # 🚨 MANDATORY: ROOT MOUNT ONLY
    return Starlette(routes=[Mount("/", app=handle_mcp)])  # NO PATH CONFLICTS
```

## Historical Context

This rule was discovered after multiple MCP deployment failures where:
1. `curl` tests showed "Missing session ID" (appeared working)
2. Claude.ai connections failed with generic errors
3. Root cause was 307 redirects from path conflicts
4. Fixed by changing to root mount pattern

**Priority**: This is the #1 preventable cause of MCP deployment failures.