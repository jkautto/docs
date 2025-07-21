# Browser Testing Guide

## Overview
The browser testing toolkit allows DAI to perform automated UI testing with real-time visual feedback that you can watch at test.kaut.to.

## Quick Start

### 1. Start the Testing Environment
```bash
cd /srv/apps/browser-test
docker-compose up -d
```

### 2. View Live Tests
Visit https://test.kaut.to (auth: kaut:to)

### 3. Run Tests
```bash
# Test pastebin upload
python3 /srv/toolkit/browser_test.py --test upload

# Test clipboard functionality
python3 /srv/toolkit/browser_test.py --test clipboard

# Run all tests
python3 /srv/toolkit/browser_test.py --test all
```

## Features

### Real-Time Viewing
- Watch tests execute in real-time
- No software installation needed
- Works from any device

### Multiple Browsers
- Chrome (port 7900)
- Firefox (port 7901)
- More browsers coming soon

### Test Capabilities
- Click elements
- Fill forms
- Upload files
- Take screenshots
- Verify content

## Architecture

```
┌─────────────────┐     ┌──────────────────┐
│   test.kaut.to  │────▶│  Browser Test    │
│   (Web UI)      │     │  Dashboard       │
└─────────────────┘     └──────────────────┘
         │                       │
         ▼                       ▼
┌─────────────────┐     ┌──────────────────┐
│  Chrome with    │     │  Firefox with    │
│  noVNC (7900)   │     │  noVNC (7901)    │
└─────────────────┘     └──────────────────┘
         │                       │
         ▼                       ▼
┌─────────────────────────────────────────┐
│         Selenium Grid Hub (4444)         │
└─────────────────────────────────────────┘
```

## Writing Tests

### Basic Test Structure
```python
from browser_test import BrowserTest

# Create test instance
test = BrowserTest(browser='chrome')
test.setup()

# Navigate to site
test.driver.get("https://pb.kaut.to")

# Find and click element
button = test.driver.find_element(By.ID, "submit-button")
button.click()

# Clean up
test.teardown()
```

### Best Practices
1. Always use explicit waits
2. Take screenshots on errors
3. Use meaningful test names
4. Clean up test data
5. Test multiple browsers

## Troubleshooting

### Container Issues
```bash
# Check container status
docker ps

# View logs
docker logs selenium-chrome

# Restart containers
docker-compose restart
```

### Connection Issues
- Ensure ports 7900, 7901, 4444 are not in use
- Check firewall allows Docker traffic
- Verify nginx is running

### Test Failures
- Screenshots saved to `/srv/apps/browser-test/`
- Check browser console for errors
- Verify selectors are correct
- Ensure page fully loaded

## Advanced Usage

### Headless Testing
```bash
python3 /srv/toolkit/browser_test.py --headless --browser chrome
```

### Custom Tests
Add new test methods to `/srv/toolkit/browser_test.py`

### Video Recording
Coming soon - automatic test recording

## Security Notes
- VNC has no password for ease of use
- Access controlled by nginx auth
- Containers isolated in Docker network
- No sensitive data in test environment