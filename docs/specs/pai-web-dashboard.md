# PAI Web Dashboard Specification v0.1
# Modular Personal AI Assistant Interface for kaut.to

## Executive Summary

This specification outlines the development of a modular web dashboard for PAI (Personal AI Assistant) at kaut.to. The system will start with a core chat interface and progressively add panels for email, calendar, tasks, and notes management. Built with NiceGUI for rapid development and easy modularity, it will integrate with the existing PAI Claude CLI backend.

## Vision & Goals

### Primary Goal
Create a unified web interface where users can interact with their AI assistant and view all personal data streams in one compact, mobile-friendly dashboard.

### Design Philosophy
- **Apple-inspired but compact**: Clean aesthetics with smaller fonts and denser information display
- **Progressive disclosure**: Start with chat, add features gradually
- **Mobile-first**: Optimized for iPhone 16 Pro Max (430×932px viewport)
- **Context-aware**: Leverages shared context library between DAI/PAI
- **Real-time**: Live updates across all panels

## Technical Architecture

### Framework Choice: NiceGUI
**Rationale:**
- Pure Python (no JavaScript required)
- Built-in components for chat, file upload, real-time updates
- Easy panel/layout management
- WebSocket support out of the box
- Minimal code for maximum functionality

### System Architecture
```
┌─────────────────────────────────────────────────────┐
│                   nginx (kaut.to)                   │
│                  HTTP Basic Auth                    │
└─────────────────┬───────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────┐
│          NiceGUI Web Server (port 8080)            │
│  ┌─────────┬─────────┬──────────┬────────────┐    │
│  │  Chat   │  Email  │ Calendar │   Tasks    │    │
│  │  Panel  │ Summary │   View   │ Management │    │
│  └────┬────┴────┬────┴────┬─────┴─────┬──────┘    │
│       │         │         │           │            │
└───────┼─────────┼─────────┼───────────┼────────────┘
        │         │         │           │
┌───────▼─────────▼─────────▼───────────▼────────────┐
│              PAI Backend Services                   │
│  ┌──────────────┐ ┌─────────────┐ ┌────────────┐  │
│  │ Claude CLI   │ │   Toolkit   │ │ Intel Stack│  │
│  │ with -c flag │ │   Modules   │ │ Collectors │  │
│  └──────────────┘ └─────────────┘ └────────────┘  │
└─────────────────────────────────────────────────────┘
```

## Implementation Phases

### Phase 1: Core Chat Interface (Week 1)
**Features:**
- Single conversation view with Claude
- File/image upload support
- Voice input (using browser API)
- Message history with scroll
- Typing indicators
- Real-time streaming responses

**Technical Details:**
```python
# Core structure
app = NiceGUI()

# Layout: Sidebar (collapsed on mobile) + Main chat area
# Chat uses subprocess to call: claude -c -p "user message"
# WebSocket for streaming responses
# SQLite for message history
```

### Phase 2: Multi-Panel Foundation (Week 2)
**Features:**
- Collapsible sidebar navigation
- Panel switching system
- Email summary panel (placeholder)
- Calendar view panel (placeholder)
- Tasks panel (placeholder)
- Settings panel

**Layout Mockup:**
```
┌─────┬────────────────────────────────┐
│ ☰ AI│  Chat with PAI                 │
├─────┤ ┌────────────────────────────┐ │
│ 💬  │ │ How can I help you today?  │ │
│ 📧  │ └────────────────────────────┘ │
│ 📅  │ ┌────────────────────────────┐ │
│ ✓   │ │ [Type message...] 🎤 📎 ➤  │ │
│ ⚙️  │ └────────────────────────────┘ │
└─────┴────────────────────────────────┘
```

### Phase 3: Email Integration (Week 3)
**Features:**
- Live email summaries from monitoring
- Unread count badges
- Priority inbox view
- Quick actions (archive, reply via AI)
- Search functionality

**Integration:**
- Reads from `/srv/pai/intelligence_stack/data/`
- Updates every 10 minutes (matching monitoring schedule)
- Claude analyzes importance

### Phase 4: Calendar Integration (Week 4)
**Features:**
- Today/Week/Month views
- Conflict detection highlights
- Meeting preparation alerts
- Quick event creation
- Finnish holidays display

**Integration:**
- Uses calendar_collector.py data
- Real-time updates via WebSocket
- Morning brief integration

### Phase 5: Task Management (Week 5)
**Features:**
- Task lists with priorities
- Drag-and-drop reordering
- Quick add with natural language
- Due date tracking
- Project grouping

**Integration:**
- Syncs with Google Tasks via gtask.py
- Stores in shared task format

## UI/UX Specifications

