# System Health Check Runbook

**Purpose**: Daily verification that all PAI/DAI components are functioning correctly.

**Frequency**: Daily at start of workday, or when issues are suspected.

## Prerequisites
- SSH access to server
- Understanding of PAI architecture
- Access to Slack channels (#pai, #pai-verbose)

## Steps

### 1. Run Automated Health Check
```bash
python3 /srv/pai/monitoring/update_system_status.py
```

Expected output: Overall health > 80%

### 2. Verify Critical Processes

#### Check Slack Bot
```bash
# Check if running
ps aux | grep slack.py | grep -v grep

# If not running, check PID file
cat /srv/pai/slack_v2.pid
ps -p $(cat /srv/pai/slack_v2.pid)

# View recent logs
tail -50 /srv/pai/logs/slack_bot.log
```

#### Check Claude Sessions
```bash
# List active Claude sessions
claude list

# Check for stuck sessions
ps aux | grep claude | grep -v grep
```

### 3. Verify Cron Jobs
```bash
# List user crons
crontab -l | grep -E "(morning_brief|email_monitor|heartbeat)"

# Check recent cron execution
grep "$(date '+%Y-%m-%d')" /srv/pai/intelligence_stack/logs/cron.log
```

Expected crons:
- Morning Brief: 6 AM daily
- Email Monitor: Every 10-60 min (based on time)
- Heartbeat: Every 30 min

### 4. Check Authentication Status

#### Gmail Token
```bash
python3 /srv/pai/toolkit/gmail_tool.py auth
```
Should show: "Token expires in X hours"

#### Calendar Access
```bash
python3 /srv/pai/intelligence_stack/collectors/calendar_collector.py --test
```
Should return today's events

### 5. Review Logs for Errors
```bash
# Check for recent errors
for log in /srv/pai/monitoring/logs/*.log /srv/pai/intelligence_stack/logs/*.log; do
    echo "=== $log ==="
    tail -20 "$log" | grep -i error | tail -5
done
```

### 6. Verify Disk Space
```bash
df -h /srv
du -sh /srv/pai/logs /srv/pai/monitoring/logs /srv/pai/intelligence_stack/logs
```

Warning if:
- Disk usage > 80%
- Any log directory > 1GB

### 7. Test Slack Integration
Send test message:
```bash
echo "Health check test at $(date)" | python3 /srv/pai/toolkit/slack_sender_multichannel.py --channel verbose
```

Check #pai-verbose for the message.

## Troubleshooting

### If Slack Bot is Down
See [`slack-bot-recovery.md`](./slack-bot-recovery.md)

### If Tokens are Expired
See [`token-refresh.md`](./token-refresh.md)

### If Crons Aren't Running
1. Check cron service: `systemctl status cron`
2. Review cron logs: `grep CRON /var/log/syslog | tail -20`
3. Test individual scripts manually

### If Health < 70%
1. Run this health check manually
2. Check [`incident-response.md`](./incident-response.md)
3. Alert in #pai channel if critical

## Success Criteria
- [ ] Overall health > 80%
- [ ] All critical processes running
- [ ] No authentication errors
- [ ] Disk usage < 80%
- [ ] Recent activity in logs
- [ ] Slack test message delivered

## Notes
- Morning Brief runs at 6 AM UTC
- Email monitoring frequency varies by time of day
- Heartbeat provides self-healing capabilities
- Always check #pai-verbose for detailed system activity