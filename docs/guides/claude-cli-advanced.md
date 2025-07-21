# Claude CLI Advanced Features

## System Prompt Customization

The Claude CLI supports dynamic system prompt customization through command-line flags, enabling context-specific behavior without modifying code.

## Available Flags

### `--system-prompt` (Override)

Completely replaces the default system prompt.

```bash
# Example: Technical expert
claude -p "Review this Python code" \
  --system-prompt "You are a senior Python developer with 10 years of experience. Focus on performance, security, and maintainability."

# Example: Content writer
claude -p "Write product description for hiking boots" \
  --system-prompt "You are a professional copywriter specializing in outdoor gear. Write compelling, SEO-friendly descriptions that highlight features and benefits."
```

### `--append-system-prompt` (Extend)

Adds instructions to the existing system prompt.

```bash
# Example: Add formatting requirements
claude -p "Analyze sales data" \
  --append-system-prompt "Always provide actionable recommendations. Format numbers with thousands separators. Keep analysis under 300 words."

# Example: Add constraints
claude -p "Draft email to team" \
  --append-system-prompt "Keep responses under 100 words. Use professional but friendly tone. Include a clear call-to-action."
```

### Combined Usage

Both flags can be used together:

```bash
claude -p "Create project timeline" \
  --system-prompt "You are an experienced project manager specializing in agile methodologies." \
  --append-system-prompt "Include risk assessments for each milestone. Format as a table with dates."
```

## Important Limitations

⚠️ **These flags only work with `-p/--print` mode**

```bash
# ✅ Correct - works with print mode
claude -p "Your prompt" --system-prompt "Custom prompt"

# ❌ Wrong - won't work in interactive mode
claude --system-prompt "Custom prompt"  # Opens interactive session, ignores flag
```

## PAI/DAI Integration Examples

### Monitoring System Enhancement

#### Morning Brief
```bash
#!/bin/bash
CALENDAR_DATA=$(gcal_tool today)
TASK_DATA=$(task_tool today)

claude -p "Create morning brief: Calendar: $CALENDAR_DATA Tasks: $TASK_DATA" \
  --system-prompt "You are Joni's personal morning assistant providing a warm, encouraging start to the day." \
  --append-system-prompt "Highlight any conflicts. Mention family events prominently. Keep under 200 words. Use bullet points."
```

#### Email Triage
```bash
EMAIL_DATA=$(python3 /srv/pai/toolkit/gmail_tool.py unread)

claude -p "Analyze emails for urgency: $EMAIL_DATA" \
  --system-prompt "You are an email triage specialist. Categorize emails by urgency and required action." \
  --append-system-prompt "Flag emails from Riikka as VIP. Identify emails requiring response today. Summarize action items."
```

### Slack Bot Integration

In `/srv/pai/slack.py`:

```python
# Build command with Slack formatting
cmd = [
    '/home/joni/.npm-global/bin/claude', '-c', '-p',
    f"[Slack User: {user_id}] {text}",
    '--model', self.model,
    '--append-system-prompt', 
    'Format your responses for Slack using Slack message formatting: Use *bold* (not **bold**), _italic_ (not *italic*), ~strikethrough~, `code`, ```code blocks```, and :emoji: syntax. Use • for bullet points.'
]
```

### Context-Aware Responses

```python
def get_context_prompt(hour, stress_level):
    """Generate time and context-aware prompts"""
    
    base_prompt = "You are PAI, a helpful personal AI assistant."
    
    if hour < 9:
        append = "Morning context: Be energetic and motivating. Focus on the day ahead."
    elif hour < 17:
        append = "Workday context: Be focused and efficient. Prioritize urgent matters."
    else:
        append = "Evening context: Help wind down. Focus on family time and relaxation."
    
    if stress_level == "high":
        append += " User has a stressful day. Be extra supportive and suggest simplifications."
    
    return base_prompt, append
```

## Prompt Engineering Best Practices

### 1. Keep Prompts Concise
- System prompts: Under 200 words
- Append prompts: Under 100 words
- Total combined: Under 500 words

### 2. Be Specific
```bash
# ❌ Vague
--append-system-prompt "Be helpful"

# ✅ Specific
--append-system-prompt "Provide step-by-step instructions. Number each step. Include time estimates."
```

### 3. Use Role Definitions
```bash
# Define expertise and perspective
--system-prompt "You are a senior DevOps engineer with expertise in Kubernetes and cloud architecture."

# Add specific constraints
--append-system-prompt "Always consider security implications. Suggest monitoring strategies."
```

### 4. Format Instructions
```bash
# Specify output format
--append-system-prompt "Format response as: 1) Summary (2 sentences), 2) Details (bullet points), 3) Next steps (numbered list)"
```

## Testing Prompts

