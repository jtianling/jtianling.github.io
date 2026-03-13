---
layout: post
title: Agent of Empires：一个基于 tmux 的 AI agent 会话管理器
date: 2026-03-13 15:21:39 +0800
comments: true
categories: 编程
published: true
tags:
  - AI 编程工具
  - tmux
  - git worktree
  - agent of empires
  - Codex
---

最近一段时间，各种 AI coding agent 工具我都在试。试来试去以后，我越来越觉得，真正麻烦的往往不是模型本身，而是怎么把多个 agent 安排好：谁在什么分支上工作，谁在跑什么任务，当前是不是卡住了，要不要我去接管一下，关掉界面以后它是不是还在继续跑。这些事情如果全靠手工管理，agent 一多，很快就乱了。

这两天看到一个我觉得挺有意思的工具：[Agent of Empires](https://github.com/njbrake/agent-of-empires)。名字起得很大，不过它做的事情倒是挺朴素：它不是重新造一整套“AI IDE”，而是站在 `tmux` 和 `git worktree` 这些已经很好用的基础设施上，做了一个专门给 AI agent 用的会话管理器。这个思路我很喜欢。

仓库地址：

- 原版：<https://github.com/njbrake/agent-of-empires>
- 我的 fork：<https://github.com/jtianling/agent-of-empires>

<!-- more -->

### 一句话说明

`Agent of Empires` 可以理解成一个终端里的 AI agent 调度面板。它把不同 agent 跑在各自独立的 `tmux session` 里，并且可以结合 `git worktree` 同时在同一个项目的不同分支上开工。

### 为什么我会觉得它有意思

现在做 AI 辅助编程，比较自然的一种工作方式，其实已经不是“我和一个 agent 一问一答”了，而是：

- 一个 agent 写功能
- 一个 agent 跑测试或者修 lint
- 一个 agent 只做 code review
- 还有一个 agent 去查文档或者整理思路

这种情况下，单纯开很多终端标签页也不是不行，但是很快就会碰到几个问题：目录容易乱，分支容易串，关掉窗口以后状态不好追，另外 agent 当前到底是在忙、在等、还是已经结束了，也不容易一眼看清。

`Agent of Empires` 的思路就是把这些问题系统化处理掉。它的几个核心点我觉得比较实用：

- 基于 `tmux`，所以会话本身是持续存在的，关掉 TUI 以后 agent 也不会停
- 能结合 `git worktree`，让不同 agent 在不同分支上并行工作
- 有 TUI，也有 CLI，不一定非得全程待在界面里
- 可以看状态，也可以直接 attach 进去接管
- 还支持 Docker sandbox，这一点对于想把 agent 跑得更隔离一些的人也挺有吸引力

说白了，它不是去替代终端，而是把“同时管理很多个 agent 终端”这件事情做得更顺手。

### 安装和最基本的用法

原版 README 里给了几种安装方式，最简单的大概是这样：

```bash
curl -fsSL \
  https://raw.githubusercontent.com/njbrake/agent-of-empires/main/scripts/install.sh \
  | bash
```

或者如果你用 Homebrew，也可以：

```bash
brew install aoe
```

启动以后，最直接的用法就是：

```bash
aoe
```

另外它也支持直接从命令行加 session，比如：

```bash
# 在当前项目上加一个 session
aoe add .

# 在新的 worktree / 分支上加一个 session
aoe add . -w feat/my-feature -b

# 用 sandbox 方式启动
aoe add --sandbox .
```

这个设计里面我最喜欢的一点，就是它没有把底层模型藏起来。底层还是 `tmux` session，所以真出了什么问题，你随时都可以 attach 进去看，不会有那种“界面一关，一切都变成黑盒”的感觉。

### 它适合什么样的人

我觉得它尤其适合下面这类场景：

- 已经习惯终端工作流，至少不排斥 `tmux`
- 一个项目里会同时跑多个 AI agent
- 会认真使用 `git worktree` 或多分支并行开发
- 希望 agent 是长期运行的，而不是一次性问答式工具

反过来说，如果你平时本来就不怎么用终端，也不太愿意接受 `tmux` 这一层概念，那上手成本可能还是会觉得偏高一点。这个工具显然不是给“完全不想碰终端”的用户准备的。

### 为什么我会把 aoe 本身运行在一个 tmux 里

我自己现在比较喜欢的一种用法，是不只是让 AoE 去管理里面那些 agent session，而是把 `aoe` 自己也放到一个外层的 `tmux session` 里跑。

这样做的好处非常直接：假如我离开了工位，随便拿一个手机上的 SSH 客户端登录到自己的电脑，只需要 `tmux attach` 到那个跑着 `aoe` 的 session，就可以在手机上继续管理所有 coding agent。哪些 agent 还在跑，哪些在等输入，要不要 attach 进去接管，都会方便很多。

对我来说，这种体验其实很有意思，因为它有点像一个更适合程序员的 OpenClaw。不是说界面更花哨，而是它本质上建立在 SSH、`tmux`、终端这些程序员本来就天天在用的东西上，所以远程接管这件事情会显得特别自然。

如果电脑本身是在内网里，也不是什么大问题。只要再配合一下 Tailscale 或者 Cloudflare WARP，手机连回自己电脑这件事情其实并不难。这样一来，不管人在不在工位前，整个 agent 工作台都还是可达的。

原版 README 其实已经提到了移动端 SSH 客户端这种使用方式，不过我自己在实际这样用的时候，发现原版在这条工作流上还有一些 bug，尤其是 nested tmux 相关的 detach、鼠标和界面体验问题。我 fork 里把这些地方修掉以后，这种“手机上接回去管理 agent”的体验就顺很多了。

### 我自己 fork 以后改了几处

原版已经很好用了，不过我自己在用的时候，还是顺手改了几处更偏“日常体验”的问题。因为这些修改还没有写进 README，这里简单提一下重点。

第一类是终端标题和状态可见性。我给它加了动态 terminal tab title，让 TUI、自身状态和 agent 状态能反映到终端标题上。对我来说最有用的是 Codex 这类工具等待用户输入的时候，更容易一眼看出来，而不用切进去挨个确认。

第二类是 `tmux` 里的交互体验问题。比如 nested tmux 下的 detach 行为、鼠标滚轮被错误当成方向键、TUI flicker 之类，这些单独看都不算大功能，但是如果每天都在里面切来切去，其实非常影响体验。我 fork 里把这些地方顺手补了一遍。

第三类是 profile 机制。原版更偏全局单实例，不管你在哪个目录里启动，管理的基本还是同一套 AoE 状态。我自己加了基于运行目录自动分配的 profile，这样不同项目可以分别管理各自的一组 agent，不容易混在一起。当然，如果你就是想强制共用同一个 profile，也还是支持通过命令或环境变量明确指定。

第四类是 session 切换效率。我加了 `Ctrl+b j/k` 在 agent session 之间切换，这样在同一个 profile 里来回看几个 agent 的时候，不一定非得先退回 TUI 再进下一个。这个改动不大，但是挺顺手。

### 总的感觉

我觉得 `Agent of Empires` 最有价值的地方，不是它又支持了多少个模型，而是它抓住了一个很实际的问题：当 AI agent 从“偶尔用一下”变成“同时跑好几个”以后，真正需要管理的是会话、状态、隔离和上下文，而不是一个更花哨的聊天框。

所以如果你本来就在终端里工作，也已经开始习惯用多个 agent 并行做事，那这个工具确实值得试一下。对我自己来说，它至少属于那种“看完 README 以后会想亲手装起来跑跑看”的工具，而不是看起来很酷、但落不到日常工作流里的那种。
