#!/bin/bash
# Automated MkDocs build script

LOG_FILE="/srv/docs/build.log"
LOCK_FILE="/srv/docs/.build.lock"
DOCS_DIR="/srv/docs"

# Check if build is already running
if [ -f "$LOCK_FILE" ]; then
    echo "[$(date)] Build already in progress, skipping..." >> "$LOG_FILE"
    exit 0
fi

# Create lock file
touch "$LOCK_FILE"

# Function to cleanup on exit
cleanup() {
    rm -f "$LOCK_FILE"
}
trap cleanup EXIT

# Log start time
echo "[$(date)] Starting MkDocs build..." >> "$LOG_FILE"

# Change to docs directory
cd "$DOCS_DIR" || {
    echo "[$(date)] ERROR: Cannot change to $DOCS_DIR" >> "$LOG_FILE"
    exit 1
}

# Activate virtual environment
if [ -f "venv/bin/activate" ]; then
    source venv/bin/activate
else
    echo "[$(date)] ERROR: Virtual environment not found" >> "$LOG_FILE"
    exit 1
fi

# Pull latest changes from git (if available)
if [ -d ".git" ]; then
    echo "[$(date)] Pulling latest changes from git..." >> "$LOG_FILE"
    git pull origin main >> "$LOG_FILE" 2>&1
fi

# Build docs
echo "[$(date)] Building documentation..." >> "$LOG_FILE"
mkdocs build >> "$LOG_FILE" 2>&1

# Check build status
if [ $? -eq 0 ]; then
    echo "[$(date)] Build completed successfully" >> "$LOG_FILE"
    echo "[$(date)] Site updated at https://docs.kaut.to" >> "$LOG_FILE"
else
    echo "[$(date)] Build FAILED - check errors above" >> "$LOG_FILE"
    exit 1
fi

# Log disk usage
echo "[$(date)] Disk usage: $(du -sh site/ | cut -f1)" >> "$LOG_FILE"

# Keep only last 1000 lines of log
tail -1000 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"

echo "[$(date)] Build script completed" >> "$LOG_FILE"
echo "----------------------------------------" >> "$LOG_FILE"