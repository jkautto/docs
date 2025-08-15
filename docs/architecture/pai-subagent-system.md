# PAI Sub-Agent System Architecture

## Overview

The PAI Sub-Agent System is a strategic framework for deploying specialized AI agents that address specific operational needs. Based on comprehensive system analysis conducted in July 2025, this architecture focuses on fixing critical issues before adding features.

## Current System Status

### Critical Issues (July 2025)
- **Gmail OAuth Expired**: Email monitoring non-functional
- **Calendar Collector Broken**: Missing basic import statement
- **Slack Bot Unstable**: Frequent SSL crashes
- **Manual Email Triage**: 30+ minutes daily overhead
- **No Maker Time Protection**: Interruptions during 6:30-12:00 focus blocks

### Working Components
- Morning Brief generation (6 AM)
- Batch monitoring infrastructure
- Service account calendar access
- Multi-account task management
- Web monitoring framework

## Sub-Agent Philosophy

### Core Principles
1. **Fix Before Feature**: Stabilize existing tools before adding capabilities
2. **Resilient Over Clever**: Graceful failure handling over complex logic
3. **Observable Over Invisible**: Clear status reporting and health checks
4. **Focused Over Flexible**: Single responsibility, excellent execution

### Design Patterns
```yaml
Each agent follows this structure:
- Single clear purpose
- Observable health status
- Graceful failure modes
- Measurable success metrics
- Minimal tool permissions
```

## Implementation Roadmap

### Phase 1: Foundation (Week 1)
Critical infrastructure to stabilize the system.

#### Health Monitor Agent
- **Purpose**: Proactive system monitoring and auto-fixes
- **Frequency**: Every 30 minutes
- **Auto-fixes**: Missing imports, service restarts, log cleanup
- **Alerts**: Token expiry, service failures, resource issues

#### Auth Guardian Agent  
- **Purpose**: Authentication management and renewal
- **Monitors**: OAuth tokens, API keys, service accounts
- **Actions**: 3-day expiry warnings, guided re-auth, fallback methods
- **Coverage**: Gmail, Calendar, Tasks, Slack, External APIs

### Phase 2: Daily Productivity (Week 2)
Automation of repetitive daily tasks.

#### Email Master Agent
- **Purpose**: Multi-account email triage and response
- **Accounts**: Personal, Xwander, Accolade
- **Features**: VIP detection, smart categorization, draft responses
- **Time Saved**: 30 minutes daily

#### Calendar Guard Agent
- **Purpose**: Protect maker time and optimize scheduling
- **Protection**: 6:30-12:00 AM block enforcement
- **Features**: Conflict detection, meeting optimization, auto-decline
- **Integration**: Cross-calendar visibility

#### Task Flow Agent
- **Purpose**: Intelligent task planning and routing
- **Method**: 1-2-3 daily planning (1 big, 2 medium, 3 small)
- **Routing**: Smart account assignment based on context
- **Analytics**: Completion patterns and optimization

### Phase 3: Business Intelligence (Week 3)
Strategic support for business decisions.

#### Project Context Agent
- **Purpose**: Smooth context switching between projects
- **Projects**: Northern Lights Holiday, Alone Project, Financial Systems
- **Features**: State saving, context loading, time tracking
- **Impact**: 10x faster context switches

#### Business Intel Agent
- **Purpose**: Financial and strategic analytics
- **Coverage**: Cross-account financial tracking, KPI monitoring
- **Focus**: 3-4 year business exit strategy support
- **Outputs**: Weekly reports, trend analysis, market research

## Technical Specifications

### Agent Definition Structure
```markdown
---
name: agent-name
description: "Clear purpose statement. Use PROACTIVELY for X."
tools: [Comma-separated tool list]
model: haiku|sonnet|opus (based on complexity)
---

System prompt defining:
- Core responsibilities
- Decision criteria
- Interaction patterns
- Constraints and limits
```

### Tool Permissions Matrix

