---
layout: post
title: "Agent of Empires: 一个基于 tmux 的 AI agent 会话管理器"
date: 2026-03-30 15:21:39 +0800
comments: true
categories: 编程
published: true
tags:
  - AI 编程工具
  - tmux
  - git worktree
  - agent of empires
  - Claude Code
---

最近一段时间, 各种 AI coding agent 工具我都在试. 试来试去以后, 我越来越觉得, 真正麻烦的往往不是模型本身, 而是怎么把多个 agent 安排好: 谁在什么分支上工作, 谁在跑什么任务, 当前是不是卡住了, 要不要我去接管一下, 关掉界面以后它是不是还在继续跑. 这些事情如果全靠手工管理, agent 一多, 很快就乱了.

用了大半个月的 [Agent of Empires](https://github.com/njbrake/agent-of-empires) 以后, 觉得可以认真写一下. 名字起得很大(以后简称 AoE) 不过它做的事情倒是挺朴素: 它不是重新造一整套"AI IDE", 而是站在 `tmux` 和 `git worktree` 这些已经很好用的基础设施上, 做了一个专门给 AI agent 用的会话管理器. AoE 最近刚到 v1.0.0, 整体已经比较成熟了.

仓库地址:

- 原版: <https://github.com/njbrake/agent-of-empires>
- 我的 fork: <https://github.com/jtianling/agent-of-empires>

<!-- more -->

### 一句话说明

`Agent of Empires` 可以理解成一个终端里的 AI agent 调度面板. 它把不同 agent 跑在各自独立的 `tmux session` 里, 并且可以结合 `git worktree` 同时在同一个项目的不同分支上开工. 目前支持的 agent 包括 Claude Code, Codex CLI, Gemini CLI, OpenCode, Cursor CLI, Copilot CLI, Mistral Vibe, Pi.dev, Factory Droid CLI 等, 基本上主流的终端 AI agent 都覆盖了.

### 为什么我会觉得它有意思

现在做 AI 辅助编程, 比较自然的一种工作方式, 其实已经不是"我和一个 agent 一问一答"了, 而是:

- 一个 agent 写功能
- 一个 agent 跑测试或者修 lint
- 一个 agent 只做 code review
- 还有一个 agent 去查文档或者整理思路

这种情况下, 单纯开很多终端标签页也不是不行, 但是很快就会碰到几个问题: 目录容易乱, 分支容易串, 关掉窗口以后状态不好追, 另外 agent 当前到底是在忙, 在等, 还是已经结束了, 也不容易一眼看清.

`Agent of Empires` 的思路就是把这些问题系统化处理掉. 它的几个核心点我觉得比较实用:

- 基于 `tmux`, 所以会话本身是持续存在的, 关掉 TUI 以后 agent 也不会停
- 能结合 `git worktree`, 让不同 agent 在不同分支上并行工作
- 有 TUI, 也有 CLI, 不一定非得全程待在界面里
- 可以看状态(Running / Waiting / Idle), 也可以直接 attach 进去接管
- 支持 Docker sandbox, 想把 agent 跑得更隔离一些的话很方便
- 内置 diff view, 可以在 TUI 里直接 review agent 的 git 改动
- 支持给 agent 发消息(`aoe send`), 不用 attach 进去也能下指令
- 每个项目可以有自己的 `.aoe/config.toml`, 配 hooks 和项目级设定
- 有声音提醒, agent 状态变化的时候可以收到通知

说白了, 它不是去替代终端, 而是把"同时管理很多个 agent 终端"这件事情做得更顺手.

在我使用的时候, 最最让我感觉有用的是, 当我不希望 Code Agent 老是对话中断, 可以保持持续运行, 我习惯在一个做服务器使用的 Mac 电脑上, 然后哪怕我需要离开工作环境, 比如在交通的路上, 在家里, 也可以通过一个简单的ssh登录到工作的Mac上, 运行aoe, 直接就可以恢复整个工作环境. 也是因为这个优势, 我就没有使用很强大的本地Agent管理工具, 类似 cmux 这样的, 虽然本地的窗口分割, agent 管理很方便, 但是远程没法简单的恢复.


### 安装和最基本的用法

原版 README 里给了几种安装方式, 最简单的大概是这样:

```bash
curl -fsSL \
  https://raw.githubusercontent.com/njbrake/agent-of-empires/main/scripts/install.sh \
  | bash
```

或者如果你用 Homebrew 或 Nix:

```bash
# Homebrew
brew install aoe

# Nix
nix run github:njbrake/agent-of-empires
```

启动以后, 最直接的用法就是:

```bash
aoe
```

另外它也支持直接从命令行加 session, 比如:

```bash
# 在当前项目上加一个 session
aoe add .

# 在新的 worktree / 分支上加一个 session
aoe add . -w feat/my-feature -b

# 用 sandbox 方式启动
aoe add --sandbox .
```

这个设计里面我最喜欢的一点, 就是它没有把底层模型藏起来. 底层还是 `tmux` session, 所以真出了什么问题, 你随时都可以 attach 进去看, 不会有那种"界面一关, 一切都变成黑盒"的感觉.

### 它适合什么样的人

我觉得它尤其适合下面这类场景:

- 已经习惯终端工作流, 至少不排斥 `tmux`
- 一个项目里会同时跑多个 AI agent
- 会认真使用 `git worktree` 或多分支并行开发
- 希望 agent 是长期运行的, 而不是一次性问答式工具

反过来说, 如果你平时本来就不怎么用终端, 也不太愿意接受 `tmux` 这一层概念, 那上手成本可能还是会觉得偏高一点. 这个工具显然不是给"完全不想碰终端"的用户准备的.

### 我自己 fork 以后改了哪些

我从比较早期就开始 fork 了, 累计提交了大概 90 多个 commit. 早期加的一些功能, 比如 profile 机制, 终端标题管理, tmux 下的各种交互修复. 目前 fork 比上游多出来的改动, 主要集中在几个日常体验的细节上:

- **Session 导航快捷键** -- 原版在 session 之间的导航比较基础, 我加了一整套: `Ctrl+.` / `Ctrl+,` 在 session 之间快速切换(跨 group 循环), 在 TUI 和 tmux 里都可以用数字键(1-99)直接跳转到指定 session, `Ctrl+b b` 回到上一个 session(类似 vim 的 `Ctrl+^`). tmux 内部也加了 vi 风格的 pane 导航(`Ctrl+b h/j/k/l`), `Ctrl+;` 循环切换 pane, `Ctrl+Q` 一键 detach. 这些快捷键加起来以后, 日常在多个 agent 之间跳转的手感好了很多, 基本不需要再回到 TUI 列表里去选.

- **Notification Bar** -- 灵感来自 [Agent Deck](https://github.com/asheshgoplani/agent-deck), 在 tmux 的状态栏里直接显示所有 session 的实时状态(Running / Waiting / Idle), 带状态图标. 这样即使你 attach 在某一个 agent session 里工作, 也能通过状态栏一眼看到其他 session 有没有在等你输入, 不用切回 TUI 去检查. 配合 quick-switch, 跳过去的时候还会自动 ack 掉 Waiting 状态.

- **Agent Restart** -- 按 `R` 键可以直接重启 agent pane, 不需要销毁整个 session 再重建. 主要场景是像 Claude Code 这样需要重启才能刷新 skill 配置的 agent, 改完 skill 以后按一下就行, 不用手动退出再重开. 对 Claude Code 和 Codex 还做了优雅的 resume restart, 会持久化 resume token, 重启后可以从上次的对话状态恢复.

- **Narrow-screen layout** -- 在窄终端下(iPhone 竖屏, Mac 分屏, 小 tmux pane), TUI 会自动隐藏预览面板, 只显示全宽的 session 列表. Attach 到有 split pane 的 session 时, agent pane 会自动 zoom 成全屏可用的视图; 回到宽终端时自动 unzoom. Pane 切换快捷键(`Ctrl+b h/j/k/l`, `Ctrl+;`)是 zoom-aware 的, 在 zoom 状态下切换 pane 会自动 re-zoom 目标 pane, 体验无缝.


### 总的感觉

用了大半个月以后, 我觉得 `Agent of Empires` 最有价值的地方, 不是它又支持了多少个模型, 而是它抓住了一个很实际的问题: 当 AI agent 从"偶尔用一下"变成"同时跑好几个"以后, 真正需要管理的是会话, 状态, 隔离和上下文, 而不是一个更花哨的聊天框.

到 v1.0.0 以后, 完成度已经相当高了, diff view, per-repo config, 声音提醒, send message 这些功能补上以后, 日常使用基本不需要再自己折腾太多. 如果你本来就在终端里工作, 也已经开始习惯用多个 agent 并行做事, 那这个工具确实值得认真试一下.
