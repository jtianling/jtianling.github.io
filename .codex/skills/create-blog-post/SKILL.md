---
name: create-blog-post
description: Create blog posts for jtianling's Jekyll blog with proper YAML frontmatter, file naming conventions, and writing style. Use when the user asks to create, write, or draft a new blog post. Automatically handles Chinese/English titles, date formatting, categories, tags, and the homepage truncation marker. Ensures posts match the blog's technical writing style and format requirements.
---

# Create Blog Post

## Overview

This skill creates properly formatted blog posts for a Jekyll blog located at `/Users/jtianling/workspace/jtianling-blog`. It handles:
- YAML frontmatter with required fields
- File naming convention: `YYYY-MM-DD-title-slug.md`
- Frontmatter `date` with full timestamp and timezone for stable same-day ordering
- Placement in `_posts/` directory
- Homepage truncation with `<!-- more -->`
- README `Recent posts` maintenance after publishing a new article
- Consistent writing style matching the blog's existing posts
- Final verification with a local Jekyll build when feasible

## Workflow

### 1. Gather Requirements

Prefer inferring as much as possible from the user's request and repository context instead of asking for every field.

Infer from:
- The user prompt
- Linked README / GitHub repo / notes provided by the user
- Existing posts in `_posts/`
- The current date and time from the environment

Only ask follow-up questions if a wrong assumption would materially change the article.

Determine:
- **Title**: Can be in Chinese or English
- **Category**: Prefer existing active categories that match similar recent posts
- **Tags**: Small, relevant tag list; usually 3-6 tags is enough
- **Article type**: Choose from:
  - Technical learning note (技术学习笔记)
  - Translation article (翻译文章)
  - Tool release (工具发布)
  - Book review (读书笔记)
  - Essay/thought piece (随笔)
  - General technical post

**Important**:
- If the title is in Chinese, create an English slug for the filename.
- The slug does not need to be a literal translation of the title; it should be short, natural, and topic-based.
- For tool release posts, it is often better to derive the slug from the tool/repo name.
- Always write `date` with full local timestamp and timezone, for example `2026-03-13 21:35:00 +0800`.
- Do not use date-only frontmatter such as `2026-03-13` for new posts.
- If multiple posts are published on the same day, use the actual creation/publish time so homepage ordering matches publication order.
- If editing an old post rather than creating a new one, keep its original timestamp unless the user explicitly wants to change ordering.

### 2. Check Existing Content for Style Reference

Before writing, read 2-3 relevant posts from `/Users/jtianling/workspace/jtianling-blog/_posts/` to refresh understanding of the writing style.

Prefer matching by article type first:
- Tool release → recent tool release / project release posts
- Reading note → reading / review posts
- Essay → recent `随笔`
- Technical article → recent technical posts with similar depth

Do not rely only on old posts from many years ago when a newer style example exists. See `references/blog_style_guide.md` for detailed style guidelines.

### 3. Select Template

Based on article type, use the appropriate template from `references/post_templates.md`:
- Technical learning note → Use technical learning template with installation, usage, examples
- Translation → Use translation template with attribution and 译后感
- Tool release → Use tool release template with installation and usage
- Book review → Use book review template
- Essay → Use essay template
- General → Use basic template

Treat templates as starting points, not rigid requirements. Match the length and structure of nearby recent posts.

### 4. Generate Content

Write the article following these guidelines:

**Structure:**
- Start with 1-3 paragraph introduction providing background/motivation
- Place `<!-- more -->` after introduction (critical for homepage display)
- For long articles, add table of contents:
  ```
  **目录**:

  * TOC
  {:toc}
  ```
- For short release posts, a concise structure is preferred; do not force TOC or long section trees
- Use clear section headers. For short modern posts, `###` sections are often enough because the page title already serves as the article H1.
- Do not force an ending "小结" / "总结" section if the article reads better without it

