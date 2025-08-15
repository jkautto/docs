# Claude Code Sub-Agents

## Overview

Claude Code CLI supports native sub-agents - specialized AI assistants that can be invoked from within the main Claude Code session. These sub-agents provide focused expertise and can be created programmatically by AI to handle specific domains or tasks.

## What Are Sub-Agents?

Sub-agents are separate Claude instances with:
- **Specialized prompts** for specific domains (email, tasks, travel, etc.)
- **Independent context windows** from the main Claude session
- **Custom model selection** (Haiku, Sonnet, Opus)
- **Defined personalities and capabilities** through system prompts

## Key Differences from PAI Sub-Agents

| Feature | Claude Code Sub-Agents | PAI Sub-Agents |
|---------|------------------------|----------------|
| **Purpose** | Native CLI sub-agents with YAML frontmatter | PAI system task routing via Task tool |
| **Location** | `.claude/agents/` directory | `/srv/pai/.claude/agents/` |
| **Format** | YAML frontmatter + Markdown | Custom agent definitions |
| **Invocation** | Direct CLI commands | Task tool with `subagent_type` |
| **Restart Required** | ✅ **YES - Critical!** | No |

## CRITICAL REQUIREMENT: Restart After Creation

⚠️ **IMPORTANT**: After creating or modifying Claude Code sub-agent files, you **MUST restart the Claude Code CLI** for them to be recognized and available.

```bash
# After creating/modifying agents, restart Claude Code CLI
# Exit current session (Ctrl+C or exit command)
# Then restart Claude Code
```

**This restart step is mandatory and often forgotten!**

## Sub-Agent File Structure

### Directory Structure

Sub-agents can be placed in two locations:

```
# Project-level agents (preferred for project-specific agents)
.claude/agents/
├── task-agent.md
├── email-agent.md
├── travel-agent.md
└── research-agent.md

# User-level agents (for global agents used across projects)
~/.claude/agents/
├── writing-assistant.md
├── code-reviewer.md
└── translator.md
```

### YAML Frontmatter Format

Every sub-agent file **MUST** start with YAML frontmatter:

```yaml
---
name: agent-name
description: "Brief description of the agent's purpose and when to use it"
model: haiku|sonnet|opus
color: "#hex-color"  # Optional, for UI display
---

# Agent system prompt content goes here
```

#### Required Fields

- **`name`**: Unique identifier for the agent (used in CLI commands)
- **`description`**: Clear description of what the agent does
- **`model`**: Which Claude model to use (`haiku`, `sonnet`, or `opus`)

#### Optional Fields

- **`color`**: Hex color code for visual identification in UI (e.g., `"#3B82F6"`)

## Complete Agent Examples

### Example 1: Task Management Agent

**File**: `.claude/agents/task-agent.md`

```yaml
---
name: task-agent
description: "Specialized task and calendar management across multiple Google accounts (personal, xwander, accolade). Expert in GTD methodology and time blocking."
model: sonnet
color: "#10B981"
---

You are the Task Management Specialist for Joni Kautto's productivity system.

## Core Expertise
- Multi-account Google Tasks and Calendar management
- Getting Things Done (GTD) methodology
- Time blocking and schedule optimization
- Context-aware task routing between accounts

## Account Management
- **Personal** (joni.kautto@gmail.com): Personal tasks and calendar
- **Xwander** (joni@xwander.fi): Business tasks and meetings
- **Accolade** (joni@accolade.fi): Client work and projects

## Key Capabilities
1. **Smart Task Creation**: Route tasks to appropriate accounts based on context
2. **Calendar Analysis**: Identify conflicts and optimize scheduling
3. **Daily Planning**: Generate 1-2-3 daily plans (1 big, 2 medium, 3 small tasks)
4. **Context Switching**: Help transition between different project contexts

## Tools Available
Use the multi-account task and calendar tools:
- `/srv/pai/toolkit/task.py` for task management
- `/srv/pai/toolkit/calendar_service_account.py` for calendar access
- `/srv/pai/toolkit/tasks_tool_multi.py` for advanced multi-account operations

## Response Style
- Concise and actionable
- Include specific commands when helpful
- Explain routing decisions for multi-account operations
- Focus on productivity outcomes
```

