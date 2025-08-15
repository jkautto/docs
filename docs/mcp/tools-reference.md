# MCP Tools Reference

Complete reference documentation for all PAI tools available through the MCP server. These tools integrate seamlessly with Claude Desktop to provide direct access to your personal productivity systems.

## Available Tools Overview

| Tool | Status | Description | Capabilities |
|------|--------|-------------|--------------|
| **task** | Active | Google Tasks management | Create, list, plan, complete |
| **note** | Active | Local note storage | Create, list, read with tags |
| **docs** | Active | docs.kaut.to integration | Read, write, search documentation |
| **email** | Planned | Gmail operations | Read, send, search emails |
| **calendar** | Planned | Calendar management | Events, scheduling, availability |

## Task Tool

The task tool provides complete Google Tasks management across multiple accounts, enabling seamless task creation, organization, and planning.

### Create Tasks

Create new tasks with automatic account routing and smart categorization.

**Endpoint**: `POST /tools/task/create`

**Parameters**:
- `description` (required): Task description
- `account` (optional): Target account (personal, xwander, accolade)

**Examples**:
```json
{
  "description": "Review quarterly budget proposal"
}

{
  "description": "Prepare Nordic expansion presentation",
  "account": "xwander"
}
```

**Claude Usage**:
```
User: "Create a task to review the Q1 budget"
Claude: [Uses task tool] Task created: "Review the Q1 budget"

User: "Add a task for my Xwander account to prepare the Nordic presentation"  
Claude: [Routes to xwander account] Task created for Xwander account
```

### List Tasks

Retrieve and display tasks with filtering options.

**Endpoint**: `POST /tools/task/list`

**Parameters**:
- `account` (optional): Filter by account (default: "all")
- `filter` (optional): Filter type (default: "today")

**Filter Options**:
- `today`: Tasks due today or overdue
- `week`: Tasks due this week
- `all`: All tasks

**Examples**:
```json
{
  "account": "all",
  "filter": "today"
}

{
  "account": "xwander",
  "filter": "all"
}
```

### Generate Daily Plans

Create structured 1-2-3 priority plans from current tasks.

**Endpoint**: `POST /tools/task/plan`

**Parameters**: None (analyzes current task load automatically)

**Claude Usage**:
```
User: "What's my daily plan?"
Claude: [Generates plan from current tasks] Here's your 1-2-3 priority plan for today...

User: "Show me my tasks"  
Claude: [Lists organized by account and priority]
```

### Multi-Account Support

Tasks are automatically routed to appropriate accounts based on:

1. **Explicit account parameter**: `"account": "xwander"`
2. **Context tags in description**: `"[accolade] Contract review"`
3. **Smart routing**: Based on content keywords and patterns
4. **Default routing**: Falls back to personal account

**Account Mapping**:
- **personal**: joni.kautto@gmail.com (default)
- **xwander**: joni@xwander.fi (business)
- **accolade**: joni@accolade.fi (client work)

## Note Tool

Local note storage system with tagging and search capabilities, perfect for quick thoughts, meeting notes, and reference material.

### Create Notes

Store notes locally on the PAI server with metadata.

**Endpoint**: `POST /tools/note/create`

**Parameters**:
- `content` (required): Note content/body
- `title` (optional): Note title (auto-generated if not provided)
- `tags` (optional): Array of tags for organization

**Examples**:
```json
{
  "content": "Meeting with Sarah went well. She approved the budget increase for Q2."
}

{
  "title": "Sarah Meeting - Budget Approval",
  "content": "Meeting notes with next steps and action items",
  "tags": ["meeting", "budget", "sarah", "q2"]
}
```

### List Notes

Browse all stored notes with metadata.

**Endpoint**: `POST /tools/note/list`

**Parameters**: None

### Read Notes

Retrieve full note content and metadata.

**Endpoint**: `POST /tools/note/read`

**Parameters**:
- `note_id` (required): Note ID to retrieve

## Documentation Tool

The docs tool provides complete integration with docs.kaut.to, enabling Claude Code to read, write, and manage documentation directly. This tool bridges the gap between local development and centralized documentation.

### List Documentation Files

