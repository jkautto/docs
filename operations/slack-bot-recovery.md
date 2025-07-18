# Slack Bot Recovery Playbook

**Purpose**: Restore Slack bot functionality when it crashes or stops responding.

**Symptoms**:
- No messages in Slack channels
- Process not running
- Event loop errors in logs

## Quick Recovery (Try First)

```bash
cd /srv/pai
./start_slack_bot.sh
```

If successful, verify in #pai-verbose channel.

## Detailed Recovery Steps

### 1. Check Current Status
```bash
# Check if process exists
ps aux | grep -E "slack|pai" | grep -v grep

# Check PID file
cat /srv/pai/slack_v2.pid
ps -p $(cat /srv/pai/slack_v2.pid)

# Check logs for errors
tail -50 /srv/pai/logs/slack_bot.log
```

### 2. Stop Any Stuck Processes
```bash
# Kill by PID file
kill $(cat /srv/pai/slack_v2.pid) 2>/dev/null

# Kill any slack.py processes
pkill -f slack.py

# Kill any slack_bot processes
pkill -f slack_bot

# Wait for cleanup
sleep 3
```

### 3. Clear Stale Files
```bash
# Remove PID file if process is dead
rm -f /srv/pai/slack_v2.pid

# Clear any lock files
rm -f /tmp/slack_bot.lock
```

### 4. Start Fresh Instance
```bash
cd /srv/pai

# Try the wrapper script first
./start_slack_bot.sh

# If that fails, start directly
nohup python3 slack.py > logs/slack_bot.log 2>&1 &
echo $! > slack_v2.pid
```

### 5. Verify Operation
```bash
# Check process started
ps -p $(cat /srv/pai/slack_v2.pid)

# Monitor logs for startup
tail -f /srv/pai/logs/slack_bot.log
# (Ctrl+C to exit)

# Send test message
echo "Slack bot restarted at $(date)" | \
  python3 /srv/pai/toolkit/slack_sender_multichannel.py --channel verbose
```

## Common Issues and Solutions

### "Event loop is closed" Error
This happens when the async event loop crashes.

Solution:
1. Kill all python processes related to slack
2. Clear any stale async locks: `rm -f /tmp/slack_*.lock`
3. Restart with fresh process

### "Bad file descriptor" Error
Network connection was lost.

Solution:
1. Check network connectivity: `ping api.slack.com`
2. Restart the bot
3. Check Slack webhook is valid

### Bot Starts But No Messages
Could be webhook or authentication issue.

Solution:
1. Test webhook directly:
```bash
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"Webhook test"}' \
  $(grep SLACK_WEBHOOK_VERBOSE /srv/.env | cut -d'=' -f2)
```
2. Check webhook URLs in `/srv/.env`
3. Verify Slack user ID in bot configuration

### Multiple Bot Instances
Sometimes multiple instances can run simultaneously.

Solution:
```bash
# Kill ALL slack-related Python processes
pkill -9 -f "python.*slack"

# Clear PID file
rm -f /srv/pai/slack_v2.pid

# Start fresh
cd /srv/pai && ./start_slack_bot.sh
```

## Prevention

### Add to Monitoring
Ensure heartbeat checks for Slack bot:
```bash
# Add to heartbeat monitoring
grep -q "slack_bot" /srv/pai/intelligence_stack/collectors/heartbeat_collector.py
```

### Regular Health Checks
Check bot health during daily system check:
```bash
ps -p $(cat /srv/pai/slack_v2.pid) >/dev/null && echo "✓ Bot running" || echo "✗ Bot down"
```

### Log Rotation
Prevent log files from growing too large:
```bash
# Check log size
ls -lh /srv/pai/logs/slack_bot.log

# Rotate if > 100MB
if [ $(stat -c%s /srv/pai/logs/slack_bot.log) -gt 104857600 ]; then
    mv /srv/pai/logs/slack_bot.log /srv/pai/logs/slack_bot.log.old
    touch /srv/pai/logs/slack_bot.log
fi
```

## Escalation

If bot repeatedly fails:
1. Check for recent code changes in git
2. Review full error traceback in logs
3. Test individual components:
   - Webhook connectivity
   - Python environment
   - Async event loop health
4. Consider reverting to last known good version

## Success Criteria
- [ ] Bot process running (check PID)
- [ ] No errors in last 50 log lines
- [ ] Test message appears in #pai-verbose
- [ ] Bot responds to monitoring events

## Related Documentation
- [`incident-response.md`](./incident-response.md) - General incident handling
- [`monitoring-alerts.md`](./monitoring-alerts.md) - Understanding bot alerts
- [`common-issues.md`](./common-issues.md) - Other common problems