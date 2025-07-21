# JTools Testing Toolkit Guide

The JTools Testing Toolkit provides a unified testing framework for all jtools components, supporting multiple programming languages and test types.

## Overview

The testing toolkit allows you to:

- Write and run tests in Python, JavaScript, and Bash
- Test CLI tools, web applications, and APIs
- Generate comprehensive test reports
- Run browser automation tests
- Integrate with CI/CD pipelines

## Installation

### Prerequisites

```bash
# Python testing
pip install pytest

# JavaScript/Browser testing
npm install -D @playwright/test
npx playwright install chromium

# Bash testing
sudo apt-get install bats  # Ubuntu/Debian
brew install bats-core     # macOS
```

### Quick Setup

The toolkit is already installed in `/srv/jtools/test/`. To use it:

```bash
# Add to PATH (optional)
export PATH="/srv/jtools:$PATH"

# Or use directly
/srv/jtools/jtest
```

## Basic Usage

### Running All Tests

```bash
# Run all tests across all frameworks
jtest

# Output example:
🐍 Running Python tests...
🌐 Running JavaScript/Browser tests...
🔧 Running Bash tests...

✨ Test Summary:
   Total: 15
   ✅ Passed: 14
   ❌ Failed: 1
   ⏱️  Duration: 23.45s
```

### Running Specific Test Types

```bash
# Python tests only
jtest --python

# JavaScript tests only
jtest --javascript

# Bash tests only
jtest --bash

# Specific test file
jtest --python test_perplexity.py
jtest --javascript shifts.spec.js
```

## Writing Tests

### Python Tests (PyTest)

Create a test file with `test_` prefix:

```python
# test_my_tool.py
import pytest
from my_tool import process_data

def test_basic_functionality():
    """Test basic data processing"""
    result = process_data("input")
    assert result == "expected_output"

@pytest.mark.integration
def test_api_integration():
    """Test external API integration"""
    # Test code here
    pass

@pytest.mark.slow
def test_large_dataset():
    """Test with large dataset (marked as slow)"""
    # Test code here
    pass
```

Run with markers:

```bash
# Skip slow tests
jtest --python -m "not slow"

# Only integration tests
jtest --python -m integration
```

### JavaScript/Browser Tests (Playwright)

Create a test file with `.spec.js` suffix:

```javascript
// app.spec.js
const { test, expect } = require('@playwright/test');

test.describe('My Web App', () => {
  test('should load homepage', async ({ page }) => {
    await page.goto('https://kaut.to/myapp/');
    await expect(page.locator('h1')).toContainText('Welcome');
  });

  test('should handle form submission', async ({ page }) => {
    await page.goto('https://kaut.to/myapp/');
    await page.fill('#name', 'Test User');
    await page.click('button[type="submit"]');
    await expect(page.locator('.success')).toBeVisible();
  });

  test('should capture screenshot on failure', async ({ page }) => {
    await page.goto('https://kaut.to/myapp/');
    // This will fail and capture screenshot
    await expect(page.locator('#nonexistent')).toBeVisible();
  });
});
```

### Bash Tests (BATS)

Create a test file with `.bats` extension:

```bash
#!/usr/bin/env bats

load test/frameworks/bash/setup.bash

@test "tool exists and is executable" {
    assert_file_exists "$JTOOLS_DIR/mytool"
    [[ -x "$JTOOLS_DIR/mytool" ]]
}

@test "tool shows help message" {
    run_jtool "mytool" --help
    assert_success
    assert_output_contains "Usage:"
}

@test "tool processes input correctly" {
    echo "test data" > input.txt
    run_jtool "mytool" process input.txt
    assert_success
    assert_file_exists "output.txt"
    assert_file_contains "output.txt" "processed"
}

@test "tool handles errors gracefully" {
    run_jtool "mytool" process nonexistent.txt
    assert_failure
    assert_output_contains "Error"
}
```

## Test Organization

### Directory Structure

```
/srv/jtools/
├── mytool/
│   ├── mytool.py          # Tool implementation
│   └── test_mytool.py     # Python tests
├── webapp/
│   ├── index.html         # Web app
│   └── webapp.spec.js     # Browser tests
└── scripts/
    ├── deploy.sh          # Bash script
    └── test_deploy.bats   # Bash tests
```

### Best Practices

1. **Keep tests close to code** - Place test files next to the code they test
2. **Use descriptive names** - Test names should explain what they verify
3. **One assertion per test** - Makes failures easier to diagnose
4. **Use fixtures** - Share common setup code
5. **Mock external dependencies** - Tests should be reliable and fast

## Advanced Features

### Custom Fixtures (Python)