| Agent | Bash | Read | Write | Email | Calendar | Tasks | Slack |
|-------|------|------|-------|-------|----------|-------|-------|
| health-monitor | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | - |
| auth-guardian | ✓ | ✓ | ✓ | - | - | - | - |
| email-master | - | ✓ | ✓ | ✓ | - | - | ✓ |
| calendar-guard | - | ✓ | ✓ | - | ✓ | ✓ | ✓ |
| task-flow | - | ✓ | ✓ | - | ✓ | ✓ | - |
| project-context | - | ✓ | ✓ | ✓ | ✓ | ✓ | - |
| business-intel | - | ✓ | ✓ | ✓ | - | - | ✓ |

### Integration Patterns

#### Morning Routine (6:00 AM)
```
health-monitor → System check
    ↓
email-master → Overnight triage
    ↓
task-flow → Generate 1-2-3 plan
    ↓
calendar-guard → Confirm maker time
    ↓
Morning Brief → Slack notification
```

#### Meeting Request Flow
```
New request → calendar-guard
    ↓
Check maker time rules
    ↓
Evaluate with project-context
    ↓
Auto-response or escalate
```

#### Project Switch Pattern
```
Context change detected → project-context
    ↓
Save current state
    ↓
Load new context
    ↓
Update task-flow priorities
    ↓
Filter email-master view
```

## Success Metrics

### System Health
- **Uptime**: >99% for core services
- **Auth Issues**: <1 per month
- **Auto-fix Rate**: >60% of detected issues
- **Detection Time**: <5 minutes for critical issues

### Productivity Gains
- **Email Triage**: <5 minutes daily (from 30+)
- **Maker Time**: Zero interruptions 6:30-12:00
- **Context Switch**: <30 seconds (from 5+ minutes)
- **Task Planning**: Automated 1-2-3 generation

### Business Impact
- **Report Generation**: Weekly automated (from manual)
- **KPI Tracking**: Real-time dashboard (from sporadic)
- **Decision Support**: Data-driven insights available

## Implementation Guidelines

### Before Building Any Agent
- [ ] Solves a real, measured daily problem
- [ ] Saves >10 minutes per day or prevents critical failures
- [ ] Can operate with degraded dependencies
- [ ] Has clear success metrics
- [ ] Integrates with existing tools

### Each Agent Must Have
- [ ] Detailed specification document
- [ ] Observable health status
- [ ] Graceful failure handling
- [ ] Integration test suite
- [ ] Performance benchmarks

### Testing Requirements
1. **Unit Tests**: Core functionality
2. **Integration Tests**: Tool interactions
3. **Failure Tests**: Graceful degradation
4. **Performance Tests**: Response times
5. **User Acceptance**: Real workflow validation

## Current Status (July 2025)

### Completed
- ✅ System analysis and pain point identification
- ✅ Strategic plan and prioritization
- ✅ Health Monitor specification
- ✅ Documentation framework

### In Progress
- 🔄 Health Monitor implementation
- 🔄 Auth Guardian design

### Planned
- 📋 Email Master development
- 📋 Calendar Guard development
- 📋 Task Flow development
- 📋 Project Context development
- 📋 Business Intel development

## Quick Reference

### File Locations
- **Strategy**: `/srv/pai/.claude/agents/SUBAGENT_STRATEGY.md`
- **Specifications**: `/srv/pai/.claude/agents/*-spec.md`
- **Agent Definitions**: `/srv/pai/.claude/agents/*.md`
- **Test Suites**: `/srv/pai/tests/agents/`
- **Monitoring**: `/srv/pai/monitoring/agent_health/`

### Key Commands
```bash
# Check agent health
pai-agent health

# List active agents
pai-agent list

# Test specific agent
pai-agent test health-monitor

# View agent metrics
pai-agent metrics email-master
```

## Next Steps

1. **Immediate**: Fix calendar_collector.py import issue
2. **Today**: Complete Health Monitor implementation
3. **This Week**: Deploy Auth Guardian
4. **Next Week**: Roll out productivity agents
5. **Month Goal**: Full sub-agent ecosystem operational

---

*Last Updated: July 2025*
*Based on: Comprehensive PAI system analysis*
*Status: Active development*