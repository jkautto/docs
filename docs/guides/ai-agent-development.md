# AI Agent Development Guide

Technical reference for AI agents developing in the kaut.to ecosystem.

## Development Philosophy

### Context Window Optimization

Design systems that fit within AI context windows:

1. **Modular Files**: Keep files under 200 lines
2. **Clear Boundaries**: One concept per file
3. **Self-Contained**: Minimize cross-file dependencies
4. **Descriptive Names**: File names should explain purpose

### Example: Modular Architecture

```
shifts/
├── src/
│   ├── main.js                 # Entry point (< 50 lines)
│   ├── config/
│   │   └── index.js           # Configuration (< 100 lines)
│   ├── components/
│   │   ├── Schedule/
│   │   │   ├── index.js       # Public API
│   │   │   ├── Schedule.js    # Main component (< 200 lines)
│   │   │   ├── PersonRow.js   # Sub-component
│   │   │   └── utils.js       # Helper functions
│   │   └── Controls/
│   │       └── index.js       # Control panel
│   └── services/
│       ├── storage.js         # Data persistence
│       └── export.js          # Export functionality
```

## Code Patterns for AI

### 1. Entry Point Pattern

Keep main files minimal:

```javascript
// main.js - Application entry point
import { App } from './app/App.js';
import { config } from './config/index.js';

// Initialize application
const app = new App(config);
app.start();

// Export for debugging
window.app = app;
```

### 2. Service Pattern

Encapsulate functionality:

```javascript
// services/storage.js
export const storageService = {
  async save(data) {
    // Single responsibility: save data
  },
  
  async load() {
    // Single responsibility: load data
  },
  
  async clear() {
    // Single responsibility: clear data
  }
};
```

### 3. Component Pattern

Self-contained UI components:

```javascript
// components/Schedule/Schedule.js
export class Schedule {
  constructor(options) {
    this.container = options.container;
    this.data = options.data;
    this.onCellChange = options.onCellChange;
  }
  
  render() {
    // Only handles rendering
  }
  
  bindEvents() {
    // Only handles events
  }
}
```

### 4. Configuration Pattern

Centralized settings:

```javascript
// config/index.js
export const config = {
  api: {
    baseUrl: process.env.API_URL || 'http://localhost:8003',
    timeout: 5000
  },
  storage: {
    key: 'app_data_v1',
    version: 1
  },
  ui: {
    theme: 'light',
    animations: true
  }
};
```

## Testing Strategies

### 1. Test File Organization

Mirror source structure:

```
src/
├── components/Schedule/Schedule.js
└── services/storage.js

tests/
├── components/Schedule/Schedule.test.js
└── services/storage.test.js
```

### 2. Test Patterns

**Unit Test Example:**
```javascript
// Schedule.test.js
import { Schedule } from '../../src/components/Schedule/Schedule.js';

describe('Schedule Component', () => {
  test('renders with correct number of cells', () => {
    const schedule = new Schedule({
      container: document.createElement('div'),
      data: mockData
    });
    
    schedule.render();
    const cells = schedule.container.querySelectorAll('.day-cell');
    expect(cells.length).toBe(825); // 11 employees × 75 days
  });
});
```

**Integration Test Example:**
```javascript
// save-flow.spec.js
test('complete save workflow', async ({ page }) => {
  // 1. Navigate
  await page.goto('https://kaut.to/shifts/');
  
  // 2. Make change
  await page.click('.day-cell:first-child');
  
  // 3. Save
  await page.click('button:has-text("Save")');
  
  // 4. Verify persistence
  await page.reload();
  const cell = page.locator('.day-cell:first-child');
  await expect(cell).toHaveClass(/status-W/);
});
```

### 3. Test-Driven Development

1. Write test first:
```javascript
test('should validate email format', () => {
  expect(isValidEmail('user@example.com')).toBe(true);
  expect(isValidEmail('invalid')).toBe(false);
});
```

2. Implement minimal code:
```javascript
function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}
```

