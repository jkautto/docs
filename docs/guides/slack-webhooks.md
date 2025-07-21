# Slack Webhooks Guide

## Overview

Webhooks provide a simple, reliable way to send messages to Slack channels without needing full bot permissions. They're ideal for system notifications, monitoring alerts, and one-way communication.

## Webhook URLs

Production webhooks are stored in `/srv/pai/.env`:

```bash
SLACK_PAI_WEBHOOK=https://hooks.slack.com/services/TGQEEE5T9/B08V274GQP5/...
SLACK_PAI_NOTIFICATIONS_WEBHOOK=https://hooks.slack.com/services/TGQEEE5T9/B0919P5HX8W/...
SLACK_PAI_VERBOSE_WEBHOOK=https://hooks.slack.com/services/TGQEEE5T9/B0919P6L346/...
```

### Channel Mapping

| Channel | Purpose | Webhook Variable |
|---------|---------|------------------|
| #pai | Primary alerts, urgent notifications | SLACK_PAI_WEBHOOK |
| #pai-notifications | Non-urgent updates, confirmations | SLACK_PAI_NOTIFICATIONS_WEBHOOK |
| #pai-verbose | Detailed logs, debug information | SLACK_PAI_VERBOSE_WEBHOOK |

## Creating New Webhooks

1. Go to your Slack App settings at api.slack.com
2. Navigate to **Features** → **Incoming Webhooks**
3. Toggle **Activate Incoming Webhooks** to On
4. Click **Add New Webhook to Workspace**
5. Select the target channel
6. Copy the webhook URL
7. Add to `/srv/pai/.env` with descriptive name

## Usage Examples

### Python Implementation

```python
import os
import json
import urllib.request
from datetime import datetime
from dotenv import load_dotenv

load_dotenv('/srv/pai/.env')

def send_webhook_message(webhook_url, title, message, level="INFO"):
    """Send formatted message to Slack via webhook"""
    
    colors = {
        "INFO": "#36a64f",    # Green
        "WARNING": "#ff9900", # Orange  
        "ERROR": "#ff0000",   # Red
        "DEBUG": "#0099ff"    # Blue
    }
    
    data = {
        "attachments": [{
            "color": colors.get(level, "#cccccc"),
            "title": f"[{level}] {title}",
            "text": message,
            "footer": "PAI System",
            "ts": int(datetime.now().timestamp())
        }]
    }
    
    req = urllib.request.Request(
        webhook_url,
        data=json.dumps(data).encode('utf-8'),
        headers={'Content-Type': 'application/json'}
    )
    
    try:
        urllib.request.urlopen(req)
        return True
    except Exception as e:
        print(f"Webhook failed: {e}")
        return False

# Usage
webhook = os.environ['SLACK_PAI_VERBOSE_WEBHOOK']
send_webhook_message(
    webhook,
    "System Startup",
    "PAI monitoring system initialized successfully",
    "INFO"
)
```

### Bash Implementation

```bash
#!/bin/bash
# send_slack_notification.sh

source /srv/pai/.env

send_slack_webhook() {
    local webhook_url="$1"
    local title="$2"
    local message="$3"
    local color="${4:-#36a64f}"  # Default green
    
    local timestamp=$(date +%s)
    
    curl -X POST "$webhook_url" \
        -H 'Content-Type: application/json' \
        -d @- << EOF
{
    "attachments": [{
        "color": "$color",
        "title": "$title",
        "text": "$message",
        "footer": "PAI System",
        "ts": $timestamp
    }]
}
EOF
}

# Send to verbose channel
send_slack_webhook \
    "$SLACK_PAI_VERBOSE_WEBHOOK" \
    "[INFO] Backup Complete" \
    "Daily backup completed successfully. Size: 1.2GB" \
    "#36a64f"
```

### Multi-Channel Sender

