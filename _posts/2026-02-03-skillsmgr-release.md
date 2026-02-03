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

最近在整理各种 AI 编程工具的 skills 时，发现每个工具都有自己的目录和格式，切来切去很容易乱。索性就做了一个统一管理的小工具：skillsmgr。它把 skills 集中放到 `~/.skills-manager/` 里，然后一键部署到不同的工具里。

仓库地址：<https://github.com/jtianling/skills-manager>

<!-- more -->

### 一句话说明

skillsmgr 是一个统一的 skills 管理器，帮你把一份技能库同步到多个 AI 编程工具。

### 安装

~~~ bash
npx skillsmgr setup
~~~

### 使用

~~~ bash
# 初始化本地 skills 仓库结构
npx skillsmgr setup

# 安装官方 Anthropic skills
npx skillsmgr install anthropic

# 进入项目并部署到本项目
cd your-project
npx skillsmgr init
~~~

### 支持的工具

目前支持 Claude Code、Cursor、Windsurf、Cline、Roo Code、Kilo Code、OpenCode、Trae、Antigravity 等多个 AI 编程工具，目录结构会按各自规范自动处理。

### 支持的功能/特性

- 统一管理：所有 skills 都放在 `~/.skills-manager/` 下
- 多工具部署：一份 skills 同时部署到多个工具
- 默认软链接：技能更新可以自动同步
- 搜索过滤：技能仓库大时也能快速挑选
- 增量更新：只增删变更的技能，不用全量重装