### Design System
```css
/* Typography */
--font-primary: -apple-system, SF Pro Text, sans-serif;
--font-size-base: 14px; /* Smaller than typical */
--font-size-small: 12px;
--line-height-compact: 1.3;

/* Colors */
--color-primary: #007AFF; /* Apple blue */
--color-background: #FFFFFF;
--color-surface: #F2F2F7;
--color-text: #1C1C1E;
--color-text-secondary: #8E8E93;

/* Spacing */
--spacing-xs: 4px;
--spacing-sm: 8px;
--spacing-md: 12px;
--spacing-lg: 16px;

/* Components */
--border-radius: 8px;
--shadow-sm: 0 1px 3px rgba(0,0,0,0.1);
```

### Mobile Responsiveness
- **Breakpoints**: 
  - Mobile: < 768px (sidebar hidden, swipe to reveal)
  - Tablet: 768-1024px (sidebar collapsible)
  - Desktop: > 1024px (sidebar always visible)
- **Touch targets**: Minimum 44×44px
- **Gestures**: Swipe for panel navigation on mobile

### Accessibility
- ARIA labels for all interactive elements
- Keyboard navigation support
- High contrast mode support
- Screen reader optimized

## Integration Points

### Claude CLI Integration
```python
import subprocess
import asyncio

async def send_to_claude(message: str, context: str = None):
    """Send message to Claude CLI with persistent context"""
    cmd = ['claude', '-c', '-p', message]
    if context:
        cmd.extend(['--context', context])
    
    process = await asyncio.create_subprocess_exec(
        *cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )
    
    # Stream response back via WebSocket
    async for line in process.stdout:
        yield line.decode().strip()
```

### Context Library Integration
```python
# Shared context path
CONTEXT_PATH = '/srv/context/current/'

# Load user facts for personalization
user_facts = load_json(f'{CONTEXT_PATH}/user_facts.json')

# Load system facts for capabilities
system_facts = load_json(f'{CONTEXT_PATH}/system_facts.json')

# Update context based on interactions
update_context_library(conversation_id, new_facts)
```

### Authentication
- Leverage existing nginx HTTP Basic Auth
- No additional auth layer needed initially
- Future: OAuth2 integration for multi-user

## File Structure
```
/srv/pai/web/
├── main.py              # NiceGUI application entry
├── panels/
│   ├── __init__.py
│   ├── chat.py         # Chat interface panel
│   ├── email.py        # Email summary panel
│   ├── calendar.py     # Calendar view panel
│   ├── tasks.py        # Task management panel
│   └── settings.py     # Settings panel
├── services/
│   ├── claude_service.py    # Claude CLI wrapper
│   ├── context_service.py   # Context library interface
│   └── data_service.py      # Data collectors interface
├── static/
│   ├── css/
│   │   └── custom.css  # Custom styles
│   └── js/
│       └── voice.js    # Voice input handling
├── templates/           # If needed for custom components
└── requirements.txt     # Dependencies
```

## Development Timeline

### Week 1: Foundation
- [ ] Setup NiceGUI project structure
- [ ] Implement basic chat interface
- [ ] Add Claude CLI integration
- [ ] File/image upload support
- [ ] Deploy behind nginx

### Week 2: Multi-Panel System
- [ ] Create panel navigation
- [ ] Add placeholder panels
- [ ] Implement panel state management
- [ ] Mobile swipe gestures
- [ ] Settings panel

### Week 3-5: Feature Panels
- [ ] Email integration and UI
- [ ] Calendar integration and views
- [ ] Task management system
- [ ] Real-time updates
- [ ] Performance optimization

### Week 6: Polish & Launch
- [ ] UI refinements
- [ ] Performance testing
- [ ] Documentation
- [ ] Deployment optimization
- [ ] User feedback integration

## Performance Considerations

### Optimization Strategies
1. **Lazy loading**: Load panels only when accessed
2. **Caching**: Cache frequently accessed data
3. **Debouncing**: Limit API calls during typing
4. **Virtual scrolling**: For long lists
5. **WebSocket connection pooling**: Reuse connections

### Monitoring
- Track API usage per panel
- Monitor WebSocket connection health
- Log panel load times
- Track user interactions for UX improvements

## Security Measures

1. **Input sanitization**: Clean all user inputs
2. **Rate limiting**: Prevent API abuse
3. **Content Security Policy**: Restrict resource loading
4. **Session management**: Timeout after inactivity
5. **Audit logging**: Track all actions

## Future Enhancements

### Version 0.2
- Multi-conversation support
- Conversation search
- Export capabilities
- Keyboard shortcuts
- Dark mode

### Version 0.3
- Plugin system for custom panels
- API for third-party integrations
- Advanced context management
- Team collaboration features
- Mobile app wrapper

## Success Metrics

1. **Page load time**: < 1 second
2. **Time to first interaction**: < 2 seconds
3. **Mobile usability score**: > 95
4. **User engagement**: > 5 min average session
5. **API efficiency**: < 1000 tokens per interaction

## Conclusion

This modular approach allows PAI to start simple with a chat interface while building toward a comprehensive personal AI dashboard. NiceGUI provides the perfect balance of simplicity and capability for rapid development while maintaining the flexibility to grow into a full-featured system.