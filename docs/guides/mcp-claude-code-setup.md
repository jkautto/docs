# PAI MCP Toolkit Setup with Claude Code

Complete guide for setting up the PAI MCP (Model Context Protocol) Toolkit with local Claude Code CLI.

## Overview

The PAI MCP Toolkit provides powerful automation tools for:
- **Task Management**: Create, list, and manage tasks across Google accounts
- **Email Operations**: Search, read, and manage Gmail across multiple accounts
- **Calendar Access**: View events and manage calendars with service account authentication
- **Slack Integration**: Send messages to configured channels
- **File Operations**: Upload files to various destinations
- **Web Fetching**: Download and process web content with screenshots

**Current Version**: v1.1.0  
**MCP Server**: mcp.kaut.to (port 8003)  
**Authentication**: Basic auth (kaut:to)

## Prerequisites

- Claude Code CLI installed and configured
- Network access to kaut.to services
- Basic understanding of MCP (Model Context Protocol)

## Installation

### Method 1: SSE Connection (Recommended)
```bash
# Add MCP server using Server-Sent Events
claude mcp add-server \
  --name "pai-toolkit" \
  --url "https://mcp.kaut.to/sse" \
  --auth-type basic \
  --username kaut \
  --password to
```

### Method 2: HTTP Connection
```bash
# Add MCP server using HTTP
claude mcp add-server \
  --name "pai-toolkit" \
  --url "https://mcp.kaut.to" \
  --auth-type basic \
  --username kaut \
  --password to
```

### Verify Installation
```bash
# List configured MCP servers
claude mcp list-servers

# Test connection
claude mcp test-connection pai-toolkit
```

## Available Tools

### 1. Task Management (`tasks_multi`)
Create and manage tasks across multiple Google accounts.

```bash
# Example usage through Claude Code
claude chat --mcp pai-toolkit
> Create a task "Review quarterly reports" for the xwander account
```

**Status**: ✅ Fully operational  
**Accounts**: personal, xwander, accolade  
**Authentication**: Service account (pre-configured)

### 2. Email Operations (`gmail_multi`)
Search, read, and manage Gmail across multiple accounts.

```bash
# Example usage
> Search for emails about "project update" in all accounts
> Read the latest email from john@company.com
```

**Status**: ⚠️ Requires OAuth re-authentication  
**Accounts**: personal, xwander, accolade  
**Note**: OAuth tokens may need refresh for some accounts

### 3. Calendar Access (`calendar_multi`)
View calendar events with advanced service account authentication.

```bash
# Example usage
> Show today's calendar events for xwander account
> Check if I'm free tomorrow at 2 PM
```

**Status**: ✅ Fully operational via service account  
**Accounts**: personal, xwander, accolade  
**Authentication**: Service account (shared calendar access)

### 4. Slack Integration (`slack_sender`)
Send messages to configured Slack channels.

```bash
# Example usage
> Send a message to #pai channel: "Task completed successfully"
> Notify the team about the deployment in #general
```

**Status**: ✅ Operational  
**Channels**: #pai, #pai-notifications, #pai-verbose, #general  
**Authentication**: Webhook-based

### 5. File Upload (`file_uploader`)
Upload files to various destinations including pastebin.

```bash
# Example usage
> Upload this screenshot to pastebin
> Save this log file for later reference
```

**Status**: ✅ Operational  
**Destinations**: Pastebin (pb.kaut.to), local storage  
**Features**: Automatic URL generation, metadata tracking

## Configuration

### Environment Variables
The MCP server is pre-configured with necessary credentials. No local environment setup required.

### Authentication Status
- ✅ **Tasks**: Service account authentication working
- ⚠️ **Gmail**: May require OAuth refresh for some accounts
- ✅ **Calendar**: Service account with shared access
- ✅ **Slack**: Webhook authentication configured
- ✅ **File Upload**: Pre-configured endpoints

## Testing the Connection

### Basic Connection Test
```bash
# Test if MCP server responds
curl -u kaut:to https://mcp.kaut.to/health

# Expected response: {"status": "healthy", "version": "1.1.0"}
```

### Tool-Specific Tests

#### Test Task Creation
```bash
claude chat --mcp pai-toolkit
> Create a test task "MCP connection test" for personal account
```

