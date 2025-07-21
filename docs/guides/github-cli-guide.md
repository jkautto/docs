# GitHub CLI Guide for AI Agents

## Purpose
This comprehensive guide covers GitHub CLI usage for AI agents, focusing on working with issues, pull requests, and the GraphQL API. For quick commands and error solutions, see the [GitHub Quick Reference](./github-quick-reference.md).

A practical guide for using GitHub CLI with real, tested examples. All commands have been verified to work.

## Prerequisites

```bash
# Check authentication
gh auth status

# If needed, set token from .env
export GITHUB_TOKEN=$(grep GITHUB_PAT /srv/.env | cut -d= -f2)
```

## GitHub Discussions

### ⚠️ Important: Limited CLI Support

GitHub CLI does **not** have native commands for discussions. You must use the GraphQL API.

### Working Methods for Discussion Comments

**Method 1: Simple Inline Comment**

```bash
# This works - tested and verified
gh api graphql -f query='
mutation {
  addDiscussionComment(input: {
    discussionId: "D_kwDOPOIQDs4AgzMq"
    body: "Your comment here"
  }) {
    comment {
      id
      url
    }
  }
}'
```

**Method 2: Multi-line Comments with JSON Escaping**

```bash
# Step 1: Create your comment
cat > comment.txt << 'EOF'
This is line one.
This is line two.

This is after a blank line.
EOF

# Step 2: Escape it properly
body=$(cat comment.txt | jq -Rs .)

# Step 3: Use it in the query
gh api graphql -f query="
mutation {
  addDiscussionComment(input: {
    discussionId: \"D_kwDOPOIQDs4AgzMq\"
    body: $body
  }) {
    comment {
      id
      url
    }
  }
}"
```

### Finding Discussion IDs

```bash
# Get discussion ID (not the number!)
gh api graphql -f query='
{
  repository(owner: "jkautto", name: "shifts") {
    discussions(first: 10) {
      nodes {
        id
        number
        title
      }
    }
  }
}'
```

## Project Boards V2

### List User's Projects

```bash
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

### Get Project Details with Items

```bash
gh api graphql -f query='
{
  user(login: "jkautto") {
    projectsV2(first: 5) {
      nodes {
        id
        title
        items(first: 20) {
          nodes {
            id
            content {
              ... on Issue {
                number
                title
                repository {
                  name
                }
              }
            }
          }
        }
      }
    }
  }
}'
```

### Add Issue to Project

```bash
# Step 1: Get issue ID
issue_data=$(gh api graphql -f query='
{
  repository(owner: "jkautto", name: "shifts") {
    issue(number: 8) {
      id
    }
  }
}')

issue_id=$(echo $issue_data | jq -r '.data.repository.issue.id')

# Step 2: Add to project
gh api graphql -f query="
mutation {
  addProjectV2ItemById(input: {
    projectId: \"PVT_kwHOBx09m84A-Is0\"
    contentId: \"$issue_id\"
  }) {
    item {
      id
    }
  }
}"
```

### Update Project Item Status

This is complex because you need field IDs and option IDs:

```bash
# Step 1: Get field information
gh api graphql -f query='
{
  node(id: "PVT_kwHOBx09m84A-Is0") {
    ... on ProjectV2 {
      fields(first: 20) {
        nodes {
          ... on ProjectV2SingleSelectField {
            id
            name
            options {
              id
              name
            }
          }
        }
      }
    }
  }
}'

# Step 2: Update status (use IDs from above)
gh api graphql -f query='
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: "PROJECT_ID"
    itemId: "ITEM_ID"
    fieldId: "FIELD_ID"
    value: {
      singleSelectOptionId: "OPTION_ID"
    }
  }) {
    projectV2Item {
      id
    }
  }
}'
```

## Standard GitHub CLI Commands

### Issues

```bash
# List issues
gh issue list --repo jkautto/shifts

# View issue
gh issue view 8 --repo jkautto/shifts

