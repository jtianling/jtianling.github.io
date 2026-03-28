---
layout: post_en
title: skillsmgr Released
date: 2026-02-03
comments: true
categories: Tools
published: true
tags:
- Open Source
- CLI
- GitHub
- AI Coding Tools
---

While organizing skills for various AI coding tools recently, I realized each tool has its own directory and format, and switching between them gets confusing fast. So I built a unified management tool: skillsmgr. It installs skills centrally into `~/.skills-manager/` and deploys them to projects through a single `.agents/skills/` directory, currently supporting 44 tools.

Repository: <https://github.com/jtianling/skills-manager>

<!-- more -->

### In One Sentence

skillsmgr is a unified skills manager — install skills once into a local repository, then deploy them to any project or globally on demand, supporting 44 AI coding tools.

### Highlights

- **Central repository, deploy anywhere** — Skills are installed once into `~/.skills-manager/`. After that, `add` lets you interactively pick from all locally installed skills and deploy them to any project or globally — no need to remember the original repo URL or path every time.
- **Custom groups for batch management** — Organize your own skills into named groups (e.g., `--group my-tools`). Deploy an entire group to a project with a single `add --group` command, making it easy to maintain and share personal skill collections.
- **Zip archive support** — Install skills directly from `.zip` files or Anthropic's `.skill` packages, which makes it simple to package and share skill bundles outside of GitHub.

### Deployment Model

```text
project/
├── .agents/
│   └── skills/
│       ├── code-review -> ~/.skills-manager/official/anthropic/skills/code-review
│       └── example-skill -> ~/.skills-manager/custom/example-skill
├── .claude/
│   └── skills -> ../.agents/skills
└── .cursor/
    └── skills -> ../.agents/skills
```

All skills deploy to `.agents/skills/`. Native tools read that directory directly. Non-native tools use a symlink bridge to their legacy skill path. You can also use `--copy` to deploy project-local copies instead.

### Installation

```bash
npx skillsmgr setup
```

### Usage

```bash
# Install official Anthropic skills
npx skillsmgr install anthropic

# Install from a GitHub repository
npx skillsmgr install owner/repo

# Install from a local directory or zip archive
npx skillsmgr install ./my-skill
npx skillsmgr install ./skills-archive.zip

# Navigate to your project and deploy interactively
cd your-project
npx skillsmgr init

# Add a specific skill to a specific tool
npx skillsmgr add code-review -a claude-code

# Deploy globally
npx skillsmgr add code-review -g -a claude-code

# Inspect deployed skills
npx skillsmgr list --deployed
```

### Supported Tools

Currently supports 44 AI coding tools. The interactive selector shows 16 major tools (Claude Code, Codex, Cursor, Gemini CLI, GitHub Copilot, Cline, Windsurf, etc.), with 28 more available via the `-a` flag. Native tools read `.agents/skills/` directly; non-native tools are bridged via symlinks.

### Features

- Unified management: all skills installed to `~/.skills-manager/`, organized into official / community / custom categories
- Multi-tool deployment: one set of skills deployed to multiple tools through a unified directory + symlink bridges
- Symlinks by default: skill updates sync automatically; `--copy` mode also available
- Custom groups: batch manage and deploy your own skill collections with `--group`
- Interactive selector: supports search, group collapsing, and vim-style shortcuts
- Global deployment: use `-g` to deploy to agent user-level directories
