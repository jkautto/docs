# CAG Learnings & Best Practices

**Version: 3.1**

This document is a collection of troubleshooting guides, lessons learned, and best practices.

---

## 1. Critical Learnings

### 1.1. Python Environment (2025-07-17)
- **Problem:** `ModuleNotFoundError` for both pip-installed and local packages.
- **Root Cause:** System-level Python environment is unreliable. Conflicts exist between global and user `site-packages`.
- **Solution:** **Always use a virtual environment.** A `venv` has been created at `/srv/jtools/.venv`. All development on `jtools` must be done using this interpreter. See `/srv/jtools/PYTHON_DEVELOPMENT_GUIDE.md`.

### 1.2. SSL & Subdomain Access (2025-07-15)
- **Problem:** New subdomains were inaccessible from the internet.
- **Root Cause:** Split DNS. The main domain was proxied, while subdomains pointed directly to the server, which was firewalled.
- **Lesson:** Ensure subdomains and the main domain resolve to the same IP, especially when a proxy or CDN is in use.

### 1.3. Claude CLI Context (2025-07-05)
- **Problem:** "Prompt too long" errors in cron jobs.
- **Root Cause:** Using the `-c` flag accumulates context indefinitely.
- **Solution:** Use stateless calls (no `-c` or `-r`) for frequent, repetitive tasks. Use session-based calls (`-r <session_id>`) for coherent, multi-turn conversations.

### 1.4. GitHub Projects API (2025-07-17)
- **Problem:** Unable to create GitHub project boards programmatically.
- **Root Cause:** GitHub Projects (classic) has been deprecated in favor of the new Projects experience.
- **Solution:** Use GitHub Issues with labels and milestones for task tracking. The new Projects API requires GraphQL and is more complex. For simple task management, issues are sufficient.
- **Lesson:** Check API deprecation notices. GitHub CLI (`gh`) doesn't support the new Projects API directly.

### 1.5. Documentation Consolidation (2025-07-17)
- **Problem:** Documentation scattered across multiple locations with no unified search capability (CAG files, /docs/, context library, inline comments).
- **Root Cause:** Organic growth led to documentation being created wherever it was most convenient at the time.
- **Solution:** MkDocs with Material theme provides a unified documentation site with powerful search, navigation, and organization features.
- **Key Insight:** Static site generators work exceptionally well for AI agents because they use simple markdown files that can be easily read, edited, and searched programmatically.
- **Lesson:** When choosing tools for AI-first systems, prioritize simplicity and file-based approaches over complex databases or proprietary formats. The easier it is for an AI to read and modify content, the more effective the system will be.

---

## 2. Best Practices

### 2.1. Development
- **Virtual Environments:** All Python projects MUST use a virtual environment (`venv`).
- **Version Control:** Do not commit secrets, backups, or virtual environment directories (`.venv/`). Use `.gitignore`.
- **Modularity:** Break down large scripts into smaller, single-purpose modules.
- **Configuration:** Use `.env` files for all secrets and environment-specific configuration. Do not hardcode credentials.

### 2.2. Monitoring
- **Stateless by Default:** Monitoring scripts should be stateless to avoid context overflow.
- **Progressive Disclosure:** Use different Slack channels for different alert severities (e.g., `urgent`, `notifications`, `verbose`).
- **Actionable Alerts:** Alerts should provide context and suggest a clear next step.

### 2.3. Prompt Engineering
- **Be Specific:** Provide clear, direct instructions.
- **Use Examples:** Include few-shot examples in prompts for complex tasks.
- **Update Prompts, Not Code:** For AI-first applications, iterate on the prompts before refactoring the code.

---

## 3. Common Issues & Fixes

- **Issue:** "No routing decisions from Claude"
  - **Cause:** Session timeout or API overload.
  - **Fix:** 1. Check Claude status. 2. Restart the monitoring script.

- **Issue:** Email monitor stops detecting new emails.
  - **Fixes:**
    ```bash
    # 1. Check for a valid, non-expired token
    python3 /srv/pai/toolkit/gmail_tool.py --account all auth-test

    # 2. Clear a potentially stuck cache
    rm /tmp/pai_emails_cache.json
    ```

- **Issue:** Calendar conflicts are not detected.
  - **Cause:** The calendar has not been shared with the service account.
  - **Fix:** Share the Google Calendar with `pai-assistant@personal-ai-453416.iam.gserviceaccount.com`.