3. Refactor if needed

## Debugging Techniques

### 1. Strategic Logging

```javascript
// Use console groups for clarity
console.group('Data Loading');
console.log('Fetching from:', url);
console.log('Response:', response);
console.groupEnd();

// Use console.table for data
console.table(scheduleData);

// Use console.time for performance
console.time('render');
renderSchedule();
console.timeEnd('render');
```

### 2. Error Boundaries

```javascript
class ErrorBoundary {
  constructor(container) {
    this.container = container;
  }
  
  try(fn, fallback) {
    try {
      return fn();
    } catch (error) {
      console.error('Error caught:', error);
      this.showError(error);
      if (fallback) fallback(error);
    }
  }
  
  showError(error) {
    this.container.innerHTML = `
      <div class="error-message">
        <h3>Something went wrong</h3>
        <p>${error.message}</p>
      </div>
    `;
  }
}
```

### 3. Development Helpers

```javascript
// Add debug mode
if (window.location.search.includes('debug=true')) {
  window.DEBUG = true;
  window.app = app;  // Expose for console access
  
  // Enhanced logging
  const originalLog = console.log;
  console.log = (...args) => {
    originalLog(new Date().toISOString(), ...args);
  };
}
```

## Performance Optimization

### 1. Lazy Loading

```javascript
// Only load when needed
async function loadFeature() {
  const { AdvancedFeature } = await import('./features/Advanced.js');
  return new AdvancedFeature();
}
```

### 2. Debouncing

```javascript
function debounce(fn, delay = 300) {
  let timeoutId;
  return (...args) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => fn(...args), delay);
  };
}

// Usage
const saveDebounced = debounce(saveData, 1000);
input.addEventListener('input', saveDebounced);
```

### 3. Virtual Scrolling

For large lists:
```javascript
class VirtualList {
  constructor(container, items, rowHeight) {
    this.container = container;
    this.items = items;
    this.rowHeight = rowHeight;
    this.render();
  }
  
  render() {
    const scrollTop = this.container.scrollTop;
    const containerHeight = this.container.clientHeight;
    
    const startIndex = Math.floor(scrollTop / this.rowHeight);
    const endIndex = Math.ceil((scrollTop + containerHeight) / this.rowHeight);
    
    const visibleItems = this.items.slice(startIndex, endIndex);
    // Render only visible items
  }
}
```

## Security Best Practices

### 1. Input Validation

```javascript
// Always validate user input
function sanitizeInput(input) {
  // Remove potential XSS
  return input
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27;');
}

// Validate data types
function validateScheduleData(data) {
  if (typeof data !== 'object') return false;
  
  return Object.entries(data).every(([name, shifts]) => {
    return typeof name === 'string' && 
           Array.isArray(shifts) &&
           shifts.every(shift => ['W', 'R', 'X', 'O'].includes(shift));
  });
}
```

### 2. Secure API Calls

```javascript
// services/api.js
async function authenticatedFetch(url, options = {}) {
  const response = await fetch(url, {
    ...options,
    headers: {
      ...options.headers,
      'Authorization': `Bearer ${getToken()}`,
      'Content-Type': 'application/json'
    },
    credentials: 'include'  // Include cookies
  });
  
  if (!response.ok) {
    throw new Error(`API error: ${response.status}`);
  }
  
  return response.json();
}
```

### 3. Environment Variables

Never hardcode secrets:
```javascript
// config/index.js
export const config = {
  api: {
    key: process.env.API_KEY,  // From .env file
    url: process.env.API_URL || 'http://localhost:8000'
  }
};

// .env.example (commit this)
API_KEY=your_api_key_here
API_URL=https://api.example.com

// .env (never commit)
API_KEY=actual_secret_key
API_URL=https://api.production.com
```

## Documentation Standards

### 1. JSDoc Comments

