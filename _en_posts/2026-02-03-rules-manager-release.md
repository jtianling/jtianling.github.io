---
layout: post_en
title: "rulesmgr Released: One Set of Rules, Synced Across Multiple Tools"
date: 2026-02-03
comments: true
categories: Programming
published: true
tags:
- AI Coding Tools
- Rules Management
- rulesmgr
- rules-manager
---

While using AI coding tools like Claude Code, Cursor, and Cline recently, I kept running into the same tedious problem: each tool has its own rules directory with slightly different formats, and team conventions need to be copy-pasted across multiple locations, easily drifting apart over time. So I built a small tool called `rulesmgr` to manage a single set of rules and deploy them to multiple tools at once.

Repository: <https://github.com/jtianling/rules-manager>

<!-- more -->

### In One Sentence

Maintain a single rule template, select your target tools, and it automatically generates the corresponding directory structure, with sync support in copy mode.

### Installation

```bash
npx rulesmgr setup
```

This creates example rule templates in `~/.rules-manager/`, with a structure like this:

```
~/.rules-manager/
├── 01-tech-stack.md
├── 02-coding-principles.md
├── 03-architecture.md
├── 04-testing.md
├── 05-git-commit.md
├── 06-code-review.md
└── languages/
    ├── typescript-coding-style.md
    ├── python-coding-style.md
    └── ...
```

### Deploy to a Project

```bash
# Interactive mode
npx rulesmgr init

# Specify tools and language
npx rulesmgr init --tools=claude-code,cursor --lang=typescript

# Use copy mode
npx rulesmgr init --tools=claude-code --copy

# Deploy .gitignore
npx rulesmgr init --gitignore
```

### Sync Rules in Copy Mode

```bash
npx rulesmgr sync
```

### Supported Tools

Currently supports Claude Code, Cursor, Cline, Roo Code, Kilo Code, Windsurf, OpenCode, TRAE, Goose, Antigravity, and more. See the repository README for the full directory mapping.

Feel free to try it out and share feedback. More tools and templates will be added over time.
