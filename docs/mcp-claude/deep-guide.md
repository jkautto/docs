# Deep Implementation Guide

Complete technical guide for implementing production-ready MCP servers with Claude.ai integration.

!!! note "Prerequisites"
    This guide assumes you've completed the [Quick Start Guide](quick-start.md) and have a basic working MCP server.

## Production Server Template

!!! danger "CRITICAL: Root Mount Required"
    **MUST USE `Mount("/", app=handle_mcp)`** - Using `Mount("/mcp", app=handle_mcp)` causes 307 redirects that break Claude.ai connections. This is the #1 failure cause.

```python
#!/usr/bin/env python3
import logging
from typing import Any
import mcp.types as types
from mcp.server.lowlevel import Server
from mcp.server.streamable_http_manager import StreamableHTTPSessionManager
from starlette.applications import Starlette
from starlette.routing import Mount

logging.basicConfig(level=logging.INFO)

class ProductionMCPServer:
    def __init__(self):
        self.app = Server("production-mcp")
        self.setup_tools()
    
    def setup_tools(self):
        @self.app.call_tool()
        async def call_tool(name: str, arguments: dict[str, Any]) -> list[types.ContentBlock]:
            if name == "hello":
                return await self.hello_tool(arguments)
            elif name == "system_info":
                return await self.system_info_tool(arguments)
            return [types.TextContent(type="text", text=f"Unknown tool: {name}")]
        
        @self.app.list_tools()
        async def list_tools() -> list[types.Tool]:
            return [
                types.Tool(name="hello", description="Say hello", inputSchema={"type": "object", "properties": {"name": {"type": "string"}}}),
                types.Tool(name="system_info", description="Get system info", inputSchema={"type": "object", "properties": {}})
            ]
    
    async def hello_tool(self, args: dict) -> list[types.ContentBlock]:
        name = args.get("name", "World")
        return [types.TextContent(type="text", text=f"Hello, {name}! From production MCP server.")]
    
    async def system_info_tool(self, args: dict) -> list[types.ContentBlock]:
        import platform
        info = f"Platform: {platform.platform()}\nPython: {platform.python_version()}"
        return [types.TextContent(type="text", text=info)]

def create_app():
    server = ProductionMCPServer()
    session_manager = StreamableHTTPSessionManager(app=server.app, json_response=False)
    
    async def handle_mcp(scope, receive, send):
        await session_manager.handle_request(scope, receive, send)
    
    async def lifespan(app):
        async with session_manager.run():
            yield
    
    # CRITICAL: Use root mount to avoid 307 redirects that break Claude.ai
    return Starlette(routes=[Mount("/", app=handle_mcp)], lifespan=lifespan)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(create_app(), host="0.0.0.0", port=8087)
```

## nginx Configuration

```nginx
server {
    listen 443 ssl http2;
    server_name mcp.yourdomain.com;
    
    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;
    
    # CORS for Claude.ai
    add_header 'Access-Control-Allow-Origin' 'https://claude.ai' always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
    add_header 'Access-Control-Allow-Headers' 'Content-Type, Authorization, Last-Event-ID' always;
    
    if ($request_method = 'OPTIONS') {
        return 204;
    }
    
    location / {
        proxy_pass http://127.0.0.1:8087;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # SSE support
        proxy_buffering off;
        proxy_cache off;
        chunked_transfer_encoding off;
    }
}
```

## systemd Service

```ini
[Unit]
Description=MCP Server
After=network.target

[Service]
Type=simple
User=mcp
WorkingDirectory=/srv/mcp-server
ExecStart=/usr/bin/python3 /srv/mcp-server/server.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

For complete implementation details, see the [Examples](examples.md) section.