# Documentation Consolidation v0.1 Plan

**Version:** 0.1  
**Date:** 2025-07-17  
**Author:** DAI

## Executive Summary

Based on analysis of the current documentation structure (253+ files across multiple directories) and research on documentation systems, I recommend adopting **MkDocs with Material theme** as the core documentation platform, enhanced with AI-friendly features and maintaining the existing CAG system for AI context management.

## Current State Analysis

### What We Have
- **253+ documentation files** across /srv/docs, /srv/specs, /srv/context, /srv/CAG
- **Well-organized** by purpose (specs, guides, operations, context)
- **Multiple index files** but no unified search
- **Web-accessible** via https://kaut.to/docs
- **AI-optimized** CAG system for Claude

### Pain Points
1. No unified search across all documentation
2. Some duplication between directories
3. No programmatic way for AI to add/update docs
4. Multiple index files to maintain
5. No versioning or change tracking UI

## Documentation System Comparison

### Options Evaluated

| System | Pros | Cons | AI-Friendly | Verdict |
|--------|------|------|-------------|---------|
| **Wiki.js** | Full-featured, Node.js based | Too heavy, requires database | Moderate | ❌ Too complex |
| **MoinMoin** | Python-based, mature | Dated UI, complex setup | Poor | ❌ Not modern enough |
| **Sphinx** | Powerful, API docs | Complex, Python-focused | Good | ❌ Overkill for our needs |
| **MkDocs** | Simple, fast, markdown | Basic features | Excellent | ✅ **Recommended** |
| **Docsify** | No build step, simple | No static generation | Good | 🤔 Alternative option |

### Why MkDocs?

1. **Simple**: Just markdown files + YAML config
2. **Fast**: Static site generation
3. **Git-based**: All content version controlled
4. **Extensible**: Rich plugin ecosystem
5. **AI-friendly**: Easy to read/write markdown files programmatically
6. **Material theme**: Modern UI with search, navigation, dark mode

## AI-Friendly Requirements

Based on research, AI agents need:

1. **Programmatic access** to read/write files
2. **Simple markdown format** for content
3. **Clear file structure** for navigation
4. **Metadata support** for categorization
5. **Search API** for finding content
6. **Version control** integration

## Proposed Architecture

```
/srv/docs-unified/
├── mkdocs.yml           # MkDocs configuration
├── docs/                # All documentation
│   ├── index.md         # Home page
│   ├── architecture/    # System architecture
│   ├── guides/          # How-to guides
│   ├── operations/      # Operational procedures
│   ├── specs/           # Technical specifications
│   ├── context/         # Context library
│   └── api/             # API documentation
├── custom_theme/        # Material theme customizations
├── plugins/             # Custom MkDocs plugins
│   └── ai_writer.py     # AI documentation helper
└── scripts/
    ├── build.sh         # Build documentation
    ├── deploy.sh        # Deploy to kaut.to
    └── ai_update.py     # AI update interface
```

## Implementation Plan

### Phase 1: Setup (Week 1)
1. Install MkDocs + Material theme
2. Create basic mkdocs.yml configuration
3. Set up directory structure
4. Create initial navigation

### Phase 2: Migration (Week 2)
1. Migrate existing markdown files
2. Update internal links
3. Set up redirects from old URLs
4. Test search functionality

### Phase 3: AI Integration (Week 3)
1. Create AI writer plugin for MkDocs
2. Implement llms.txt standard for AI discovery
3. Add metadata to all pages
4. Create AI update scripts

### Phase 4: Enhancement (Week 4)
1. Customize Material theme
2. Add advanced search features
3. Implement versioning
4. Set up automated deployment

## AI Integration Features

### 1. AI Writer Plugin
```python
# plugins/ai_writer.py
class AIWriterPlugin:
    """MkDocs plugin for AI agents to write documentation"""
    
    def write_page(self, path, content, metadata):
        """Write or update a documentation page"""
        # Validate path
        # Add metadata
        # Write markdown file
        # Update navigation
        # Trigger rebuild
```

### 2. llms.txt Implementation
Create `/srv/docs-unified/llms.txt`:
```markdown
# DAI/PAI Documentation System

## API Access
- Base URL: https://kaut.to/docs/api
- Format: JSON/Markdown
- Authentication: Bearer token

## Key Sections
- /architecture: System design documents
- /guides: Step-by-step tutorials
- /operations: Maintenance procedures
- /context: Current system state
```

### 3. Metadata Standard
All pages include frontmatter:
```yaml
---
title: Page Title
category: guide|spec|operation|context
tags: [python, api, security]
ai_editable: true
last_updated_by: DAI|PAI|human
---
```

## Benefits

1. **Unified Search**: Single search box for all documentation
2. **Better Navigation**: Automatic sidebar generation
3. **Version Control**: Full Git integration
4. **AI-Friendly**: Programmatic read/write access
5. **Modern UI**: Responsive, dark mode, mobile-friendly
6. **Static Output**: Fast loading, can be cached
7. **Easy Maintenance**: Just edit markdown files

## Minimal Viable Product (MVP)

For v0.1, focus on:
1. Basic MkDocs setup with Material theme
2. Migration of core documentation
3. Simple AI write script
4. Automated deployment to kaut.to

## Next Steps

1. **Approve plan**: Review and approve this specification
2. **Create test instance**: Set up MkDocs in /srv/docs-test
3. **Migrate sample docs**: Move 10-20 key documents
4. **Test AI integration**: Verify AI can read/write
5. **Plan full migration**: Schedule complete transition

## Alternative: Lightweight Option

If MkDocs feels too heavy, consider:
- **Docsify**: No build step, renders markdown on-the-fly
- **Custom solution**: Simple Python script + Jinja2 templates
- **Enhanced CAG**: Extend existing CAG system with web UI

## Conclusion

MkDocs with Material theme offers the best balance of simplicity, features, and AI-friendliness. It maintains our markdown-based approach while adding professional documentation features like search, navigation, and theming. The static output integrates well with our existing web infrastructure, and the programmatic access enables AI agents to contribute to documentation.