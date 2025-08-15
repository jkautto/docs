# PAI Sub-Agent Implementation Guide

## Quick Start

This guide provides practical steps for implementing PAI sub-agents based on the strategic plan developed in July 2025.

## Understanding Sub-Agents

Sub-agents are specialized AI assistants that:
- Operate in separate context windows
- Have specific expertise and responsibilities
- Can be restricted to certain tools
- Are automatically invoked based on task context

## Creating Your First Sub-Agent

### Step 1: Identify the Problem

Before creating any sub-agent, document:
```markdown
Problem: [What specific issue does this solve?]
Current Time Cost: [How much time does this take daily?]
Impact if Not Solved: [What breaks or fails?]
Success Metric: [How do we measure success?]
```

### Step 2: Write the Specification

Create a specification file: `/srv/pai/.claude/agents/[agent-name]-spec.md`

```markdown
# [Agent Name] Specification

## Purpose
One sentence describing what this agent does.

## Problem Solved
Detailed description of the problem and impact.

## Success Metrics
- Metric 1: Specific measurable outcome
- Metric 2: Time saved or errors prevented

## Workflow
Step-by-step process the agent follows.

## Tools Required
List of tools and why each is needed.
```

### Step 3: Create the Agent Definition

Create the agent file: `/srv/pai/.claude/agents/[agent-name].md`

```yaml
---
name: agent-name
description: "Concise description. Use PROACTIVELY for [trigger]."
tools: Tool1, Tool2, Tool3
model: haiku|sonnet|opus
---

You are [role description].

## Core Responsibilities
1. First responsibility
2. Second responsibility
3. Third responsibility

## Decision Criteria
- When to act
- When to escalate
- When to wait

## Constraints
- What you cannot do
- What requires approval
- What to avoid
```

## Implementation Examples

### Example 1: Health Monitor Agent

```yaml
---
name: health-monitor
description: "System health monitor. Use PROACTIVELY every 30 minutes."
tools: Bash, Read, Write, gmail_tool
model: haiku
---

You are the PAI System Health Monitor.

## Core Responsibilities
1. Check OAuth token expiration
2. Verify service availability
3. Monitor resource usage
4. Auto-fix simple issues

## Auto-Fix Authority
- Add missing imports
- Restart crashed services
- Clean old logs
- Fix file permissions

## Alert Thresholds
- Token <7 days: Yellow warning
- Token <3 days: Orange alert
- Service down: Red critical
```

### Example 2: Email Master Agent

```yaml
---
name: email-master
description: "Email triage specialist. Use PROACTIVELY for email summaries."
tools: Read, Write, gmail_tool, slack_sender
model: sonnet
---

You are Joni's Email Triage Specialist.

## Core Responsibilities
1. Monitor 3 accounts (personal, xwander, accolade)
2. Identify VIP communications
3. Categorize by urgency
4. Draft routine responses

## VIP List
- Riikka Hakanen (wife) - ALWAYS urgent
- Tiina Khatnani - Team member
- Elisa Juopperi - Team member

## Categorization Rules
- URGENT: VIP + time-sensitive
- IMPORTANT: Business critical
- ROUTINE: Can wait 24 hours
- BULK: Newsletters, notifications
```

## Testing Your Sub-Agent

### Test Framework

Create test file: `/srv/pai/tests/agents/test_[agent-name].py`

```python
def test_agent_responds():
    """Test that agent responds to trigger phrase"""
    response = invoke_agent("health-monitor", "check system")
    assert "health" in response.lower()

def test_agent_tools():
    """Test that agent uses correct tools"""
    response = invoke_agent_with_mock("health-monitor")
    assert_tools_called(["Bash", "Read"])

def test_agent_failure():
    """Test graceful failure handling"""
    response = invoke_agent_with_error("health-monitor")
    assert "error" in response.lower()
    assert_no_crash()
```

### Manual Testing Checklist

- [ ] Agent responds to description triggers
- [ ] Agent uses only permitted tools
- [ ] Agent handles errors gracefully
- [ ] Agent provides clear status updates
- [ ] Agent respects defined constraints

## Deployment Process

