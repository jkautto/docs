# Local Claude Code Configuration

This guide walks you through configuring Claude Desktop on your MacBook to connect to the PAI MCP server, enabling direct access to PAI tools from your local Claude Code interface.

## Prerequisites

- Claude Desktop app installed (latest version)
- macOS 12+ (Monterey or later)
- Network access to mcp.kaut.to
- Basic auth credentials: kaut:to

## Configuration Steps

### 1. Locate Claude Desktop Config

Claude Desktop stores its configuration in your user's application support directory:

```bash
# Navigate to Claude Desktop config directory
cd ~/Library/Application\ Support/Claude/

# Create config file if it doesn't exist
touch claude_desktop_config.json
```

### 2. Basic MCP Server Configuration

Add the PAI MCP server to your configuration:

```json
{
  "mcp": {
    "servers": [
      {
        "name": "pai-mcp",
        "url": "http://mcp.kaut.to:3000",
        "auth": {
          "type": "basic",
          "username": "kaut",
          "password": "to"
        },
        "description": "PAI Personal AI Tools",
        "tools": ["task", "note"]
      }
    ],
    "settings": {
      "timeout": 30000,
      "retries": 3,
      "keepAlive": true
    }
  }
}
```

### 3. Testing the Connection

After updating the configuration:

1. Restart Claude Desktop completely
2. Open a new conversation
3. Test with: "Can you create a task for me to test MCP integration?"

You should see Claude use the MCP task tool to create the task.

## Common Configuration Issues

### File Permissions
Ensure Claude Desktop can read the configuration:

```bash
chmod 644 ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### JSON Syntax Validation
Validate your configuration file:

```bash
python3 -m json.tool ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### Network Connectivity
Test connection to MCP server:

```bash
# Test basic connectivity
curl http://mcp.kaut.to:3000/health

# Test with authentication
curl -u "kaut:to" http://mcp.kaut.to:3000/
```

## Security Considerations

Set restrictive permissions on the config file:

```bash
chmod 600 ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

The configuration contains authentication credentials, so protect it appropriately.

## Troubleshooting

### Connection Failures
1. Check network connectivity to mcp.kaut.to
2. Verify credentials are correct (kaut:to)  
3. Confirm server is running: `curl http://mcp.kaut.to:3000/health`
4. Restart Claude Desktop after config changes

### Authentication Errors
1. Double-check username/password in config
2. Ensure no extra spaces in credentials
3. Test authentication manually with curl

For more advanced configuration options and troubleshooting, see the full MCP documentation.