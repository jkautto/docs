# GitHub Issue-Driven Development Workflow

## Overview

This guide outlines the systematic approach to development using GitHub issues as the primary driver for all changes. This workflow ensures traceability, proper planning, and consistent quality across all projects.

## Core Principles

### 1. Issues First
Every change starts with an issue. No code without context.

### 2. Plan Before Code
Create detailed checklists and implementation plans before writing code.

### 3. Test Everything
Verify functionality works before marking tasks complete.

### 4. Document Always
Update documentation as part of the development process.

### 5. Fail Fast, Fail Better
Test early, identify problems quickly, iterate based on learnings.

## The Complete Workflow

### Step 1: Issue Analysis

When starting work on an issue:

```bash
# View issue details
gh issue view 6 --repo jkautto/shifts

# List all project issues
gh issue list --repo jkautto/shifts --state all

# Check linked project board
gh api graphql -f query='
{
  user(login: "jkautto") {
    projectsV2(first: 10) {
      nodes {
        id
        number
        title
      }
    }
  }
}'
```

### Step 2: Create Implementation Plan

Always create a systematic plan with clear phases:

```markdown
## Implementation Plan for Issue #6

### Phase 1: Analysis & Testing (HIGH Priority)
- [ ] Analyze existing code structure
- [ ] Test current functionality
- [ ] Identify gaps and requirements
- [ ] Document findings

### Phase 2: Implementation (HIGH Priority)
- [ ] Core feature development
- [ ] Error handling
- [ ] Edge case handling
- [ ] Integration with existing code

### Phase 3: Testing (HIGH Priority)
- [ ] Unit tests
- [ ] Integration tests
- [ ] Manual testing
- [ ] Performance validation

### Phase 4: Documentation (MEDIUM Priority)
- [ ] API documentation
- [ ] Update README
- [ ] Add code examples
- [ ] Update changelog
```

### Step 3: Git Operations

#### Check Repository State
```bash
# View recent commits
git log --oneline -20

# Check current tags
git tag -l

# See commits since last release
git log v1.0..HEAD --oneline

# Check current status
git status
```

#### Commit Best Practices

Use conventional commit format:

| Type | Description | Example |
|------|-------------|---------|
| feat | New feature | `feat: add JSON storage backend` |
| fix | Bug fix | `fix: resolve auth error on load` |
| test | Adding tests | `test: add storage service tests` |
| docs | Documentation | `docs: update API reference` |
| refactor | Code restructuring | `refactor: simplify auth logic` |
| chore | Maintenance | `chore: update dependencies` |

### Step 4: Testing Strategy

#### 1. Manual Testing First
Always verify functionality manually before automation:
```bash
# Test the feature directly
node test-feature.js

# Use curl for API testing
curl -u user:pass http://localhost:8003/api/endpoint
```

#### 2. Create Test Scripts
Write standalone test scripts for validation:
```javascript
// test-json-storage.js
// Test all CRUD operations
// Test error cases
// Test edge cases
// Verify data integrity
```

#### 3. Add to Test Suite
```bash
# Update package.json
"scripts": {
  "test": "vitest",
  "test:watch": "vitest --watch"
}
```

### Step 5: Issue Management

Keep stakeholders informed throughout:

```bash
# Post progress update
gh issue comment 6 --repo jkautto/shifts --body "
## Status Update
- [x] Analysis complete
- [x] Tests written
- [ ] Implementation in progress
"

# Update labels
gh issue edit 6 --repo jkautto/shifts --add-label "in-progress"

# Link pull request (if using PRs)
gh issue develop 6 --repo jkautto/shifts
```

### Step 6: Release Process

#### Version Planning
- **Major (x.0.0)**: Breaking changes
- **Minor (0.x.0)**: New features  
- **Patch (0.0.x)**: Bug fixes

#### Release Checklist
```bash
# 1. Ensure all tests pass
npm test

# 2. Update version
npm version minor

# 3. Commit all changes
git add -A
git commit -m "feat: complete feature for v2.1.0"

# 4. Tag release
git tag v2.1.0
git push origin v2.1.0

# 5. Update and close issue
gh issue comment 6 --repo jkautto/shifts --body "
✅ Implementation complete in v2.1.0
"
gh issue close 6 --repo jkautto/shifts
```

## Best Practices

### Use Todo Lists

Maintain a todo list for complex tasks:

```javascript
// Using TodoWrite tool
const todos = [
  { id: "1", content: "Research existing code", status: "completed" },
  { id: "2", content: "Write tests", status: "in_progress" },
  { id: "3", content: "Implement feature", status: "pending" }
];
```

### Documentation as Code

- Update docs in the same commit as code changes
- Keep README current with features
- Document APIs with examples
- Add inline comments for complex logic

### MVP Approach

1. **Build the simplest working solution first**
2. **Test and validate it works**
3. **Document what exists**
4. **Iterate based on feedback**
5. **Avoid over-engineering**

## Common Patterns

### Feature Implementation Pattern

```bash
# 1. Create/claim issue
gh issue create --title "Add new feature" --body "Description..."

# 2. Research and plan
# - Analyze codebase
# - Create implementation plan
# - Update issue with plan

# 3. Implement incrementally
# - Write tests first (TDD)
# - Implement feature
# - Test thoroughly

# 4. Document
# - Update README
# - Add API docs
# - Create examples

# 5. Release
# - Update version
# - Tag release
# - Close issue
```

### Bug Fix Pattern

```bash
# 1. Reproduce the issue
# 2. Write failing test
# 3. Fix the bug
# 4. Verify test passes
# 5. Check for regressions
# 6. Document the fix
# 7. Release patch version
```

## Tools Reference

### GitHub CLI Essential Commands

```bash
# Issues
gh issue create --repo owner/repo
gh issue list --repo owner/repo
gh issue view <number> --repo owner/repo
gh issue comment <number> --repo owner/repo
gh issue close <number> --repo owner/repo
gh issue edit <number> --repo owner/repo

# API Access
gh api /repos/owner/repo/issues
gh api graphql -f query='{ ... }'

# Projects (GraphQL)
gh api graphql -f query='
{
  user(login: "username") {
    projectsV2(first: 10) {
      nodes {
        id
        title
        items(first: 100) {
          nodes {
            content {
              ... on Issue {
                title
                number
              }
            }
          }
        }
      }
    }
  }
}'
```

### Git Essential Commands

```bash
# Status and History
git status
git log --oneline -n 20
git diff
git show <commit>

# Branches and Tags  
git branch -a
git tag -l
git describe --tags

# Remote Operations
git push origin main
git push origin v2.1.0
git fetch --all --tags
```

## Integration with AI Workflows

### Context Preservation
- Use HANDOVER.md for session continuity
- Update BACKLOG.md with pending tasks
- Document decisions in commit messages

### Collaboration Protocol
- Clear issue descriptions
- Detailed implementation plans  
- Progress updates on issues
- Complete documentation

### Token Optimization
- Reference issues by number
- Use short, clear messages
- Batch related changes
- Link to existing docs

## Examples from Real Projects

### Shifts Application (v2.1.0)
1. Started with issue #6 for file storage
2. Discovered feature already implemented
3. Pivoted to testing and documentation
4. Created comprehensive test suite
5. Documented API completely
6. Released with confidence

### Key Learnings
- Always test existing functionality first
- Document what actually exists
- Follow MVP principles
- Maintain backward compatibility

## Related Documentation

- [GitHub CLI Guide](./github-cli-guide.md)
- [Git Workflow](/srv/docs/git-workflow.md)
- [AI Agent Onboarding](./ai-agent-onboarding.md)
- [Development Standards](./development-standards.md)