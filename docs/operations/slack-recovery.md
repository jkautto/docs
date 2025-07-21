# Slack Bot Recovery Playbook

**Purpose**: Restore PAI Slack bot functionality when it crashes or stops responding.

**Current Implementation**: Unified bot at `/srv/pai/slack.py` (v0.3.1)

**Symptoms**:
- Bot not responding in #pai channel
- No interactive menu on "help" command
- Process not running
- Event loop errors in logs

## Quick Recovery (Try First)

```bash
cd /srv/pai
./slack.sh --daemon --verbose
```

The script automatically kills old processes and starts fresh. Check #pai-verbose for startup message.

## Detailed Recovery Steps

### 1. Check Current Status
```bash
# Check if process exists
ps aux | grep "python3.*slack.py" | grep -v grep

# Check PID file
cat /srv/pai/slack.pid
ps -p $(cat /srv/pai/slack.pid) 2>/dev/null

# Check logs for errors
tail -50 /srv/pai/logs/slack.log
```

### 2. Use the Smart Startup Script

The `slack.sh` script handles all cleanup automatically:

```bash
cd /srv/pai
./slack.sh --daemon --verbose
```

What it does:
- Kills existing `slack.py` processes
- Kills old `slack_v2*` processes
- Cleans up PID file
- Starts fresh instance
- Verifies single instance running

### 3. Manual Process Cleanup (if needed)
```bash
# Kill all Slack-related processes
pkill -f "python.*slack"

# Remove PID file
rm -f /srv/pai/slack.pid

# Kill specific PID
kill $(cat /srv/pai/slack.pid) 2>/dev/null
```

### 4. Start Fresh Instance
```bash
cd /srv/pai

# Recommended: Use wrapper script
./slack.sh --daemon --verbose

# Alternative: Direct start
nohup python3 slack.py --verbose > logs/slack.log 2>&1 &
echo $! > slack.pid
```

### 5. Verify Operation
```bash
# Check process running
ps -p $(cat /srv/pai/slack.pid)

# Monitor startup logs
tail -f /srv/pai/logs/slack.log

# Test in Slack
# Type "help" or "menu" in #pai channel
# Should see interactive button menu

# Check verbose logging
# Look for messages in #pai-verbose channel
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
- [PAI Slack Bot](../applications/slack-bot.md) - Full bot documentation
- [Claude CLI Advanced](../guides/claude-cli-advanced.md) - System prompt features
- [Slack Webhooks](../guides/slack-webhooks.md) - Webhook configuration
- [Troubleshooting](./troubleshooting.md) - General troubleshooting guide