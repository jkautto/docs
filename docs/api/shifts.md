# Shifts API Reference

## Overview

The Shifts API provides programmatic access to shift scheduling data. It follows RESTful principles and uses JSON for data exchange.

## Base Information

| Property | Value |
|----------|--------|
| Base URL | `https://kaut.to/api/shifts` |
| Protocol | HTTPS |
| Authentication | Basic Auth |
| Content-Type | `application/json` |

## Authentication

All endpoints require Basic Authentication:

```bash
# Using curl
curl -u joni:Penacova https://kaut.to/api/shifts/schedules

# Using JavaScript
const auth = btoa('joni:Penacova');
fetch('https://kaut.to/api/shifts/schedules', {
  headers: {
    'Authorization': `Basic ${auth}`
  }
});
```

## Data Models

### Schedule Object

```typescript
interface Schedule {
  year: number;
  month: number;
  project: string;
  data: ScheduleData;
}

interface ScheduleData {
  [personName: string]: ShiftType[];
}

type ShiftType = 'W' | 'R' | 'X' | 'O';
```

### Shift Types

| Code | Type | Description |
|------|------|-------------|
| `W` | Working | Regular on-site work shift |
| `R` | R-Duty | Remote work duty |
| `X` | Xwander | Special assignment |
| `O` | Off | Day off / Not working |

## Endpoints

### List All Schedules

Returns a list of all available schedules.

```http
GET /schedules
```

**Response** `200 OK`:
```json
[
  {
    "year": 2025,
    "month": 7,
    "project": "ProjectSkyfire"
  },
  {
    "year": 2025,
    "month": 8,
    "project": "ProjectKaamanen"
  }
]
```

**Example**:
```bash
curl -u joni:Penacova https://kaut.to/api/shifts/schedules
```

### Get Specific Schedule

Retrieves schedule data for a specific year, month, and project.

```http
GET /schedules?year={year}&month={month}&project={project}
```

**Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| year | number | Yes | Year (e.g., 2025) |
| month | number | Yes | Month (1-12) |
| project | string | Yes | Project name |

**Response** `200 OK`:
```json
{
  "Ossi": ["W", "W", "O", "R", "W", ...],
  "Aleksi": ["O", "W", "W", "O", "R", ...],
  "Jesse": ["R", "O", "W", "W", "X", ...]
}
```

**Response** `404 Not Found`:
```json
{
  "error": "Schedule not found"
}
```

**Example**:
```bash
curl -u joni:Penacova \
  "https://kaut.to/api/shifts/schedules?year=2025&month=7&project=ProjectSkyfire"
```

### Create New Schedule

Creates a new schedule. Fails if schedule already exists.

```http
POST /schedules
```

**Request Body**:
```json
{
  "year": 2025,
  "month": 9,
  "project": "NewProject",
  "data": {
    "Alice": ["W", "W", "R", "O", "X"],
    "Bob": ["O", "W", "W", "R", "O"]
  }
}
```

**Response** `201 Created`:
```json
{
  "message": "Schedule created successfully"
}
```

**Response** `400 Bad Request`:
```json
{
  "error": "Invalid schedule data"
}
```

**Response** `409 Conflict`:
```json
{
  "error": "Schedule already exists"
}
```

**Example**:
```bash
curl -u joni:Penacova \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "year": 2025,
    "month": 9,
    "project": "TestProject",
    "data": {
      "TestUser": ["W", "W", "O", "R", "X"]
    }
  }' \
  https://kaut.to/api/shifts/schedules
```

### Update Existing Schedule

Updates an existing schedule. Creates new if doesn't exist.

```http
PUT /schedules
```

**Request Body**:
```json
{
  "year": 2025,
  "month": 7,
  "project": "ProjectSkyfire",
  "data": {
    "Ossi": ["W", "W", "W", "W", "W"],
    "Aleksi": ["R", "R", "R", "R", "R"]
  }
}
```

**Response** `200 OK`:
```json
{
  "message": "Schedule updated successfully"
}
```

**Response** `201 Created`:
```json
{
  "message": "Schedule created successfully"
}
```

**Example**:
```bash
curl -u joni:Penacova \
  -X PUT \
  -H "Content-Type: application/json" \
  -d '{
    "year": 2025,
    "month": 7,
    "project": "ProjectSkyfire",
    "data": {
      "Ossi": ["R", "R", "R", "R", "R"]
    }
  }' \
  https://kaut.to/api/shifts/schedules
```

### Delete Schedule

Deletes a specific schedule.

```http
DELETE /schedules?year={year}&month={month}&project={project}
```

**Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| year | number | Yes | Year |
| month | number | Yes | Month |
| project | string | Yes | Project name |

**Response** `200 OK`:
```json
{
  "message": "Schedule deleted successfully"
}
```

**Response** `404 Not Found`:
```json
{
  "error": "Schedule not found"
}
```

**Example**:
```bash
curl -u joni:Penacova \
  -X DELETE \
  "https://kaut.to/api/shifts/schedules?year=2025&month=9&project=TestProject"
```

## Error Responses

### Authentication Error

