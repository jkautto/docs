# Claude Code Project Management Guide

## Purpose
This guide focuses on project management best practices for Claude Code CLI, including issue tracking, codebase maintenance, and technical debt prevention. For Git commands, see [Git Workflow Guide](./git-workflow.md). For GitHub CLI usage, see [GitHub CLI Guide](./github-cli-guide.md).

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

### ⚠️ CRITICAL RESPONSIBILITY: Project Board Management
**You MUST add every new issue to the project board immediately!**

### 1. Issue Creation & Project Board Integration

Creating an issue is a multi-step process. It is not complete until it is visible on the project board.

**Step 1: Create the Issue**
```bash
# Create the issue and take note of the issue number from the URL it returns
gh issue create --repo jkautto/shifts --title "feat: New Feature Title" --body "Detailed description..."
```

**Step 2: Add the Issue to the Project Board**
This requires getting the GraphQL IDs for the project and the new issue, then linking them.

```bash
# First, get the Project ID. You only need to do this once per project.
# Find the project number from the URL: https://github.com/users/jkautto/projects/1 -> number is 1
PROJECT_ID=$(gh api graphql -f query='
  query($user: String!, $number: Int!) {
    user(login: $user){
      projectV2(number: $number){
        id
      }
    }
  }' -f user='jkautto' -F number=1 --jq '.data.user.projectV2.id')

# Second, get the Node ID of the new issue (e.g., for issue #14)
ISSUE_ID=$(gh api graphql -f query='
  query($owner: String!, $repo: String!, $number: Int!) {
    repository(owner: $owner, name: $repo) {
      issue(number: $number) {
        id
      }
    }
  }' -f owner='jkautto' -f repo='shifts' -F number=14 --jq '.data.repository.issue.id')

# Finally, link the issue to the project
gh api graphql -f query='
  mutation($project:ID!, $issue:ID!) {
    addProjectV2ItemById(input: {projectId: $project, contentId: $issue}) {
      item {
        id
      }
    }
  }' -f project=$PROJECT_ID -f issue=$ISSUE_ID
```
**Verification:** After running these commands, you must verify that the issue is visible on the project board.


### 2. Before Starting Work
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
For Git and GitHub commands, see:
- [Git Workflow Guide](./git-workflow.md) - Git basics
- [GitHub Quick Reference](./github-quick-reference.md) - GitHub CLI commands
- [GitHub CLI Guide](./github-cli-guide.md) - Advanced GitHub usage

### Red Flags to Watch For
- Uncommitted changes > 24 hours old
- Issues in "In Progress" > 1 week
- Test files in production directories
- Hardcoded credentials
- Missing documentation

## Real-World Examples from Practice

### Working with AI Agents (Gemini Case Study)
When reviewing another AI's work:

1. **Issue Planning Review**:
   ```bash
   gh issue view 11 --comments  # Check implementation plan
   # Look for: Missing details, blank templates, vague descriptions
   ```

2. **Post-Implementation Review**:
   ```bash
   git pull
   git log --oneline -5  # Check their commits
   git show <commit-hash>  # Review changes
   npm run build  # Test if it builds
   ```

3. **Common Issues to Fix**:
   - Hardcoded asset paths in index.html
   - Missing imports or components
   - No pull request created
   - Build failures

### Proper Issue Closure Example
From today's session with issue #10:
```bash
# 1. Comment with implementation details
gh issue comment 10 -b "Implemented in commit 1ca2e7c:
- Changed role name from 'Helpers' to 'Paramedics'
- Updated members to Niina and Emilia only
- Also cleaned up codebase"

# 2. Close the issue
gh issue close 10
```

### MVP Implementation Example
Issue #8 - Keyboard shortcuts:
- Skip multi-browser testing → Chrome only
- No complex UI → Simple help text
- Basic functionality → Just the shortcuts
- Time to implement: 30 minutes vs 2 hours

## Integration with Claude Code

When starting a session:
1. Check `gh issue list --assignee @me`
2. Review `git status` and `git log -5`
3. Update project board if needed
4. Clean up any technical debt noticed

Remember: **Clean code is maintainable code**

## Related Guides

- **[Git Workflow Guide](./git-workflow.md)** - Daily Git operations and commands
- **[GitHub Quick Reference](./github-quick-reference.md)** - Quick GitHub CLI reference
- **[GitHub CLI Guide](./github-cli-guide.md)** - Comprehensive GitHub CLI usage
- **[Working with AI Agents](./working-with-ai-agents.md)** - Collaborating with other AIs
- **[AI Agent Onboarding](./ai-agent-onboarding.md)** - Getting started guide