# Quick Start Guide

Get your first MCP server running with Claude.ai in 5 minutes.

!!! tip "Minimal Setup"
    This guide creates the simplest possible working MCP server. No authentication, no complexity - just the essentials to establish a connection with Claude.ai.

## Prerequisites

- Linux server with Python 3.8+
- nginx with SSL certificate
- Subdomain (e.g., `mcp.yourdomain.com`)
- Basic command line knowledge

## Step 1: Install Dependencies

```bash
pip3 install mcp fastmcp starlette uvicorn
```

## Step 2: Create Minimal Server

!!! danger "CRITICAL: Avoid 307 Redirect Bug"
    **MUST USE ROOT MOUNT** - Claude.ai accesses `/mcp` but Starlette `Mount("/mcp")` only handles `/mcp/`, causing 307 redirects that break the connection. Always use `Mount("/", app=handle_mcp)`.

Create `/srv/mcp-hello/server.py`:

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
app = Server("hello-mcp")

@app.call_tool()
async def call_tool(name: str, arguments: dict[str, Any]) -> list[types.ContentBlock]:
    if name == "hello":
        name_arg = arguments.get("name", "World")
        return [types.TextContent(type="text", text=f"Hello, {name_arg}!")]
    return [types.TextContent(type="text", text=f"Unknown tool: {name}")]

@app.list_tools()
async def list_tools() -> list[types.Tool]:
    return [types.Tool(name="hello", description="Say hello", inputSchema={"type": "object", "properties": {"name": {"type": "string"}}})]

def create_app():
    session_manager = StreamableHTTPSessionManager(app=app, json_response=False)
    async def handle_mcp(scope, receive, send):
        await session_manager.handle_request(scope, receive, send)
    async def lifespan(app):
        async with session_manager.run():
            yield
    # CRITICAL: Use root mount, not "/mcp" mount to avoid 307 redirects
    return Starlette(routes=[Mount("/", app=handle_mcp)], lifespan=lifespan)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(create_app(), host="0.0.0.0", port=8087)
```

## Step 3: Connect to Claude.ai

1. Go to Claude.ai → Settings → MCP Connectors
2. Add Custom Connector:
   - **URL**: `https://mcp.yourdomain.com/mcp/`
   - **Authentication**: None
3. Test with: "Use the hello tool to greet John"

!!! warning "Troubleshooting 307 Redirects"
    If Claude.ai can't connect, check nginx logs for `"POST /mcp HTTP/1.1" 307 0 "-" "Claude-User"`. This indicates the 307 redirect bug - ensure you're using `Mount("/", app=handle_mcp)` not `Mount("/mcp", app=handle_mcp)`.

For complete setup instructions, see the [Deep Guide](deep-guide.md).