```python
# conftest.py
import pytest

@pytest.fixture
def api_client():
    """Provide configured API client"""
    from my_api import Client
    return Client(base_url="http://localhost:8000")

@pytest.fixture
def sample_data():
    """Provide sample test data"""
    return {
        "users": ["alice", "bob"],
        "projects": ["alpha", "beta"]
    }

# test_api.py
def test_user_endpoint(api_client, sample_data):
    response = api_client.get_users()
    assert response.users == sample_data["users"]
```

### Browser Context (Playwright)

```javascript
// Advanced browser testing
test.describe('Authenticated Tests', () => {
  test.use({
    storageState: 'auth.json',  // Reuse authentication
    viewport: { width: 1280, height: 720 },
    locale: 'en-US',
  });

  test('should access protected page', async ({ page }) => {
    await page.goto('https://kaut.to/protected/');
    await expect(page.locator('.user-profile')).toBeVisible();
  });
});

// Visual regression testing
test('visual comparison', async ({ page }) => {
    await page.goto('https://kaut.to/myapp/');
    await expect(page).toHaveScreenshot('homepage.png');
});
```

### BATS Helpers

```bash
# Custom helper functions
setup_test_repo() {
    git init test_repo
    cd test_repo
    echo "# Test" > README.md
    git add README.md
    git commit -m "Initial commit"
}

@test "git operations" {
    setup_test_repo
    
    run_jtool "git-helper" status
    assert_success
    assert_output_contains "On branch main"
}
```

## Test Reports

### JSON Reports

Test results are automatically saved as JSON:

```bash
# Reports location
/srv/jtools/test/reports/test-report-YYYYMMDD-HHMMSS.json
```

### HTML Reports

Generate beautiful HTML reports:

```bash
# Generate HTML from latest test run
cd /srv/jtools/test
python3 reporters/html/generate_report.py reports/latest.json

# Open in browser
open reports/report-*.html
```

### CI/CD Integration

```yaml
# GitHub Actions example
name: Test Suite
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
      - uses: actions/setup-node@v3
      
      - name: Install dependencies
        run: |
          pip install pytest
          npm install -D @playwright/test
          npx playwright install
          
      - name: Run tests
        run: /srv/jtools/jtest
        
      - name: Upload test results
        uses: actions/upload-artifact@v3
        with:
          name: test-results
          path: test/reports/
```

## Debugging Failed Tests

### Python Debugging

```bash
# Run with debugger
pytest --pdb test_mytool.py

# Verbose output
jtest --python -- -vv

# Show local variables on failure
jtest --python -- --showlocals
```

### Playwright Debugging

```bash
# Run in headed mode (see browser)
npx playwright test --headed

# Debug mode (opens Playwright Inspector)
npx playwright test --debug

# Slow motion
npx playwright test --slow-mo=1000
```

### BATS Debugging

```bash
# Verbose output
bats -v test_script.bats

# TAP format for better parsing
bats -t test_script.bats
```

## Common Patterns

### Testing CLI Tools

```python
# test_cli.py
import subprocess

def test_cli_help():
    result = subprocess.run(
        ["python3", "mytool.py", "--help"],
        capture_output=True,
        text=True
    )
    assert result.returncode == 0
    assert "Usage:" in result.stdout
```

### Testing APIs

```javascript
// api.spec.js
test('API endpoint returns data', async ({ request }) => {
    const response = await request.get('/api/data');
    expect(response.ok()).toBeTruthy();
    
    const data = await response.json();
    expect(data).toHaveProperty('items');
    expect(data.items).toHaveLength(10);
});
```

### Testing File Operations

```bash
# test_files.bats
@test "creates output file" {
    run_jtool "processor" input.txt output.txt
    assert_success
    assert_file_exists "output.txt"
    
    # Check file content
    run cat output.txt
    assert_output_contains "Processed"
}
```

## Troubleshooting

### Common Issues

**Tests not found:**
```bash
# Check test discovery
pytest --collect-only
npx playwright test --list
```

**Import errors in Python:**
```python
# Add to conftest.py
import sys
sys.path.insert(0, '/srv/jtools')
```

**Authentication issues in browser tests:**
```javascript
// Save auth state
npx playwright codegen --save-storage=auth.json
```

**BATS not found:**
```bash
# Install BATS
git clone https://github.com/bats-core/bats-core.git
cd bats-core
./install.sh /usr/local
```

## Best Practices Summary

1. **Fast Tests**: Keep unit tests under 100ms
2. **Isolated Tests**: Each test should be independent
3. **Clear Names**: `test_should_process_valid_input_correctly`
4. **Arrange-Act-Assert**: Structure tests clearly
5. **Continuous Testing**: Run tests before committing
6. **Test Documentation**: Document complex test scenarios
7. **Regular Cleanup**: Remove obsolete tests

## Next Steps

- [Read the full specification](/specs/jtools-testing-toolkit/)
- [View example tests](https://github.com/jkautto/jtools/tree/main/test/examples)
- [Set up CI/CD integration](/guides/ci-cd-setup/)
- [Learn about performance testing](/guides/performance-testing/)