Browse documentation directory structure and find files.

**Endpoint**: `POST /tools/docs/list`

**Parameters**:
- `directory` (optional): Directory path to list (default: root docs directory)
- `include_content` (optional): Include file content preview (default: false)

**Examples**:
```json
{
  "directory": "guides"
}

{
  "directory": "api",
  "include_content": true
}
```

**Response**:
```json
{
  "status": "success",
  "directory": "/srv/docs/docs/guides/",
  "files": [
    {
      "name": "getting-started.md",
      "path": "/srv/docs/docs/guides/getting-started.md",
      "size": 2048,
      "modified": "2025-01-13T10:30:00Z"
    }
  ]
}
```

**Claude Usage**:
```
User: "What documentation files are available?"
Claude: [docs.list] Here are all the documentation files organized by section...

User: "Show me the API documentation files"
Claude: [docs.list with directory="api"] Here are the API documentation files...
```

### Read Documentation

Access full content of any documentation file.

**Endpoint**: `POST /tools/docs/read`

**Parameters**:
- `file_path` (required): Path to documentation file
- `section` (optional): Specific section to extract

**Examples**:
```json
{
  "file_path": "guides/getting-started.md"
}

{
  "file_path": "api/tools-api.md",
  "section": "Authentication"
}
```

**Response**:
```json
{
  "status": "success",
  "file_path": "/srv/docs/docs/guides/getting-started.md",
  "content": "# Getting Started Guide\n\nWelcome to...",
  "metadata": {
    "title": "Getting Started Guide",
    "sections": ["Prerequisites", "Installation", "First Steps"]
  }
}
```

### Write Documentation

Create or update documentation files with automatic building.

**Endpoint**: `POST /tools/docs/write`

**Parameters**:
- `file_path` (required): Target file path
- `content` (required): File content
- `create_backup` (optional): Create backup before overwriting (default: true)
- `auto_build` (optional): Trigger documentation build (default: true)

**Examples**:
```json
{
  "file_path": "guides/new-feature.md",
  "content": "# New Feature Guide\n\nThis guide explains..."
}

{
  "file_path": "api/endpoint-reference.md", 
  "content": "# API Endpoint Reference\n\n## Authentication\n...",
  "create_backup": true,
  "auto_build": false
}
```

**Response**:
```json
{
  "status": "success",
  "file_path": "/srv/docs/docs/guides/new-feature.md",
  "action": "created",
  "backup_path": "/srv/docs/docs/guides/new-feature.md.backup.20250113103000",
  "build_triggered": true,
  "url": "https://docs.kaut.to/guides/new-feature/"
}
```

### Search Documentation

Find content across all documentation files.

**Endpoint**: `POST /tools/docs/search`

**Parameters**:
- `query` (required): Search query
- `type` (optional): Search type - "content", "titles", "both" (default: "both")
- `directory` (optional): Limit search to specific directory

**Examples**:
```json
{
  "query": "authentication"
}

{
  "query": "API endpoint",
  "type": "content",
  "directory": "api"
}
```

**Response**:
```json
{
  "status": "success",
  "query": "authentication",
  "results": [
    {
      "file": "api/tools-api.md",
      "title": "Tools API Reference",
      "matches": [
        {
          "line": 45,
          "content": "Authentication is required for all API endpoints...",
          "context": "## Authentication\n\nAuthentication is required..."
        }
      ]
    }
  ]
}
```

### Create Documentation Section

Create a new documentation section with proper structure.

**Endpoint**: `POST /tools/docs/create_section`

**Parameters**:
- `section_name` (required): Name of the new section
- `description` (required): Section description
- `files` (optional): Initial files to create

**Examples**:
```json
{
  "section_name": "integrations",
  "description": "Third-party integrations and APIs"
}

{
  "section_name": "tutorials",
  "description": "Step-by-step tutorials",
  "files": [
    {
      "name": "index.md",
      "content": "# Tutorials\n\nComprehensive tutorials..."
    }
  ]
}
```

### Get Documentation Structure

Retrieve the complete documentation site structure.

**Endpoint**: `POST /tools/docs/structure`

**Parameters**: None

