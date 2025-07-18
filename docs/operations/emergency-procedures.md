# Emergency Procedures

Quick reference for handling critical system failures and emergencies.

## Emergency Response Framework

### Severity Levels

| Level | Description | Response Time | Examples |
|-------|-------------|---------------|----------|
| **P1** | Critical - System Down | < 15 min | All services offline, data loss risk |
| **P2** | Major - Degraded Service | < 1 hour | Single service down, auth failures |
| **P3** | Minor - Limited Impact | < 4 hours | Slow response, minor errors |
| **P4** | Low - Cosmetic Issues | Next day | UI glitches, non-critical warnings |

## P1: Critical Emergencies

### Total System Failure
```bash
# 1. Check server accessibility
ping kaut.to

# 2. SSH to server
ssh kaut

# 3. Check all services
sudo systemctl status --all | grep kaut

# 4. Emergency restart
sudo systemctl restart nginx
sudo systemctl restart pai-web kaut-api kaut-pastebin kaut-auth
```

### Data Loss Prevention
```bash
# STOP all write operations immediately
sudo systemctl stop pai-web kaut-api

# Create emergency backup
sudo cp -r /srv /emergency-backup-$(date +%Y%m%d-%H%M%S)

# Check filesystem
df -h
sudo dmesg | tail -50
```

## P2: Service Failures

### PAI Dashboard Down
```bash
# Quick recovery
sudo systemctl restart pai-web

# If persists, check logs
sudo journalctl -u pai-web -n 100

# Manual start for debugging
cd /srv/pai && python3 app.py
```

### Authentication Failures
```bash
# Check nginx auth
sudo nginx -t
sudo tail -f /var/log/nginx/error.log

# Verify htpasswd file
ls -la /etc/nginx/auth/.htpasswd

# Test authentication
curl -I https://kaut.to --user joni:Penacova
```

### API Service Issues
```bash
# Restart API service
sudo systemctl restart kaut-api

# Check port binding
sudo lsof -i :8002

# Test API endpoint
curl http://localhost:8002/health
```

## P3: Performance Issues

### High CPU Usage
```bash
# Identify culprit
htop
ps aux | sort -k 3 -n -r | head

# Kill runaway process
kill -9 [PID]

# Check for loops in logs
tail -f /srv/pai/logs/app.log
```

### Memory Exhaustion
```bash
# Check memory usage
free -h
ps aux | sort -k 4 -n -r | head

# Clear caches
sync && echo 3 > /proc/sys/vm/drop_caches

# Restart memory-heavy services
sudo systemctl restart pai-web
```

### Disk Space Critical
```bash
# Find large files
du -h /srv | sort -h | tail -20

# Clean logs
find /srv -name "*.log" -mtime +7 -delete

# Clean pip cache
pip cache purge
```

## Recovery Procedures

### Quick Service Recovery
1. **Identify** - Which service is down?
2. **Isolate** - Stop dependent services
3. **Restart** - Use systemctl restart
4. **Verify** - Check service status
5. **Test** - Confirm functionality

### Roll Back Changes
```bash
# If recent change caused issues
cd /srv/apps && git log --oneline -10
git revert HEAD

# Rebuild if needed
cd /srv/apps/docs && mkdocs build
```

### Emergency Contacts
1. Check `/srv/HANDOVER.md` for current status
2. Review recent commits for changes
3. Check monitoring alerts

## Common Error Patterns

### "502 Bad Gateway"
```bash
# Usually means backend service is down
sudo systemctl status pai-web kaut-api
sudo systemctl restart pai-web kaut-api
```

### "Connection Refused"
```bash
# Service not listening on port
sudo lsof -i :8001 :8002 :8080 :8090 :8091
# Restart affected service
```

### "Permission Denied"
```bash
# Fix file permissions
sudo chown -R joni:joni /srv
sudo chmod -R 755 /srv/apps
```

## Post-Incident

### Documentation
1. Create incident report in `/srv/docs/incidents/`
2. Update this guide with new procedures
3. Add to monitoring if applicable

### Prevention
1. Identify root cause
2. Implement monitoring
3. Create automated recovery
4. Update documentation

## Emergency Command Reference

```bash
# Service management
sudo systemctl status --all | grep -E "pai|kaut"
sudo systemctl restart pai-web kaut-api kaut-pastebin kaut-auth

# Log analysis
sudo journalctl --since "1 hour ago" | grep ERROR
tail -f /var/log/nginx/error.log

# Resource monitoring
htop
df -h
free -h

# Network checks
ss -tulpn | grep LISTEN
ping -c 3 kaut.to

# Quick backup
tar -czf emergency-backup-$(date +%Y%m%d).tar.gz /srv
```

## Related Documentation

- [Daily Maintenance](daily-maintenance.md)
- [Troubleshooting Guide](troubleshooting.md)
- [Backup & Recovery](backup-recovery.md)
- [System Monitoring](monitoring.md)

---

!!! danger "Remember"
    In an emergency, prioritize:
    1. **Data preservation** - Don't lose user data
    2. **Service restoration** - Get back online
    3. **Root cause analysis** - Prevent recurrence