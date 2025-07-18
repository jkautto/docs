# DAI System Documentation

**Version: 3.1**

Welcome to the master documentation for the Development AI Infrastructure (DAI). This is the primary entry point for understanding the system's architecture, operations, and development practices.

---

## 1. Core System Context (The CAG)

For the most critical, AI-optimized information about the system, start with the **Core Agent Gateway (CAG)** knowledge base.

- **Start Here:** [`/srv/CAG/index.md`](/srv/CAG/index.md)

The CAG provides a high-level overview and links to detailed information on:
- **`CAG-core.json`**: All structured configuration, paths, and credentials.
- **`CAG-architecture.md`**: The "why" behind the system's design.
- **`CAG-operations.md`**: The current health and status of the system.
- **`CAG-learnings.md`**: Best practices and lessons learned.

---

## 2. Operational Guides

This section contains detailed guides and runbooks for day-to-day operations and development.

- **[Python Development Guide](./jtools/PYTHON_DEVELOPMENT_GUIDE.md)**
  - **MUST READ.** Instructions for setting up and using the standardized `venv` virtual environment.

- **[Git Workflow](./git-workflow.md)**
  - Guidelines for branching, commits, and pull requests.

- **[Operations Manual](./operations/)**
  - Checklists for daily maintenance, emergency recovery, and managing system services.

---

## 3. Troubleshooting

This section contains guides for diagnosing and resolving common issues.

- **[SSL and Subdomain Access](./troubleshooting/ssl_and_subdomain_access.md)**
  - A complete guide to diagnosing and fixing issues related to SSL certificates and subdomain routing.

- **[Common Issues](./operations/common-issues.md)**
  - A list of frequently encountered problems and their solutions.

---

## 4. System Specifications

For detailed technical specifications of system components, see the `/srv/specs/` directory.

---

## 5. Archive

Outdated documents, completed plans, and historical notes are moved to `/srv/docs/archive/`. This directory should only be consulted for historical research.
