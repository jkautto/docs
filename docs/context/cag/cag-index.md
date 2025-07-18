# CAG Index: AI Knowledge Base

**Version: 3.1**

This is the master index for the Core Agent Gateway (CAG) knowledge base. Start here to understand the system architecture, operations, and learned best practices.

---

### 1. Core Configuration (`CAG-core.json`)

For all structured data, paths, credentials, and service definitions, refer to `CAG-core.json`. This is the single source of truth for machine-readable configuration.

- **Paths:** All key directory paths (`/srv`, `/srv/jtools`, etc.).
- **Services:** All running services, ports, and public domains.
- **Authentication:** API key locations, OAuth token paths, and service account details.
- **Repositories:** Git repository URLs and descriptions.
- **Schedules:** All cron job schedules.

---

### 2. System Architecture (`CAG-architecture.md`)

This document outlines the "why" behind the system's design.

- **Core Design Principles:** "Claude-first," session management, etc.
- **Technical Stack:** Languages, APIs, and key technologies.
- **Design Decisions:** Rationale for key architectural choices.
- **Integration Patterns:** Data flow and error handling strategies.
- **Future Plans:** High-level roadmap for v0.4 and beyond.

---

### 3. Operations & Current State (`CAG-operations.md`)

This document provides a real-time snapshot of the system's health and status.

- **System Health:** What's working, what's broken.
- **Active Monitors:** Details on all running monitoring agents.
- **Operational Procedures:** Checklists for daily maintenance and emergency recovery.
- **Performance Metrics:** Key performance indicators (KPIs) for system response times and resource usage.

---

### 4. Learnings & Best Practices (`CAG-learnings.md`)

This document is a collection of troubleshooting guides, lessons learned, and best practices.

- **Critical Learnings:** High-impact lessons from past incidents.
- **Common Issues & Fixes:** A "FAQ" for debugging common problems.
- **Best Practices:** A list of "do's" and "don'ts" for development.
- **Anti-Patterns:** A list of things to avoid.

---

### 5. Primary Documentation Hub (`/srv/docs/index.md`)

For user-facing documentation, guides, and detailed specifications, refer to the main documentation hub at `/srv/docs/index.md`.
