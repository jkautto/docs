# JTools Testing Toolkit

## Overview

The JTools Testing Toolkit is a unified testing framework that enables comprehensive testing across the entire jtools ecosystem. It supports multiple programming languages and test types through a single, consistent interface.

**Status**: ✅ Active (v0.1)  
**Repository**: [github.com/jkautto/jtools](https://github.com/jkautto/jtools/tree/main/test)  
**Location**: `/srv/jtools/test/`  
**Command**: `jtest`

## Features

- **Multi-Language Support**: Python (PyTest), JavaScript (Playwright), Bash (BATS)
- **Unified Runner**: Single command interface for all test types
- **Browser Testing**: Headless browser automation with Playwright
- **HTML Reports**: Beautiful, shareable test reports
- **AI-Friendly**: Clear output optimized for AI interpretation
- **Fast Feedback**: Fail-fast approach with detailed error messages

## Quick Start

```bash
# Run all tests
/srv/jtools/jtest

# Run specific language tests
/srv/jtools/jtest --python
/srv/jtools/jtest --javascript
/srv/jtools/jtest --bash

# Run specific test file
/srv/jtools/jtest --python test_perplexity.py
```

## Architecture

```
/srv/jtools/test/
├── bin/
│   └── jtest              # Main test runner
├── frameworks/
│   ├── python/           # PyTest configuration
│   ├── javascript/       # Playwright configuration
│   └── bash/             # BATS helpers
├── reporters/
│   └── html/             # HTML report generator
├── examples/             # Example tests
└── reports/              # Test results
```

## Component Details

### Test Runner (`jtest`)

The main test runner is a Python script that orchestrates test execution across all frameworks:

- Detects and runs tests based on file patterns
- Captures output from each framework
- Generates unified JSON reports
- Provides summary statistics

### Framework Configurations

#### Python (PyTest)
- **Config**: `test/frameworks/python/pytest.ini`
- **Features**: Fixtures, markers, parametrization
- **File Pattern**: `test_*.py`, `*_test.py`

#### JavaScript (Playwright)
- **Config**: `test/frameworks/javascript/playwright.config.js`
- **Features**: Browser automation, visual testing, API testing
- **File Pattern**: `*.spec.js`

#### Bash (BATS)
- **Config**: `test/frameworks/bash/setup.bash`
- **Features**: Command-line testing, file operations
- **File Pattern**: `*.bats`

### Reporting

Reports are generated in two formats:

1. **JSON**: Machine-readable test results
2. **HTML**: Human-readable reports with charts and details

## Integration Points

### With Other JTools

- **jcommit**: Validates commit messages
- **px (Perplexity)**: Tests API integration
- **ft (Fetch)**: Tests web scraping functionality
- **gtask**: Tests Google Tasks integration

### With Web Applications

- **Shifts App**: Full E2E testing
- **PAI Dashboard**: UI automation tests
- **Pastebin**: API and UI testing

## Development Workflow

### 1. Write Tests

```python
# Python example
def test_feature():
    result = my_function()
    assert result == expected
```

```javascript
// JavaScript example
test('feature works', async ({ page }) => {
    await page.goto('/');
    await expect(page.locator('h1')).toBeVisible();
});
```

```bash
# Bash example
@test "feature works" {
    run my_command
    assert_success
}
```

### 2. Run Tests

```bash
# During development
jtest --python test_my_feature.py

# Before committing
jtest
```

### 3. Review Reports

```bash
# Generate HTML report
python3 test/reporters/html/generate_report.py test/reports/latest.json

# Open in browser
open test/reports/report-*.html
```

## Configuration

### Environment Variables

```bash
# Test configuration
export JTEST_TIMEOUT=60        # Test timeout in seconds
export JTEST_PARALLEL=4        # Number of parallel workers
export JTEST_VERBOSE=true      # Verbose output
```

### Custom Markers

```python
# pytest.ini
[pytest]
markers =
    slow: marks tests as slow
    integration: integration tests
    unit: unit tests
    smoke: smoke tests
```

## Troubleshooting

### Common Issues

**Dependencies not installed:**
```bash
pip install pytest
npm install -D @playwright/test
sudo apt-get install bats
```

**Tests not discovered:**
```bash
# Check Python path
python3 -c "import sys; print(sys.path)"

# Check test patterns
jtest --list
```

**Browser tests failing:**
```bash
# Install browsers
npx playwright install

# Run with headed mode
npx playwright test --headed
```

## Best Practices

1. **Test Naming**: Use descriptive names that explain what's being tested
2. **Test Independence**: Tests should not depend on each other
3. **Fast Tests**: Keep unit tests under 100ms
4. **Clear Assertions**: One logical assertion per test
5. **Proper Cleanup**: Always clean up test artifacts

## Maintenance

### Regular Tasks

- Update test dependencies monthly
- Review and remove obsolete tests
- Update browser versions for Playwright
- Archive old test reports

### Health Checks

```bash
# Check test coverage
pytest --cov=jtools

# Find slow tests
jtest --profile

# Validate test structure
jtest --validate
```

## Future Enhancements

- [ ] Coverage reporting integration
- [ ] Performance benchmarking
- [ ] Mutation testing support
- [ ] Distributed test execution
- [ ] Integration with GitHub Actions

## Related Documentation

- [Testing Guide](/guides/jtools-testing/)
- [Testing Specification](/specs/jtools-testing-toolkit/)
- [Browser Testing Guide](/guides/browser-testing/)
- [CI/CD Integration](/guides/ci-cd-setup/)