**Response**:
```json
{
  "status": "success",
  "structure": {
    "root": "/srv/docs/docs/",
    "sections": [
      {
        "name": "guides",
        "files": ["getting-started.md", "ai-agent-onboarding.md"],
        "description": "How-to guides and tutorials"
      },
      {
        "name": "api", 
        "files": ["tools-api.md", "task-api.md"],
        "description": "API documentation and references"
      }
    ]
  }
}
```

### Documentation Auto-Building

All write operations automatically trigger the documentation build process:

1. **File saved** to `/srv/docs/docs/`
2. **Build triggered** via `/srv/docs/build.sh`
3. **Site updated** at https://docs.kaut.to
4. **Changes live** within 5 minutes (or immediate if manual build)

### Integration Benefits

**For Local Claude Code**:
- Read any docs.kaut.to content directly
- Update documentation without server access
- Search entire knowledge base
- Maintain documentation during development

**For Documentation Workflow**:
- Real-time updates from any Claude Code instance
- Consistent formatting and structure
- Automatic backup and version control
- Integrated build process

**Usage Patterns**:
```
# Research existing documentation
User: "What documentation exists about API authentication?"
Claude: [docs.search] Found authentication docs in 3 files...

# Update documentation during development
User: "Document the new webhook endpoint we just created"
Claude: [docs.write] I've added documentation for the webhook endpoint...

# Create comprehensive guides
User: "Create a tutorial for setting up the PAI system"
Claude: [docs.create_section] I'll create a new tutorials section...
         [docs.write] Added comprehensive setup tutorial...
```

## Upcoming Tools

### Email Tool (Planned)

Full Gmail integration across multiple accounts.

**Planned Capabilities**:
- **Read emails**: Search and retrieve email content
- **Send emails**: Compose and send messages
- **Email management**: Archive, label, delete
- **Multi-account**: Support for all configured accounts

### Calendar Tool (Planned)

Calendar management and scheduling assistance.

**Planned Capabilities**:
- **View calendar**: Today's schedule, upcoming events
- **Create events**: Schedule meetings and appointments
- **Check availability**: Find free time slots

## Tool Usage Patterns

### Single Tool Operations

```
# Simple task creation
User: "Create a task to review the contract"
Claude: [task.create] Task created successfully

# Quick note taking  
User: "Note that the client prefers email over Slack"
Claude: [note.create] Note saved with timestamp
```

### Multi-Tool Workflows

```
# Planning and note-taking session
User: "Help me plan my day and take notes on priorities"
Claude: [task.plan] Here's your daily plan...
       [note.create] I've also created a note with today's priorities
```

### Voice Mode Integration

```
# Voice task management
User: "Show me my tasks and create a new one for the presentation"
Claude: [task.list] "You have 3 tasks today..."
       [task.create] "I've added the presentation task"
```

## Error Handling

### Common Error Responses

**Authentication Errors**:
```json
{
  "status": "error", 
  "error": "Invalid authentication",
  "code": 401
}
```

**Tool Execution Errors**:
```json
{
  "status": "error",
  "error": "Failed to create task: Google API quota exceeded",
  "tool": "task",
  "method": "create"
}
```

Claude automatically handles common errors with retry logic and user feedback.

## Rate Limiting & Performance

### Current Limits
- **Requests per minute**: 60
- **Concurrent operations**: 5
- **Response timeout**: 30 seconds

### Performance Optimization
- Response caching for frequently accessed data
- Batch operations for multiple tasks/notes
- Connection pooling to reduce latency

## Security & Privacy

### Data Handling
- **Task data**: Stored in Google Tasks (encrypted by Google)
- **Note data**: Stored locally on PAI server
- **Transmission**: HTTP Basic Auth (HTTPS when SSL ready)
- **Audit logs**: All tool usage logged for security

### Access Control
- Authentication required for all tool endpoints
- Tools respect underlying service permissions
- Rate limiting prevents abuse

!!! tip "Getting Started"
    Start with simple task and note operations to get familiar with the tools. More advanced features and additional tools will be available soon.

!!! info "Tool Requests"
    Need a specific tool or feature? The MCP server is designed for easy extension. Contact the development team with requirements.