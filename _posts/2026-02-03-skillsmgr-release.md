---
layout: post
title: skillsmgr 发布
date: 2026-02-03
comments: true
categories: 工具
published: true
tags:
- 开源软件
- CLI
- GitHub
- AI 编程工具
---

最近在整理各种 AI 编程工具的 skills 时，发现每个工具都有自己的目录和格式，切来切去很容易乱。索性就做了一个统一管理的小工具：skillsmgr。它把 skills 集中安装到 `~/.skills-manager/` 里，然后通过一个统一的 `.agents/skills/` 目录部署到项目中，目前支持 44 个工具。

仓库地址：<https://github.com/jtianling/skills-manager>

<!-- more -->

### 一句话说明

skillsmgr 是一个统一的 skills 管理器，安装一次 skills 到本地仓库，然后按需部署到任意项目或全局，支持 44 个 AI 编程工具。

### 亮点

- **中心仓库，随处部署** — Skills 安装一次到 `~/.skills-manager/`，之后用 `add` 交互式选择并部署到任意项目或全局，不需要每次都记住原始仓库地址。
- **自定义分组批量管理** — 把自己的 skills 组织到命名分组里（如 `--group my-tools`），一条 `add --group` 命令就能把整组部署到项目中。
- **Zip 压缩包支持** — 可以直接从 `.zip` 文件或 Anthropic 的 `.skill` 包安装 skills，方便在 GitHub 之外打包和分享。

### 部署模型

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

所有 skills 统一部署到 `.agents/skills/`。原生支持该目录的工具直接读取，其他工具通过 symlink bridge 桥接到各自的 skills 目录。也可以用 `--copy` 改为复制模式。

### 安装

```bash
npx skillsmgr setup
```

### 使用

```bash
# 安装官方 Anthropic skills
npx skillsmgr install anthropic

# 从 GitHub 仓库安装
npx skillsmgr install owner/repo

# 从本地目录或 zip 安装
npx skillsmgr install ./my-skill
npx skillsmgr install ./skills-archive.zip

# 进入项目并交互式部署
cd your-project
npx skillsmgr init

# 添加特定 skill 到特定工具
npx skillsmgr add code-review -a claude-code

# 全局部署
npx skillsmgr add code-review -g -a claude-code

# 查看已部署的 skills
npx skillsmgr list --deployed
```

### 支持的工具

目前支持 44 个 AI 编程工具，交互选择器中展示 16 个主流工具（Claude Code、Codex、Cursor、Gemini CLI、GitHub Copilot、Cline、Windsurf 等），其余 28 个可通过 `-a` 参数直接指定。原生工具直接读取 `.agents/skills/`，非原生工具通过 symlink bridge 桥接。

### 主要功能

- 统一管理：所有 skills 安装到 `~/.skills-manager/`，分为 official / community / custom 三类
- 多工具部署：一份 skills 通过统一目录 + symlink bridge 部署到多个工具
- 默认软链接：skill 更新自动同步，也支持 `--copy` 复制模式
- 自定义分组：通过 `--group` 批量管理和部署自己的 skill 集合
- 交互式选择器：支持搜索、分组折叠、vim 风格快捷键
- 全局部署：用 `-g` 部署到工具的用户级目录