### Example 2: Email Management Agent

**File**: `.claude/agents/email-agent.md`

```yaml
---
name: email-agent
description: "Email triage specialist for multi-account email management. Expert in VIP detection, smart categorization, and response drafting."
model: sonnet
color: "#EF4444"
---

You are Joni Kautto's Email Triage Specialist.

## Primary Responsibilities
1. **Multi-Account Monitoring**: personal, xwander, accolade email accounts
2. **VIP Detection**: Identify high-priority communications
3. **Smart Categorization**: Urgent, Important, Routine, Bulk
4. **Response Drafting**: Prepare replies for routine communications

## VIP Contact List
- **Riikka Hakanen** (wife) - ALWAYS highest priority
- **Tiina Khatnani** - Team member at Xwander
- **Elisa Juopperi** - Team member at Xwander
- **Client communications** - Business critical

## Categorization Rules

### URGENT (Immediate Action)
- VIP contacts with time-sensitive requests
- Calendar conflicts or meeting changes
- System alerts or service disruptions
- Client escalations

### IMPORTANT (Same Day)
- Business opportunities
- Team communications
- Non-urgent VIP messages
- Administrative deadlines

### ROUTINE (24-48 hours)
- Standard business communications
- Newsletter digests
- Non-critical updates
- Scheduling requests

### BULK (Filter/Archive)
- Marketing emails
- Automated notifications
- Spam or low-value content

## Tools Available
- `/srv/pai/toolkit/gmail_tool.py` for email operations
- Always use `--account all` for multi-account searches

## Communication Style
- **Urgent items**: Clear action required, @Joni mention in Slack
- **Summaries**: Concise bullet points with sender, subject, urgency
- **Draft responses**: Professional but warm tone matching Joni's style
```

### Example 3: Simple Research Agent

**File**: `.claude/agents/research-agent.md`

```yaml
---
name: research-agent
description: "Research assistant for comprehensive information gathering, analysis, and report generation on any topic."
model: opus
color: "#8B5CF6"
---

You are a Research Specialist focused on thorough information gathering and analysis.

## Core Capabilities
- Deep research across multiple sources
- Fact verification and source credibility assessment
- Synthesis of complex information into actionable insights
- Competitive analysis and market research
- Technical documentation and trend analysis

## Research Methodology
1. **Source Diversification**: Use multiple types of sources (academic, industry, news, official)
2. **Credibility Assessment**: Evaluate source reliability and potential bias
3. **Cross-Reference Verification**: Confirm facts across multiple sources
4. **Temporal Analysis**: Consider how information changes over time
5. **Synthesis**: Combine insights into coherent, actionable conclusions

## Output Formats
- **Executive Summary**: Key findings in 2-3 bullet points
- **Detailed Analysis**: Comprehensive breakdown with sources
- **Actionable Recommendations**: Specific next steps based on findings
- **Source Citations**: Clear references for further investigation

## Research Areas
- Business strategy and market analysis
- Technology trends and implementation guidance
- Travel and location research
- Financial and investment analysis
- Competitive intelligence

## Tools Available
- Web search and analysis tools
- Document processing capabilities
- Data synthesis and reporting tools
```

## Creating Sub-Agents Programmatically

As an AI assistant, you can create sub-agents for users. Here's the process:

### 1. Identify the Need

Before creating a sub-agent, ensure it addresses a real need:
- Specialized domain expertise required
- Repeated similar requests from user
- Complex multi-step processes
- Need for consistent context/personality

### 2. Design the Agent

Plan the agent's:
- **Purpose**: What specific problem does it solve?
- **Expertise**: What domain knowledge does it need?
- **Personality**: How should it communicate?
- **Model**: Which Claude model fits the complexity?

### 3. Create the File

```bash
# Create the agent file in the .claude/agents directory
# Use descriptive names that match the agent's purpose
```

### 4. CRITICAL: Inform User About Restart

**Always emphasize this step to the user:**

"⚠️ **IMPORTANT**: I've created the sub-agent file, but you must **restart Claude Code CLI** for it to become available. Exit your current session and restart Claude Code to use the new agent."

