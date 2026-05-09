---
layout: post
title: "cross-agent-teams 发布: 让本机的多个 coding agent 互相通信"
date: 2026-05-01 21:00:00 +0800
comments: true
categories: 编程
published: true
tags:
- AI 编程工具
- MCP
- Claude Code
- Codex
- multi-agent
- cross-agent-teams
---

我现在本机长期开着好几个 coding agent 一起工作: Claude Code 跑主开发, Codex 在另一边做 review 或者跑长任务, 偶尔再拉一个 opencode 做点别的. 工具都不缺, 真正缺的是: 它们之间没有任何官方互通方式. 想让 Codex 把刚发现的问题"告诉"那边的 Claude Code, 只能我自己把内容复制过去. Claude Code 这种纯 TUI 的 agent 还没有"被外部唤醒"的标准入口, 你给它写一段话, 它的 CLI 不会"叮"一下, 用户必须主动切窗口才能看到.

折腾了一阵以后, 我做了一个本地 MCP daemon, 叫 `cross-agent-teams-mcp` (项目内简称 `xats`), 就是给本机所有这些 agent 一个统一的邮箱和唤醒通道. 各 agent 还跑在自己原生的 CLI 里, 完全不用改 harness, daemon 只负责"传话"和"敲门".

仓库地址: <https://github.com/jtianling/cross-agent-teams-mcp>

<!-- more -->

### 一句话说明

`cross-agent-teams-mcp` 是一个本地 MCP daemon. 同一台机器上的多个 coding agent (Claude Code, Codex, opencode, cursor, ...) 各自把它注册成一个 MCP server, 之后就可以按名字, team 或 role 互相发私信和广播; daemon 同时负责把消息推回给收件 agent, 让它能自己醒来读. 全程不依赖任何外部服务, 数据存在 `~/.cross-agent-teams-mcp/data.db` 这一个 SQLite 文件里.

### 为什么做这个

我的痛点很具体, 不是"想搞一个 multi-agent 框架":

- Codex 和 Claude Code 想互相调用, 只能我手动复制粘贴. 一来一回, 上下文很容易就丢了.
- Claude Code 没有"被外部唤醒"的标准入口. 你给它写一段话, 它的 CLI 不会主动提示, 用户得切回去看.
- 用 `tmux send-keys` 兜底唤醒过, 但要手动维护 pid 和 pane 的对应关系, 而且只对纯 TUI agent 管用, Claude Code 这种又是另一套.
- 多个 agent 之间没有共享上下文, 每开一个新会话都要把同一段背景再贴一遍.

所以 xats 想做的事情非常窄: 给本机已经在跑的这些 coding agent 一个公共的 mailbox + wake 通道, 别的什么都不管.

### 跟现有方案的区别

我特地想跟下面这几类东西划清边界, 因为最初一拍脑袋很容易把它们混在一起:

- **Claude Code 自带的 sub-agent / Task tool**: 那是父子关系, 一个 Claude 实例 fork 出短生命周期的 sub-agent, 用完就丢, 没有跨 harness 的概念. xats 处理的是同级 agent 之间的横向沟通, 各 agent 是独立长生命周期会话.
- **`codex --remote`**: 那只是把 Codex 自己的 TUI 连到远端的 Codex 进程, 还是单 agent 在玩自己. xats 不替换任何 agent 的 runtime.
- **autogen / crewai 这种 multi-agent 框架**: 那些是 orchestrator, 由框架自己持有 agent 循环, 你写 Python 把业务塞进去. xats 反过来 — 各 agent 仍然在它原生的 CLI 里运行 (Claude Code 还是 Claude Code 的 TUI, Codex 还是 Codex 的 TUI), MCP daemon 只负责 inbox 和 wake. 不绑定语言, 不要求把代码迁到框架里.

一句话定位: 给本机已经在跑的那些 coding agent 一个共用的消息总线, 而不是又造一个 multi-agent 框架.

### 技术上比较有意思的两点

#### Claude Code 的 channel-proxy

Claude Code 有一个 experimental capability 叫 `notifications/claude/channel`, 启动的时候得加 `--dangerously-load-development-channels server:<name>` 才会打开. 但 daemon 本身是 HTTP server, 而 Claude Code 跟 MCP server 之间走的是 stdio — 两边接口不一样, 不能直接对接.

解法是单独发布一个很薄的 stdio shim, 叫 `cross-agent-teams-channel`. Claude Code 把它当普通 MCP server 启动, shim 内部建一条到 daemon 的长连接, 把 daemon 推过来的 wake 通过 channel 通道注入回 Claude Code. 用户什么都不用配, 只要在 `.mcp.json` 里同时加 daemon 和 shim 两个条目即可.

