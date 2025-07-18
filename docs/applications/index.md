# Applications

This section documents the various applications and tools in the kaut.to ecosystem.

## Core Tools

### [JTools Testing Toolkit](jtools-testing-toolkit.md)
Unified testing framework for all jtools components supporting Python, JavaScript, and Bash tests.

### JTools Suite
Command-line tools for productivity:

- **jcommit** - Conventional commit helper
- **px** - Perplexity AI search integration
- **ft** - Web content fetcher with screenshot capability
- **gtask** - Google Tasks CLI

## Web Applications

### [Shifts Schedule Manager](/applications/shifts/)
Web-based shift scheduling application with:
- Visual grid interface
- Multiple shift types (W, R, X, O)
- Export functionality
- File-based storage backend

### [PAI Dashboard](/applications/pai-dashboard/)
Personal AI Assistant web interface featuring:
- Task management
- Email monitoring
- System status
- Real-time updates

### [Kaut.to Pastebin](/applications/pastebin/)
Secure file and text sharing service:
- String/text snippets
- File uploads
- URL shortening
- Basic authentication

## Backend Services

### Task API
RESTful API service for task management:
- Port: 8001
- Endpoints: /tasks, /projects
- Google Tasks integration

### Tools API
API service for jtools functionality:
- Port: 8002
- Perplexity search endpoint
- Fetch service endpoint

### Shifts Backend
File-based storage for shifts application:
- Port: 8003
- RESTful CRUD operations
- JSON file storage

## System Services

### Morning Brief
Automated daily briefing system:
- Runs at 6 AM daily
- Email summary
- Calendar events
- Task overview

### Email Monitor
Multi-account email monitoring:
- Real-time inbox monitoring
- Intelligent filtering
- Slack notifications

### Cookie Auth Service
Centralized authentication portal:
- Port: 8091
- Shared cookie management
- Basic auth integration

## Development Tools

### [MkDocs Documentation](https://docs.kaut.to)
This documentation site powered by MkDocs Material:
- Auto-build every 5 minutes
- GitHub integration
- Search functionality

### Context Management (CAG)
Cumulative Aggregated Guidance system:
- Living knowledge documents
- Structured configuration
- AI-optimized context

## Monitoring & Maintenance

### Heartbeat Monitor
System health monitoring:
- Service status checks
- Uptime tracking
- Alert notifications

### Token Manager
OAuth token management:
- Automatic refresh
- Multi-account support
- Secure storage

## Integration Points

### Slack Integration
Multi-channel notifications:
- General updates
- Email alerts
- System monitoring

### Google Workspace
Deep integration with Google services:
- Gmail API
- Google Tasks
- Google Sheets
- Service account authentication

## Quick Links

- [Architecture Overview](/architecture/)
- [Operations Guide](/operations/)
- [API Documentation](/api/)
- [Development Guides](/guides/)