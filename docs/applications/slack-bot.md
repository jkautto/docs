# PAI Slack Bot

## Overview

The PAI Slack Bot is a unified implementation providing an intelligent interface to PAI (Personal AI Assistant) through Slack. It uses Socket Mode for real-time bidirectional communication and features an interactive UI with Block Kit components.

## Architecture

### Core Components

```
/srv/pai/
├── slack.py           # Main bot implementation
├── slack.sh           # Startup script with process management
├── .env.slack         # Bot tokens (Socket Mode)
├── .env              # Webhook URLs
└── logs/
    └── slack.log     # Bot activity logs
```

### Key Classes

- **`PAISlackBot`** - Main bot class handling all Slack interactions
- **`Config`** - Centralized configuration management
- **`Logger`** - Multi-channel logging system with webhook fallback
- **`PAIInterface`** - Claude CLI integration with session persistence
- **`UIBuilder`** - Block Kit UI component factory
- **`UserRestrictions`** - Access control (currently Joni only)

## Features

### Interactive UI

The bot provides a rich interactive experience using Slack's Block Kit:

- **Main Menu** - Triggered by "menu", "help", "?" or empty message
- **Action Buttons**:
  - 📅 Today's Schedule - Shows calendar events
  - 📧 Check Emails - Displays unread email summary
  - ✅ Show Tasks - Lists current tasks
  - 🔍 Research - Opens Perplexity AI search modal
  - 💬 Ask PAI - Direct question modal

### Response Modes

Configurable via `--mode` flag:

1. **`pai-channel`** (default) - Responds to all messages in #pai + DMs + mentions
2. **`mentions-only`** - Only responds to @mentions and DMs  
3. **`all`** - Responds to all messages in all channels (use carefully)

### Claude Integration

Uses Claude CLI with intelligent session management:

```bash
/home/joni/.npm-global/bin/claude -c -p "[Slack User: ID] message" \
  --model sonnet \
  --append-system-prompt "Format for Slack: *bold*, _italic_, :emoji:, • bullets"
```

Features:
- Directory-based sessions (`-c` flag) in `/srv/pai`
- Context persistence across conversations
- Slack-specific formatting via system prompt
- Markdown to Slack syntax conversion

### Multi-Channel Logging

Verbose logging system with fallback mechanism:

1. **Channel API** - Primary method for #pai-verbose
2. **Webhook Fallback** - When channel not found or API fails
3. **Structured Logs** - Color-coded by severity (INFO, WARNING, ERROR, DEBUG)

## Configuration

### Environment Variables

#### `.env.slack` (Required)
```bash
SLACK_BOT_TOKEN=xoxb-...  # Bot User OAuth Token  
SLACK_APP_TOKEN=xapp-...  # Socket Mode App Token
```

#### `.env` (Optional Webhooks)
```bash
SLACK_PAI_WEBHOOK=https://hooks.slack.com/...
SLACK_PAI_VERBOSE_WEBHOOK=https://hooks.slack.com/...
SLACK_PAI_NOTIFICATIONS_WEBHOOK=https://hooks.slack.com/...
```

### Slack App Configuration