这里还有一个值得记一下的细节: shim 启动时给自己生成一个 channel_session_id (csid), 并把 `process.ppid` (= Claude Code CLI 自己的 pid) 注册到 daemon 上的 proxy 行. 之后 Claude Code 业务侧调 `register_agent` 时只要把 `ui_pid=$PPID` 一起传上去, daemon 就会按 ui_pid 找到对应的 proxy 并自动把 csid 绑过去 — 用户不需要手动复制 csid, 也避免了多个 Claude 实例之间 csid 串错的"silent mis-bind"陷阱 (这个 bug 我专门 fix 过, 排查的时候相当不直观).

#### pid → tty → pane 的 tmux 唤醒

对 opencode, cursor, 或者没开 app-server 的 Codex 这类没有 push 通道的 agent, 唤醒方式只能朴素一点: 把一行短文本 paste 进 agent 所在的 tmux pane.

实现思路是: 注册时拿到 `ui_pid`, 通过 `/dev/ttys` 反查 tty, 再用 `tmux list-panes -F` 把 tty 映射到 pane id, 缓存下来. 后续 `send_message` 触发 wake 时, 直接 `tmux send-keys` 进对应 pane. 想法不复杂, 但踩过的坑不少: macOS 上 `ps` 拿到的 tty 跟 tmux 看到的不一定字面一致; 用 `npx` 套了 wrapper 后 `process.ppid` 不是 Claude Code 而是 npm 的 pid; 等等. 现在的实现会沿 process tree 一直往上找, 直到摸到真正的 host pid 为止.

### 现在能用什么

下面这些是已经稳定, 我每天都在用的:

- `register_agent`: 自动判断 `claude-code` / `codex` / `custom` 三种 agent_type
- `send_message`: 1→1 私信, 按 name 或 agent_id
- `broadcast` / `broadcast_to_role`: 同 team 内广播
- `get_inbox`: 读邮箱
- `list_agents`: 看看团队里有谁
- 唤醒通道: Claude Code 走 channel push, Codex 走 app-server WebSocket (开了 app-server 的话) / 没开就 tmux paste, opencode/cursor/custom 走 tmux paste
- `ui_pid` 自动绑 channel, csid 不一致会被 daemon 主动拒绝

另外有两块功能已经实现了, 但 README 里暂时没强推, 因为我自己还没用顺手:

- 共享任务列表 (`task_add` / `task_list` / `task_claim` / `task_complete`)
- contracts (`register_contract` / `subscribe_contract` / `diff_contracts`), 给跨 agent 的接口约定一个轻量描述

等我自己用透以后再补到 README 里.

### 怎么开始用

最快的路径是 daemon + `mcpsmgr` 三步搞定, 不用手动改 `.mcp.json`.

**Claude Code (默认)**:

```bash
# 1. 启 daemon (起一次, 让它持续跑, 单独终端 / tmux / launchd 都行)
npx -y cross-agent-teams-mcp@latest daemon --port 9100 &
# 2. 在你项目里让 mcpsmgr 装好 MCP 配置 (会自动改本项目 .mcp.json)
npx mcpsmgr add jtianling/cross-agent-teams-mcp -a claude-code
# 3. 启动 Claude Code 时带上 channel loader (需要手动确认权限)
claude --dangerously-load-development-channels server:cross-agent-teams-channel
```

**其它 agent (Codex, opencode, ...)**:

```bash
npx -y cross-agent-teams-mcp@latest daemon --port 9100 &
npx mcpsmgr add jtianling/cross-agent-teams-mcp     # 交互式选择 agent 类型
# 然后照常启动对应 coding agent
```

提醒一下: 这些 agent 没有 Claude Code 那种 channel push 通道, daemon 推消息时只能走 tmux paste 兜底 (Codex 开了 app-server 例外). 实际用起来很可能需要你自己时不时让 agent 调 `get_inbox` 收一下信, 比如直接说"看看我邮箱里有什么新消息". 想要更原生的唤醒, Codex 建议把 app-server 一起开上 (下面"详细参考"里有具体说明).

进到 agent 会话以后, 用平时说话的口吻就够了, 不用记工具名:

```
# Agent A: 把我注册到 xats, 名字叫 backend, team 是 default.
# Agent B: 把我注册到 xats, 名字叫 frontend, team 是 default.
#         给 backend 发个消息: API 改了.
```

agent 自己会挑 `register_agent`, `send_message`, `get_inbox` 这些工具去调.