#### Test Calendar Access
```bash
> Show today's events for xwander calendar
```

#### Test Slack Integration
```bash
> Send a test message to #pai-verbose channel
```

## Authentication Setup

### Gmail OAuth Re-authentication
If Gmail tools return authentication errors:

1. **Contact System Administrator**: OAuth tokens are managed server-side
2. **Account-Specific Issues**: Mention which account (personal/xwander/accolade) needs refresh
3. **Temporary Workaround**: Use calendar and task tools which use service account authentication

### Calendar Service Account
Calendar access uses service account authentication:
- ✅ **xwander**: Full access configured
- ✅ **personal**: Read access available
- ⚠️ **accolade**: May need additional sharing permissions

### Slack Webhook Verification
If Slack messages fail to send:
1. Verify channel exists: #pai, #pai-notifications, #pai-verbose, #general
2. Check webhook endpoint is responsive
3. Test with simple message first

## Usage Examples

### Daily Workflow Integration

#### Morning Routine
```bash
claude chat --mcp pai-toolkit
> Show today's calendar events for all accounts
> List my current tasks
> Check for urgent emails from the last 24 hours
```

#### Task Management
```bash
> Create a task "Prepare presentation slides" due tomorrow for xwander account
> List all overdue tasks
> Mark task as completed: "Review MCP documentation"
```

#### Communication
```bash
> Send update to #pai channel: "MCP toolkit documentation completed"
> Upload this screenshot to pastebin and share the URL
```

### Project Coordination
```bash
> Search emails for "project alpha" in xwander account
> Create calendar event "Project Alpha Review" for Friday 2 PM
> Send summary to #general channel
```

## Troubleshooting

### Common Issues

#### Connection Refused
```bash
# Check server status
curl -u kaut:to https://mcp.kaut.to/health
```
**Solution**: Verify network access to kaut.to domain

#### Authentication Failed
- **Gmail**: OAuth token needs refresh (contact admin)
- **Calendar**: Service account permissions issue
- **Slack**: Webhook endpoint changed

#### Tool Not Available
```bash
# List available tools
claude mcp list-tools pai-toolkit
```
**Solution**: Verify server connection and tool registration

### Debug Mode
```bash
# Enable verbose logging
claude mcp test-connection pai-toolkit --verbose

# Check MCP server logs
curl -u kaut:to https://mcp.kaut.to/logs
```

## Advanced Features

### Multi-Account Operations
All tools support account-specific operations:
- `personal`: joni.kautto@gmail.com (default)
- `xwander`: joni@xwander.fi
- `accolade`: joni@accolade.fi

### Batch Operations
```bash
> Create tasks for all accounts: "Review weekly reports"
> Search all email accounts for "urgent" messages from today
> Check calendar availability across all accounts for next week
```

### Integration Patterns
- **Morning Brief**: Combine calendar, tasks, and email checking
- **Project Updates**: Task creation + Slack notification + file upload
- **Meeting Prep**: Calendar check + email search + task creation

## Best Practices

### Efficiency Tips
1. **Batch Similar Operations**: Group calendar checks, task operations
2. **Use Specific Accounts**: Specify account when known
3. **Test Incrementally**: Start with simple operations

### Security Considerations
1. **Credential Management**: All credentials managed server-side
2. **Network Access**: Uses secure HTTPS connections
3. **Authentication**: Basic auth + service accounts where applicable

### Error Handling
1. **Graceful Degradation**: Use available tools if others fail
2. **Retry Logic**: Some operations may need retry
3. **Fallback Methods**: Alternative tools for similar operations

## Support

### Getting Help
- **Documentation**: https://docs.kaut.to
- **MCP Server Status**: https://mcp.kaut.to/health
- **Tool Status**: Check individual tool responses

### Reporting Issues
1. Include specific error messages
2. Mention which tool/account combination
3. Provide steps to reproduce

## Version History

### v1.1.0 (Current)
- Multi-account support for all tools
- Service account authentication for calendar
- Enhanced error handling
- Improved tool descriptions

### v1.0.0
- Initial MCP server implementation
- Basic tool set (tasks, gmail, calendar, slack, file_uploader)
- HTTP and SSE connection support

---

**Next Steps**: After setup, try the [Daily Workflow Examples](#daily-workflow-integration) to get familiar with the toolkit capabilities.