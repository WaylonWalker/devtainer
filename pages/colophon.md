---
date: '2026-02-07'
description: 'How this site is built - colophon'
published: true
tags: ['slash']
title: 'Colophon'
---

This site is built with modern, open-source tools. Here is what powers it.

## Site Generator

**[markata](https://markata.dev/)** - A Python-based static site generator that processes markdown files with customizable hooks and plugins.

## Hosting

Static files served via [Cloudflare Pages](https://pages.cloudflare.com/) or similar CDN-based hosting.

## Styling

Custom CSS with a focus on readability and clean typography. No heavy frameworks - just semantic HTML and minimal styling.

## Content Format

All content is written in Markdown with YAML frontmatter:

```yaml
---
date: '2026-02-07'
description: 'Page description'
published: true
title: 'Page Title'
---
```

## Fonts

- Body: System font stack (native performance)
- Code: JetBrains Mono or system monospace

## Syntax Highlighting

Code blocks are syntax-highlighted at build time using Pygments or similar.

## Build Process

1. Markdown files are processed by markata
2. Wikilinks are converted to internal links
3. Static HTML is generated
4. Deployed to CDN

## Source

The content and build configuration is available in the devtainer repository:
[github.com/waylonwalker/devtainer](https://github.com/waylonwalker/devtainer)