注意 `--dangerously-load-development-channels server:` 后面那个名字, 必须等于 `.mcp.json` 里 channel shim 那条的 server key, 默认是 `cross-agent-teams-channel`.

#### 详细参考

daemon 默认听 9100, 换端口直接传 `--port`:

```bash
npx -y cross-agent-teams-mcp@latest daemon --port 9300
```

##### 推荐: 用 mcpsmgr 装 MCP 配置

`npx mcpsmgr add jtianling/cross-agent-teams-mcp -a claude-code` 会自动写好 Claude Code 那两个 server 条目 (HTTP 入口 + channel shim) 进当前项目的 `.mcp.json`. 不指定 `-a` 时会进交互模式让你选 agent (codex, opencode, cursor 等同理).

如果你 daemon 改了端口 (比如上面的 9300), 在 mcpsmgr 之后用环境变量或 `.mcp.json` 微调一下 daemon URL 就行. 配出来的 `.mcp.json` 是普通 JSON, 写完想再改完全没问题.

##### 手动配 .mcp.json

如果偏好不引入 mcpsmgr, 直接手写也可以. Claude Code 需要两个条目, 一个是 HTTP 入口, 一个是 channel shim:

```json
{
  "mcpServers": {
    "cross-agent-teams": {
      "type": "http",
      "url": "http://127.0.0.1:9100/mcp"
    },
    "cross-agent-teams-channel": {
      "command": "npx",
      "args": [
        "-y", "-p", "cross-agent-teams-mcp@latest",
        "cross-agent-teams-channel",
        "--daemon-url", "http://127.0.0.1:9100/mcp"
      ]
    }
  }
}
```

Codex 那边稍微特殊一点. 工具调用本身只要在 `~/.codex/config.toml` 里加一段 streamable-http 配置就行, 没有 channel proxy 的事:

```toml
[mcp_servers.cross-agent-teams]
type = "streamable-http"
url = "http://127.0.0.1:9100/mcp"
```

但如果你希望别的 agent 能"唤醒"这个 Codex thread, 而不是只能给它写邮件等它自己来读, 就要再多一步: 把 Codex 自带的 app-server 一起拉起来, 让 Codex TUI 通过它连过来. 这条路用的是 Codex 自家的 websocket 协议 (`codex-appserver` transport), wake 的本质是直接在那个 thread 里 start a turn, 比 tmux paste 干净不少:

```bash
codex app-server --listen ws://127.0.0.1:8799     # 一个终端开 app-server
codex --remote ws://127.0.0.1:8799                # 另一个终端开 TUI 连过来
```

之后 Codex 在自己的会话里调 `register_agent` 注册一下, daemon 就会把它的 `thread_id` 记成 `codex-appserver` delivery (Codex 0.124.0+ 会自动 export `CODEX_THREAD_ID` 给 MCP 工具, 注册时直接用即可). 后面 xats 给这个 Codex 推消息, 走的就是 websocket 直连, 不再依赖 tmux.

如果不开 app-server 也能用, daemon 会回退到 tmux paste, 只是体验上会差一点 — 唤醒得靠把一行字 paste 到 Codex 所在的 pane. 所以个人建议是: 想被同侪 agent 主动唤醒的 Codex, 就把 app-server 一起开上.

opencode / cursor 这类 agent 直接连 daemon, 没有专属 wake 通道, 都是走 tmux paste, 配置都在 `docs/configs/` 下面.

### 后续打算 (作者考虑中, 不算承诺)

- 短期: 把 contracts 跑顺, 给跨 agent 的接口约定一个轻量描述; 共享任务列表也希望真正用起来.
- 中期: 跨机器. 现在严格 localhost, 一旦扩出去, 鉴权, 隔离, proxy 这些都得重新设计.
- 不打算做的: agent 编排框架. xats 的边界就是 transport + inbox, agent 之间怎么协作, 交给用户自己的 prompt 和工作流去决定.

### 顺便说一句, 它已经在 dogfood 了

`xats` 现在已经在它自己开发流程里用上了. 这次 0.5.0 之前的好几次 release, 包括 channel proxy 的重构, 以及 `register_*_self` 几个工具被 collapse 成统一的 `register_agent`, 都是我用 Claude Code + Codex + xats 三方协作做掉的: Claude Code 写一部分实现, Codex 在旁边做 review 或者跑独立的检查, 互相通过 xats 同步进度和发现的问题, 不再需要我做"人肉中继". 这条经历比我自己讲一堆"它能做什么"要更有说服力.

如果你也在本机同时跑了好几个 coding agent, 又被它们之间没法互通烦到过, 欢迎试用一下, 也欢迎反馈.
