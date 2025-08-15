# Search Tool - Perplexity AI Integration

The search tool provides powerful web search capabilities through Perplexity AI, enabling your local Claude Code to access real-time information beyond its training data.

## Overview

The search tool integrates with the existing px.py Perplexity search implementation, providing multiple search modes and intelligent caching.

## Available Methods

### 1. Perplexity Search

General-purpose search with multiple modes.

**Endpoint**: `POST /tools/search/perplexity`

**Parameters**:
- `query` (required): Search query string
- `mode` (optional): Search mode - `quick` (default), `detailed`, `academic`, `news`
- `max_results` (optional): Maximum number of results (default: 5)

**Example**:
```json
{
  "query": "latest AI developments 2025",
  "mode": "detailed"
}
```

### 2. Web Search

Web search with optional filters for site-specific searches.

**Endpoint**: `POST /tools/search/web`

**Parameters**:
- `query` (required): Search query
- `filters` (optional): Filter object
  - `site`: Limit to specific domain
  - `filetype`: File type filter
  - `intitle`: Title search
  - `after`: Date filter

**Example**:
```json
{
  "query": "FastAPI tutorial",
  "filters": {
    "site": "github.com",
    "filetype": "md"
  }
}
```

### 3. Code Search

Specialized search for code examples and implementations.

**Endpoint**: `POST /tools/search/code`

**Parameters**:
- `query` (required): Code search query
- `language` (optional): Programming language filter

**Features**:
- Automatically searches GitHub, StackOverflow, and dev.to
- Extracts code blocks from results
- Language-specific optimization

**Example**:
```json
{
  "query": "async websocket server",
  "language": "python"
}
```

### 4. News Search

Search for recent news and updates.

**Endpoint**: `POST /tools/search/news`

**Parameters**:
- `query` (required): News topic
- `timeframe` (optional): Time period - `day`, `week` (default), `month`

**Example**:
```json
{
  "query": "artificial intelligence regulation",
  "timeframe": "week"
}
```

### 5. Research

Deep research with multiple related queries.

**Endpoint**: `POST /tools/search/research`

**Parameters**:
- `topic` (required): Research topic
- `depth` (optional): Research depth - `quick`, `standard` (default), `deep`

**Depth Levels**:
- `quick`: Single query, fast results
- `standard`: Main topic + comprehensive guide
- `deep`: Multiple queries covering overview, developments, best practices, challenges

**Example**:
```json
{
  "topic": "quantum error correction",
  "depth": "deep"
}
```

### 6. Cache Status

Check search cache information.

**Endpoint**: `POST /tools/search/cache_status`

**Returns**:
- Cache file count
- Cache size
- Recent searches

### 7. Clear Cache

Clear cached search results.

**Endpoint**: `POST /tools/search/clear_cache`

**Parameters**:
- `older_than_days` (optional): Only clear cache older than N days

## Response Format

All search methods return a structured response:

```json
{
  "status": "success",
  "query": "original query",
  "content": "full search results",
  "sections": {
    "summary": "brief summary",
    "key_points": ["point 1", "point 2"],
    "sources": ["url1", "url2"],
    "details": "detailed content"
  },
  "timestamp": "2025-01-13T...",
  "cached": false
}
```

## Claude Usage Examples

### Basic Search
```
You: Search for information about Docker best practices
Claude: [Uses search tool to query Perplexity]
```

### Code Search
```
You: Find Python examples of async database connections
Claude: [Uses code search with Python language filter]
```

### News Search
```
You: What's the latest news about SpaceX?
Claude: [Uses news search with week timeframe]
```

### Deep Research
```
You: Do comprehensive research on transformer architectures
Claude: [Uses research with deep depth]
```

## Features

### Intelligent Caching
- Results are cached to reduce API calls
- Cache stored in `/srv/jtools/px/.cache/`
- Automatic cache management

### Source Attribution
- All results include source URLs
- Numbered references for credibility
- Direct links to original content

### Code Extraction
- Automatically identifies code blocks
- Preserves language markers
- Formats for readability

## Integration Benefits

1. **Real-time Information**: Access current data beyond training cutoff
2. **Verified Sources**: All information includes source attribution
3. **Specialized Modes**: Optimized for different search types
4. **Efficient Caching**: Reduces redundant API calls
5. **Structured Results**: Consistent, parseable response format

## Troubleshooting

### Search Timeout
- Default timeout: 30 seconds
- Complex searches may take longer
- Consider using `quick` mode for faster results

### No Results
- Check query spelling
- Try broader search terms
- Verify network connectivity

### Cache Issues
- Use `clear_cache` to reset
- Check disk space in `/srv/jtools/px/`

## Technical Details

- **Backend**: px.py (Perplexity AI integration)
- **Location**: `/srv/jtools/px/`
- **Cache**: JSON files in `.cache/` directory
- **Timeout**: 30 seconds per search
- **Rate Limiting**: Handled by px.py

---

*Search tool added to MCP Server v1.0.0*
*Powered by Perplexity AI*

---
*Last updated: 2025-08-13 13:23:17 via MCP*