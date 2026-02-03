---
layout: post
title: rulesmgr 发布：一份规则，多工具同步
date: 2026-02-03
comments: true
categories: 编程
published: true
tags:
- AI 编程工具
- 规则管理
- rulesmgr
- rules-manager
---

最近在使用 Claude Code、Cursor、Cline 之类的 AI 编程工具时，总会遇到一个重复劳动：每个工具都有自己的规则目录，格式略有差异，团队的约定需要在多个地方复制粘贴，还容易漂移。于是做了一个小工具 `rulesmgr`，统一管理一份规则，然后一次性部署到多个工具。

仓库地址：<https://github.com/jtianling/rules-manager>

<!-- more -->

### 一句话说明

维护一份规则模板，选择目标工具后自动生成对应目录结构，并支持复制模式的同步更新。

### 安装

```bash
npx rulesmgr setup
```

它会在 `~/.rules-manager/` 生成示例规则模板，结构类似下面这样：

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

### 部署到项目

```bash
# 交互模式
npx rulesmgr init

# 指定工具与语言
npx rulesmgr init --tools=claude-code,cursor --lang=typescript

# 使用复制模式
npx rulesmgr init --tools=claude-code --copy

# 部署 .gitignore
npx rulesmgr init --gitignore
```

### 同步复制模式的规则

```bash
npx rulesmgr sync
```

### 支持的工具

当前支持 Claude Code、Cursor、Cline、Roo Code、Kilo Code、Windsurf、OpenCode、TRAE、Goose、Antigravity 等工具，具体目录映射可参考仓库 README。

欢迎试用和反馈，后续会继续补充更多工具与模板。
