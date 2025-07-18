# Current Context

This page tracks the current operational context of the DAI/PAI system.

## System Status

**Last Updated**: 2025-07-17

### Service Health
- ✅ All core services operational
- ✅ Documentation site deployed (https://docs.kaut.to)
- ✅ PAI Dashboard running
- ✅ Task API functional
- ✅ Tools API operational

### Recent Changes
- Migrated documentation to MkDocs at https://docs.kaut.to
- Updated CLAUDE.md and GEMINI.md with new documentation paths
- Cleaned up repository structure (/srv/.git removed)
- Created new apps repository on GitHub

## Active Projects

### In Progress
1. **Documentation Migration** - Moving all docs to MkDocs
2. **Context Library Consolidation** - Organizing scattered documentation
3. **Repository Cleanup** - Archiving old files and organizing structure

### Planned
1. **Automated Documentation Builds** - GitHub Actions integration
2. **Search Enhancement** - Improving documentation search
3. **AI Update Endpoints** - Programmatic documentation updates

## Known Issues

### Minor
- Some navigation links in docs point to not-yet-created pages
- Old documentation paths still referenced in some scripts

### Resolved Recently
- nginx SSL cipher configuration fixed
- MkDocs analytics provider issue resolved
- Repository merge conflicts resolved

## Temporary Configurations

None currently active.

## Work in Progress

### Documentation Migration Status
- [x] CAG files migrated
- [ ] /srv/docs content pending
- [ ] /srv/specs content pending
- [ ] /srv/context remaining files pending
- [ ] PAI documentation pending

## Quick Commands

```bash
# Rebuild documentation
cd /srv/apps/docs && source venv/bin/activate && mkdocs build

# Check service status
sudo systemctl status kaut-pastebin pai-web kaut-auth kaut-api

# View recent logs
sudo journalctl -u pai-web -f --since "1 hour ago"
```

## Contact Points

- **Documentation**: https://docs.kaut.to
- **PAI Dashboard**: https://kaut.to/ai/
- **Task Manager**: https://kaut.to/tasks/
- **Pastebin**: https://pb.kaut.to

---

!!! note
    This is a living document. Update whenever significant changes occur to maintain accurate operational context.