# Working Code Examples

Complete, copy-paste ready examples for MCP server implementations.

!!! success "Verified Working"
    All examples are based on our verified working implementation at `mcp.kaut.to` and have been tested with Claude.ai.

## Minimal Hello World Server

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
    return [
        types.Tool(
            name="hello",
            description="Say hello to someone",
            inputSchema={
                "type": "object",
                "properties": {"name": {"type": "string"}},
                "required": []
            }
        )
    ]

def create_app():
    session_manager = StreamableHTTPSessionManager(app=app, json_response=False)
    async def handle_mcp(scope, receive, send):
        await session_manager.handle_request(scope, receive, send)
    async def lifespan(app):
        async with session_manager.run():
            yield
    return Starlette(routes=[Mount("/mcp", app=handle_mcp)], lifespan=lifespan)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(create_app(), host="0.0.0.0", port=8087)
```

## Multi-Tool Server

```python
#!/usr/bin/env python3
import logging
import time
from typing import Any
import mcp.types as types
from mcp.server.lowlevel import Server
from mcp.server.streamable_http_manager import StreamableHTTPSessionManager
from starlette.applications import Starlette
from starlette.routing import Mount

logging.basicConfig(level=logging.INFO)

class MultiToolServer:
    def __init__(self):
        self.app = Server("multi-tool-mcp")
        self.setup_tools()
    
    def setup_tools(self):
        @self.app.call_tool()
        async def call_tool(name: str, arguments: dict[str, Any]) -> list[types.ContentBlock]:
            if name == "hello":
                return await self.hello_tool(arguments)
            elif name == "time":
                return await self.time_tool(arguments)
            elif name == "calculator":
                return await self.calculator_tool(arguments)
            return [types.TextContent(type="text", text=f"Unknown tool: {name}")]
        
        @self.app.list_tools()
        async def list_tools() -> list[types.Tool]:
            return [
                types.Tool(name="hello", description="Say hello", inputSchema={"type": "object", "properties": {"name": {"type": "string"}}}),
                types.Tool(name="time", description="Get current time", inputSchema={"type": "object", "properties": {}}),
                types.Tool(name="calculator", description="Calculate math expression", inputSchema={"type": "object", "properties": {"expression": {"type": "string"}}, "required": ["expression"]})
            ]
    
    async def hello_tool(self, args: dict) -> list[types.ContentBlock]:
        name = args.get("name", "World")
        return [types.TextContent(type="text", text=f"Hello, {name}!")]
    
    async def time_tool(self, args: dict) -> list[types.ContentBlock]:
        current_time = time.strftime("%Y-%m-%d %H:%M:%S")
        return [types.TextContent(type="text", text=f"Current time: {current_time}")]
    
    async def calculator_tool(self, args: dict) -> list[types.ContentBlock]:
        expression = args.get("expression", "")
        try:
            result = eval(expression, {"__builtins__": {}})
            return [types.TextContent(type="text", text=f"{expression} = {result}")]
        except Exception as e:
            return [types.TextContent(type="text", text=f"Error: {str(e)}")]

def create_app():
    server = MultiToolServer()
    session_manager = StreamableHTTPSessionManager(app=server.app, json_response=False)
    
    async def handle_mcp(scope, receive, send):
        await session_manager.handle_request(scope, receive, send)
    
    async def lifespan(app):
        async with session_manager.run():
            yield
    
    return Starlette(routes=[Mount("/mcp", app=handle_mcp)], lifespan=lifespan)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(create_app(), host="0.0.0.0", port=8087)
```

## nginx Configuration Template

```nginx
server {
    listen 443 ssl http2;
    server_name mcp.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    # CORS Headers for Claude.ai
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

For more examples, see the [Deep Guide](deep-guide.md).