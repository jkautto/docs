# Universal Setup Script Specification v0.1

## Overview
A hybrid bash/AI-readable script accessible via HTTPS that sets up a complete development environment with one command.

## Access Method
```bash
# Direct bash execution:
curl -s https://joni:Penacova@kaut.to/setup | bash

# AI consumption:
curl -s https://joni:Penacova@kaut.to/setup > setup.sh && cat setup.sh
```

## Design Principles
1. **Single Command**: One curl to get everything
2. **Self-Contained**: All credentials and access info embedded
3. **Temporary Workspace**: Easy cleanup with single directory
4. **AI-Friendly**: Clear comments for AI interpretation
5. **Human-Executable**: Valid bash script

## Script Structure

```bash
#!/bin/bash
# UNIVERSAL SETUP SCRIPT FOR JONI'S DEVELOPMENT ENVIRONMENT
# 
# For AI Assistants: Execute each section below in order
# For Humans: curl -s https://joni:Penacova@kaut.to/setup | bash
#
# This script sets up:
# - Credentials via dotenv-vault (72+ environment variables)
# - jtools repository (Python CLI tools)
# - kaut-shared repository (Docker configs, standards, docs)
# - Temporary workspace at ~/kwork/

# Exit on any error
set -e

echo "🚀 Starting universal setup..."

# 1. CREATE WORKSPACE
# AI: Create a temporary workspace directory
mkdir -p ~/kwork && cd ~/kwork
echo "✓ Created workspace at ~/kwork"

# 2. SETUP CREDENTIALS 
# AI: Install dotenv-vault and pull all platform credentials
echo "📦 Installing dotenv-vault CLI..."
npm install -g @dotenv-org/cli --silent

echo "🔐 Setting up credential vault..."
cat > .env.me << 'EOF'
DOTENV_ME=me_3879349a3f4afc8558ad76e354b8c3321399a5dda091361a64f4d948c2309718
EOF

# Initialize vault connection
npx dotenv-vault@latest new vlt_25ccece6b7add6a2f9c5ae012567f4845d73b7a6d6ab088d36accc3948dbda17 --yes

# Pull all credentials
echo "⬇️  Pulling credentials..."
npx dotenv-vault@latest pull

echo "✓ Credentials available in .env ($(grep -c '^[A-Z_]*=' .env) variables)"

# 3. CLONE ESSENTIAL REPOSITORIES
# AI: Clone the core tool repositories
echo "📥 Cloning repositories..."

# jtools - Python CLI tools
git clone --quiet https://github.com/jkautto/jtools.git
echo "✓ jtools cloned"

# kaut-shared - Docker configs, standards, shared resources
git clone --quiet https://github.com/jkautto/kaut-shared.git  
echo "✓ kaut-shared cloned"

# 4. SETUP ENVIRONMENT
# AI: Configure environment for immediate use
echo "⚙️  Configuring environment..."

# Add jtools to PATH for this session
export PATH="$PATH:$HOME/kwork/jtools"

# Create convenience symlinks
ln -sf ~/kwork/.env ~/.env.kwork

# 5. CREATE CONTEXT FILE
# AI: Create a context file with key information
cat > CONTEXT.md << 'EOF'
# Development Environment Context

## Available Resources
- **Credentials**: .env file with 72+ variables (via dotenv-vault)
- **jtools**: Python CLI tools (gsheet.py, gtask.py, px.py, etc.)
- **kaut-shared**: Docker templates, MCP architecture, standards

## Key Paths
- Workspace: ~/kwork/
- Credentials: ~/kwork/.env
- Tools: ~/kwork/jtools/
- Shared Resources: ~/kwork/kaut-shared/

## Common Commands
- Google Sheets: `python3 ~/kwork/jtools/gsheet.py`
- Perplexity Search: `python3 ~/kwork/jtools/px.py`
- View credentials: `grep -E "^[A-Z_]*=" ~/kwork/.env | cut -d= -f1`

## Cleanup
When done: `rm -rf ~/kwork`
EOF

# 6. FINAL SUMMARY
echo ""
echo "✅ Setup complete!"
echo ""
echo "📁 Workspace: ~/kwork/"
echo "🔑 Credentials: ~/kwork/.env ($(grep -c '^[A-Z_]*=' .env) variables)"
echo "🛠️  Tools available in: ~/kwork/jtools/"
echo "📚 Shared resources in: ~/kwork/kaut-shared/"
echo ""
echo "🧹 Cleanup when done: rm -rf ~/kwork"
echo ""

# For AI assistants: Setup is complete. The environment is ready for use.
```

## Implementation Steps

1. **Create Web Endpoint**
   ```bash
   # On kaut.to server
   sudo mkdir -p /var/www/kaut.to/
   sudo vim /var/www/kaut.to/setup
   # Paste the script above
   sudo chmod 644 /var/www/kaut.to/setup
   ```

2. **Configure Nginx**
   ```nginx
   location = /setup {
       auth_basic "Development Setup";
       auth_basic_user_file /etc/nginx/auth/.htpasswd;
       
       add_header Content-Type "text/plain; charset=utf-8";
       try_files /setup =404;
   }
   ```

3. **Test Access**
   ```bash
   # Test authentication works
   curl -s https://joni:Penacova@kaut.to/setup | head -20
   
   # Test full execution
   curl -s https://joni:Penacova@kaut.to/setup | bash
   ```

## Security Considerations

1. **HTTPS Only**: Enforce SSL for credential transmission
2. **HTTP Basic Auth**: Existing .htpasswd protection
3. **Credential Storage**: Using dotenv-vault's secure mechanism
4. **Temporary Workspace**: Easy to remove all traces

## Benefits

1. **One Command Setup**: Single curl command gets everything
2. **No Prerequisites**: Only needs curl and npm
3. **AI-Friendly**: Clear instructions throughout
4. **Human-Executable**: Works as bash script
5. **Complete Environment**: All tools and credentials ready
6. **Easy Cleanup**: Single directory to remove

## Future Enhancements (v0.2)

- Add platform detection (Linux/Mac)
- Include PAI toolkit 
- Add interactive mode for selective installation
- Create `kwork` command for quick access
- Add update mechanism

## Usage Examples

### For New Server Setup
```bash
# SSH to new server
ssh newserver

# Run setup
curl -s https://joni:Penacova@kaut.to/setup | bash

# Start working with tools
cd ~/kwork
python3 jtools/px.py search "kubernetes best practices"
```

### For AI Assistant
```
User: Pull my development environment

AI: I'll set up your development environment:
*Executes: curl -s https://joni:Penacova@kaut.to/setup | bash*

The environment is now ready with:
- 72+ credentials in ~/kwork/.env
- jtools CLI tools in ~/kwork/jtools/
- Shared resources in ~/kwork/kaut-shared/
```

### For Temporary Work
```bash
# Quick setup for debugging
curl -s https://joni:Penacova@kaut.to/setup | bash
cd ~/kwork

# Do work...

# Clean up completely
rm -rf ~/kwork
```