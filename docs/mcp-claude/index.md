# MCP & Claude.ai Integration

## Overview

Model Context Protocol (MCP) is Anthropic's standardized protocol for connecting external data sources and tools to Large Language Models like Claude. This documentation provides verified, working configurations for integrating MCP servers with Claude.ai.

!!! success "Verified Configuration"
    All documentation in this section is based on **verified working implementations** as of August 15, 2025. The configurations have been tested and confirmed to work with Claude.ai.

## What is MCP?

MCP enables Claude to access external tools, databases, and services in a secure, standardized way. Instead of Claude being limited to its training data, MCP allows it to:

- Access real-time data from APIs
- Interact with databases and file systems
- Execute custom business logic
- Integrate with third-party services

## Key Benefits

### For Developers
- **Standardized Protocol**: One protocol for all Claude integrations
- **Secure**: Built-in authentication and permission controls
- **Flexible**: Support for various transport mechanisms
- **Extensible**: Easy to add new tools and capabilities

### For Users
- **Enhanced Capabilities**: Claude can access external data and tools
- **Real-time Information**: Get current data, not just training data
- **Custom Workflows**: Automate complex business processes
- **Seamless Integration**: Tools appear natively in Claude conversations

## Quick Start Path

1. **[Quick Start Guide](quick-start.md)** - Get a basic server running in 5 minutes
2. **[Deep Implementation Guide](deep-guide.md)** - Complete technical setup
3. **[Working Examples](examples.md)** - Copy-paste implementations
4. **[Troubleshooting](troubleshooting.md)** - Solve common issues
5. **[Architecture Guide](architecture.md)** - Technical deep dive

## Working Implementation

We maintain a verified working MCP server at:
- **URL**: `https://mcp.kaut.to/mcp/`
- **Status**: ✅ Active and tested with Claude.ai
- **Authentication**: None (for simplicity)
- **Tools**: Hello World example

## Critical Success Factors

### ✅ Must Have
- **Clean subdomain**: No HTTP Basic Auth conflicts
- **Proper SSL**: Let's Encrypt or valid certificate
- **IPv4 configuration**: Avoid IPv6 connection issues
- **Correct CORS headers**: Allow claude.ai origin
- **Proper port mapping**: nginx to server consistency

### ❌ Common Pitfalls
- Using localhost instead of 127.0.0.1 in nginx
- Mixing authentication schemes initially
- Forgetting trailing slashes in URLs
- Improper CORS configuration
- Port conflicts with existing services

## Resources

### Official Documentation
- [Anthropic MCP Documentation](https://modelcontextprotocol.io/)
- [MCP SDK on GitHub](https://github.com/modelcontextprotocol)

### Our Implementation
- Source code: `/srv/mcp-hello/`
- Live server: `https://mcp.kaut.to/mcp/`
- System status: `sudo systemctl status mcp-hello`

---

*This documentation is maintained by the DAI/PAI team and reflects real-world deployment experience.*