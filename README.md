# DAI/PAI Documentation

This repository contains the comprehensive documentation for the DAI/PAI ecosystem using MkDocs with Material theme.

## 🌐 Live Documentation

Visit: https://docs.kaut.to (auth: kaut:to)

## 📁 Structure

```
/srv/docs/
├── docs/              # Markdown source files
│   ├── architecture/  # System design docs
│   ├── guides/        # How-to guides
│   ├── operations/    # Operational procedures
│   ├── api/          # API documentation
│   ├── context/      # Context library & CAG
│   └── specs/        # Technical specifications
├── site/             # Built HTML (git ignored)
├── mkdocs.yml        # MkDocs configuration
└── build.sh          # Automated build script
```

## 🚀 Quick Start

### Manual Build
```bash
cd /srv/docs
source venv/bin/activate
mkdocs build
```

### Local Development
```bash
cd /srv/docs
source venv/bin/activate
mkdocs serve --dev-addr 0.0.0.0:8000
```

## 🤖 For AI Agents

### Reading Documentation
```bash
# View all docs
ls -la /srv/docs/docs/

# Read specific file
cat /srv/docs/docs/quickstart.md

# Search documentation
grep -r "search_term" /srv/docs/docs/
```

### Updating Documentation
```bash
# Edit file
nano /srv/docs/docs/operations/new-guide.md

# Documentation will auto-build every 5 minutes via cron
# Or manually: cd /srv/docs && ./build.sh
```

## 🔄 Automation

Documentation automatically rebuilds every 5 minutes via cron job.

Check build status:
```bash
tail -f /srv/docs/build.log
```

## 📝 Contributing

1. Edit Markdown files in `/srv/docs/docs/`
2. Follow existing structure and formatting
3. Test locally with `mkdocs serve`
4. Commit changes - auto-build handles deployment

## 🔧 Setup

### Initial Setup
```bash
cd /srv/docs
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Nginx Configuration
Documentation is served at https://docs.kaut.to via nginx from `/srv/docs/site/`

## 📚 Key Documentation

- [Quick Start Guide](docs/quickstart.md) - Essential for new AI agents
- [CAG System](docs/context/cag/cag-index.md) - Core knowledge base
- [Architecture](docs/architecture/index.md) - System design
- [Operations](docs/operations/daily-maintenance.md) - Daily procedures

## 🆘 Troubleshooting

If builds fail, check:
1. `/srv/docs/build.log` for errors
2. Virtual environment is activated
3. All Python dependencies installed
4. Disk space available

---

Part of the DAI/PAI ecosystem. For system documentation, visit https://docs.kaut.to