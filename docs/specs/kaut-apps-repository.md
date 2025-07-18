# kaut-apps Repository Structure

## Overview

Consolidate all kaut.to applications into a single monorepo for easier management, consistent deployment, and shared utilities.

## Repository: github.com/jkautto/kaut-apps

### Structure
```
kaut-apps/
├── README.md                    # Main documentation
├── .github/
│   ├── workflows/
│   │   ├── deploy-all.yml      # Deploy all apps
│   │   ├── deploy-pastebin.yml # Deploy pastebin only
│   │   ├── deploy-tasks.yml    # Deploy tasks only
│   │   └── test.yml            # Run all tests
│   └── ISSUE_TEMPLATE/
├── shared/                      # Shared utilities
│   ├── auth/                   # Common auth logic
│   ├── models/                 # Shared data models
│   └── utils/                  # Helper functions
├── pastebin/                   # pb.kaut.to
│   ├── Dockerfile
│   ├── README.md
│   ├── app.py
│   ├── requirements.txt
│   ├── config.py
│   ├── database.py
│   ├── static/
│   ├── templates/
│   └── tests/
├── tasks/                      # task.kaut.to
│   ├── Dockerfile
│   ├── README.md
│   ├── requirements.txt
│   ├── backend/
│   │   ├── main.py
│   │   ├── api/
│   │   ├── models/
│   │   └── services/
│   ├── frontend/
│   │   ├── index.html
│   │   ├── app.js
│   │   └── style.css
│   └── tests/
├── auth/                       # auth.kaut.to
│   ├── Dockerfile
│   ├── README.md
│   ├── app.py
│   └── templates/
├── browser-test/               # test.kaut.to
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── index.html
│   └── toolkit/
└── scripts/                    # Deployment & maintenance
    ├── deploy.sh
    ├── backup.sh
    └── health-check.sh
```

## Benefits

### 1. Unified Management
- Single repository to maintain
- Consistent versioning
- Shared dependencies
- Common CI/CD pipelines

### 2. Code Reuse
- Shared authentication logic
- Common utilities
- Consistent API patterns
- Unified documentation

### 3. Deployment Simplification
- One repository to deploy from
- Atomic deployments possible
- Rollback entire system
- Environment consistency

### 4. Development Efficiency
- Single clone for all apps
- Cross-app refactoring easier
- Shared development environment
- Consistent coding standards

## Migration Plan

### Phase 1: Repository Creation
```bash
# Create new repository
gh repo create jkautto/kaut-apps --private

# Clone and setup
git clone https://github.com/jkautto/kaut-apps.git
cd kaut-apps

# Create structure
mkdir -p {pastebin,tasks,auth,browser-test,shared,scripts}
```

### Phase 2: Pastebin Migration
```bash
# Copy pastebin files
cp -r /srv/apps/pastebin/* ./pastebin/

# Remove old symlinks/references
# Update imports to use shared utilities

# Commit
git add pastebin/
git commit -m "Migrate pastebin app from /srv/apps"
```

### Phase 3: Add New Apps
```bash
# Create tasks app structure
mkdir -p tasks/{backend,frontend,tests}

# Copy existing task files
cp /var/www/kaut.to/tasks/* ./tasks/frontend/

# Develop backend
# ... implementation ...
```

## Deployment Strategy

### Local Development
```bash
# Run all apps locally
./scripts/run-local.sh

# Run specific app
cd pastebin && python3 app.py
```

### Production Deployment
```bash
# Deploy all apps
./scripts/deploy.sh all

# Deploy specific app
./scripts/deploy.sh pastebin

# Health check
./scripts/health-check.sh
```

### Service Management
Each app has its own systemd service:
- `kaut-pastebin.service`
- `kaut-tasks.service`
- `kaut-auth.service`
- `kaut-browser-test.service`

## GitHub Actions

### Automated Deployment
```yaml
# .github/workflows/deploy-all.yml
name: Deploy All Apps
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Deploy to server
        run: |
          ssh joni@kaut.to 'cd /srv/apps && ./update-from-github.sh'
```

## Best Practices

1. **Consistent Structure**: Each app follows same layout
2. **Shared Standards**: Common linting, formatting
3. **Documentation**: Each app has its own README
4. **Testing**: Unified test suite
5. **Versioning**: Semantic versioning for releases

## Future Additions

Planned apps for the monorepo:
- `notes/` - note.kaut.to (simple notes)
- `files/` - files.kaut.to (file manager)
- `api/` - api.kaut.to (unified API gateway)
- `dashboard/` - dash.kaut.to (system dashboard)

---
*This structure provides a scalable foundation for all kaut.to applications*