#### Required Bot Token Scopes
- `app_mentions:read` - Read when bot is mentioned
- `channels:history` - Read public channel messages
- `channels:read` - List channels
- `chat:write` - Send messages
- `files:write` - Upload files
- `groups:history` - Read private channel messages (#pai)
- `groups:read` - List private channels
- `im:history` - Read direct messages
- `im:read` - List DM conversations
- `im:write` - Send DMs

#### Event Subscriptions
Enable these in your Slack app settings:
- `app_mention` - When bot is @mentioned
- `message.channels` - Messages in public channels
- `message.groups` - Messages in private channels
- `message.im` - Direct messages

#### Socket Mode
- **Must be enabled** for real-time events
- Requires App-Level Token with `connections:write` scope
- More reliable than Events API (no public URL needed)

## Usage

### Starting the Bot

```bash
# Default mode (pai-channel)
cd /srv/pai
./slack.sh

# With verbose logging
./slack.sh --verbose

# Run in background (daemon)
./slack.sh --daemon

# Specific mode
./slack.sh --mode mentions-only
```

### Interacting with the Bot

1. **Show Menu**: Type "menu", "help", "?" or send empty message
2. **Direct Questions**: Just type naturally in #pai or DM
3. **Research**: Click 🔍 button, enter query in modal
4. **Quick Actions**: Use buttons for calendar, emails, tasks

### Process Management

The `slack.sh` script includes robust process management:

```bash
# Automatically kills:
- Existing slack.py processes
- Old slack_v2* processes  
- Processes from PID file
- Any slack.*bot.*py variants

# Verifies single instance after startup
# Logs to /srv/pai/logs/slack.log
```

## Slack Message Formatting

The bot automatically converts markdown to Slack syntax:

| Markdown | Slack | Example |
|----------|-------|---------|
| `**text**` | `*text*` | *bold* |
| `*text*` | `_text_` | _italic_ |
| `## Header` | `*Header*` | *Header* |
| `- item` | `• item` | • bullet |
| `:emoji:` | `:emoji:` | :white_check_mark: |

This is handled by:
1. `--append-system-prompt` flag telling Claude to use Slack formatting
2. `markdown_to_slack()` function as fallback converter

## Troubleshooting

### Bot Not Responding

1. **Check Process**:
   ```bash
   ps aux | grep "python3.*slack.py" | grep -v grep
   cat /srv/pai/slack.pid
   ```

2. **Verify Tokens**:
   - App token must start with `xapp-` (not `xoxb-`)
   - Bot token must start with `xoxb-`
   - Socket Mode must be enabled

3. **Check Channel Access**:
   - Bot must be invited to #pai channel
   - Event subscription for `message.groups` is critical

4. **Review Logs**:
   ```bash
   tail -f /srv/pai/logs/slack.log
   ```

### Common Errors

#### "Event loop is closed"
```bash
# Kill all processes and restart
pkill -f "python.*slack"
rm -f /srv/pai/slack.pid
./slack.sh --daemon
```

#### Bot receives mentions but not regular messages
- Check if bot is in #pai channel
- Verify `message.groups` event subscription
- Confirm channel ID matches (hardcoded: C08VA59A4CS)

#### Multiple responses
- Run `./slack.sh` which auto-kills duplicates
- Check for multiple bot instances
- Verify single PID in `/srv/pai/slack.pid`

## Advanced Features

### Perplexity Search Integration

Accessed via Research button:
```python
async def search_perplexity(query):
    cmd = ['python3', '/srv/jtools/px.py', '-r', query]
    # Returns AI-powered search results with citations
```

### Session Persistence

Claude maintains conversation context:
- Sessions tied to `/srv/pai` directory
- Survives bot restarts
- Accessible via `claude -c` flag

### User Restrictions

Currently limited to authorized users:
```python
ALLOWED_USER_IDS = ["UGQR4AJNS"]  # Joni's Slack ID
```

## Development

### Adding New Features

1. Add handler method to `PAISlackBot` class
2. Register in `_register_handlers()`
3. Update `UIBuilder` for new UI components
4. Test with verbose logging enabled

### Testing

```bash
# Test configuration
./slack.sh --test

# Run with debug output
./slack.sh --debug --verbose

# Monitor real-time logs
tail -f /srv/pai/logs/slack.log
```

## Webhook Configuration

For reliable system notifications, configure webhooks:

1. Go to Slack App settings → Incoming Webhooks
2. Activate and add new webhook for each channel
3. Add URLs to `/srv/pai/.env`

Used for:
- System startup/shutdown notifications
- Verbose logging when channel API fails
- Monitoring alerts from Intelligence Stack

## Related Documentation

- [Slack Recovery Playbook](../operations/slack-recovery.md) - Restore bot after crashes
- [Claude CLI Advanced Features](../guides/claude-cli-advanced.md) - System prompt usage
- [Intelligence Stack](../architecture/intelligence-stack.md) - Bot's role in monitoring

## Version History

- **v0.3.1** (2025-06-17) - Current unified implementation
  - Fixed Claude CLI path issues
  - Added Slack formatting conversion
  - Enhanced process management
  - Hardcoded #pai channel fallback

- **v0.2.x** - Previous enhanced bot with Block Kit UI
- **v0.1.x** - Original simple bot implementation