# Comment on issue (this works!)
gh issue comment 8 --repo jkautto/shifts --body "Comment text"

# Comment from file
gh issue comment 8 --repo jkautto/shifts --body-file comment.md

# Create issue
gh issue create --repo jkautto/shifts \
  --title "Title" \
  --body "Description"

# Assign issue
gh issue edit 8 --repo jkautto/shifts --add-assignee @me
```

### Pull Requests

```bash
# Create PR
gh pr create --repo jkautto/shifts \
  --title "feat: add feature" \
  --body "Closes #8"

# List PRs
gh pr list --repo jkautto/shifts

# Check out PR locally
gh pr checkout 123 --repo jkautto/shifts

# Review PR
gh pr review 123 --repo jkautto/shifts --approve

# Merge PR
gh pr merge 123 --repo jkautto/shifts --squash
```

## Common Pitfalls & Solutions

### GraphQL Pitfalls

1. **Variable Syntax Issues**
   - The `-F` flag for variables often causes parsing errors
   - Stick to inline queries or string interpolation

2. **Multi-line Content**
   - Always escape with `jq -Rs .`
   - Use double quotes for the outer query when interpolating

3. **Finding IDs**
   - Many operations need node IDs, not numbers
   - Always query for the ID first

### Authentication Issues

```bash
# Check current auth
gh auth status

# Refresh if needed
gh auth refresh

# Use specific token
GITHUB_TOKEN=$token gh api ...
```

### Debugging GraphQL

```bash
# Pretty print responses
gh api graphql -f query='...' | jq .

# Check for errors
response=$(gh api graphql -f query='...')
echo $response | jq '.errors'
```

## Working Example: Complete Workflow

```bash
#!/bin/bash
# Start work on an issue

ISSUE=8
REPO="jkautto/shifts"

# 1. Assign yourself
gh issue edit $ISSUE --repo $REPO --add-assignee @me

# 2. Comment on issue
gh issue comment $ISSUE --repo $REPO \
  --body "Starting work on this. Moving to In Progress."

# 3. Find discussion and comment
discussion_id=$(gh api graphql -f query='
{
  repository(owner: "jkautto", name: "shifts") {
    discussions(first: 1) {
      nodes { id }
    }
  }
}' | jq -r '.data.repository.discussions.nodes[0].id')

gh api graphql -f query="
mutation {
  addDiscussionComment(input: {
    discussionId: \"$discussion_id\"
    body: \"Starting work on issue #$ISSUE\"
  }) {
    comment { id }
  }
}"

# 4. Create branch
git checkout -b feature/issue-$ISSUE

echo "Ready to work on issue #$ISSUE"
```

## Tips for AI Agents

1. **Always Test First**: Run commands in test repos before production
2. **Use JSON Output**: Add `| jq .` for readable output
3. **Check for Errors**: GraphQL returns 200 even with errors
4. **Save Complex Queries**: Use files for complex GraphQL
5. **Escape Properly**: Use `jq -Rs .` for multi-line content

## Quick Reference

```bash
# Issues - These work!
gh issue list
gh issue view NUMBER
gh issue comment NUMBER -b "text"
gh issue create -t "title" -b "body"

# PRs - These work!
gh pr list
gh pr create -t "title" -b "body"
gh pr checkout NUMBER
gh pr review NUMBER --approve

# GraphQL - Use these patterns!
gh api graphql -f query='{ ... }'          # Simple queries
gh api graphql -f query="..."              # With variables
body=$(cat file | jq -Rs .)               # Escape content
```

Remember: When standard CLI commands don't exist (like for discussions), use GraphQL!

## Related Guides

- **[GitHub Quick Reference](./github-quick-reference.md)** - Quick commands and common error solutions
- **[Git Workflow Guide](./git-workflow.md)** - Basic Git operations
- **[Claude Code PM Guide](./claude-code-pm-guide.md)** - Project management workflows
- **[Working with AI Agents](./working-with-ai-agents.md)** - Collaboration with other AIs