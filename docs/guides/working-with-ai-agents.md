# Working with AI Agents - Practical Guide

## Overview
This guide documents practical lessons learned from collaborating with various AI agents (Gemini, Claude, etc.) on development projects.

## Common AI Agent Behaviors

### Gemini Agent Characteristics
Based on real-world experience:

1. **Planning Issues**:
   - Often provides templates with blank spaces
   - May repeat the same mistakes multiple times
   - Good conceptual ideas but sloppy execution

2. **Implementation Patterns**:
   - Usually delivers working code eventually
   - May skip Git best practices (no PRs, direct commits)
   - Sometimes breaks builds with hardcoded paths

3. **How to Work Effectively**:
   - Provide extremely specific instructions
   - Include actual file paths and code examples
   - Review and test their work immediately
   - Be prepared to fix minor issues

### Example: Gemini's Issue #11 Implementation

**The Problem**: Gemini provided three implementation plans with blank templates:
```
File to be modified: [BLANK]
Code to be added: [BLANK]
```

**The Solution**: Provided concrete examples:
```
File to be modified: /srv/apps/shifts/src/config/index.js
Code structure: highlightedDates: [{ date: "2025-09-21", label: "Dry-run", className: "highlight-dry-run" }]
```

**The Result**: Once given specific details, Gemini successfully implemented the feature.

## Best Practices for AI Collaboration

### 1. Clear Communication
- **Be Specific**: Always provide full file paths
- **Show Examples**: Include code snippets
- **Set Expectations**: Clarify MVP vs production requirements

### 2. Review Process
```bash
# Always review AI commits
git pull
git log --oneline -5
git diff HEAD~1

# Test immediately
npm run build
npm test  # if tests exist

# Check deployment
python3 /srv/jtools/screenshot.py https://kaut.to/app/
```

### 3. Common Fixes Needed

#### Build Failures
Often caused by hardcoded asset paths:
```javascript
// Bad (Gemini often does this)
<script src="/app/assets/index-ABC123.js"></script>

// Good
<script type="module" src="/src/main.js"></script>
```

#### Missing Imports
Check for components used but not imported:
```javascript
// If Legend is used but not imported
import { Legend } from '../Legend/index.js';
```

### 4. Feedback Templates

#### For Good Work:
```markdown
## ✅ Implementation Review - APPROVED
- Feature works as expected
- Clean code structure
- All acceptance criteria met
Minor issue: [specific issue] - I fixed it
Great job overall!
```

#### For Issues:
```markdown
## 🔧 Needs Improvement
The plan has blank spaces where critical information should be:
- File paths are missing
- No actual code examples
Please provide:
1. Complete file paths
2. Actual code snippets
3. Specific implementation details
```

## Working with Multiple AI Agents

### Division of Labor
- **Claude Code**: Project management, code review, deployment
- **Gemini**: Feature implementation (with supervision)
- **Other AIs**: Specialized tasks (documentation, testing)

### Coordination Tips
1. One AI per issue/feature
2. Clear handoffs in issue comments
3. Always verify work before closing issues
4. Document fixes needed for future reference

## Common Pitfalls and Solutions

| Problem | Solution |
|---------|----------|
| Blank implementation plans | Provide concrete examples |
| No Git workflow | Remind about branches/PRs |
| Build failures | Check and fix immediately |
| Over-engineering | Emphasize MVP approach |
| Missing tests | Accept for MVP, note for later |

## Quick Reference Commands

```bash
# Check AI's work
gh issue view <number> --comments
git log --author="Claude AI" --oneline

# Fix common issues
npm run build  # Check for build errors
git commit --amend  # Fix commit messages
git push --force-with-lease  # Update after fixes

# Provide feedback
gh issue comment <number> -b "Feedback here"
```

## Lessons Learned

1. **Be Patient but Firm**: AIs may need multiple attempts
2. **Trust but Verify**: Always test their implementations
3. **Fix Forward**: Don't spend time on blame, just fix issues
4. **Document Patterns**: Keep notes on each AI's tendencies
5. **Appreciate Success**: Celebrate when things work!

Remember: AI agents are tools to augment your productivity. Guide them well, and they can significantly speed up development.