### 1. Local Testing
```bash
# Test agent definition
claude-code --test-agent health-monitor

# Run integration tests
pytest /srv/pai/tests/agents/test_health_monitor.py
```

### 2. Staging Deployment
```bash
# Deploy to staging context
cp /srv/pai/.claude/agents/health-monitor.md \
   /srv/pai/.claude/agents/staging/

# Test in isolation
claude-code --context staging --agent health-monitor
```

### 3. Production Deployment
```bash
# Move to production
mv /srv/pai/.claude/agents/staging/health-monitor.md \
   /srv/pai/.claude/agents/

# Verify activation
claude-code --list-agents
```

## Monitoring Agent Performance

### Metrics to Track

```python
# Agent usage metrics
{
    "agent": "health-monitor",
    "invocations_daily": 48,
    "auto_fixes": 12,
    "alerts_sent": 3,
    "avg_response_time": "2.3s",
    "success_rate": "94%"
}
```

### Performance Dashboard

Check agent performance at: `https://kaut.to/ai/agents/`

Metrics displayed:
- Invocation frequency
- Success/failure rates
- Tool usage patterns
- Time saved estimates
- Error logs

## Common Patterns

### Pattern 1: Scheduled Monitor
```yaml
description: "Use PROACTIVELY every 30 minutes"
```

### Pattern 2: Event Trigger
```yaml
description: "Use when email received from VIP"
```

### Pattern 3: User Request
```yaml
description: "Use when user asks for status update"
```

### Pattern 4: Chain Trigger
```yaml
description: "Use after task-flow completes planning"
```

## Troubleshooting

### Agent Not Triggering

1. Check description includes trigger phrase
2. Verify tools are available
3. Check agent file syntax
4. Review Claude Code logs

### Agent Using Wrong Tools

1. Explicitly list allowed tools
2. Remove access to unnecessary tools
3. Add constraints in system prompt

### Agent Too Verbose

1. Add "Be concise" to system prompt
2. Specify output format
3. Use haiku model for simple tasks

### Agent Failing Tasks

1. Check tool availability
2. Verify permissions
3. Add error handling instructions
4. Increase model complexity if needed

## Best Practices

### DO:
- ✅ Start with simplest viable agent
- ✅ Test thoroughly before deployment
- ✅ Monitor performance metrics
- ✅ Document success criteria
- ✅ Use appropriate model for task complexity

### DON'T:
- ❌ Create agents for one-time tasks
- ❌ Give agents unnecessary permissions
- ❌ Chain more than 3 agents
- ❌ Ignore failure modes
- ❌ Skip testing phase

## Current Agent Roster (July 2025)

### Active Agents
1. **web-monitor-scheduler** - Website monitoring
2. **task-calendar-toolkit-manager** - Task/calendar management
3. **travel-concierge-planner** - Trip planning

### In Development
1. **health-monitor** - System health (Week 1)
2. **auth-guardian** - Authentication management (Week 1)

### Planned
1. **email-master** - Email triage (Week 2)
2. **calendar-guard** - Maker time protection (Week 2)
3. **task-flow** - 1-2-3 planning (Week 2)
4. **project-context** - Context switching (Week 3)
5. **business-intel** - Analytics (Week 3)

## Quick Commands

```bash
# List all agents
ls /srv/pai/.claude/agents/*.md

# Test specific agent
claude-code "Use health-monitor to check system"

# View agent definition
cat /srv/pai/.claude/agents/health-monitor.md

# Check agent logs
grep "health-monitor" /srv/pai/logs/claude.log

# Disable agent temporarily
mv /srv/pai/.claude/agents/health-monitor.md{,.disabled}
```

## Resources

- **Strategy Document**: `/srv/pai/.claude/agents/SUBAGENT_STRATEGY.md`
- **Architecture**: `/srv/docs/docs/architecture/pai-subagent-system.md`
- **Specifications**: `/srv/pai/.claude/agents/*-spec.md`
- **Test Suite**: `/srv/pai/tests/agents/`
- **Performance Metrics**: `https://kaut.to/ai/agents/`

---

*Last Updated: July 2025*
*Version: 1.0*
*Status: Active Development*