**Writing Style** (see `references/blog_style_guide.md` for full details):
- Use first person "我"
- Keep language conversational and accessible
- Include personal motivation and judgment instead of writing like product documentation
- Include personal insights and reflections
- Use technical terms with appropriate Chinese translations
- Add external links for references
- Use ASCII half-width punctuation by default to match the blog owner's writing habit, even in Chinese text. Prefer `, . : ; ? ! ( ) " ' -` over full-width Chinese punctuation such as `,.:""'()`.
- Match nearby posts for punctuation and code fence style
- Prefer natural tone; do not force "......" or other signature expressions into every article

**Images:**
- Only add images when they materially help the post
- Do not invent screenshots or placeholder images
- If creating a new local image asset, use `/public/images/YYYY/descriptive-name.png`

### 5. Create File

Create the post in `_posts/` using the correct filename and frontmatter. Use this structure:

```markdown
---
layout: post
title: Article Title
date: YYYY-MM-DD HH:MM:SS +0800
comments: true
categories: Category
published: true
tags:
- Tag1
- Tag2
---

Introduction paragraph...

<!-- more -->

Content...
```

After creating a new published post, update `/Users/jtianling/workspace/jtianling-blog/README.md` in the `## Recent posts` section:
- Add the new post at the top of the list
- Use the post title as the link text
- Convert the post slug to the final page URL, for example `2026-03-13-net-use-release.md` → `https://www.jtianling.com/net-use-release.html`
- Keep the existing bullet-list style consistent
- Prefer keeping the list focused on recent content; if needed, remove the oldest entry to keep the section length stable

### 6. Review

Before finalizing:
- [ ] YAML frontmatter is complete and properly formatted
- [ ] Filename follows `YYYY-MM-DD-slug.md` pattern
- [ ] File is in `_posts/` directory
- [ ] `date` includes time and timezone, not just the day
- [ ] `<!-- more -->` is placed after introduction
- [ ] `README.md` `Recent posts` is updated if this is a newly published article
- [ ] Writing style matches blog's voice
- [ ] Punctuation style uses ASCII half-width punctuation by default, unless the user explicitly asks otherwise
- [ ] Structure matches similar recent posts
- [ ] Image paths follow `/public/images/YYYY/` pattern
- [ ] External links are formatted correctly
- [ ] `bundle exec jekyll build` passes when feasible

## Frontmatter Fields

**Required:**
- `layout: post` (always this value)
- `title:` - Article title (Chinese or English)
- `date:` - Format `YYYY-MM-DD HH:MM:SS +0800`
- `comments: true` (always true)
- `categories:` - Single category

**Optional:**
- `published: true` - Include if ready to publish
- `tags:` - List of tags, each on separate line with `- `

## File Naming

Format: `YYYY-MM-DD-title-in-english.md`

For Chinese titles, create an English slug:
- "Redis初次学习" → `2013-02-23-the-first-time-i-learn-redis.md`
- "读'启动大脑'" → `2018-02-26-review-of-use-your-head.md`
- "rulesmgr 发布" → `2026-02-03-rules-manager-release.md`
- "net-use 发布" → `2026-03-13-net-use-release.md`

For English titles, convert to lowercase with hyphens:
- "Building Spine" → `building-spine.md`

## Common Categories and Tags

**Categories:**
- 编程 (Programming)
- 随笔 (Essays/Thoughts)
- 阅读 (Reading)
- 工具 (Tools, only if it matches existing project usage)

**Category guidance:**
- Tool release posts often fit `编程`
- Use `工具` only when it matches nearby existing project posts or the user's explicit preference
- Prefer consistency with recent similar posts over inventing a new category

**Common Tags:**
- Languages: C++, Python, JavaScript, TypeScript, Lua
- Technologies: Redis, MySQL, MongoDB, nodejs, React, Vue
- Domains: 游戏开发, AI 编程工具, 算法
- Types: 翻译, 思维导图, 开源软件

## Resources

### references/blog_style_guide.md
Comprehensive guide to the blog's writing style, including:
- Language characteristics and common expressions
- Paragraph organization patterns
- Code and image usage conventions
- Examples from different article types

Read this before writing to ensure style consistency.

### references/post_templates.md
Ready-to-use templates for different article types:
- Technical learning notes
- Translation articles
- Tool releases
- Book reviews
- Essays

Choose the appropriate template based on article type, then simplify or expand according to recent examples.
