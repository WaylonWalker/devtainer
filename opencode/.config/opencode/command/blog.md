---
description: Create a new blog post
agent: build
subtask: true
---

Create a new long-form blog post.

Then create a slug from the title (lowercase, replace spaces with hyphens, remove special chars).

Create a new file with this content:

```markdown
---
date: {{ current_date }}
templateKey: blog
title: {{ title }}
published: true
tags:
  - {{ tag }}
---

{{ description }}

Add your blog content here...

## Introduction

## Main Content

## Conclusion
```

The filename should be: `{slug}.md`

After creating the file, open it for editing so the user can add their content.
