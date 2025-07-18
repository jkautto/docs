# Claude CLI Session Management

**Purpose**: Manage Claude CLI sessions effectively to prevent context issues and optimize performance.

## Understanding Claude Sessions

Claude CLI maintains conversation context in sessions. Each session accumulates context until cleared or reset.

### Key Concepts
- **Session ID**: Unique identifier for each conversation
- **Context Window**: Limited size (~200k tokens)
- **Context Accumulation**: Each interaction adds to context
- **Stateless Mode**: No session persistence (recommended for cron)

## Common Session Commands

```bash
# List all sessions
claude list

# View specific session
claude view SESSION_ID

# Create new session
claude new

# Kill session
claude kill SESSION_ID

# Kill all sessions
claude kill --all
```

## Best Practices

### 1. For Cron Jobs - Use Stateless Mode
```bash
# Good - No context accumulation
echo "$PROMPT" | claude -p

# Bad - Accumulates context
echo "$PROMPT" | claude -p -c

# Bad - Uses persistent session
echo "$PROMPT" | claude -r SESSION_ID
```

### 2. For Interactive Work - Use Sessions
```bash
# Create dedicated session
claude new --name "pai-monitoring"

# Resume session
claude -r SESSION_ID

# Or use the default
claude
```

### 3. For Long-Running Monitors
Create separate sessions for different purposes:
```bash
# Email monitoring session
MONITORING_SESSION=$(claude new --name "monitoring" -j | jq -r .id)

# Development session  
DEV_SESSION=$(claude new --name "development" -j | jq -r .id)
```

## Troubleshooting Session Issues

### "Prompt too long" Error

**Cause**: Context window exceeded.

**Fix**:
```bash
# For cron scripts - remove -c flag
sed -i 's/claude -p -c/claude -p/g' /path/to/script.sh

# For interactive - start fresh session
claude new
```

### "Session not found" Error

**Cause**: Session was killed or expired.

**Fix**:
```bash
# Check if session exists
claude list | grep SESSION_ID

# Create new if needed
NEW_SESSION=$(claude new -j | jq -r .id)
echo "New session: $NEW_SESSION"
```

### Sessions Growing Too Large

**Monitor session sizes**:
```bash
# Check all session sizes (approximate)
for session in $(claude list -j | jq -r '.[].id'); do
  echo "Session $session:"
  claude view $session | wc -c
done
```

**Clean up large sessions**:
```bash
# Kill sessions over 100KB
for session in $(claude list -j | jq -r '.[].id'); do
  size=$(claude view $session | wc -c)
  if [ $size -gt 100000 ]; then
    echo "Killing large session $session (${size} bytes)"
    claude kill $session
  fi
done
```

## Session Management for PAI/DAI

### Current Session Architecture

1. **Main Development** - Interactive DAI session (this one)
2. **Monitoring** - Used by monitoring scripts (should be stateless)
3. **Slack Integration** - Handles Slack routing (should be stateless)

### Recommended Changes

```bash
# Update monitoring scripts to be stateless
# In /srv/pai/monitoring/email_monitor.py:
# Change: claude -p -c
# To: claude -p

# In /srv/pai/intelligence_stack/processors/heartbeat_intelligent.sh:
# Already fixed - uses claude -p without -c
```

### Session Monitoring Script

Create `/srv/pai/monitoring/check_claude_sessions.sh`:
```bash
#!/bin/bash
# Check Claude session health

echo "=== Claude Session Status ==="
echo "Active sessions:"
claude list

echo -e "\n=== Session Sizes ==="
for session in $(claude list -j | jq -r '.[].id'); do
  size=$(claude view $session 2>/dev/null | wc -c)
  echo "Session $session: $size bytes"
done

echo -e "\n=== Recommendations ==="
# Check for oversized sessions
for session in $(claude list -j | jq -r '.[].id'); do
  size=$(claude view $session 2>/dev/null | wc -c)
  if [ $size -gt 100000 ]; then
    echo "⚠️  Session $session is large ($size bytes) - consider killing"
  fi
done

# Check for monitoring using sessions
if grep -q "claude.*-c" /srv/pai/monitoring/*.py 2>/dev/null; then
  echo "⚠️  Found monitoring scripts using -c flag (context accumulation)"
fi
```

## Prevention Strategies

### 1. Use Aliases for Common Operations
Add to `.bashrc`:
```bash
alias claude-monitoring='claude -p'  # Stateless for scripts
alias claude-dev='claude'            # Interactive with context
```

### 2. Regular Cleanup Cron
Add to crontab:
```bash
# Weekly Claude session cleanup (Sundays at 3 AM)
0 3 * * 0 /srv/pai/monitoring/cleanup_claude_sessions.sh
```

### 3. Monitor in Heartbeat
Add Claude session checks to heartbeat monitoring:
- Check number of active sessions
- Alert if any session > 100KB
- Alert if monitoring using -c flag

## Quick Reference

| Use Case | Command | Why |
|----------|---------|-----|
| Cron jobs | `claude -p` | No context accumulation |
| Monitoring | `claude -p` | Stateless, won't overflow |
| Development | `claude` or `claude -r ID` | Maintains helpful context |
| One-off tasks | `claude -p` | Clean, no side effects |

## Related Documentation
- [`common-issues.md`](./common-issues.md) - See "Claude CLI Issues" section
- [`monitoring-alerts.md`](./monitoring-alerts.md) - Claude-based alert routing
- PAI system uses Claude SDK at specific model: `claude-3-5-sonnet-20241022`