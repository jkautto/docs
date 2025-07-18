# Context Archives

Historical context preserved for reference. Organized by date and topic.

## Archive Structure

Archives are organized by:
- **Year/Quarter** - For time-based archives
- **Topic** - For subject-specific archives
- **Project** - For project-related archives

## 2025 Q1 Archives

### Documentation Migration
- Original documentation structure before MkDocs migration
- Legacy context files from pre-consolidation era

## 2024 Archives

*To be migrated from /srv/context/archives/*

## Accessing Archives

Archives are stored in subdirectories:
- Time-based: `/context/archives/2025/Q1/`
- Topic-based: `/context/archives/topics/`
- Project-based: `/context/archives/projects/`

## Archive Policy

### What Gets Archived
- Deprecated configurations
- Old architectural decisions
- Completed project documentation
- Superseded procedures
- Historical incident reports

### When to Archive
- Quarterly reviews
- Major system changes
- Project completions
- Documentation overhauls

### How to Archive
1. Create appropriate subdirectory
2. Move files with clear naming
3. Add README explaining context
4. Update this index
5. Remove from active documentation

## Quick Search

To search archives:
```bash
grep -r "search_term" /srv/apps/docs/docs/context/archives/
```

---

!!! warning
    Archives are for reference only. Do not use archived configurations or procedures in production.