# Daily Maintenance

Daily maintenance procedures to keep the DAI/PAI ecosystem running smoothly.

## Morning Checklist

### 1. System Health Check
Run the comprehensive health check:
```bash
# Check all services
sudo systemctl status kaut-pastebin pai-web kaut-auth kaut-api

# Check disk space
df -h /srv

# Check system resources
htop
```

### 2. Service Verification
Verify each service is responding:
```bash
# Test PAI Dashboard
curl -I https://kaut.to/ai/ --user joni:Penacova

# Test Task API
curl https://kaut.to/api/health

# Test Pastebin
curl -I https://pb.kaut.to --user kaut:to
```

### 3. Log Review
Check for errors or warnings:
```bash
# Check PAI logs
sudo journalctl -u pai-web --since "24 hours ago" | grep -E "ERROR|WARNING"

# Check API logs
sudo journalctl -u kaut-api --since "24 hours ago" | grep -E "ERROR|WARNING"

# Check nginx logs
sudo tail -100 /var/log/nginx/error.log
```

### 4. Authentication Status
Verify OAuth tokens:
```bash
# Check Google OAuth
python3 /srv/jtools/gtask/gtask.py list

# Check Slack bot status
python3 /srv/pai/monitors/slack_health_check.py
```

## Weekly Tasks

### Monday - Backup Check
- Verify backup scripts are running
- Check backup integrity
- Review backup storage space

### Wednesday - Security Review
- Review authentication logs
- Check for unusual access patterns
- Update passwords if needed

### Friday - Performance Review
- Analyze service response times
- Check token usage metrics
- Review system resource trends

## Monthly Tasks

### First Monday
- Full system backup
- Archive old logs
- Clean temporary files

### Third Monday
- Review and update documentation
- Check for system updates
- Review SSL certificate expiration

## Quick Recovery Procedures

### Service Down
```bash
# Restart specific service
sudo systemctl restart [service-name]

# Check service logs
sudo journalctl -u [service-name] -f
```

### Authentication Issues
```bash
# Refresh Google OAuth
cd /srv/jtools && python3 gtask/gtask.py auth

# Fix Slack token
export SLACK_BOT_TOKEN=$(cat /srv/tokens/slack_bot_token.txt)
```

### Disk Space Issues
```bash
# Clean old logs
find /srv/pai/logs -name "*.log" -mtime +7 -delete

# Clean pip cache
pip cache purge

# Remove old Docker images
docker image prune -a
```

## Monitoring Commands

### Real-time Monitoring
```bash
# Watch service status
watch -n 5 'systemctl status pai-web kaut-api'

# Monitor logs
tail -f /srv/pai/logs/app.log

# Track resource usage
htop
```

### Performance Metrics
```bash
# Check response times
time curl https://kaut.to/api/health

# Monitor network connections
ss -tulpn | grep LISTEN

# Check process memory
ps aux | grep python | sort -k 6 -n -r | head
```

## Emergency Contacts

- **Primary**: Check HANDOVER.md for current on-call
- **Escalation**: See emergency procedures
- **Documentation**: https://docs.kaut.to

## Related Documentation

- [System Health Check Details](monitoring.md)
- [Troubleshooting Guide](troubleshooting.md)
- [Emergency Procedures](emergency-procedures.md)
- [Token Optimization](token-optimization.md)

---

!!! tip "Pro Tip"
    Set up these checks as aliases in your `.bashrc` for quick access:
    ```bash
    alias health='sudo systemctl status kaut-pastebin pai-web kaut-auth kaut-api'
    alias logs='sudo journalctl -u pai-web -f --since "1 hour ago"'
    ```