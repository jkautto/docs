# task.kaut.to v2.0 Executive Summary

## What We're Building

Transform the static task manager at kaut.to/tasks into a modern multi-account Google Tasks application at task.kaut.to that aggregates tasks from all three accounts (personal, xwander, accolade).

## Key Decisions

### 1. **Multi-Account Architecture**
- Aggregate tasks from: joni.kautto@gmail.com, joni@xwander.fi, joni@accolade.fi
- Color-coded account indicators
- Unified view with account filtering
- Account-aware task creation

### 2. **Repository Structure**
- New monorepo: github.com/jkautto/kaut-apps
- Contains: pastebin, tasks, auth, browser-test
- Shared utilities and consistent deployment
- Individual app independence maintained

### 3. **Technology Stack**
- Backend: FastAPI (consistency with other services)
- Frontend: Progressive enhancement of existing PWA
- Auth: OAuth2 with existing Google tokens
- Database: SQLite for caching/settings

### 4. **Self-Documenting API**
Following established pattern:
- `/api` - Human-readable docs
- `/api-spec.json` - Machine-readable spec
- `/health` - Service health check

## Implementation Timeline

**Week 1: Foundation**
- Days 1-2: Create repository, migrate pastebin
- Days 3-4: OAuth setup, multi-account authentication
- Days 5-7: Core API development

**Week 2: Features**
- Days 8-9: Complete API endpoints
- Days 10-11: Frontend migration
- Days 12-14: Testing and deployment

## Key Features

### MVP (Must Have)
✓ Multi-account task aggregation  
✓ Account indicators in UI  
✓ Basic CRUD operations  
✓ OAuth token refresh  
✓ Self-documenting API  

### Phase 2 (Should Have)
- Focus mode with timer
- Advanced filtering/sorting
- Quick task entry
- Sync status indicators
- PWA offline support

## Technical Highlights

### Multi-Account Service
```python
# Aggregate tasks from all accounts
all_tasks = await task_service.get_all_tasks()

# Create task in specific account
await task_service.create_task(
    title="Review budget",
    account="xwander"
)
```

### Frontend Integration
```javascript
// Account-aware task display
<span class="account-dot" style="background: #27ae60"></span>
<div class="task-title">Review Q3 Budget</div>
<div class="task-account">Xwander</div>
```

## Deployment

1. **DNS**: Create A record for task.kaut.to → 157.180.28.186
2. **Service**: Run on port 8092 with systemd
3. **Proxy**: Nginx configuration ready
4. **Auth**: HTTP Basic (joni:Penacova)

## Success Criteria

1. ✓ All three accounts accessible
2. ✓ Tasks sync in real-time
3. ✓ Account context preserved
4. ✓ API self-documented
5. ✓ PWA functionality maintained

## Next Steps

1. **Immediate**: Create kaut-apps repository
2. **This Week**: Implement core backend
3. **Next Week**: Complete frontend migration
4. **Testing**: Verify all account operations
5. **Launch**: Deploy to task.kaut.to

## Risk Mitigation

- **Token Expiry**: Automatic refresh implementation
- **API Limits**: Intelligent caching layer
- **Rollback**: Keep kaut.to/tasks as fallback
- **Data Loss**: No destructive operations without confirmation

---

**Bottom Line**: A modern, multi-account task manager that aggregates Google Tasks from all three accounts into a unified, intelligent interface with full API access for DAI/PAI integration.

*Ready to proceed with implementation upon approval.*