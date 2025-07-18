# Common Issues and Solutions

This document covers frequently encountered problems in the DAI/PAI system and their solutions.

## Claude CLI Issues

### "Prompt too long" Error

**Symptom**: Scripts fail with "prompt too long" error from Claude.

**Cause**: Using `-c` flag causes context accumulation over multiple runs.

**Solution**:
```bash
# Remove -c flag from Claude invocations
# Bad:  claude -p -c
# Good: claude -p

# Fixed in:
# - /srv/pai/monitoring/email_monitor.py
# - /srv/pai/intelligence_stack/processors/heartbeat_intelligent.sh
```

### Claude Session Not Found

**Symptom**: "Session not found" errors.

**Solution**:
```bash
# List all sessions
claude list

# Create new session if needed
claude new

# Use specific session
claude -r SESSION_ID
```

## Authentication Issues

### Gmail Token Expired

**Symptom**: Email monitoring fails with authentication errors.

**Solution**:
```bash
# Refresh token
python3 /srv/pai/toolkit/gmail_tool.py auth

# Follow OAuth flow if completely expired
# Token saved to: /srv/tokens/gmail_token.json
```

### Calendar Access Denied

**Symptom**: Calendar collector fails with permission errors.

**Cause**: Service account permissions changed.

**Solution**:
1. Verify service account email: `pai-assistant@personal-ai-453416.iam.gserviceaccount.com`
2. Re-share calendars with service account
3. Test access: `python3 /srv/pai/intelligence_stack/collectors/calendar_collector.py`

## Slack Integration Issues

### Messages Not Appearing

**Symptom**: System says messages sent but nothing in Slack.

**Checklist**:
```bash
# 1. Test webhook
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"Test"}' \
  $(grep SLACK_WEBHOOK_PAI /srv/.env | cut -d'=' -f2)

# 2. Check channel mappings
grep SLACK_WEBHOOK /srv/.env

# 3. Verify Slack user ID
grep "@" /srv/pai/monitoring/email_monitor.py
# Should be: <@UGQR4AJNS>
```

### Wrong Channel Routing

**Symptom**: Messages going to wrong Slack channel.

**Solution**:
Review routing logic in:
- `/srv/pai/monitoring/email_monitor.py`
- `/srv/pai/toolkit/slack_sender_multichannel.py`

Channel mapping:
- Urgent + @mention → #pai
- Important → #pai-notifications  
- Everything → #pai-verbose

## Python Import Errors

### Module Not Found

**Symptom**: `ModuleNotFoundError` in logs.

**Common fixes**:
```bash
# Missing argparse (fixed in calendar_collector.py)
import argparse

# Path issues
sys.path.insert(0, '/srv/pai/apps')

# Wrong import path
# Bad:  from utils.google_auth import
# Good: from pai_toolkit.auth import
```

## Cron Job Issues

### Cron Not Running

**Symptom**: Expected tasks not executing.

**Debug steps**:
```bash
# 1. Check cron service
systemctl status cron

# 2. Check user crontab
crontab -l

# 3. Check cron logs
grep CRON /var/log/syslog | tail -20

# 4. Test script manually
/srv/pai/intelligence_stack/processors/morning_brief.sh
```

### Cron Running But Failing

**Common causes**:
1. No PATH in cron environment
2. Relative paths in scripts
3. Missing environment variables

**Solution**: Always use absolute paths and export required vars:
```bash
#!/bin/bash
export PATH=/home/joni/.npm-global/bin:$PATH
cd /srv/pai/intelligence_stack
```

## Performance Issues

### Slow Email Monitoring

**Symptom**: Email checks taking > 30 seconds.

**Solutions**:
1. Check cache: `ls -la /tmp/pai_*_cache.json`
2. Clear stale cache: `rm -f /tmp/pai_*_cache.json`
3. Reduce accounts checked if needed

### High Memory Usage

**Symptom**: Python processes using > 500MB RAM.

**Check**:
```bash
ps aux | grep python | sort -k4 -rn | head -5
```

**Solutions**:
1. Restart long-running processes
2. Check for memory leaks in logs
3. Implement process recycling in cron

## Disk Space Issues

### Logs Growing Too Large

**Symptom**: Disk space warnings.

**Quick fix**:
```bash
# Find large logs
find /srv/pai -name "*.log" -size +100M

# Rotate large logs
cd /srv/pai/monitoring/logs
for log in *.log; do
  if [ $(stat -c%s "$log") -gt 104857600 ]; then
    mv "$log" "${log}.old"
    touch "$log"
  fi
done
```

**Long-term**: Ensure log rotation is working:
```bash
# Should run nightly
/srv/pai/intelligence_stack/utils/rotate_logs.sh
```

## Quick Diagnostic Commands

```bash
# Overall health
python3 /srv/pai/monitoring/update_system_status.py

# Check all processes
ps aux | grep -E "(pai|slack|claude)" | grep -v grep

# Recent errors (last hour)
find /srv/pai -name "*.log" -mmin -60 -exec grep -l ERROR {} \;

# Test core functionality
echo "System test at $(date)" | \
  python3 /srv/pai/toolkit/slack_sender_multichannel.py --channel verbose

# Check disk/memory
df -h /srv && free -h
```

## When All Else Fails

1. Check recent commits: `cd /srv && git log --oneline -10`
2. Review recent worklogs: `ls -la /srv/worklogs/dai_*.md | tail -5`
3. Look for pattern in errors: `grep -r "ERROR\|CRITICAL" /srv/pai/*/logs/*.log | tail -50`
4. Restart minimal services and add one at a time
5. Post in #pai channel for help

## Prevention

1. **Monitor regularly**: Run health checks daily
2. **Update CAG**: Document new issues and solutions
3. **Test changes**: Always test scripts manually before cron
4. **Review logs**: Check logs weekly for warnings
5. **Clean up**: Remove old logs, cache files monthly