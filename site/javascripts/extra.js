// Custom JavaScript for DAI/PAI Documentation

// Add copy button to code blocks
document.addEventListener('DOMContentLoaded', function() {
    // Code block copy functionality is handled by Material theme
    
    // Add AI-friendly metadata
    const meta = document.createElement('meta');
    meta.name = 'ai-accessible';
    meta.content = 'true';
    document.head.appendChild(meta);
    
    // Log page views for analytics (if needed)
    console.log('DAI/PAI Docs loaded:', window.location.pathname);
});