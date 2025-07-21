# API Reference

## Overview

The kaut.to ecosystem provides several RESTful APIs for programmatic access to various services. All APIs use JSON for data exchange and require authentication.

## Available APIs

### [Shifts API](./shifts.md)
**Base URL**: `https://kaut.to/api/shifts`  
**Port**: 8003  
**Authentication**: Basic Auth

Manage shift schedules for teams across multiple projects.

**Key Features**:
- CRUD operations for shift schedules
- File-based JSON storage
- Atomic writes for data integrity
- Support for multiple projects

**Endpoints**:
- `GET /schedules` - List all schedules
- `GET /schedules?year=Y&month=M&project=P` - Get specific schedule
- `POST /schedules` - Create new schedule
- `PUT /schedules` - Update schedule
- `DELETE /schedules?year=Y&month=M&project=P` - Delete schedule

---

### [Tools API](./tools.md)
**Base URL**: `https://kaut.to/api`  
**Port**: 8002  
**Authentication**: Basic Auth

Access to jtools functionality via API.

**Key Features**:
- Perplexity AI search integration
- Web content fetching
- Screenshot generation
- URL processing

**Endpoints**:
- `POST /search` - Perplexity search
- `POST /fetch` - Fetch and process URLs
- `GET /status` - API health check

---

### [Task API](./task.md)
**Base URL**: `http://localhost:8001`  
**Port**: 8001  
**Authentication**: None (localhost only)

Task management and Google Tasks integration.

**Key Features**:
- Task CRUD operations
- Project management
- Google Tasks sync
- Priority and status tracking

**Endpoints**:
- `GET /tasks` - List all tasks
- `POST /tasks` - Create new task
- `PUT /tasks/:id` - Update task
- `DELETE /tasks/:id` - Delete task
- `GET /projects` - List projects

---

### [PAI Web API](./pai-web.md)
**Base URL**: `https://kaut.to/api/pai`  
**Port**: 8080  
**Authentication**: Basic Auth

Backend for PAI dashboard and integrations.

**Key Features**:
- Real-time status updates
- Email monitoring stats
- System health metrics
- Claude CLI integration

**Endpoints**:
- `GET /status` - System status
- `GET /emails/unread` - Unread email count
- `POST /claude/message` - Send to Claude
- `GET /metrics` - System metrics

## Common Patterns

### Authentication

Most APIs use Basic Authentication:

```bash
# Using curl
curl -u username:password https://kaut.to/api/endpoint

# Using JavaScript
const auth = btoa('username:password');
fetch('https://kaut.to/api/endpoint', {
  headers: {
    'Authorization': `Basic ${auth}`
  }
});
```

### Error Handling

All APIs return consistent error responses:

```json
{
  "error": "Error message",
  "code": "ERROR_CODE",
  "details": {}
}
```

Common HTTP status codes:
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `404` - Not Found
- `409` - Conflict
- `500` - Internal Server Error

### Request/Response Format

All APIs use JSON:

```bash
# Request
curl -X POST https://kaut.to/api/endpoint \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}'

# Response
{
  "status": "success",
  "data": {}
}
```

## Best Practices

### 1. Rate Limiting
- Be mindful of API usage
- Implement exponential backoff
- Cache responses when possible

### 2. Error Handling
```javascript
try {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`HTTP ${response.status}`);
  }
  const data = await response.json();
} catch (error) {
  console.error('API Error:', error);
}
```

### 3. Data Validation
Always validate data before sending:
```javascript
function validateData(data) {
  // Check required fields
  // Validate data types
  // Ensure constraints are met
}
```

### 4. Security
- Never hardcode credentials
- Use environment variables
- Implement proper CORS policies
- Validate all inputs

## API Development Guidelines

### Creating New APIs

1. **Follow RESTful principles**
   - Use proper HTTP methods
   - Return appropriate status codes
   - Keep endpoints predictable

2. **Documentation**
   - Document all endpoints
   - Provide examples
   - List all parameters
   - Show error responses

3. **Consistency**
   - Use consistent naming
   - Standard error format
   - Common authentication

4. **Testing**
   - Unit tests for all endpoints
   - Integration tests
   - Load testing for performance

### Versioning

Consider API versioning for breaking changes:
- URL versioning: `/api/v2/endpoint`
- Header versioning: `API-Version: 2`
- Query parameter: `?version=2`

## Quick Reference

| API | Port | Auth | Primary Use |
|-----|------|------|-------------|
| Shifts | 8003 | Basic | Shift scheduling |
| Tools | 8002 | Basic | AI tools access |
| Task | 8001 | None | Task management |
| PAI Web | 8080 | Basic | Dashboard backend |

## Related Documentation

- [Architecture Overview](/architecture/)
- [Authentication Guide](/guides/authentication/)
- [Development Setup](/guides/development-setup/)
- [Security Best Practices](/architecture/security/)