```python
#!/usr/bin/env python3
# /srv/pai/toolkit/slack_sender.py

import os
import sys
import json
import urllib.request
from enum import Enum
from dotenv import load_dotenv

load_dotenv('/srv/pai/.env')

class SlackChannel(Enum):
    PRIMARY = "SLACK_PAI_WEBHOOK"
    NOTIFICATIONS = "SLACK_PAI_NOTIFICATIONS_WEBHOOK"  
    VERBOSE = "SLACK_PAI_VERBOSE_WEBHOOK"

class SlackSender:
    def __init__(self):
        self.webhooks = {
            SlackChannel.PRIMARY: os.environ.get(SlackChannel.PRIMARY.value),
            SlackChannel.NOTIFICATIONS: os.environ.get(SlackChannel.NOTIFICATIONS.value),
            SlackChannel.VERBOSE: os.environ.get(SlackChannel.VERBOSE.value)
        }
    
    def send(self, channel, message, title=None, color=None, mention_user=None):
        """Send message to specified channel"""
        webhook_url = self.webhooks.get(channel)
        if not webhook_url:
            print(f"No webhook configured for {channel}")
            return False
        
        # Add @mention if specified
        if mention_user:
            message = f"<@{mention_user}> {message}"
        
        # Simple text message
        if not title:
            data = {"text": message}
        else:
            # Formatted attachment
            data = {
                "attachments": [{
                    "color": color or "#36a64f",
                    "title": title,
                    "text": message,
                    "footer": "PAI System"
                }]
            }
        
        return self._send_webhook(webhook_url, data)
    
    def _send_webhook(self, url, data):
        req = urllib.request.Request(
            url,
            data=json.dumps(data).encode('utf-8'),
            headers={'Content-Type': 'application/json'}
        )
        
        try:
            urllib.request.urlopen(req)
            return True
        except Exception as e:
            print(f"Webhook error: {e}")
            return False

# CLI usage
if __name__ == "__main__":
    sender = SlackSender()
    
    # Examples:
    # Send urgent to primary
    sender.send(
        SlackChannel.PRIMARY,
        "System memory usage critical: 95%",
        title="[ALERT] Memory Warning",
        color="#ff0000",
        mention_user="UGQR4AJNS"  # @Joni
    )
    
    # Send info to verbose
    sender.send(
        SlackChannel.VERBOSE,
        "Morning email check completed. Found 5 new messages.",
        title="[INFO] Email Monitor"
    )
```

## Message Formatting

### Basic Text
```json
{
    "text": "Hello from webhook!"
}
```

### Formatted Attachments
```json
{
    "attachments": [{
        "color": "#36a64f",
        "title": "Success",
        "text": "Operation completed",
        "fields": [
            {
                "title": "Duration",
                "value": "2.5 seconds",
                "short": true
            },
            {
                "title": "Records",
                "value": "150",
                "short": true
            }
        ],
        "footer": "PAI System",
        "ts": 1634567890
    }]
}
```

### Rich Formatting
```json
{
    "blocks": [{
        "type": "section",
        "text": {
            "type": "mrkdwn",
            "text": "*Daily Summary*\n• ✅ All systems operational\n• 📧 15 emails processed\n• 📅 3 meetings today"
        }
    }]
}
```

## Webhook Security

### Best Practices

1. **Never commit webhook URLs to public repos**
   ```bash
   # .gitignore
   .env
   *.webhook
   ```

2. **Rotate webhooks periodically**
   - Delete old webhooks in Slack settings
   - Generate new ones
   - Update .env files

3. **Validate webhook URLs**
   ```python
   def is_valid_webhook(url):
       return url.startswith('https://hooks.slack.com/services/')
   ```

4. **Rate limiting**
   ```python
   import time
   
   class RateLimitedSender:
       def __init__(self, min_interval=1.0):
           self.min_interval = min_interval
           self.last_sent = 0
       
       def send(self, webhook_url, data):
           now = time.time()
           if now - self.last_sent < self.min_interval:
               time.sleep(self.min_interval - (now - self.last_sent))
           
           # Send webhook
           self.last_sent = time.time()
   ```

## Integration with PAI Systems

### Morning Brief
```python
# /srv/pai/intelligence_stack/processors/morning_brief_processor.py

async def send_morning_brief(self, brief_data):
    """Send formatted morning brief to Slack"""
    
    # Determine urgency
    has_conflicts = brief_data.get('conflicts', [])
    mention = "<@UGQR4AJNS>" if has_conflicts else ""
    
    message = self.format_brief(brief_data)
    
    if has_conflicts:
        # Urgent - send to primary
        webhook = os.environ['SLACK_PAI_WEBHOOK']
        color = "#ff0000"
    else:
        # Normal - send to notifications
        webhook = os.environ['SLACK_PAI_NOTIFICATIONS_WEBHOOK']
        color = "#36a64f"
    
    self.send_webhook(webhook, f"{mention} {message}", "Morning Brief", color)
```

### Email Monitor
```python
# /srv/pai/monitoring/email_monitor.py

def route_email_notification(self, email_data):
    """Route email notifications based on importance"""
    
    vip_senders = ['riikka', 'important-client@example.com']
    urgent_keywords = ['urgent', 'critical', 'deadline', 'emergency']
    
    sender = email_data.get('from', '').lower()
    subject = email_data.get('subject', '').lower()
    
    # Check importance
    is_vip = any(vip in sender for vip in vip_senders)
    is_urgent = any(keyword in subject for keyword in urgent_keywords)
    
    if is_vip or is_urgent:
        # Send to primary with mention
        self.slack_sender.send(
            SlackChannel.PRIMARY,
            f"VIP Email from {email_data['from']}: {email_data['subject']}",
            title="[URGENT] Email Alert",
            color="#ff0000",
            mention_user="UGQR4AJNS"
        )
    else:
        # Send to notifications
        self.slack_sender.send(
            SlackChannel.NOTIFICATIONS,
            f"New email from {email_data['from']}",
            title="[INFO] Email Received"
        )
    
    # Always log to verbose
    self.slack_sender.send(
        SlackChannel.VERBOSE,
        json.dumps(email_data, indent=2),
        title="[DEBUG] Email Data"
    )
```

