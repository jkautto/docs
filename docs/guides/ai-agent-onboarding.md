# AI Agent Onboarding Guide

Welcome to the kaut.to development team! This guide provides essential information for AI agents working on our projects.

## Quick Start Checklist

- [ ] Read this onboarding guide completely
- [ ] Understand Git workflow and conventions
- [ ] Learn about available tools and testing frameworks
- [ ] Review coding standards and documentation requirements
- [ ] Familiarize yourself with GitHub Issues and Project boards
- [ ] Join the team discussion on GitHub Discussions

## Core Principles

### 1. Fail Fast, Fail Better

**Always test your changes immediately:**
```bash
# After ANY code change:
1. Check syntax: node -c file.js OR python -m py_compile file.py
2. Run tests: jtest
3. Test deployment: python3 test-deployment.py
4. Only then commit
```

**If something breaks:**
- Don't hide it or try complex fixes
- Report immediately in the issue
- Revert to last working state
- Try a different approach

### 2. Small, Atomic Changes

**One change = One commit:**
```bash
# BAD: Large commit with multiple changes
git commit -m "fix everything"

# GOOD: Atomic commits
git commit -m "fix: correct data format validation"
git commit -m "test: add save functionality test"
git commit -m "docs: update API documentation"
```

### 3. Communication is Key

- **Issues**: For specific tasks and bug reports
- **Discussions**: For general questions and team coordination
- **Commit messages**: Clear and descriptive
- **Code comments**: Explain WHY, not WHAT

## Git Workflow

### Basic Commands

```bash
# Always start by checking status
git status

# Create a feature branch
git checkout -b feature/issue-8-keyboard-shortcuts

# Make changes and test
# ... edit files ...
node -c src/main.js  # Check syntax
jtest                # Run tests

# Stage and commit
git add -p  # Review changes piece by piece
git commit -m "feat: add keyboard shortcuts for paint modes"

# Push to GitHub
git push origin feature/issue-8-keyboard-shortcuts

# Create PR via GitHub CLI
gh pr create --title "feat: add keyboard shortcuts" --body "Closes #8"
```

### Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation only
- `style:` Code style (formatting, semicolons, etc)
- `refactor:` Code restructuring without changing behavior
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

Examples:
```
feat: add keyboard shortcuts for paint modes
fix: correct schedule data validation
docs: update testing guide with new examples
test: add e2e tests for save functionality
```

### Branch Naming

Format: `type/issue-number-description`

Examples:
- `feature/issue-8-keyboard-shortcuts`
- `fix/issue-6-save-functionality`
- `docs/improve-api-documentation`

## Authentication & Access

### GitHub Token

Located in `/srv/pai/.env`:
```bash
# Use for GitHub API calls
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### HTTP Basic Auth

Default for all kaut.to services:
- Username: `kaut`
- Password: `to`

Admin access (when needed):
- Username: `joni`
- Password: `Penacova`

### Repository Access

All repositories under: https://github.com/jkautto/
- Main app repos: shifts, pai, dai, jtools
- Shared resources: kaut-shared
- Documentation: docs

## Coding Standards

### 1. Modular Architecture

**Bad:**
```javascript
// 1000 lines of code in one file
function doEverything() {
  // ... massive function ...
}
```

**Good:**
```javascript
// main.js
import { Schedule } from './components/Schedule.js';
import { storageService } from './services/storage.js';

// components/Schedule.js
export class Schedule {
  // Single responsibility: render schedule
}

// services/storage.js
export const storageService = {
  // Single responsibility: handle data persistence
}
```

### 2. AI-Optimized Code

Write code that AI agents can easily understand and modify:

**Use clear, descriptive names:**
```javascript
// Bad
const d = new Date();
const u = users.filter(x => x.a);

// Good
const currentDate = new Date();
const activeUsers = users.filter(user => user.isActive);
```

**Add section comments:**
```javascript
/**
 * Data Loading Section
 * Handles fetching and validating schedule data
 */
async loadScheduleData() {
  // Implementation...
}

/**
 * Rendering Section
 * Manages DOM updates and user interface
 */
render() {
  // Implementation...
}
```

### 3. Error Handling

Always handle errors gracefully:
```javascript
try {
  const data = await fetchData();
  processData(data);
} catch (error) {
  console.error('Failed to fetch data:', error);
  // Fallback behavior
  showErrorMessage('Unable to load data. Please try again.');
}
```

## Documentation Requirements

### 1. Code Documentation

**Every file needs a header:**
```javascript
/**
 * Schedule Management Component
 * 
 * Handles the visual display and interaction for shift schedules.
 * Part of the Shifts application.
 * 
 * @module components/Schedule
 */
```

**Document complex logic:**
```javascript
/**
 * Validates schedule data format
 * 
 * Expected format:
 * {
 *   "PersonName": ["W", "O", "R", ...],  // Array of shift codes
 *   ...
 * }
 * 
 * @param {Object} data - Raw schedule data
 * @returns {boolean} True if valid, false otherwise
 */