### Quick Testing Script
```bash
#!/bin/bash
# test_prompts.sh

TEST_INPUT="What are the top 3 priorities for today?"

echo "=== Testing Different Personalities ==="

echo -e "\n1. Executive Assistant:"
claude -p "$TEST_INPUT" \
  --system-prompt "You are an executive assistant focused on productivity and efficiency."

echo -e "\n2. Life Coach:"
claude -p "$TEST_INPUT" \
  --system-prompt "You are a supportive life coach focused on work-life balance and wellbeing."

echo -e "\n3. Technical Advisor:"
claude -p "$TEST_INPUT" \
  --system-prompt "You are a technical advisor who relates everything to systems and optimization."
```

## Advanced Use Cases

### Dynamic Prompt Selection

```python
# prompt_manager.py
import json

class PromptManager:
    def __init__(self):
        self.prompts = {
            "email": {
                "urgent": {
                    "system": "You are an email crisis manager.",
                    "append": "Focus only on time-critical items. Be extremely concise."
                },
                "normal": {
                    "system": "You are an email assistant.",
                    "append": "Summarize key points. Group by topic."
                }
            },
            "tasks": {
                "planning": {
                    "system": "You are a productivity coach.",
                    "append": "Suggest time blocks. Consider energy levels."
                },
                "review": {
                    "system": "You are a project analyst.",
                    "append": "Identify blockers. Suggest optimizations."
                }
            }
        }
    
    def get_prompt(self, category, mode):
        prompt_config = self.prompts.get(category, {}).get(mode, {})
        return (
            prompt_config.get("system", "You are a helpful assistant."),
            prompt_config.get("append", "")
        )
```

### Prompt Chaining

```bash
# First pass: Extract key information
SUMMARY=$(claude -p "Extract key points from: $LONG_TEXT" \
  --system-prompt "You are a summarization expert." \
  --append-system-prompt "Output only bullet points. Maximum 5 points.")

# Second pass: Generate action items
claude -p "Based on these points, what actions are needed: $SUMMARY" \
  --system-prompt "You are a project manager focused on execution." \
  --append-system-prompt "Create specific, assignable tasks with deadlines."
```

## Performance Considerations

### Token Usage
- Longer prompts = more tokens = higher cost
- System prompts are included in every request
- Balance specificity with efficiency

### Caching Strategy
```bash
# Cache frequently used prompt combinations
EMAIL_PROMPT="--system-prompt 'You are an email assistant.' --append-system-prompt 'Be concise.'"
claude -p "Process email" $EMAIL_PROMPT
```

### Monitoring Prompt Effectiveness
```python
# Log prompt performance
import time
import json

def log_prompt_usage(prompt_type, system_prompt, append_prompt, response_time, quality_score):
    log_entry = {
        "timestamp": time.time(),
        "type": prompt_type,
        "system_prompt_length": len(system_prompt),
        "append_prompt_length": len(append_prompt),
        "response_time": response_time,
        "quality_score": quality_score
    }
    
    with open("/srv/pai/logs/prompt_performance.jsonl", "a") as f:
        f.write(json.dumps(log_entry) + "\n")
```

## Security Considerations

### Never Include Sensitive Data
```bash
# ❌ Wrong - exposes API key
--system-prompt "Use API key: sk-123456"

# ✅ Right - reference without exposing
--system-prompt "You have access to approved APIs. Never expose credentials."
```

### Sanitize User Input
```python
def sanitize_prompt(user_input):
    # Remove potential prompt injections
    sanitized = user_input.replace("--system-prompt", "")
    sanitized = sanitized.replace("--append-system-prompt", "")
    return sanitized
```

## Integration with PAI Monitoring

The Intelligence Stack can leverage these features:

```python
# /srv/pai/monitoring/email_processor.py
async def process_emails(self, email_data):
    # Determine urgency level
    urgent_count = sum(1 for e in email_data if 'urgent' in e.get('subject', '').lower())
    
    if urgent_count > 3:
        system_prompt = "You are in crisis management mode. Be extremely direct."
        append_prompt = "List only critical actions. Use @mentions for urgent items."
    else:
        system_prompt = "You are a helpful email assistant."
        append_prompt = "Provide a calm, organized summary."
    
    cmd = [
        'claude', '-p', json.dumps(email_data),
        '--system-prompt', system_prompt,
        '--append-system-prompt', append_prompt
    ]
```

## Future Possibilities

### Multi-Language Support
```bash
claude -p "Bonjour, comment allez-vous?" \
  --append-system-prompt "Detect the user's language and respond in the same language."
```

### Personality Persistence
```python
# Save preferred prompts per user
user_preferences = {
    "default_system": "You are a friendly, professional assistant.",
    "morning_append": "Start with an encouraging greeting.",
    "evening_append": "Include reminders about work-life balance."
}
```

### A/B Testing Prompts
```python
import random

prompts_a = {"system": "You are concise.", "append": "Use bullets."}
prompts_b = {"system": "You are detailed.", "append": "Explain thoroughly."}

selected = random.choice([prompts_a, prompts_b])
# Track which performs better
```

## Related Documentation

- [PAI Slack Bot](../applications/slack-bot.md) - How prompts are used in Slack
- [Intelligence Stack](../architecture/intelligence-stack.md) - Monitoring integration
- [Operations Playbooks](../operations/) - Prompt usage in automation