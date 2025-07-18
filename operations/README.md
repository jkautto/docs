# DAI/PAI Operations Guide

This directory contains operational documentation for maintaining and troubleshooting the DAI/PAI system.

## Contents

### Runbooks
- [`system-health-check.md`](./system-health-check.md) - Daily system health verification
- [`incident-response.md`](./incident-response.md) - How to respond to system failures
- [`monitoring-alerts.md`](./monitoring-alerts.md) - Understanding and responding to alerts

### Playbooks
- [`slack-bot-recovery.md`](./slack-bot-recovery.md) - Recovering from Slack bot failures
- [`token-refresh.md`](./token-refresh.md) - Managing authentication tokens
- [`log-management.md`](./log-management.md) - Log rotation and cleanup procedures
- [`claude-session-management.md`](./claude-session-management.md) - Managing Claude CLI sessions

### Troubleshooting
- [`common-issues.md`](./common-issues.md) - Common problems and solutions
- [`debug-procedures.md`](./debug-procedures.md) - Step-by-step debugging procedures
- [`performance-tuning.md`](./performance-tuning.md) - Optimizing system performance

### Maintenance
- [`scheduled-maintenance.md`](./scheduled-maintenance.md) - Regular maintenance tasks
- [`backup-procedures.md`](./backup-procedures.md) - Backup and recovery procedures
- [`update-procedures.md`](./update-procedures.md) - Updating system components

## Quick Reference

### Emergency Contacts
- **System Owner**: Joni Kautto
- **Primary Channel**: #pai
- **Debug Channel**: #pai-verbose
- **GitHub Issues**: [jkautto/dai](https://github.com/jkautto/dai/issues)

### Critical Commands
```bash
# Check system health
python3 /srv/pai/monitoring/update_system_status.py

# Restart Slack bot
cd /srv/pai && ./start_slack_bot.sh

# View recent errors
tail -100 /srv/pai/monitoring/logs/*.log | grep ERROR

# Clear all caches
rm -f /tmp/pai_*.json
```

### Key File Locations
- **Logs**: `/srv/pai/monitoring/logs/`, `/srv/pai/intelligence_stack/logs/`
- **Config**: `/srv/.env`, `/srv/config/`
- **Tokens**: `/srv/tokens/`
- **Documentation**: `/srv/docs/`, `/srv/CAG*.md`