function validateScheduleData(data) {
  // Implementation with inline comments for complex parts
}
```

### 2. README Updates

Always update README.md when:
- Adding new features
- Changing setup instructions
- Modifying API endpoints
- Adding dependencies

### 3. Inline Comments

```javascript
// WHY comments (good):
// We need to validate data here because the backend
// might return legacy format from localStorage
if (!isValidFormat(data)) {
  data = convertLegacyFormat(data);
}

// WHAT comments (avoid):
// Set x to 5
x = 5;
```

## Testing Requirements

### 1. Test Before Committing

**Always run tests:**
```bash
# Run all tests
jtest

# Run specific test type
jtest --javascript  # For web apps
jtest --python      # For Python tools
jtest --bash        # For shell scripts
```

### 2. Write Tests for New Features

**Example JavaScript test:**
```javascript
// keyboard-shortcuts.spec.js
test('should activate paint mode with keyboard', async ({ page }) => {
  await page.goto('https://kaut.to/shifts/');
  
  // Press 'W' key
  await page.keyboard.press('w');
  
  // Verify paint mode is active
  const activeButton = page.locator('.paint-button.active');
  await expect(activeButton).toHaveText('W');
});
```

### 3. Visual Testing

For UI changes:
```bash
# Capture before screenshot
python3 test-deployment.py --screenshot before.png

# Make changes

# Capture after screenshot
python3 test-deployment.py --screenshot after.png

# Compare visually or use diff tools
```

## Available Tools

### 1. Research with Perplexity (px.py)

When you need to research something:
```bash
cd /srv/jtools/px
python3 px.py "how to implement keyboard shortcuts in JavaScript"
```

Use for:
- Finding best practices
- Researching error messages
- Learning new APIs
- Checking browser compatibility

### 2. Testing with jtest

```bash
# From any project directory
/srv/jtools/jtest

# Run continuously during development
watch -n 5 /srv/jtools/jtest
```

### 3. Git Helpers

```bash
# Commit with conventional format
/srv/jtools/jcommit "feat: add new feature"

# Check git history
git log --oneline -10
```

## GitHub Project Board Workflow

### Issue States

1. **To Do**: Issue created but not started
2. **In Progress**: Actively working on it
3. **Blocked**: Stuck and need help
4. **In Review**: PR created and awaiting review
5. **Done**: Completed and merged

### Moving Issues

When you start working:
```bash
# Comment on the issue
gh issue comment 8 --body "Starting work on keyboard shortcuts implementation"

# Move to In Progress (on project board)
# This is usually done via GitHub UI
```

When blocked:
```bash
gh issue comment 8 --body "**Blocked**: Need clarification on which keys to use for shortcuts"
```

When complete:
```bash
# Create PR
gh pr create --title "feat: add keyboard shortcuts" --body "Closes #8

## Changes
- Added keyboard event listeners
- Implemented W, R, X, O shortcuts
- Added visual feedback

## Testing
- Tested in Chrome, Firefox
- Added automated tests
- No visual regressions"
```

## Communication Guidelines

### GitHub Issues

Use for:
- Specific bugs or features
- Task tracking
- Technical discussions
- Progress updates

Format:
```markdown
## Status Update

Completed:
- ✅ Research keyboard event handling
- ✅ Implement basic shortcuts

In Progress:
- 🔄 Adding visual feedback

Next:
- 📝 Write tests
- 📝 Update documentation
```

### GitHub Discussions

Use for:
- General questions
- Architecture discussions
- Team coordination
- Knowledge sharing
- Introductions

### Code Reviews

When reviewing:
1. Test the changes locally
2. Check for syntax errors
3. Verify tests pass
4. Look for security issues
5. Suggest improvements kindly

## Environment Setup

### Local Development

1. **Clone repository:**
```bash
git clone https://github.com/jkautto/shifts.git
cd shifts
```

2. **Install dependencies:**
```bash
# For Node.js projects
npm install

# For Python projects
pip install -r requirements.txt
```

3. **Start development server:**
```bash
# Check package.json for scripts
npm run dev
```

### Testing Environment

- Local dev server: http://localhost:5173
- Production: https://kaut.to/shifts/
- Always test in both environments

## Common Pitfalls to Avoid

### 1. Large Uncommitted Changes

❌ **Don't**: Work for hours without committing
✅ **Do**: Commit every 15-30 minutes

### 2. Ignoring Syntax Errors

❌ **Don't**: Hope it works in production
✅ **Do**: Always check syntax before committing

### 3. Skipping Tests

❌ **Don't**: "It works on my machine"
✅ **Do**: Run full test suite before pushing

### 4. Poor Communication

❌ **Don't**: Go silent when stuck
✅ **Do**: Ask for help early and often

### 5. Breaking Changes

❌ **Don't**: Change APIs without discussion
✅ **Do**: Propose changes in issues first

## Getting Help

1. **Check documentation**: https://docs.kaut.to
2. **Search existing issues**: `gh issue list --search "keyword"`
3. **Ask in Discussions**: For general questions
4. **Tag team members**: @jkautto for urgent items

## Summary

Remember the key principles:
1. **Test everything** before committing
2. **Communicate** progress and blockers
3. **Write clear code** that other agents can understand
4. **Document** your changes
5. **Ask for help** when needed

Welcome to the team! We're excited to have you contributing to our projects. 🚀