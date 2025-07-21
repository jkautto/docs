# Vite App Deployment Quick Guide

## Common Production Issues

### 1. Blank Screen - No CSS
**Symptom**: App works locally, blank in production
**Cause**: CSS files not imported in JavaScript
**Fix**: 
```javascript
// In src/main.js or entry point
import './styles/main.css';
import './styles/component.css';
// Import ALL your CSS files
```

### 2. Wrong Nginx Path
**Symptom**: 404 errors, assets not loading
**Cause**: Nginx serving from wrong directory
**Fix**:
```nginx
# Serve from dist directory
location /app-name/ {
    alias /var/www/kaut.to/app-name/dist/;
    try_files $uri $uri/ /app-name/index.html;
}
```

### 3. Build Not Updated
**Symptom**: Changes don't appear
**Fix**:
```bash
npm run build
sudo cp -r dist/* /var/www/kaut.to/app-name/
```

## Quick Deployment Checklist

1. **Import all CSS in JavaScript**
2. **Run build**: `npm run build`
3. **Check dist output**: `ls -la dist/`
4. **Deploy to correct path**
5. **Verify nginx config**
6. **Test in browser**

## Debug Commands

```bash
# What's being served?
ls -la /var/www/kaut.to/APP_NAME/

# Check nginx errors
sudo tail -f /var/log/nginx/error.log

# Test locally first
npm run build && npm run preview
```