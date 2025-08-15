# MCP Server Setup

The PAI MCP server provides HTTP-based access to PAI tools and capabilities, implementing the Model Context Protocol standard for Claude Code integration.

## Server Architecture

The server is built using FastAPI and provides these key features:

- **HTTP Basic Authentication**: Secure access with kaut:to credentials
- **RESTful API endpoints**: Standard HTTP endpoints for tool operations
- **CORS support**: Enables browser-based MCP clients
- **Request logging**: All operations logged for security
- **Rate limiting**: 60 requests per minute protection

## Server Location
- **Domain**: mcp.kaut.to (HTTP only - SSL pending)
- **Port**: 3000
- **Service Path**: `/srv/pai/mcp_server/`
- **Executable**: `mcp_server.py`

## Available Endpoints

### Core Endpoints
- `GET /` - Server capabilities and protocol info (auth required)
- `GET /health` - Health check (no auth required)
- `GET /tools` - List available tools (auth required)

### Tool Endpoints
- `POST /tools/task/{method}` - Task operations (create, list, plan, complete)
- `POST /tools/note/{method}` - Note operations (create, list, read)
- `POST /tools/execute` - Generic tool execution endpoint

## Authentication

All endpoints except `/health` require HTTP Basic Authentication:
- **Username**: kaut
- **Password**: to

Same credentials used across all kaut.to services.

## Tool Integration

Tools are executed via subprocess calls to existing PAI toolkit:
- Task operations call `/srv/pai/toolkit/task.py`
- Note operations use local file system storage
- Multi-account support for Google services

## Monitoring & Logs

- **Log File**: `/srv/pai/logs/mcp_server.log`
- **Health Check**: `curl http://mcp.kaut.to:3000/health`
- **Service Status**: Check via systemctl or process monitoring

## Configuration

Server reads configuration from:
- `/srv/pai/mcp_server/mcp_capabilities.json` - Tool definitions
- `/srv/.env` and `/var/www/.env` - Environment variables
- Service account credentials for Google APIs

## Security

- HTTP Basic Auth protects all tool endpoints
- Rate limiting prevents abuse (60 req/min)
- Audit logging tracks all tool usage
- CORS configured for secure browser access

For detailed technical implementation, see the source code at `/srv/pai/mcp_server/mcp_server.py`.