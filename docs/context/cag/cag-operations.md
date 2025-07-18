# CAG Operations

**Version: 3.1**
**Last Updated:** 2025-07-17T16:00:00Z

This document provides a real-time snapshot of the system's health, active processes, and operational procedures.

---

## 1. Current System State

### 1.1. Health Summary
- **Overall Status:** DEGRADED
- **Reason:** Python environment issues are blocking development and refactoring.
- **Active Blockers:** `ModuleNotFoundError`, local package import failures.
- **Remediation:** A virtual environment (`.venv`) has been created in `/srv/jtools/` to provide a stable development environment.

### 1.2. Service Status
- **PAI v0.3 (Claude-brain):** Working
- **Multi-account Email Monitoring:** Working
- **Slack Integration (3-channel):** Working
- **Morning Brief (6 AM):** Working
- **PAI Web Dashboard:** Working (https://kaut.to/ai/)
- **Pastebin Service:** Working (https://pb.kaut.to)
- **Task API Backend:** Working

### 1.3. Known Issues
- Slack bot crashes occasionally (event loop errors).
- Task monitoring is not fully configured.
- Some deprecated services may still exist in `systemd`.

---

## 2. Monitoring Operations

### 2.1. Active Monitors
1.  **Email Monitor:** Every 10 mins. Multi-account collection and Claude-powered routing.
2.  **Morning Brief:** 6:00 AM daily. Calendar summary and conflict detection.
3.  **System Status:** Hourly. Component health checks and auto-alerts.

### 2.2. Key Operational Procedures

#### Daily Maintenance
```bash
# Check system health
python3 /srv/pai/monitoring/update_system_status.py

# View recent errors
tail -100 /srv/pai/monitoring/logs/*.log | grep ERROR
```

#### Authentication Refresh
```bash
# Gmail (if needed)
python3 /srv/pai/toolkit/gmail_tool.py auth

# Tasks (if needed)
python3 /srv/pai/toolkit/gtask.py auth
```

#### Emergency Recovery
```bash
# Restart monitoring (restarted by cron)
pkill -f email_monitor

# Clear all caches
rm -f /tmp/pai_*.json
```

---

## 3. Performance Metrics

- **Avg. Response Time (Email Check):** ~5 seconds
- **Avg. Response Time (Calendar Fetch):** ~3 seconds
- **Avg. Response Time (Claude Analysis):** ~8 seconds
- **Avg. Resource Usage (CPU):** < 5%
- **Avg. Resource Usage (Memory):** ~200MB (Python)
