# GitHub CLI and GraphQL API Research (2025)

## Overview
This document contains the latest research on GitHub CLI and GraphQL API, focusing on discussions, project boards V2, and common usage patterns.

## Table of Contents
1. [GitHub CLI Discussions](#github-cli-discussions)
2. [GitHub GraphQL API for Discussions](#github-graphql-api-for-discussions)
3. [GitHub Project Boards V2 GraphQL](#github-project-boards-v2-graphql)
4. [GitHub CLI GraphQL Examples](#github-cli-graphql-examples)
5. [Common Issues and Solutions](#common-issues-and-solutions)

## GitHub CLI Discussions

### Current State (July 2025)
- GitHub CLI fully supports core GitHub workflows in the terminal for issues, PRs, releases
- Active discussions forum at: https://github.com/cli/cli/discussions
- Community interest in expanding CLI support for GitHub Discussions
- Initial reservations by CLI team (2021) have shifted to acceptance of user requests

### Key Points
- Supports GitHub.com, GitHub Enterprise Cloud, and GitHub Enterprise Server
- Available on macOS, Windows, and Linux
- Installation via Homebrew, MacPorts, Scoop, Chocolatey
- Scripting capabilities with GitHub API
- Custom aliases for commands

### Discussions Support Status
- Limited native support for discussions via CLI
- Community proposals for:
  - Updating discussion comment titles
  - Better integration with GitHub Discussions
  - Managing on-call logs and task updates from terminal

## GitHub GraphQL API for Discussions

### Features
- **Repository-Level Discussions**: Full support
- **Organization-Level Discussions**: Not supported (no current plans)
- **Authentication**: Requires OAuth scopes for public/private repos

### Key Mutations

#### Create Discussion
```graphql
mutation CreateDiscussion($input: CreateDiscussionInput!) {
  createDiscussion(input: $input) {
    discussion {
      id
      title
      body
      category {
        name
      }
    }
  }
}
```

Required input fields:
- `body`: Discussion content
- `title`: Discussion title
- `repositoryId`: Repository node ID
- `categoryId`: Discussion category ID

### Key Queries

#### Query Repository Discussions
```graphql
query GetDiscussions($owner: String!, $repo: String!) {
  repository(owner: $owner, name: $repo) {
    discussions(first: 10) {
      nodes {
        id
        title
        body
        category {
          name
        }
        author {
          login
        }
      }
    }
  }
}
```

## GitHub Project Boards V2 GraphQL

### Supported Operations

| Operation | GraphQL API Support | Notes |
|-----------|-------------------|-------|
| List Project V2 board issues | ✅ Yes | Via querying organization or repository projects by ID |
| Add items to Project V2 | ✅ Yes | Mutation `addProjectV2ItemById` |
| Update item field values | ✅ Yes | Mutation `updateProjectV2ItemFieldValue`, separate call |
| Create/Edit iterations | ⚠️ Limited | Edits are problematic; no straightforward mutation |
| Create/Edit Project Views | ❌ No | No official API for creating/modifying views |

### Key Mutations

#### Add Item to Project
```graphql
mutation AddProjectItem($projectId: ID!, $contentId: ID!) {
  addProjectV2ItemById(input: {projectId: $projectId, contentId: $contentId}) {
    item {
      id
    }
  }
}
```

#### Update Project Item Field
```graphql
mutation UpdateProjectField($projectId: ID!, $itemId: ID!, $fieldId: ID!, $value: ProjectV2FieldValue!) {
  updateProjectV2ItemFieldValue(input: {
    projectId: $projectId
    itemId: $itemId
    fieldId: $fieldId
    value: $value
  }) {
    projectV2Item {
      id
    }
  }
}
```

### Limitations
- Cannot add and update items in same API call
- No API for creating/modifying project views (Tables, Boards, Roadmaps)
- Iteration management is problematic (requires workarounds)

## GitHub CLI GraphQL Examples

### Basic Query
```bash
gh api graphql -f query='
  query {
    viewer {
      login
      name
    }
  }
'
```

### Query with Variables
```bash
gh api graphql -f query='
  query($owner: String!, $repo: String!) {
    repository(owner: $owner, name: $repo) {
      issues(last: 5, states: OPEN) {
        edges {
          node {
            title
            url
            state
          }
        }
      }
    }
  }
' -F owner='octocat' -F repo='hello-world'
```

### Query from File
```bash
# Save query to file
cat > my-query.gql << 'EOF'
query($owner: String!, $repo: String!, $num: Int!) {
  repository(owner: $owner, name: $repo) {
    issues(first: $num, states: OPEN) {
      totalCount
      nodes {
        title
        number
        state
      }
    }
  }
}
EOF

# Execute query
gh api graphql --field query=@my-query.gql -F owner='cli' -F repo='cli' -F num=3
```

### Chaining Queries with Shell Variables
```bash
# Get issue ID
ISSUE_ID=$(gh api graphql -f query='
  query($owner: String!, $repo: String!, $number: Int!) {
    repository(owner: $owner, name: $repo) {
      issue(number: $number) {
        id
      }
    }
  }
' -F owner='owner' -F repo='repo' -F number=1 --jq '.data.repository.issue.id')

# Use ID in another query
gh api graphql -f query='
  query($id: ID!) {
    node(id: $id) {
      ... on Issue {
        title
        body
        comments(first: 5) {
          nodes {
            body
            author {
              login
            }
          }
        }
      }
    }
  }
' -F id="$ISSUE_ID"
```

### Using Special Headers
```bash
# For new-style IDs
gh api graphql -H "X-Github-Next-Global-ID: 1" -f query='...'

# For preview features
gh api graphql -H "GraphQL-Features: feature_name" -f query='...'
```

## Common Issues and Solutions

### Issue 1: Pagination with GraphQL
**Problem**: GraphQL doesn't support `--paginate` flag like REST API  
**Solution**: Implement cursor-based pagination manually

```bash
gh api graphql -f query='
  query($owner: String!, $repo: String!, $cursor: String) {
    repository(owner: $owner, name: $repo) {
      issues(first: 100, after: $cursor) {
        pageInfo {
          hasNextPage
          endCursor
        }
        nodes {
          title
          number
        }
      }
    }
  }
' -F owner='owner' -F repo='repo' -F cursor='null'
```

### Issue 2: Complex Field Updates in Projects V2
**Problem**: Cannot add and update item in single call  
**Solution**: Use sequential mutations

```bash
# First add the item
ITEM_ID=$(gh api graphql -f query='mutation...' --jq '.data.addProjectV2ItemById.item.id')

# Then update fields
gh api graphql -f query='mutation...' -F itemId="$ITEM_ID"
```

### Issue 3: Handling GraphQL Errors
**Problem**: GraphQL returns 200 OK even with errors  
**Solution**: Always check for errors in response

```bash
RESPONSE=$(gh api graphql -f query='...')
if echo "$RESPONSE" | jq -e '.errors' > /dev/null; then
  echo "GraphQL errors occurred:"
  echo "$RESPONSE" | jq '.errors'
  exit 1
fi
```

### Issue 4: Finding Node IDs
**Problem**: Many GraphQL operations require node IDs  
**Solution**: Use REST API or GraphQL queries to get IDs

```bash
# Get repository ID
REPO_ID=$(gh api graphql -f query='
  query($owner: String!, $repo: String!) {
    repository(owner: $owner, name: $repo) {
      id
    }
  }
' -F owner='owner' -F repo='repo' --jq '.data.repository.id')

# Get project ID
PROJECT_ID=$(gh api graphql -f query='
  query($org: String!, $number: Int!) {
    organization(login: $org) {
      projectV2(number: $number) {
        id
      }
    }
  }
' -F org='org' -F number=1 --jq '.data.organization.projectV2.id')
```

## Best Practices

1. **Use Query Files**: Store complex queries in `.gql` files for maintainability
2. **Handle Errors**: Always check for GraphQL errors in responses
3. **Use Variables**: Pass dynamic values as variables, not string interpolation
4. **Batch Operations**: Use single queries to fetch multiple related resources
5. **Cache IDs**: Store frequently used node IDs to avoid repeated lookups
6. **Test in Explorer**: Use GitHub's GraphQL Explorer before implementing in CLI

## Resources

- [GitHub GraphQL Explorer](https://docs.github.com/en/graphql/overview/explorer)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [GitHub GraphQL API Documentation](https://docs.github.com/en/graphql)
- [GitHub CLI Discussions Forum](https://github.com/cli/cli/discussions)
- [GraphQL API for Discussions Guide](https://docs.github.com/en/graphql/guides/using-the-graphql-api-for-discussions)

---

*Last updated: July 2025*