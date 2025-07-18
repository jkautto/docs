# Backup & Recovery

Comprehensive backup and recovery procedures for the DAI/PAI ecosystem.

## Backup Strategy

### What Gets Backed Up
- **Code**: All repositories pushed to GitHub
- **Configuration**: /srv/.env, service configs
- **Data**: SQLite databases, logs, tokens
- **Documentation**: Now in GitHub via apps repo

### Backup Schedule
- **Daily**: Automated git commits and pushes
- **Weekly**: Full system state snapshot
- **Monthly**: Archived backup to external storage

## Automated Backups

### Repository Backups
All code is automatically backed up via Git:
```bash
# DAI repository
cd /srv && git push

# PAI repository  
cd /srv/pai && git push

# Apps repository
cd /srv/apps && git push
```

### Database Backups
```bash
# Backup Pastebin database
cp /srv/apps/pastebin/pastebin.db /srv/backups/pastebin-$(date +%Y%m%d).db

# Backup task database
cp /srv/pai/data/tasks.db /srv/backups/tasks-$(date +%Y%m%d).db
```

### Configuration Backups
```bash
# Backup environment files
cp /srv/.env /srv/backups/env-$(date +%Y%m%d)
cp /var/www/.env /srv/backups/www-env-$(date +%Y%m%d)

# Backup nginx configs
sudo cp -r /etc/nginx/sites-available /srv/backups/nginx-$(date +%Y%m%d)
```

## Recovery Procedures

### Service Recovery
1. **Identify failed service**
   ```bash
   systemctl status [service-name]
   ```

2. **Check logs**
   ```bash
   journalctl -u [service-name] --since "1 hour ago"
   ```

3. **Restart service**
   ```bash
   sudo systemctl restart [service-name]
   ```

### Database Recovery
```bash
# Stop affected service
sudo systemctl stop pai-web

# Restore database
cp /srv/backups/tasks-YYYYMMDD.db /srv/pai/data/tasks.db

# Restart service
sudo systemctl start pai-web
```

### Full System Recovery
1. **Boot from backup**
2. **Restore repositories from GitHub**
3. **Restore databases from backups**
4. **Restore environment files**
5. **Restart all services**

## Disaster Recovery Plan

### Level 1: Service Failure
- Single service down
- Use systemctl restart
- Recovery time: < 5 minutes

### Level 2: Data Corruption
- Database or file corruption
- Restore from daily backup
- Recovery time: < 30 minutes

### Level 3: System Failure
- Full system compromise
- Restore from snapshot
- Recovery time: < 2 hours

## Backup Verification

### Weekly Checks
```bash
# Verify backup files exist
ls -la /srv/backups/

# Test database integrity
sqlite3 /srv/backups/pastebin-*.db "PRAGMA integrity_check;"

# Verify git repositories
cd /srv && git status
cd /srv/pai && git status
```

### Monthly Tests
- Restore database to test environment
- Verify service starts with restored data
- Document any issues found

## Important Files

### Critical Paths
```
/srv/.env                    # Main environment variables
/var/www/.env               # Web environment variables
/srv/tokens/                # OAuth tokens
/etc/nginx/sites-available/ # Nginx configs
/srv/pai/data/             # PAI databases
/srv/apps/pastebin/        # Pastebin data
```

### Backup Locations
```
/srv/backups/              # Local backups
GitHub repositories        # Code backups
External storage          # Monthly archives
```

## Recovery Checklist

- [ ] Identify scope of failure
- [ ] Stop affected services
- [ ] Restore from appropriate backup
- [ ] Verify data integrity
- [ ] Restart services
- [ ] Test functionality
- [ ] Document incident

## Related Documentation

- [Daily Maintenance](daily-maintenance.md)
- [Emergency Procedures](emergency-procedures.md)
- [System Health Check](monitoring.md)

---

!!! warning "Important"
    Always test backups regularly. An untested backup is not a backup!