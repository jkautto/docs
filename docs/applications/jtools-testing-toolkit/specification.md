# JTools Testing Toolkit v0.1 Specification

**Version**: 0.1  
**Date**: 2025-07-18  
**Status**: ✅ Implemented

## Executive Summary

A unified testing toolkit for the jtools ecosystem that supports multi-language testing (Python, JavaScript, Bash), headless browser automation, and comprehensive reporting. Built for AI-first development with simple, composable commands.

## Goals

1. **Unified Testing**: One toolkit for all jtools components
2. **Multi-Language Support**: Python, JavaScript, Bash testing
3. **Headless Browser Testing**: For web applications
4. **AI-Friendly**: Simple commands, clear output
5. **Fast Feedback**: Fail fast, clear error messages
6. **Visual Reporting**: HTML reports with screenshots

## Architecture

```
/srv/jtools/test/
├── bin/                    # Test runner executables
│   ├── jtest              # Main test runner
│   └── jtest-report       # Report generator
├── frameworks/            # Language-specific frameworks
│   ├── python/           # PyTest setup
│   ├── javascript/       # Playwright setup
│   └── bash/             # BATS setup
├── reporters/            # Report generators
│   ├── allure/          # Allure integration
│   └── html/            # Simple HTML reports
├── fixtures/            # Shared test fixtures
└── examples/            # Example tests
```

## Core Components

### 1. Test Runner (`jtest`)

Single entry point for all testing:

```bash
# Run all tests
jtest

# Run specific language tests
jtest --python
jtest --javascript
jtest --bash

# Run specific test file
jtest tests/api_test.py
jtest tests/ui_test.js

# Run with reporting
jtest --report html
jtest --report allure
```

### 2. Language Support

#### Python Testing (PyTest)
- **Framework**: PyTest
- **Features**: 
  - API testing
  - Unit testing
  - Integration testing
- **Plugins**: pytest-html, allure-pytest

```python
# Example test
def test_api_endpoint():
    response = requests.get("http://localhost:8002/api/health")
    assert response.status_code == 200
```

#### JavaScript Testing (Playwright)
- **Framework**: Playwright
- **Features**:
  - Headless browser testing
  - Visual regression testing
  - Cross-browser support
- **Reporters**: allure-playwright, html

```javascript
// Example test
test('homepage loads', async ({ page }) => {
  await page.goto('https://kaut.to');
  await expect(page).toHaveTitle(/Kaut.to/);
});
```

#### Bash Testing (BATS)
- **Framework**: BATS (Bash Automated Testing System)
- **Features**:
  - Script testing
  - Command testing
  - Environment testing

```bash
# Example test
@test "px.py exists and is executable" {
  [ -x "/srv/jtools/px.py" ]
}
```

### 3. Headless Browser Testing

Using Playwright for its speed and reliability:

```javascript
// Visual regression test
test('shifts app visual test', async ({ page }) => {
  await page.goto('https://kaut.to/shifts/');
  await expect(page).toHaveScreenshot('shifts-homepage.png');
});

// Interaction test
test('save functionality', async ({ page }) => {
  await page.goto('https://kaut.to/shifts/');
  await page.click('[data-shift="W"]');
  await page.click('.day-cell:first-child');
  await page.click('#saveBtn');
  // Verify save worked
});
```

### 4. Reporting

#### Allure Reports (Primary)
- Interactive HTML reports
- Test history tracking
- Screenshots and logs
- Failure analysis

#### Simple HTML Reports (Fallback)
- Basic pass/fail summary
- Quick to generate
- No dependencies

### 5. CI/CD Integration

```yaml
# GitHub Actions example
- name: Run jtools tests
  run: |
    cd /srv/jtools
    ./test/bin/jtest --report allure
    
- name: Upload test results
  uses: actions/upload-artifact@v3
  with:
    name: test-results
    path: test-results/
```

## Implementation Plan

### Phase 1: Core Infrastructure (Week 1)
- [ ] Create directory structure
- [ ] Implement `jtest` runner script
- [ ] Set up PyTest for Python tests
- [ ] Basic HTML reporting

### Phase 2: Browser Testing (Week 2)
- [ ] Install and configure Playwright
- [ ] Create browser test examples
- [ ] Visual regression setup
- [ ] Screenshot comparison

### Phase 3: Integration (Week 3)
- [ ] BATS for bash testing
- [ ] Allure reporting
- [ ] CI/CD templates
- [ ] Documentation

### Phase 4: Advanced Features (Week 4)
- [ ] Test orchestration
- [ ] Parallel execution
- [ ] Test data management
- [ ] Performance metrics

## Usage Examples

### Testing a Web App (Shifts)
```bash
# Run all shifts tests
jtest apps/shifts/

# Run visual regression tests
jtest apps/shifts/visual --compare-baseline

# Debug failed test
jtest apps/shifts/test_save.js --headed --slowmo 500
```

### Testing an API
```bash
# Test all endpoints
jtest api/

# Test with coverage
jtest api/ --coverage

# Generate report
jtest api/ --report allure
```

### Testing CLI Tools
```bash
# Test px.py
jtest tools/px/

# Test with different Python versions
jtest tools/px/ --python 3.8,3.9,3.10
```

## Success Metrics

1. **Coverage**: 80%+ code coverage across jtools
2. **Speed**: Full test suite runs in < 5 minutes
3. **Reliability**: < 1% flaky tests
4. **Adoption**: All new features have tests

## Dependencies

```json
{
  "python": {
    "pytest": "^7.4.0",
    "pytest-html": "^4.1.0",
    "allure-pytest": "^2.13.0",
    "requests": "^2.31.0"
  },
  "javascript": {
    "@playwright/test": "^1.40.0",
    "allure-playwright": "^2.13.0"
  },
  "bash": {
    "bats-core": "^1.10.0",
    "bats-assert": "^2.0.0"
  }
}
```

## Future Enhancements (v0.2+)

1. **AI-Powered Testing**: Auto-generate tests from specs
2. **Load Testing**: Performance testing capabilities
3. **Security Testing**: Basic security scans
4. **Mobile Testing**: Mobile browser support
5. **Test Data Factory**: Synthetic data generation

## Notes

- Start simple, iterate based on usage
- Focus on developer experience
- Optimize for AI agents (clear output, simple commands)
- Maintain backwards compatibility

---

*This toolkit will make testing jtools components systematic, reliable, and fast.*