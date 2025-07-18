# CAG Architecture

**Version: 3.1**

This document outlines the technical architecture and design decisions for the DAI system.

---

## 1. System Architecture

### 1.1. Core Design (v0.3)
- **AI-First:** Primary intelligence is in Claude prompts, not Python logic.
- **Simple Wrappers:** Python scripts are thin wrappers around the Claude CLI.
- **Session-Based:** Conversations use fixed sessions for different domains.
- **Toolkit Architecture:** Lightweight, cached tools for speed and monitoring.

### 1.2. Technical Stack
- **Language:** Python 3.10+
- **AI:** Claude CLI (Anthropic)
- **APIs:** Google Workspace
- **Communication:** Slack Webhooks
- **Scheduling:** System Cron
- **Authentication:** OAuth2 & Google Service Accounts

---

## 2. Design Decisions

### 2.1. Claude-First Architecture
- **Decision:** Move all complex logic to Claude prompts.
- **Rationale:** Enables rapid iteration and changes without code deployment.
- **Result:** 90% reduction in Python code complexity.

### 2.2. `toolkit` vs. `jtools`
- **`jtools`:** Full-featured CLI tools for human use.
- **`toolkit`:** Lightweight, single-purpose, cached tools for AI/monitoring.
- **Benefit:** 10x faster execution for automated tasks.

---

## 3. Integration & Data Flow

### 3.1. Data Flow Diagram
```
Google APIs -> Collectors -> Cache -> Processors -> Claude -> Slack
```

### 3.2. Error Handling Strategy
1.  **Collector Level:** Fallback to cache on API failure.
2.  **Processor Level:** Skip analysis if no data is available.
3.  **Claude Level:** Use fallback routing on API timeout.
4.  **Slack Level:** Route all errors to a verbose debug channel.

### 3.3. Security Architecture
- **Tokens:** Stored in `/srv/tokens/` with `600` permissions.
- **Service Accounts:** Granted read-only access where possible.
- **Webhooks/Secrets:** Sourced exclusively from `.env` files.
- **Logs:** Sanitized to remove sensitive data.

---

## 4. Future Architecture Roadmap

- **v0.4 - Self-Healing:** Automated error recovery, token refresh, and service restarts.
- **v0.5 - Distributed:** Multi-server redundancy and shared state management.
- **v1.0 - Full Autonomy:** Predictive monitoring and self-modifying prompts.
