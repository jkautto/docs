# Kaut.to Pastebin v1.0 Specification

## Overview
A simple, internal pastebin tool for uploading and sharing files between Joni, DAI, and PAI. Accessible at https://kaut.to/pb with HTTP basic auth.

## Technical Stack Decision
After researching various approaches, I've chosen:
- **Backend**: Flask (simpler than FastAPI for this use case, plenty of examples)
- **Frontend**: Vanilla JS with Dropzone.js for drag & drop
- **Storage**: File system with JSON metadata (simple for MVP)
- **Server**: Gunicorn behind nginx proxy

## Architecture

### Directory Structure
```
/var/www/kaut.to/pb/
├── app.py                 # Main Flask application
├── requirements.txt       # Python dependencies
├── config.py             # Configuration settings
├── templates/
│   └── index.html        # Main upload interface
├── static/
│   ├── css/
│   │   └── style.css
│   └── js/
│       └── upload.js     # Drag/drop/paste logic
├── uploads/              # File storage
│   └── 2025/
│       └── 01/
│           └── 12/
│               └── original_filename.ext
├── thumbnails/           # Generated thumbnails
└── metadata.json         # File metadata storage
```

## Core Features (v1.0)

### 1. File Upload
- **Methods**: Drag & drop, click to browse, clipboard paste (Cmd+V)
- **Size Limit**: 500MB max, warning at 50MB
- **File Types**: Images (png, jpg, gif, webp), documents (pdf, txt), archives (zip)
- **Storage**: Original filenames in date-based folders

### 2. File Display
- **List**: Last 10 uploaded files
- **Info**: Filename, upload time, file size
- **URLs**: Internal path and public URL
- **Actions**: Copy URL buttons for both paths

### 3. Auto-Delete
- Files older than 3 days are automatically deleted
- Runs via cron job every hour

### 4. Security
- HTTP Basic Auth (joni:Penacova)
- Files served through Flask (auth protected)
- No file type validation (internal tool)

## Implementation Plan

### Backend (app.py)
```python
from flask import Flask, render_template, request, jsonify, send_file
from werkzeug.utils import secure_filename
import os
import json
import datetime
from pathlib import Path

app = Flask(__name__)

# Configuration
UPLOAD_FOLDER = '/var/www/kaut.to/pb/uploads'
THUMB_FOLDER = '/var/www/kaut.to/pb/thumbnails'
METADATA_FILE = '/var/www/kaut.to/pb/metadata.json'
MAX_FILE_SIZE = 500 * 1024 * 1024  # 500MB
WARNING_SIZE = 50 * 1024 * 1024    # 50MB

@app.route('/')
def index():
    """Main upload interface"""
    files = get_recent_files(10)
    return render_template('index.html', files=files)

@app.route('/upload', methods=['POST'])
def upload():
    """Handle file upload"""
    # Implementation details in actual code

@app.route('/files/<path:filepath>')
def serve_file(filepath):
    """Serve uploaded files"""
    # Implementation details in actual code

@app.route('/api/recent')
def api_recent():
    """API endpoint for recent files"""
    return jsonify(get_recent_files(10))
```

### Frontend (index.html)
```html
<!DOCTYPE html>
<html>
<head>
    <title>Kaut.to Pastebin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/dropzone/5.9.3/dropzone.min.css">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>
    <div class="container">
        <h1>Kaut.to Pastebin</h1>
        
        <!-- Upload Area -->
        <div id="dropzone" class="dropzone">
            <div class="dz-message">
                Drop files here, click to browse, or paste with Cmd+V
            </div>
        </div>

        <!-- Recent Files -->
        <div class="recent-files">
            <h2>Recent Files</h2>
            <table id="file-list">
                <!-- Populated by JavaScript -->
            </table>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/dropzone/5.9.3/dropzone.min.js"></script>
    <script src="/static/js/upload.js"></script>
</body>
</html>
```

### JavaScript (upload.js)
Key features:
- Dropzone configuration
- Clipboard paste handler
- Copy to clipboard functionality
- File list updates

### Auto-Delete Script (cleanup.py)
```python
#!/usr/bin/env python3
import os
import time
from datetime import datetime, timedelta
import json

DELETE_AFTER_DAYS = 3

def cleanup_old_files():
    """Delete files older than DELETE_AFTER_DAYS"""
    # Implementation details in actual code
```

### Nginx Configuration
```nginx
location /pb {
    auth_basic "Pastebin Access";
    auth_basic_user_file /etc/nginx/auth/.htpasswd;
    
    proxy_pass http://127.0.0.1:8090;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $host;
    
    # Large file support
    client_max_body_size 500M;
    proxy_read_timeout 300s;
}
```

## URL Structure

- **Upload Interface**: https://kaut.to/pb/
- **File Access**: https://kaut.to/pb/files/2025/01/12/filename.ext
- **API Recent**: https://kaut.to/pb/api/recent

## Metadata Structure
```json
{
  "files": [
    {
      "id": "abc123",
      "filename": "screenshot.png",
      "path": "2025/01/12/screenshot.png",
      "size": 1048576,
      "uploaded": "2025-01-12T10:30:00Z",
      "mime_type": "image/png"
    }
  ]
}
```

## Integration with jtools

Update ft.py and screenshot.py:
```python
# Replace pictool.combot.dev with kaut.to/pb
self.url = "https://kaut.to/pb/upload"
```

## Deployment Steps

1. Create directory structure
2. Install Flask app with dependencies
3. Configure Gunicorn service
4. Set up nginx proxy
5. Add cleanup cron job
6. Update jtools integration

## Success Criteria

- [x] Files can be uploaded via drag & drop
- [x] Clipboard paste works (Cmd+V)
- [x] Last 10 files are displayed
- [x] Copy URL buttons work
- [x] Files auto-delete after 3 days
- [x] jtools integration works
- [x] HTTP auth protects access

## Future Enhancements (v2.0)

- Public/private file toggle
- Search functionality
- File type icons
- Syntax highlighting for code
- ShareX custom uploader support
- API tokens for programmatic access