## Using Sub-Agents

Once created and after CLI restart, sub-agents can be invoked in several ways:

### Direct Invocation
```bash
# Use the agent name directly in prompts
"Use task-agent to analyze my calendar conflicts for next week"
"Ask email-agent to triage my inbox from the past 24 hours"
"Have research-agent investigate market trends in AI productivity tools"
```

### Context Switching
```bash
# Switch to agent context for focused work
"Switch to task-agent mode for project planning"
"Let me work with email-agent on organizing communications"
```

## Best Practices for Agent Design

### DO:
- ✅ **Clear Purpose**: Each agent should have a focused, specific role
- ✅ **Appropriate Model**: Use Haiku for simple tasks, Sonnet for balanced work, Opus for complex analysis
- ✅ **Consistent Personality**: Maintain the same tone and approach throughout
- ✅ **Tool Integration**: Reference specific tools and file paths when relevant
- ✅ **Domain Expertise**: Include specialized knowledge and methodologies
- ✅ **Example Interactions**: Show how the agent should respond

### DON'T:
- ❌ **Overlap Agents**: Avoid creating agents with similar purposes
- ❌ **Over-Complexity**: Keep agents focused on specific domains
- ❌ **Generic Agents**: Avoid vague, general-purpose agents
- ❌ **Forget Restart**: Always remind users to restart CLI after creation
- ❌ **Missing Frontmatter**: Every agent file needs proper YAML headers

## Troubleshooting

### Agent Not Available After Creation

**Problem**: Created agent file but it doesn't appear in Claude Code CLI

**Solution**: 
1. ✅ Verify YAML frontmatter format is correct
2. ✅ Check file is in `.claude/agents/` directory
3. ✅ **RESTART Claude Code CLI** (most common issue)
4. ✅ Verify file permissions allow reading

### Agent Not Responding as Expected

**Problem**: Agent exists but doesn't behave according to its prompt

**Solution**:
1. Check the system prompt for clarity and specificity
2. Verify the model selection is appropriate for the task complexity
3. Test with simple, direct invocations first
4. Review the prompt for any conflicting instructions

### Wrong Model Selection

**Problem**: Agent is too slow/expensive (Opus) or too simple (Haiku)

**Solution**:
- **Use Haiku for**: Simple tasks, quick responses, routine operations
- **Use Sonnet for**: Balanced complexity, most general use cases, analysis
- **Use Opus for**: Complex reasoning, detailed analysis, creative tasks

## Integration with PAI System

Claude Code sub-agents complement but are separate from PAI sub-agents:

- **Claude Code sub-agents**: Native CLI functionality with YAML frontmatter
- **PAI sub-agents**: Task routing within the PAI ecosystem using Task tool

Both can coexist and serve different purposes in a comprehensive AI assistance setup.

## Quick Reference

### Creating a New Agent

1. **Create file**: `.claude/agents/agent-name.md`
2. **Add YAML frontmatter** with name, description, model
3. **Write specialized system prompt**
4. **Inform user to restart CLI**
5. **Test agent after restart**

### Essential Commands

```bash
# List available agents (after restart)
# This will show agents in the CLI interface

# Invoke agent directly in prompts
"Use [agent-name] to [specific task]"

# Check agent files
ls .claude/agents/
cat .claude/agents/task-agent.md
```

### Common Agent Types

- **Domain Experts**: email-agent, task-agent, travel-agent
- **Workflow Specialists**: project-manager, code-reviewer, writer
- **Analysis Tools**: research-agent, data-analyst, market-researcher
- **Creative Assistants**: content-creator, designer, strategist

## Related Documentation

- **[PAI Sub-Agent Implementation](pai-subagent-implementation.md)** - PAI system sub-agents (different system)
- **[AI Agent Development](ai-agent-development.md)** - General AI agent principles
- **[Claude Code PM Guide](claude-code-pm-guide.md)** - Project management with Claude Code
- **[MCP Claude Code Setup](mcp-claude-code-setup.md)** - MCP server integration

---

*Remember: Always restart Claude Code CLI after creating or modifying sub-agent files!*