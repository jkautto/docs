# Context Library

The Context Library is DAI/PAI's knowledge management system, containing accumulated wisdom, architectural decisions, and operational knowledge.

## Overview

The Context Library serves as the living memory of the DAI/PAI ecosystem. It includes:

- **CAG System**: Core Agent Gateway - structured knowledge base
- **Current Context**: Active operational context and state
- **Development Context**: In-progress features and experiments
- **Archives**: Historical context and deprecated information

## CAG (Core Agent Gateway)

The CAG system is the primary knowledge base for AI agents operating within the DAI/PAI ecosystem.

### Key Components

- [**CAG Index**](cag/cag-index.md) - Master index and navigation guide
- [**CAG Core**](cag/cag-core.json) - Structured configuration data
- [**CAG Architecture**](cag/cag-architecture.md) - System design decisions
- [**CAG Operations**](cag/cag-operations.md) - Current operational state
- [**CAG Learnings**](cag/cag-learnings.md) - Accumulated best practices

### Usage Guidelines

1. **Start with the Index**: Always begin with [cag-index.md](cag/cag-index.md) for navigation
2. **Check Core Data**: Use [cag-core.json](cag/cag-core.json) for paths, ports, and configs
3. **Understand Architecture**: Review [cag-architecture.md](cag/cag-architecture.md) for design rationale
4. **Monitor Operations**: Check [cag-operations.md](cag/cag-operations.md) for current status
5. **Learn from History**: Consult [cag-learnings.md](cag/cag-learnings.md) for troubleshooting

## Current Context

Active operational context files that guide day-to-day operations:

- System state and health
- Active projects and priorities
- Temporary configurations
- Work-in-progress documentation

## Development Context

Development-specific knowledge and workflows:

- [GitHub Issue-Driven Workflow](/srv/context/development/github-issue-driven-workflow.md) - Systematic development process
- Project setup guides
- Testing strategies
- Release procedures

## Archives

Historical context preserved for reference:

- Deprecated configurations
- Old architectural decisions
- Past incident reports
- Legacy documentation

## Best Practices

### Reading Context
- Always start with the most specific context first
- Check timestamps and versions
- Cross-reference with operational data

### Updating Context
- Keep updates atomic and focused
- Include timestamps and authorship
- Link related changes
- Archive outdated information properly

### Context Hygiene
- Review and clean up quarterly
- Move stale content to archives
- Update indexes when structure changes
- Maintain clear navigation paths

## Quick Reference

| Context Type | Location | Purpose |
|--------------|----------|---------|
| CAG System | `/context/cag/` | Core knowledge base |
| Current | `/context/current/` | Active operational context |
| Development | `/context/development/` | Work in progress |
| Archives | `/context/archives/` | Historical reference |

!!! tip "Pro Tip"
    The CAG system is designed for AI consumption. Keep entries structured, clear, and machine-readable.

## Related Documentation

- [Architecture Overview](../architecture/index.md)
- [Operations Guide](../operations/daily-maintenance.md)
- [API Documentation](../api/index.md)