# GitHub Quick Reference for AI Agents

## ⚠️ Common Errors and Solutions

### Error: "unknown command 'project' for 'gh'"
**Problem**: GitHub CLI doesn't have a `project` command  
**Solution**: Use GraphQL API for project operations

### Error: "Could not resolve to a node with the global id"
**Problem**: Wrong or outdated node ID  
**Solution**: Always fetch fresh node IDs before using them

## Essential GitHub Operations

### 1. Creating Issues
```bash
# Create issue (returns issue URL)
gh issue create --title "Title" --body "Description" --label "enhancement"
```

### 2. Adding Issues to Project Board
```bash
# Step 1: Get issue node ID (replace 13 with your issue number)
NODE_ID=$(gh api repos/jkautto/shifts/issues/13 --jq .node_id)

# Step 2: Add to project (Shifts project ID)
gh api graphql -f query="
mutation {
  addProjectV2ItemById(input: {
    projectId: \"PVT_kwHOBx09m84A-Is0\"
    contentId: \"$NODE_ID\"
  }) {
    item { id }
  }
}"
```

### 3. Issue Management
```bash
# View issue with comments
gh issue view 13 --comments

# List your assigned issues
gh issue list --assignee @me

# Comment on issue
gh issue comment 13 -b "Comment text"

# Close issue
gh issue close 13

# Assign issue to yourself
gh issue edit 13 --add-assignee @me
```

### 4. Checking Project Board
Always verify at: https://github.com/users/jkautto/projects/1/views/1

## Project IDs Reference
- **Shifts Tool**: `PVT_kwHOBx09m84A-Is0` (project #1)
- **JTools Development**: `PVT_kwHOBx09m84A-Kz4` (project #2)

## Git Basics
```bash
# Check status
git status
git log --oneline -5

# Pull latest
git pull --rebase

# Commit with message
git add -A
git commit -m "type: description (#issue-number)"

# Push
git push
```

## Common Workflows

### Complete Issue Workflow
```bash
# 1. Create issue
gh issue create --title "feat: Add feature" --body "Details..."

# 2. Add to project board (use script above)

# 3. Assign to yourself
gh issue edit <number> --add-assignee @me

# 4. Work on it
git checkout -b issue-<number>
# ... make changes ...
git add -A
git commit -m "feat: implement feature (#<number>)"
git push

# 5. Close with comment
gh issue comment <number> -b "Implemented in commit abc123"
gh issue close <number>
```

## ❌ NEVER DO THIS
```bash
# These commands don't exist:
gh project *           # No project command
gh issue add-project   # Not a valid option
gh pr add-to-project   # Not a valid option

# These require exact IDs:
"I_kwDOMxbHUM6lT8nS"   # Node IDs expire/change - always fetch fresh
```

## ✅ ALWAYS DO THIS
1. Fetch fresh node IDs before GraphQL operations
2. Add issues to project board immediately after creation
3. Check the project board URL to verify
4. Use the exact project IDs listed above

## Quick Debug Commands
```bash
# Get repo node ID
gh api repos/jkautto/shifts --jq .node_id

# Get issue details
gh api repos/jkautto/shifts/issues/13

# List all projects
gh api graphql -f query='{
  user(login: "jkautto") {
    projectsV2(first: 10) {
      nodes { id number title }
    }
  }
}'
```

Remember: When in doubt, use the GitHub web interface and document what you did!

## Related Guides

- **[GitHub CLI Guide](./github-cli-guide.md)** - Comprehensive GitHub CLI reference with advanced features
- **[Git Workflow Guide](./git-workflow.md)** - Basic Git operations and best practices
- **[Claude Code PM Guide](./claude-code-pm-guide.md)** - Project management workflows
- **[Working with AI Agents](./working-with-ai-agents.md)** - Collaboration patterns with other AIs