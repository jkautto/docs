# Simple Git Workflow for DAI/PAI Development

## When to Use This Guide
- ✅ Daily git operations (commit, push, pull)
- ✅ Working directly on main branch
- ✅ Recovery from mistakes
- ✅ Quick commits without PR overhead

For GitHub issues and project boards, see [GitHub Quick Reference](./github-quick-reference.md)

Since we're a small team of 2-3 AI developers working closely together, we keep git simple and efficient.

## Core Principles
- **No Pull Requests**: We work directly on main branch
- **Frequent Commits**: Commit early and often
- **Clear Messages**: Descriptive commit messages
- **Regular Pushes**: Push to GitHub multiple times per session
- **Version Tags**: Tag significant milestones

## Daily Workflow

### 1. Start of Session
```bash
# Check current status
git status
git log --oneline -5

# Pull any changes (if working from multiple locations)
git pull origin main
```

### 2. During Development
```bash
# After completing a feature or fix
git add -A  # or specific files
git status  # Review what's being committed

# Commit with clear message
git commit -m "feat: Add monitoring session architecture"

# For longer messages
git commit -m "fix: Resolve email collector JSON parsing

- Disabled all logging output
- Use sys.stdout.write for clean JSON
- Added error handling for edge cases"
```

### 3. Commit Message Format
- `feat:` New feature
- `fix:` Bug fix  
- `docs:` Documentation only
- `refactor:` Code restructuring
- `test:` Adding tests
- `chore:` Maintenance tasks

### 4. Push Regularly
```bash
# Push to GitHub
git push origin main

# If needed, force push (be careful!)
git push -f origin main
```

### 5. Version Tagging
```bash
# For significant releases
git tag -a v0.3.0 -m "Release description"
git push origin v0.3.0
```

## Session Management

### End of Session Checklist
1. ✓ Commit all work
2. ✓ Push to GitHub
3. ✓ Create worklog entry
4. ✓ Update HANDOVER.md if needed
5. ✓ Tag if major milestone

### Quick Commands
```bash
# See what changed
git diff

# Undo last commit (keep changes)
git reset HEAD~1

# Discard all changes (careful!)
git reset --hard HEAD

# Create release
git tag -a v0.x.0 -m "Description"
git push origin --tags
```

## File Management

### Always Commit
- Core code files (*.py)
- Documentation (*.md)
- Configuration (*.json, *.yaml)
- Scripts (*.sh)

### Never Commit (use .gitignore)
- Credentials (*.json with secrets)
- Tokens (*_token.json)
- Environment files (.env)
- Cache files (__pycache__)
- Logs (*.log)

## Collaboration Notes

Since we're AI developers:
- We can see each other's commits instantly
- No complex branching needed
- Focus on clear communication through commits
- Use worklogs for detailed context

## Recovery Procedures

### If Something Goes Wrong
```bash
# Check reflog for recovery
git reflog

# Restore deleted file
git checkout HEAD~ -- path/to/file

# Reset to specific commit
git reset --hard <commit-hash>
```

Remember: Git is our safety net. Commit often, push regularly, and don't fear making mistakes - we can always recover!

## Related Guides

- **[GitHub Quick Reference](./github-quick-reference.md)** - Quick commands and error solutions
- **[GitHub CLI Guide](./github-cli-guide.md)** - Working with issues and project boards
- **[Claude Code PM Guide](./claude-code-pm-guide.md)** - Project management best practices
- **[AI Agent Onboarding](./ai-agent-onboarding.md)** - Getting started guide for new AI agents