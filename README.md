# jtianling-blog

This is my personal blog. I write about software engineering, open-source tools, and things I have learned along the way. You will also find notes on books, games, and other interests when something is worth sharing.

Blog: <https://www.jtianling.com>

## Content

- Programming notes and technical deep dives
- Tool releases and usage notes
- Translations and summaries of articles I find useful
- Reading notes and personal reflections

## Sections

- Archive: <https://www.jtianling.com/archive.html>
- English: <https://www.jtianling.com/en/>
- English archive: <https://www.jtianling.com/en/archive.html>
- Categories: <https://www.jtianling.com/categories.html>
- Tags: <https://www.jtianling.com/tags.html>
- Programming: <https://www.jtianling.com/programming.html>
- Essays: <https://www.jtianling.com/essay.html>

## Local development

- Ruby `3.3.x`
- Bundler `2.5+`
- Install: `bundle install`
- Serve locally: `bundle exec jekyll serve --host 127.0.0.1 --port 8080`

Set `google_analytics` in `_config.yml` to a GA4 measurement ID such as `G-XXXXXXXXXX` if you want analytics enabled.

## English posts

- Put English articles in `_en_posts/`
- Keep Chinese source posts in `_posts/`
- English index: `/en/`
- English archive: `/en/archive.html`
- Each English post should include an explicit `date` in front matter because `_en_posts/` is a Jekyll collection, not the built-in posts directory

Example:

```md
---
title: Hello English
date: 2026-03-29 10:00:00 +0800
categories: [programming]
tags: [jekyll, english]
---

English post content.
```

## Recent posts

- [cross-agent-teams 发布: 让本机的多个 coding agent 互相通信](https://www.jtianling.com/cross-agent-teams-release.html)
- [Agent of Empires: 一个基于 tmux 的 AI agent 会话管理器](https://www.jtianling.com/agent-of-empires-intro.html)
- [dual-yazi: 给 Yazi 加上我想要的双栏模式](https://www.jtianling.com/yazi-dual-pane-mode.html)
- [只给 Spec，不给代码：也许这会成为一种新的软件发布方式](https://www.jtianling.com/spec-first-software-release.html)
- [net-use 发布：监控 macOS app 实际访问了哪些 IP](https://www.jtianling.com/net-use-release.html)
- [skillsmgr 发布](https://www.jtianling.com/skillsmgr-release.html)
- [rulesmgr 发布：一份规则，多工具同步](https://www.jtianling.com/rules-manager-release.html)
- [Ollama rerank adapter](https://www.jtianling.com/ollama-rerank-adapter.html)
- [给 DeepSeek 网站加个搜索功能的Chrome插件](https://www.jtianling.com/add-search-to-deepseek.html)
- [编程语言语法比较网站](https://www.jtianling.com/programming-language-comparison.html)
