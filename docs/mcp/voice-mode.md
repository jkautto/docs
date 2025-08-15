# Voice Mode Setup for MCP

Voice Mode enables hands-free interaction with PAI tools through Claude Desktop, combining speech recognition with MCP tool integration for a seamless voice-driven productivity experience.

## Overview

Voice Mode with MCP allows you to:
- Create tasks by speaking: "Create a task to review the quarterly report"  
- Take voice notes: "Take a note about the meeting with Sarah"
- Generate daily plans: "Show me my daily task plan"
- All while maintaining natural conversation flow

## Prerequisites

### Hardware Requirements
- MacBook with macOS 12+ (Monterey or later)
- Built-in or external microphone
- Speakers or headphones for voice feedback
- Stable internet connection for MCP server

### Software Requirements
- Claude Desktop with Voice Mode support
- [MCP Configuration](local-claude-setup.md) completed
- Microphone access granted to Claude Desktop

## Audio System Setup

### 1. Microphone Configuration

Configure your input settings:
1. Open **System Preferences** > **Sound** > **Input**
2. Select your preferred microphone
3. Adjust input volume to 70-80%
4. Enable noise reduction if available

### 2. Audio Output Configuration

Configure your output settings:
1. Open **System Preferences** > **Sound** > **Output**
2. Select your preferred output device
3. Set volume to comfortable level (50-70%)

## Claude Desktop Voice Mode Setup

### 1. Enable Voice Features

In Claude Desktop settings, enable voice mode and configure for MCP tools:

```json
{
  "voice": {
    "enabled": true,
    "settings": {
      "pushToTalk": true,
      "autoStop": true,
      "language": "en-US"
    },
    "responses": {
      "confirmToolCalls": true,
      "announceResults": true
    }
  },
  "mcp": {
    "servers": [
      {
        "name": "pai-voice",
        "url": "http://mcp.kaut.to:3000",
        "auth": {"type": "basic", "username": "kaut", "password": "to"},
        "voice": {
          "enabled": true,
          "announceTools": true
        }
      }
    ]
  }
}
```

### 2. Audio Permissions

Grant necessary permissions:
1. **System Preferences** > **Security & Privacy** > **Privacy**
2. Select **Microphone** in the left sidebar
3. Enable Claude Desktop

## Voice Command Patterns

### Task Management Commands

Creating Tasks:
```
"Create a task to call the dentist"
"Add a task for tomorrow to review the contract for Accolade account" 
"I need to remember to buy groceries this evening"
```

Listing and Planning:
```
"What are my tasks for today?"
"Show me my daily plan"
"What tasks do I have for my Xwander account?"
```

### Note-Taking Commands

Creating Notes:
```
"Take a note: Meeting with Sarah was productive, discuss budget next week"
"Create a note called 'Project Ideas' with AI automation content"
"Note to self: Check the server logs after lunch"
```

Managing Notes:
```
"Show me all my notes"
"Read my note from this morning"
```

## Optimization & Performance

### Audio Quality Settings

For best recognition:
- Use a quiet room with minimal background noise
- Keep microphone 12-18 inches from your mouth
- Use wired headphones for best quality
- Speak clearly and at moderate pace

### Environmental Optimization

Ideal Environment:
- Quiet room with minimal background noise
- Close microphone placement (12-18 inches)
- Stable surface to reduce vibration noise
- Good lighting for visual feedback

## Troubleshooting Voice + MCP

### Audio Issues

**Microphone Not Working:**
1. Check System Preferences > Sound > Input
2. Verify Claude Desktop has microphone permission
3. Test microphone in other applications
4. Restart Claude Desktop

**Voice Recognition Problems:**
- Check audio levels in system preferences
- Verify language settings match Voice Mode
- Reduce background noise
- Adjust microphone position

### MCP Integration Issues

**Voice Commands Not Triggering Tools:**
1. Verify MCP server is accessible: `curl http://mcp.kaut.to:3000/health`
2. Check authentication credentials in config
3. Test text-based tool calls first
4. Review Claude Desktop logs for errors

### Privacy & Security in Voice Mode

**Data Flow:**
1. Voice input processed by Claude Desktop
2. Speech-to-text converted locally or via Anthropic
3. Tool calls sent to PAI MCP server
4. Results returned and optionally read aloud

**Privacy Considerations:**
- Some voice processing happens locally
- MCP calls use HTTP (HTTPS pending)
- Voice data not stored on PAI server
- Tool usage logged for security

## Voice Mode Best Practices

### Effective Voice Commands

Be Specific:
- "Create a task to review the quarterly budget" 
- "Make a task" 

Use Natural Language:
- "I need to call the client tomorrow morning" 
- "Remind me to check the server logs after lunch" 

Provide Context:
- "Create a task for my Xwander account to prepare the Nordic expansion presentation" 
- "Add a high-priority task to respond to the Accolade contract by Friday" 

### Workflow Integration

**Morning Routine:**
1. "What's my plan for today?" (task.plan)
2. "Any urgent tasks?" (task.list with filters)
3. "Take a note about today's priorities" (note.create)

**Meeting Mode:**
1. "Start meeting notes for [topic]"
2. Voice note-taking throughout meeting
3. "Create follow-up tasks from this meeting"

**Evening Review:**
1. "What tasks did I complete today?"
2. "Any pending tasks for tomorrow?"
3. "Take a note about today's accomplishments"

!!! success "Voice + MCP Power User"
    Once configured, Voice Mode with MCP tools becomes incredibly natural. You can manage tasks, take notes, and interact with PAI tools without touching the keyboard.

!!! tip "Quiet Environment"
    Voice Mode works best in quiet environments. Consider using a headset with noise-canceling microphone for optimal performance.

!!! warning "Network Dependency"
    Voice Mode requires both internet connectivity (for speech processing) and MCP server access. Ensure stable connections for best experience.