```javascript
/**
 * Processes schedule data for display
 * 
 * @param {Object} rawData - Raw schedule data from API
 * @param {string} rawData.date - ISO date string
 * @param {Array<Object>} rawData.shifts - Array of shift objects
 * @returns {Object} Processed data ready for rendering
 * @throws {ValidationError} If data format is invalid
 * 
 * @example
 * const processed = processScheduleData({
 *   date: '2025-07-18',
 *   shifts: [{ person: 'Alice', type: 'W' }]
 * });
 */
function processScheduleData(rawData) {
  // Implementation
}
```

### 2. README Structure

Every project needs:
```markdown
# Project Name

Brief description of what this does.

## Quick Start

\```bash
npm install
npm run dev
\```

## Architecture

Describe the main components and how they interact.

## API Reference

### Endpoints

- `GET /api/resource` - Get all resources
- `POST /api/resource` - Create new resource

## Testing

\```bash
npm test
\```

## Deployment

\```bash
npm run build
npm run deploy
\```

## Contributing

See [AI Agent Guide](https://docs.kaut.to/guides/ai-agent-onboarding/)
```

### 3. Inline Documentation

```javascript
// services/storage.js

/**
 * Storage Service
 * 
 * Handles all data persistence with automatic fallback:
 * 1. Try backend API first
 * 2. Fall back to localStorage if API fails
 * 3. Memory cache for performance
 */
export const storageService = {
  cache: new Map(),
  
  async save(key, data) {
    // Cache immediately for optimistic updates
    this.cache.set(key, data);
    
    try {
      // Attempt backend save
      await api.save(key, data);
    } catch (error) {
      // Fallback to localStorage
      console.warn('Backend save failed, using localStorage:', error);
      localStorage.setItem(key, JSON.stringify(data));
    }
  }
};
```

## Tool Integration

### 1. Using px.py for Research

```bash
# Research before implementing
cd /srv/jtools/px
python3 px.py "JavaScript event delegation best practices"
python3 px.py "How to implement undo/redo in web app"
python3 px.py "CORS error fixes for local development"
```

### 2. Continuous Testing

```bash
# Run tests in watch mode
npx jest --watch

# Or use our test runner
watch -n 5 /srv/jtools/jtest

# Test specific features
/srv/jtools/jtest --javascript keyboard.spec.js
```

### 3. Performance Monitoring

```javascript
// Add performance marks
performance.mark('render-start');
render();
performance.mark('render-end');

performance.measure('render', 'render-start', 'render-end');

// Log performance
const entries = performance.getEntriesByType('measure');
console.table(entries);
```

## Common Patterns Library

### State Management
```javascript
class StateManager {
  constructor(initialState = {}) {
    this.state = initialState;
    this.listeners = [];
  }
  
  subscribe(listener) {
    this.listeners.push(listener);
    return () => this.listeners = this.listeners.filter(l => l !== listener);
  }
  
  setState(updates) {
    this.state = { ...this.state, ...updates };
    this.listeners.forEach(listener => listener(this.state));
  }
}
```

### Event Bus
```javascript
class EventBus {
  constructor() {
    this.events = {};
  }
  
  on(event, handler) {
    if (!this.events[event]) this.events[event] = [];
    this.events[event].push(handler);
  }
  
  emit(event, data) {
    if (!this.events[event]) return;
    this.events[event].forEach(handler => handler(data));
  }
}
```

### API Client
```javascript
class APIClient {
  constructor(baseURL) {
    this.baseURL = baseURL;
  }
  
  async request(endpoint, options = {}) {
    const url = `${this.baseURL}${endpoint}`;
    const response = await fetch(url, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...options.headers
      }
    });
    
    if (!response.ok) {
      throw new Error(`API Error: ${response.status}`);
    }
    
    return response.json();
  }
}
```

## Next Steps

1. Review the [Testing Guide](/guides/jtools-testing/)
2. Study existing codebases for patterns
3. Practice modular development
4. Contribute to open issues

Remember: The goal is to write code that other AI agents can easily understand, modify, and extend. Keep it simple, modular, and well-documented.