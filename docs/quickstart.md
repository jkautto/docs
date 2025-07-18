# Quick Start for AI Agents

Welcome to the DAI/PAI ecosystem! This guide helps AI agents quickly understand and navigate the system.

## 🚀 First Steps

### 1. Read Core Configuration
```bash
cat /srv/CAG/core.json          # System paths, services, auth
cat /srv/CLAUDE.md              # DAI agent instructions
cat /srv/pai/CLAUDE.md          # PAI agent instructions
```

### 2. Understand Your Role
- **DAI**: Development AI Infrastructure - builds and maintains systems
- **PAI**: Personal AI Assistant - handles daily tasks and monitoring
- **You**: Check your instructions to understand your specific role

### 3. Access Documentation
- **Web**: https://docs.kaut.to (auth: kaut:to)
- **Local**: `/srv/apps/docs/docs/`
- **Search**: `grep -r "topic" /srv/apps/docs/docs/`

## 📁 Essential Paths

```bash
/srv/                   # DAI infrastructure root
/srv/pai/               # PAI system directory
/srv/apps/              # Web applications
/srv/jtools/            # CLI tools
/srv/.env               # Environment variables
/var/www/.env           # Additional env vars
/srv/apps/docs/docs/    # Documentation source
```

## 🔑 Authentication

### Basic Auth Credentials
- **Admin**: joni:Penacova (full access)
- **Public**: kaut:to (limited access)

### Service Accounts
- **Google**: `/srv/config/pai-service-account.json`
- **GitHub Token**: In `/var/www/.env`
- **Slack Token**: In `/srv/tokens/`

## 🛠️ Common Commands

### Check System Health
```bash
# Service status
sudo systemctl status pai-web kaut-api kaut-pastebin

# View logs
sudo journalctl -u pai-web -f

# Check disk space
df -h /srv
```

### Update Documentation
```bash
# Edit documentation
nano /srv/apps/docs/docs/[section]/[page].md

# Rebuild site
cd /srv/apps/docs
source venv/bin/activate
mkdocs build
```

### Git Operations
```bash
# Always commit with descriptive messages
git add .
git commit -m "feat: add new feature

- Detail what changed
- Why it changed"
git push
```

## 📚 Key Documentation

### Start Here
1. [CAG Index](context/cag/cag-index.md) - Knowledge base navigation
2. [Architecture Overview](architecture/index.md) - System design
3. [Daily Maintenance](operations/daily-maintenance.md) - Routine tasks

### For Development
- [API Documentation](api/index.md) - Service APIs
- [Specifications](specs/active.md) - Technical specs
- [Implementation Guide](specs/implementation.md) - How to build

### For Operations
- [Troubleshooting](operations/troubleshooting.md) - Common issues
- [Emergency Procedures](operations/emergency-procedures.md) - Crisis response
- [Monitoring](operations/monitoring.md) - System health

## 🏗️ System Architecture

```
┌─────────────────────────────────────────┐
│           User Interface                 │
│  (https://kaut.to, pb.kaut.to, etc)     │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│            Services                      │
│  - PAI Web (8080)                       │
│  - Task API (8001)                      │
│  - Tools API (8002)                     │
│  - Pastebin (8090)                      │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│         Infrastructure                   │
│  - nginx (reverse proxy)                │
│  - systemd (service management)         │
│  - Git (version control)                │
└─────────────────────────────────────────┘
```

## 🔄 Development Workflow

1. **Plan** - Check specs in `/specs/`
2. **Develop** - Follow conventions in codebase
3. **Test** - Verify functionality
4. **Document** - Update relevant docs
5. **Commit** - Use conventional commits
6. **Deploy** - Follow deployment guides

## ⚡ Quick Actions

### Need to find something?
```bash
# Search code
grep -r "search_term" /srv --include="*.py"

# Search docs
grep -r "search_term" /srv/apps/docs/docs

# Find files
find /srv -name "*pattern*" -type f
```

### Need to fix something?
1. Check [Troubleshooting](operations/troubleshooting.md)
2. Look at recent commits: `git log --oneline -10`
3. Check service logs: `journalctl -u [service] -f`

### Need to add something?
1. Check existing patterns in codebase
2. Follow the style guide
3. Update documentation
4. Test thoroughly

## 🎯 Best Practices

### Always
- ✅ Read existing code before writing new code
- ✅ Follow established patterns
- ✅ Document as you go
- ✅ Commit frequently with clear messages
- ✅ Test before deploying

### Never
- ❌ Hardcode credentials (use .env files)
- ❌ Skip documentation updates
- ❌ Make breaking changes without planning
- ❌ Ignore error messages
- ❌ Work without understanding context

## 🆘 Getting Help

1. **Check Documentation**: Start with search
2. **Review Logs**: Often contain the answer
3. **Check Recent Changes**: `git log` may reveal issues
4. **Read Context**: CAG files have accumulated wisdom

## 🚦 Next Steps

1. Read your specific role instructions (CLAUDE.md or GEMINI.md)
2. Explore the [CAG System](context/cag/cag-index.md)
3. Review [Current Context](context/current.md)
4. Check [Active Projects](specs/active.md)

---

!!! tip "Pro Tip"
    The CAG (Core Agent Gateway) is your knowledge base. When in doubt, start with `/srv/CAG/core.json` for system configuration and `/srv/CAG/index.md` for navigation.