### System Monitoring
```bash
#!/bin/bash
# /srv/pai/monitoring/system_health.sh

source /srv/pai/.env

check_system_health() {
    local memory_usage=$(free | grep Mem | awk '{print int($3/$2 * 100)}')
    local disk_usage=$(df -h / | tail -1 | awk '{print int($5)}')
    
    if [ $memory_usage -gt 90 ] || [ $disk_usage -gt 90 ]; then
        # Critical - send to primary
        curl -X POST "$SLACK_PAI_WEBHOOK" \
            -H 'Content-Type: application/json' \
            -d "{
                \"text\": \"<@UGQR4AJNS> System resources critical!\",
                \"attachments\": [{
                    \"color\": \"#ff0000\",
                    \"title\": \"[CRITICAL] Resource Alert\",
                    \"text\": \"Memory: ${memory_usage}%\\nDisk: ${disk_usage}%\",
                    \"footer\": \"System Monitor\"
                }]
            }"
    else
        # Normal - send to verbose
        curl -X POST "$SLACK_PAI_VERBOSE_WEBHOOK" \
            -H 'Content-Type: application/json' \
            -d "{
                \"attachments\": [{
                    \"color\": \"#36a64f\",
                    \"title\": \"[INFO] System Health\",
                    \"text\": \"Memory: ${memory_usage}%\\nDisk: ${disk_usage}%\\nStatus: Healthy\",
                    \"footer\": \"System Monitor\"
                }]
            }"
    fi
}

# Run check
check_system_health
```

## Testing Webhooks

### Quick Test
```bash
# Test webhook is working
curl -X POST $SLACK_PAI_VERBOSE_WEBHOOK \
  -H 'Content-Type: application/json' \
  -d '{"text": "Test message from curl"}'
```

### Comprehensive Test Script
```python
#!/usr/bin/env python3
# test_webhooks.py

import os
from dotenv import load_dotenv
from slack_sender import SlackSender, SlackChannel

load_dotenv('/srv/pai/.env')

def test_all_webhooks():
    """Test all configured webhooks"""
    sender = SlackSender()
    
    tests = [
        (SlackChannel.PRIMARY, "Test message to #pai", "[TEST] Primary Channel"),
        (SlackChannel.NOTIFICATIONS, "Test message to #pai-notifications", "[TEST] Notifications"),
        (SlackChannel.VERBOSE, "Test message to #pai-verbose", "[TEST] Verbose Logging")
    ]
    
    for channel, message, title in tests:
        print(f"Testing {channel.name}...")
        success = sender.send(channel, message, title=title, color="#0099ff")
        print(f"  {'✓' if success else '✗'} {channel.name}")
    
    # Test mention
    print("Testing mention...")
    success = sender.send(
        SlackChannel.PRIMARY,
        "This is a test mention",
        title="[TEST] Mention Test",
        mention_user="UGQR4AJNS"
    )
    print(f"  {'✓' if success else '✗'} Mention test")

if __name__ == "__main__":
    test_all_webhooks()
```

## Troubleshooting

### Common Issues

1. **"channel_not_found" Error**
   - Webhook might be deleted
   - Regenerate webhook for that channel
   - Update .env file

2. **"invalid_payload" Error**
   - Check JSON formatting
   - Ensure proper escaping of special characters
   - Validate against Slack's schema

3. **No message appears**
   - Verify webhook URL is correct
   - Check network connectivity
   - Look for rate limiting

### Debug Logging
```python
import logging

logging.basicConfig(level=logging.DEBUG)

def debug_webhook(url, data):
    logging.debug(f"Webhook URL: {url}")
    logging.debug(f"Payload: {json.dumps(data, indent=2)}")
    
    try:
        response = urllib.request.urlopen(...)
        logging.debug(f"Response: {response.read()}")
    except Exception as e:
        logging.error(f"Webhook failed: {e}")
```

## Related Documentation

- [PAI Slack Bot](../applications/slack-bot.md) - Full bot implementation
- [Monitoring Alerts](../operations/monitoring-alerts.md) - Alert routing strategies
- [Intelligence Stack](../architecture/intelligence-stack.md) - Webhook usage in monitoring