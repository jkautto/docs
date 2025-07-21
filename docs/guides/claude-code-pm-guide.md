# Claude Code Project Management Guide

## Overview
This guide is optimized for Claude Code CLI to maintain clean codebases and proper project workflows.

## Core Principles
1. **Always work on GitHub issues** - Never make changes without an issue
2. **Keep project boards updated** - Move issues through columns
3. **Maintain clean codebases** - Remove technical debt regularly
4. **Use proper Git hygiene** - Tags, branches, meaningful commits

## MVP Development Philosophy

### Internal Tools = Pragmatic Choices
- **One browser is enough** - Chrome only for internal tools
- **Value over perfection** - Ship working features fast
- **Fail fast, fail better** - Quick iterations over extensive planning
- **80/20 rule** - Focus on the 20% that delivers 80% value

### Avoid Over-Engineering
❌ **Don't**:
- Test in multiple browsers for internal tools
- Add complex error handling for edge cases
- Build elaborate UI components
- Create extensive documentation for simple features

✅ **Do**:
- Test in Chrome (our standard browser)
- Handle common errors gracefully
- Use simple, functional UI
- Document only what's necessary

## GitHub Issue Workflow

### 1. Before Starting Work
```bash
# Check available issues
gh issue list --state open

# View project board
gh project list
gh project view 1  # View specific project

# Assign issue to yourself
gh issue edit <number> --add-assignee @me
```

### 2. During Work
```bash
# Create feature branch (optional for major changes)
git checkout -b issue-<number>-description

# Check git status frequently
git status
git diff

# Make atomic commits
git add -p  # Stage changes interactively
git commit -m "type: description (#<issue-number>)"
```

### 3. After Implementation
```bash
# Add implementation details to issue
gh issue comment <number> -b "Implementation details..."

# Close issue with reference to commit
gh issue close <number>

# Tag releases when appropriate
git tag -a v1.0.0 -m "Release version 1.0.0"
git push --tags
```

## Commit Message Format
```
type: description (#issue-number)

- Detail 1
- Detail 2

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

Types: feat, fix, docs, refactor, test, chore

## Codebase Maintenance

### Regular Cleanup Tasks
1. **Remove test files**: `test-*.html`, `*-debug.*`, `*.log`
2. **Clean old docs**: Consolidate scattered MD files
3. **Remove prototypes**: `_prototypes/`, `_old/`, `backup/`
4. **Check for exposed secrets**: API keys, tokens
5. **Update dependencies**: Check package.json versions

### Cleanup Commands
```bash
# Find large files
find . -type f -size +1M -exec ls -lh {} \;

# Find old log files
find . -name "*.log" -mtime +7

# Check for TODO comments
grep -r "TODO\|FIXME\|HACK" --include="*.js" --include="*.py"

# List untracked files
git ls-files --others --exclude-standard
```

## Project Board Management

### Issue States
1. **To Do** - Not started
2. **In Progress** - Actively working
3. **Review** - Needs testing/review
4. **Done** - Completed and closed

### Best Practices
- Update issue status immediately when starting work
- Add time estimates to issues
- Link related issues
- Use labels consistently
- Add milestones for major features

## Git Best Practices

### Daily Workflow
```bash
# Start of session
git pull --rebase
git log --oneline -10

# During work
git status
git diff --staged

# End of session  
git push
gh issue list --assignee @me
```

### Branch Strategy
- `main` - Production ready code
- `develop` - Integration branch (optional)
- `issue-<number>` - Feature branches

### Tagging Releases
```bash
# Semantic versioning
git tag -a v1.2.3 -m "Release: Feature X, Fix Y"

# List tags
git tag -l

# Push tags
git push origin v1.2.3
```

## Technical Debt Prevention

### Code Quality Checks
1. **Before committing**:
   - Remove console.log statements
   - Delete commented code
   - Update documentation (if needed)
   - Run linters/formatters (if configured)

2. **Weekly reviews**:
   - Check for duplicate code
   - Review dependencies
   - Update outdated docs
   - Clean test artifacts

## MVP Testing Approach

### For Internal Tools
1. **Manual Testing in Chrome** - Quick visual check
2. **Basic Functionality** - Does it work for the happy path?
3. **Screenshot if Needed** - `python3 /srv/jtools/screenshot.py`
4. **Move On** - Don't over-test internal tools

### Testing Commands
```bash
# Quick browser test
python3 /srv/toolkit/browser_test.py https://kaut.to/shifts/

# Screenshot for visual record
python3 /srv/jtools/screenshot.py https://kaut.to/shifts/ -o before.png

# That's it! No cross-browser, no edge cases for MVP
```

### Documentation Standards
- Keep README.md current
- Document API changes
- Update CHANGELOG.md
- Maintain architecture docs

## Quick Reference

### Essential Commands
```bash
# Issue management
gh issue create
gh issue list
gh issue view <number>
gh issue close <number>

# Git workflow  
git log --graph --oneline
git stash save "work in progress"
git reset HEAD~1 --soft
git cherry-pick <commit>

# Cleanup
git clean -fd  # Remove untracked files
git gc         # Garbage collection
```

### Red Flags to Watch For
- Uncommitted changes > 24 hours old
- Issues in "In Progress" > 1 week
- Test files in production directories
- Hardcoded credentials
- Missing documentation

## Integration with Claude Code

When starting a session:
1. Check `gh issue list --assignee @me`
2. Review `git status` and `git log -5`
3. Update project board if needed
4. Clean up any technical debt noticed

Remember: **Clean code is maintainable code**