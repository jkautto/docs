# Browser Testing Toolkit Specification v0.1

## Overview
A real-time browser testing toolkit that allows DAI to perform UI testing with live visual feedback at test.kaut.to.

## Architecture

### Components
1. **Selenium Grid Hub** - Central test coordinator
2. **Chrome/Firefox Nodes** - Browser instances with VNC
3. **noVNC Web Client** - Browser-based VNC viewer
4. **Playwright/Selenium Scripts** - Test automation
5. **Test Dashboard** - Live test status and controls

### Stack Decision
- **Primary**: Docker Selenium Grid with VNC-enabled nodes
- **Automation**: Playwright (modern, faster) with Selenium fallback
- **Viewing**: noVNC web client at test.kaut.to
- **Recording**: Built-in video recording for test artifacts

## Implementation Plan

### Phase 1: Infrastructure Setup
```yaml
# docker-compose.yml for test environment
version: '3'
services:
  selenium-hub:
    image: selenium/hub:4.15.0
    container_name: selenium-hub
    ports:
      - "4444:4444"
  
  chrome:
    image: selenium/node-chrome:4.15.0
    shm_size: 2gb
    depends_on:
      - selenium-hub
    environment:
      - SE_EVENT_BUS_HOST=selenium-hub
      - SE_EVENT_BUS_PUBLISH_PORT=4442
      - SE_EVENT_BUS_SUBSCRIBE_PORT=4443
      - SE_NODE_MAX_SESSIONS=1
      - SE_VNC_NO_PASSWORD=1
    ports:
      - "7900:7900"  # noVNC web interface
      - "5900:5900"  # VNC server
```

### Phase 2: Web Interface
- **test.kaut.to** - Main testing dashboard
- **Features**:
  - Live browser view via noVNC
  - Test execution controls
  - Screenshot/video capture
  - Test history and artifacts

### Phase 3: Toolkit Integration
```python
# /srv/toolkit/browser_test.py
class BrowserTest:
    def __init__(self):
        self.hub_url = "http://localhost:4444/wd/hub"
        self.vnc_url = "http://test.kaut.to:7900"
    
    def test_pastebin_upload(self):
        """Test image upload functionality"""
        driver = self.get_driver()
        driver.get("https://pb.kaut.to")
        # ... test implementation
    
    def get_live_view_url(self):
        """Return URL for live viewing"""
        return f"{self.vnc_url}/?autoconnect=1&resize=scale"
```

## User Experience

### For DAI (Developer)
1. Run test command: `python3 browser_test.py test_pastebin_upload`
2. Script outputs: "View test live at: https://test.kaut.to"
3. Execute UI actions programmatically
4. See real-time browser activity

### For Joni (Observer)
1. Visit https://test.kaut.to
2. See live browser view with DAI's actions
3. Watch tests execute in real-time
4. Review recorded videos afterward

## Key Features

### 1. Real-Time Viewing
- noVNC provides browser-based VNC access
- No client software needed
- Works on any device with a browser

### 2. Test Recording
- Automatic video recording of all tests
- Screenshots at key points
- Full test artifacts stored

### 3. Multi-Browser Support
- Chrome (primary)
- Firefox
- Edge (future)
- Safari (via WebKit)

### 4. Debugging Tools
- Pause/resume test execution
- Interactive browser console
- Network traffic inspection
- DOM element highlighting

## Security Considerations
- test.kaut.to requires authentication
- VNC sessions are temporary
- No sensitive data in test environment
- Isolated Docker network

## Future Enhancements
1. **AI-Powered Testing**: Use Claude to analyze screenshots
2. **Visual Regression**: Automatic screenshot comparison
3. **Parallel Testing**: Multiple browser instances
4. **Mobile Testing**: Android/iOS emulation
5. **Performance Metrics**: Page load times, resource usage

## Quick Start Commands
```bash
# Start test environment
docker-compose up -d

# Run a test with live view
python3 /srv/toolkit/browser_test.py --live

# View test at
https://test.kaut.to

# Stop environment
docker-compose down
```

## Benefits
1. **Transparency**: Joni can see exactly what DAI is testing
2. **Debugging**: Visual feedback for troubleshooting
3. **Confidence**: Verify UI changes work correctly
4. **Documentation**: Video records of all tests
5. **Collaboration**: Share test sessions via URL