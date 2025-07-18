# Getting Started

Welcome to the DAI/PAI ecosystem! This guide will help you get up and running quickly.

!!! tip "AI Agent?"
    If you're an AI agent, check out the [Quick Start Guide](/quickstart.md) for AI-specific onboarding.

## Prerequisites

Before you begin, ensure you have:

- **Server**: Ubuntu 22.04 LTS or similar Linux distribution
- **Domain**: A domain name with DNS control
- **Python**: Version 3.10 or higher
- **Node.js**: For certain applications (optional)
- **Git**: For version control

## Quick Setup

### 1. Universal Setup Script

The fastest way to get started is using our universal setup script:

```bash
curl -s https://kaut:to@kaut.to/setup | bash
```

This script will:
- Create workspace at `~/kwork/`
- Install dependencies
- Pull credentials from vault
- Clone necessary repositories
- Set up the complete environment

### 2. Manual Setup

If you prefer manual setup:

#### Clone the Apps Repository
```bash
git clone https://github.com/jkautto/apps.git /srv/apps
cd /srv/apps
```

#### Set Up Environment
```bash
# Create .env file
cat > .env << EOF
# Add your API keys here
GITHUB_PAT=your-github-token
GEMINI_API_KEY=your-gemini-key
# ... other keys
EOF

# Secure the file
chmod 600 .env
```

#### Install Dependencies
Each application has its own dependencies. For example:

```bash
# Documentation site
cd docs
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Pastebin service
cd ../pastebin
# Follow pastebin README
```

## Core Components

### 1. DAI (Development AI Infrastructure)
- **Purpose**: Manages infrastructure and technical systems
- **Location**: `/srv/`
- **Key Files**: 
  - `/srv/CAG/` - Core knowledge base
  - `/srv/context/` - System state

### 2. PAI (Personal AI Assistant)
- **Purpose**: Personal assistant for daily tasks
- **Location**: `/srv/pai/`
- **Services**:
  - Email monitoring
  - Calendar management
  - Task scheduling
  - Slack integration

### 3. Web Applications
Located in `/srv/apps/`:
- **auth**: Authentication service
- **pastebin**: File sharing
- **browser-test**: Testing infrastructure
- **shifts**: Scheduling application
- **docs**: This documentation

## Basic Operations

### Starting Services

Most services are managed by systemd:

```bash
# Check service status
sudo systemctl status pai-web

# Start a service
sudo systemctl start pai-web

# Enable auto-start
sudo systemctl enable pai-web
```

### Accessing Applications

- **Main Site**: https://kaut.to
- **Documentation**: https://docs.kaut.to
- **Pastebin**: https://pb.kaut.to
- **Auth Portal**: https://auth.kaut.to
- **Dev Dashboard**: https://dev.kaut.to

Default credentials:
- Username: `joni`
- Password: `Penacova`

### Checking Logs

```bash
# System logs
sudo journalctl -u nginx -f

# Application logs
tail -f /srv/pai/logs/app.log

# All logs
ls /srv/logs/
```

## Next Steps

Now that you have the basics:

1. **Explore the Architecture**: Learn how the system is designed
   - [Architecture Overview](../architecture/index.md)
   
2. **Set Up Development Environment**: Configure your local development
   - [Development Setup](development-setup.md)
   
3. **Learn Authentication**: Understand the security model
   - [Authentication Guide](authentication.md)
   
4. **Try the APIs**: Start building with our APIs
   - [API Reference](../api/index.md)

## Common Issues

### Port Already in Use
```bash
# Find process using port
sudo lsof -i :8080

# Kill process if needed
sudo kill -9 <PID>
```

### Permission Denied
```bash
# Fix ownership
sudo chown -R $USER:$USER /srv/apps

# Fix permissions
chmod 755 /srv/apps
```

### Service Won't Start
```bash
# Check logs
sudo journalctl -u service-name -n 50

# Verify configuration
nginx -t
```

## Getting Help

- **Documentation**: You're here! Use the search function
- **Logs**: Check `/srv/logs/` for detailed information
- **Context**: Review `/srv/context/current/` for system state
- **Code**: Browse https://github.com/jkautto/

## Tips for AI Agents

If you're an AI agent working with this system:

1. **Always check context first**: `/srv/context/current/`
2. **Use structured commands**: Follow the patterns in guides
3. **Update documentation**: Keep docs current as you work
4. **Log your actions**: Help future agents understand changes

---

!!! success "Ready to Go!"
    You now have the basics to start working with the DAI/PAI ecosystem. 
    Explore the documentation to learn more about specific components.