**Status**: `401 Unauthorized`
```json
{
  "error": "Authentication required"
}
```

### Bad Request

**Status**: `400 Bad Request`
```json
{
  "error": "Missing required parameters"
}
```

### Internal Server Error

**Status**: `500 Internal Server Error`
```json
{
  "error": "Internal server error"
}
```

## Usage Examples

### JavaScript/TypeScript

```javascript
class ShiftsAPI {
  constructor(username, password) {
    this.baseURL = 'https://kaut.to/api/shifts';
    this.auth = btoa(`${username}:${password}`);
  }

  async request(url, options = {}) {
    const response = await fetch(`${this.baseURL}${url}`, {
      ...options,
      headers: {
        'Authorization': `Basic ${this.auth}`,
        'Content-Type': 'application/json',
        ...options.headers
      }
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }

    return response.json();
  }

  async getSchedule(year, month, project) {
    return this.request(`/schedules?year=${year}&month=${month}&project=${project}`);
  }

  async createSchedule(year, month, project, data) {
    return this.request('/schedules', {
      method: 'POST',
      body: JSON.stringify({ year, month, project, data })
    });
  }

  async updateSchedule(year, month, project, data) {
    return this.request('/schedules', {
      method: 'PUT',
      body: JSON.stringify({ year, month, project, data })
    });
  }

  async deleteSchedule(year, month, project) {
    return this.request(`/schedules?year=${year}&month=${month}&project=${project}`, {
      method: 'DELETE'
    });
  }
}

// Usage
const api = new ShiftsAPI('joni', 'Penacova');

// Get schedule
const schedule = await api.getSchedule(2025, 7, 'ProjectSkyfire');
console.log(schedule);

// Update schedule
await api.updateSchedule(2025, 7, 'ProjectSkyfire', {
  'Ossi': ['W', 'W', 'R', 'O', 'X']
});
```

### Python

```python
import requests
from requests.auth import HTTPBasicAuth
import json

class ShiftsAPI:
    def __init__(self, username='joni', password='Penacova'):
        self.base_url = 'https://kaut.to/api/shifts'
        self.auth = HTTPBasicAuth(username, password)
    
    def get_schedule(self, year, month, project):
        params = {'year': year, 'month': month, 'project': project}
        response = requests.get(
            f'{self.base_url}/schedules',
            params=params,
            auth=self.auth
        )
        response.raise_for_status()
        return response.json()
    
    def create_schedule(self, year, month, project, data):
        payload = {
            'year': year,
            'month': month,
            'project': project,
            'data': data
        }
        response = requests.post(
            f'{self.base_url}/schedules',
            json=payload,
            auth=self.auth
        )
        response.raise_for_status()
        return response.json()
    
    def update_schedule(self, year, month, project, data):
        payload = {
            'year': year,
            'month': month,
            'project': project,
            'data': data
        }
        response = requests.put(
            f'{self.base_url}/schedules',
            json=payload,
            auth=self.auth
        )
        response.raise_for_status()
        return response.json()

# Usage
api = ShiftsAPI()

# Get schedule
schedule = api.get_schedule(2025, 7, 'ProjectSkyfire')
print(json.dumps(schedule, indent=2))

# Update someone's schedule
api.update_schedule(2025, 7, 'ProjectSkyfire', {
    'Ossi': ['W'] * 30 + ['O'] * 45  # 30 days work, 45 days off
})
```

## Best Practices

### Error Handling
Always implement proper error handling for network and API errors:

```javascript
try {
  const schedule = await api.getSchedule(2025, 7, 'ProjectSkyfire');
} catch (error) {
  if (error.message.includes('404')) {
    console.log('Schedule not found');
  } else if (error.message.includes('401')) {
    console.log('Authentication failed');
  } else {
    console.error('Unexpected error:', error);
  }
}
```

### Data Validation
Validate shift data before sending:

```javascript
function validateShiftData(data) {
  const validShifts = ['W', 'R', 'X', 'O'];
  
  for (const [person, shifts] of Object.entries(data)) {
    if (!Array.isArray(shifts)) {
      throw new Error(`Invalid shifts for ${person}: must be an array`);
    }
    
    for (const shift of shifts) {
      if (!validShifts.includes(shift)) {
        throw new Error(`Invalid shift type: ${shift}`);
      }
    }
  }
  
  return true;
}
```

### Rate Limiting
Be mindful of API usage:
- Cache responses when possible
- Implement exponential backoff for retries
- Batch operations when feasible

## Storage Details

### File Location
Schedules are stored as JSON files:
```
/srv/apps/shifts/data/schedules/YYYY-MM-ProjectName.json
```

### File Format
```json
{
  "PersonName": ["shift1", "shift2", "shift3", ...],
  "AnotherPerson": ["shift1", "shift2", "shift3", ...]
}
```

### Atomic Writes
The API uses atomic write operations (write to temp file, then rename) to prevent data corruption during concurrent access.

## Related Documentation

- [Shifts Application Overview](/applications/shifts/)
- [Authentication Guide](/guides/authentication/)
- [API Overview](/api/)
- [GitHub Repository](https://github.com/jkautto/shifts)