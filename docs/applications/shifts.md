# Shifts Application

## Overview

The Shifts application is a modular shift scheduling system designed for managing team schedules across multiple projects. Built with a focus on simplicity and reliability, it provides an intuitive interface for scheduling work shifts, remote duties, and time off.

**Live URL**: [https://kaut.to/shifts/](https://kaut.to/shifts/)  
**Repository**: [https://github.com/jkautto/shifts](https://github.com/jkautto/shifts)  
**Version**: v2.1.0

## Key Features

### Current Features (v2.1.0)
- **Interactive Grid Interface**: Click-and-edit shift scheduling
- **Paint Mode**: Quick assignment of shifts by clicking and dragging
- **Server-Side Storage**: JSON file-based persistence with atomic writes
- **API Backend**: RESTful API with authentication
- **Local Storage Fallback**: Offline capability when server is unavailable
- **Export Functionality**: Download schedules as JSON
- **Summary Calculations**: Automatic shift counting and statistics

### Architecture

```
Frontend (Vanilla JS + Vite)
    ↓
Backend API (Express.js)
    ↓
File Storage (JSON)
```

## Quick Start

### Using the Application

1. **Access**: Navigate to [https://kaut.to/shifts/](https://kaut.to/shifts/)
2. **Authentication**: Use basic auth (kaut:to) to access
3. **Select Project**: Choose between Project Skyfire or Project Kaamanen
4. **Edit Shifts**: 
   - Click any cell to edit
   - Use paint mode for bulk assignments
   - Keyboard shortcuts: W (Work), R (Remote), X (Special), O (Off)
5. **Save**: Changes auto-save to server

### Roles

**Project Skyfire**
- **Captains**: Ossi, Aleksi, Jesse
- **Hub Coordinators**: Siiri, Mathilda

**Project Kaamanen**
- **Captains**: Joonas, Juhani, Aksu
- **Paramedics**: Niina, Emilia

### Shift Types

| Code | Type | Description | Color |
|------|------|-------------|--------|
| W | Working | Regular on-site shift | Blue |
| R | R-Duty | Remote work | Green |
| X | Xwander | Special assignment | Purple |
| O | Off | Day off | Gray |

## Technical Documentation

### Data Storage

Schedules are stored as JSON files on the server:

```
/srv/apps/shifts/data/schedules/
├── 2025-07-ProjectSkyfire.json
├── 2025-08-ProjectKaamanen.json
└── ...
```

**File Format**:
```json
{
  "PersonName": ["W", "W", "O", "R", "X", ...],
  "AnotherPerson": ["O", "W", "W", "R", "O", ...]
}
```

### API Endpoints

Base URL: `http://localhost:8003/api`

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/schedules` | List all schedules |
| GET | `/schedules?year=Y&month=M&project=P` | Get specific schedule |
| POST | `/schedules` | Create new schedule |
| PUT | `/schedules` | Update existing schedule |
| DELETE | `/schedules?year=Y&month=M&project=P` | Delete schedule |

**Authentication**: Basic Auth (joni:Penacova)

### Development Setup

```bash
# Clone repository
git clone https://github.com/jkautto/shifts.git
cd shifts

# Install dependencies
npm install
cd backend && npm install

# Run development servers
npm run dev          # Frontend (port 5173)
cd backend && npm start  # Backend (port 8003)

# Run tests
npm test
cd backend && npm test
```

## Architecture Details

### Frontend Structure
```
src/
├── components/      # UI components
│   ├── Schedule/   # Grid component
│   ├── Controls/   # Control panel
│   └── Summary/    # Statistics
├── services/       # Business logic
│   ├── storage.js  # API/localStorage
│   └── export.js   # Export functionality
└── config/         # Configuration
```

### Backend Structure
```
backend/
├── api/            # REST endpoints
├── middleware/     # Auth middleware
├── services/       # Storage service
└── tests/          # Test suite
```

## Best Practices

### Data Integrity
- **Atomic Writes**: Uses temp file + rename pattern
- **Validation**: Checks data structure before saving
- **Fallback**: LocalStorage when server unavailable

### Performance
- **Lightweight**: ~2KB per schedule file
- **Fast Loading**: Direct file reads
- **No Database**: Eliminates overhead

### Security
- **Authentication**: Basic auth on all endpoints
- **Path Sanitization**: Prevents directory traversal
- **Rate Limiting**: Protects against abuse

## Troubleshooting

### Common Issues

**Blank screen in production**:
- CSS not imported in JavaScript (Vite requirement)
- Solution: Import all CSS in `src/main.js`
- Ensure nginx serves from `/dist/` directory
- Check index.html references `/src/main.js` not built assets
- Fix Node.js-only code with `typeof process !== 'undefined'` checks

**Schedule not saving**:
- Check backend is running (port 8003)
- Verify authentication credentials
- Check browser console for errors

**Data not loading**:
- Ensure file exists in data/schedules/
- Check file permissions
- Verify JSON format is valid

**Paint mode not working**:
- Click paint button first to activate
- Ensure JavaScript is enabled
- Try refreshing the page

### Debug Commands

```bash
# Check backend logs
sudo journalctl -u shifts-backend -f

# Verify data files
ls -la /srv/apps/shifts/data/schedules/

# Test API directly
curl -u joni:Penacova http://localhost:8003/api/schedules

# Check file contents
cat /srv/apps/shifts/data/schedules/2025-07-ProjectSkyfire.json | jq
```

## Future Enhancements

### Planned Features
- Multi-user conflict resolution
- Real-time collaboration
- Mobile responsive design
- Backup rotation
- Auto-save with debouncing
- Import from CSV/Excel
- Shift templates
- Advanced reporting

### API v2 Considerations
- GraphQL endpoint
- WebSocket for real-time updates
- JWT authentication
- Versioned API endpoints

## Integration Points

### With PAI System
- Can be queried via PAI for schedule information
- Integrates with task management for shift-based tasks
- Available through PAI web dashboard

### With Other Tools
- Export data for analysis in spreadsheets
- API can be consumed by other services
- Webhook notifications (planned)

## Maintenance

### Regular Tasks
- Monitor disk usage in data/schedules/
- Backup schedule files weekly
- Review API logs for errors
- Update dependencies monthly

### Backup Strategy
```bash
# Manual backup
cp -r /srv/apps/shifts/data/schedules /backup/shifts/$(date +%Y%m%d)

# Automated backup (cron)
0 2 * * * tar -czf /backup/shifts/shifts-$(date +\%Y\%m\%d).tar.gz /srv/apps/shifts/data/schedules/
```

## Related Documentation

- [API Reference](/api/shifts/)
- [GitHub Workflow Guide](/guides/github-workflow/)
- [Development Standards](/guides/development-standards/)
- [Testing Guide](/guides/testing/)