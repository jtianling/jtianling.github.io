---
title: "cross-agent-teams: a local message bus that lets multiple coding agents talk to each other"
date: 2026-05-01 21:00:00 +0800
comments: true
categories: programming
tags:
- AI coding tools
- MCP
- Claude Code
- Codex
- multi-agent
- cross-agent-teams
---

These days I usually have several coding agents running on the same machine: Claude Code doing the main development, Codex on the side for review or longer jobs, sometimes an opencode session for something else. The tools themselves are fine. What's actually missing is any official way for them to talk to each other. If Codex finds something it wants to tell the Claude Code session, I have to copy-paste it myself. Claude Code, being a pure TUI agent, has no standard "wake from outside" entry point either — you can leave it a message, but its CLI does not beep, so the user has to switch windows manually to even see it.

After enough of that friction, I built a small local MCP daemon, `cross-agent-teams-mcp` (the project nickname is `xats`), to give every coding agent on the machine a shared mailbox and wake channel. Each agent still runs in its own native CLI, no harness changes; the daemon only handles "carrying messages" and "knocking on the door".

Repo: <https://github.com/jtianling/cross-agent-teams-mcp>

<!-- more -->

### What it is, in one sentence

`cross-agent-teams-mcp` is a local MCP daemon. Multiple coding agents on the same machine (Claude Code, Codex, opencode, cursor, ...) each register it as an MCP server, and then they can DM each other by name, team, or role, or broadcast within a team. The daemon also pushes messages back to the recipient so it can wake itself up to read them. No external service is involved; everything lives in a single SQLite file at `~/.cross-agent-teams-mcp/data.db`.

### Why I built it

The pain points were specific, not "I want a multi-agent framework":

- Calling between Codex and Claude Code meant copy-paste by hand. Context kept getting lost on the round trip.
- Claude Code has no standard "wake from outside" entry point. You can leave it a message, but the CLI does not notify; the user has to switch back to see it.
- I'd worked around it with `tmux send-keys`, but that means hand-maintaining a pid-to-pane mapping, and it only works for plain TUI agents — Claude Code is its own thing again.
- Multiple agents have no shared context, so every new session has to re-paste the same background.

So `xats` is deliberately narrow: give the coding agents already running on this machine a shared mailbox and wake channel. Nothing else.

### How it differs from existing things

I want to draw a clear line against a few things that are easy to confuse it with:

- **Claude Code's built-in sub-agent / Task tool**: that's a parent–child relationship — one Claude instance forks a short-lived sub-agent, used and discarded, no cross-harness story. `xats` is horizontal communication between peer agents, each of which is its own long-running session.
- **`codex --remote`**: that just connects Codex's TUI to a remote Codex process. Still one agent talking to itself. `xats` doesn't replace any agent's runtime.
- **autogen / crewai and similar multi-agent frameworks**: those are orchestrators — the framework owns the agent loop, and you write Python around it. `xats` works the other way around: every agent keeps running in its native CLI (Claude Code is still Claude Code's TUI, Codex is still Codex's TUI), and the MCP daemon only handles inbox and wake. No language lock-in, no need to migrate code into a framework.

One-line positioning: a local message bus for already-running coding agents, not a multi-agent framework.

### Two technical bits worth mentioning

#### The Claude Code channel-proxy

Claude Code has an experimental capability called `notifications/claude/channel`. It only turns on if you launch with `--dangerously-load-development-channels server:<name>`. The trouble is that the daemon itself is an HTTP server, while Claude Code talks to MCP servers over stdio — the two don't connect directly.

The fix is a small stdio shim, published alongside the daemon as `cross-agent-teams-channel`. Claude Code starts it as if it were a normal MCP server; internally the shim opens a long-lived connection to the daemon and feeds wake events back to Claude Code over the channel transport. From the user side there's nothing to configure beyond adding both the daemon and the shim entries to `.mcp.json`.

A subtlety worth recording: when the shim starts, it generates a `channel_session_id` (csid) for itself and registers `process.ppid` (which is the Claude Code CLI's own pid) on the proxy row in the daemon. Later, when Claude Code's business side calls `register_agent` and passes `ui_pid=$PPID`, the daemon looks up the matching proxy by `ui_pid` and auto-binds the csid for it — the user never copies a csid by hand, and there's no risk of multiple Claude instances silently mis-binding to each other's channels (a bug I had to track down once; not at all obvious from the symptoms).

#### pid → tty → pane tmux wake

For agents without a push channel — opencode, cursor, or a Codex without app-server — the wake path has to fall back to something simple: paste a short line of text into the tmux pane the agent is sitting in.

The flow is: take `ui_pid` at registration time, look up its tty via `/dev/ttys`, then map tty → pane id with `tmux list-panes -F`, and cache it. When `send_message` triggers a wake, just `tmux send-keys` into that pane. The idea is unsurprising; the pitfalls are the interesting part. The tty `ps` reports on macOS doesn't always match what tmux uses literally; wrapping with `npx` makes `process.ppid` point at npm rather than Claude Code; and so on. The current implementation walks the process tree up until it finds the real host pid.

### What works today

The following are stable and what I use every day:

- `register_agent` with auto-detection of `claude-code` / `codex` / `custom`
- `send_message` for 1→1 DMs by name or agent id
- `broadcast` and `broadcast_to_role` within a team
- `get_inbox` to read mail
- `list_agents` to see who's around
- Wake channels: Claude Code via channel push, Codex via app-server WebSocket (when started) or tmux paste otherwise, opencode/cursor/custom via tmux paste
- `ui_pid` auto-binds the channel, with the daemon rejecting csid mismatches up front

Two more areas are implemented but not promoted in the README yet, because I haven't lived on them long enough:

- A shared task list (`task_add` / `task_list` / `task_claim` / `task_complete`)
- Contracts (`register_contract` / `subscribe_contract` / `diff_contracts`) for lightweight cross-agent interface descriptions

I'll add them to the README once they earn it.

### Getting started

The fastest path is daemon + `mcpsmgr` in three commands, no hand-editing of `.mcp.json` required.

**Claude Code (default)**:

```bash
# 1. Start the daemon (run once, keep it alive — dedicated terminal, tmux, launchd, your call)
npx -y cross-agent-teams-mcp@latest daemon --port 9100 &
# 2. From your project, let mcpsmgr install the MCP config (it edits the project's .mcp.json)
npx mcpsmgr add jtianling/cross-agent-teams-mcp -a claude-code
# 3. Launch Claude Code with the channel loader (you'll be prompted to approve the capability)
claude --dangerously-load-development-channels server:cross-agent-teams-channel
```

**Other agents (Codex, opencode, ...)**:

```bash
npx -y cross-agent-teams-mcp@latest daemon --port 9100 &
npx mcpsmgr add jtianling/cross-agent-teams-mcp     # interactive: pick the agent
# Then start the coding agent as usual
```

A heads-up: these agents don't have Claude Code's channel push transport, so the daemon falls back to tmux paste when delivering wake events (Codex with app-server is the exception). In practice you'll likely have to nudge the agent to call `get_inbox` yourself from time to time — something as casual as "check my inbox" works. For more native waking on Codex, run its app-server alongside (covered in "Detailed reference" below).

Once inside an agent session, you don't need to memorize tool names — just talk to it:

```
# Agent A: Register me to xats as backend on team default.
# Agent B: Register me to xats as frontend on team default.
#         Send backend a message: the API has changed.
```

The agent picks the right tool (`register_agent`, `send_message`, `get_inbox`, ...) on its own.

Note: the name after `--dangerously-load-development-channels server:` must match the channel shim's server key in `.mcp.json`, which is `cross-agent-teams-channel` by default.

#### Detailed reference

The daemon listens on 9100 by default; pass `--port` to change it:

```bash
npx -y cross-agent-teams-mcp@latest daemon --port 9300
```

##### Recommended: install the MCP config with mcpsmgr

`npx mcpsmgr add jtianling/cross-agent-teams-mcp -a claude-code` writes both Claude Code entries (the HTTP endpoint and the channel shim) into the project's `.mcp.json` automatically. Drop the `-a` flag to get an interactive picker for the agent type (codex, opencode, cursor, ...).

If you've changed the daemon port (e.g. to 9300 above), tweak the daemon URL afterwards via env var or by editing `.mcp.json` directly — the file is plain JSON, so post-hoc tweaks are fine.

##### Manual .mcp.json

If you'd rather not involve mcpsmgr, you can hand-write it. Claude Code needs two entries — the HTTP endpoint plus the channel shim:

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

Codex is a little different. Tool calls themselves only need a streamable-http entry in `~/.codex/config.toml`; no channel proxy:

```toml
[mcp_servers.cross-agent-teams]
type = "streamable-http"
url = "http://127.0.0.1:9100/mcp"
```

But if you want other agents to be able to *wake* this Codex thread, instead of only mailing it and waiting for the user to come back, there's one more step: run Codex's own app-server alongside the TUI. This uses Codex's native websocket protocol (the `codex-appserver` transport), and a wake there literally means "start a turn inside that thread" — quite a bit cleaner than tmux paste. The rough shape:

```bash
codex app-server --listen ws://127.0.0.1:8799     # one terminal: app-server
codex --remote ws://127.0.0.1:8799                # another terminal: TUI connects in
```

Those two lines aren't enough on their own — the real setup is more involved. Three key gotchas:

- Under `--remote`, MCP servers are loaded by the app-server, NOT by the TUI. So the `cross-agent-teams-mcp` entry has to live in the `CODEX_HOME` that the *app-server* reads at startup (usually the global `~/.codex/config.toml`). Setting `CODEX_HOME` on the TUI side does nothing.
- `~/.codex/config.toml` needs `experimental_use_rmcp_client = true` at the top, or streamable-http MCP servers won't load at all.
- For wake events to actually be injected into the codex thread (instead of still falling through to tmux paste), launch codex via a wrapper that calls `pre-register-codex-pane` so the daemon can map this codex process to its tmux pane.

The zsh launcher I personally use (with header comments and prereq notes) lives in a gist — source it or paste it into `~/.zshrc`: <https://gist.github.com/jtianling/6c2769f76ffb8fbff8856f90dc7f9554>. The full step-by-step (MCP entries, start order, etc.) is in the repo README under ["Let other agents wake you (codex-appserver poke)"](https://github.com/jtianling/cross-agent-teams-mcp#let-other-agents-wake-you-codex-appserver-poke).

Once that's all wired up, Codex calls `register_agent` from inside its session, and the daemon records its `thread_id` as a `codex-appserver` delivery (Codex 0.124.0+ exports `CODEX_THREAD_ID` to MCP tools automatically, so registration just picks it up). After that, when xats pushes a message to this Codex, it goes over websocket — no tmux involved.

It still works without app-server: the daemon falls back to tmux paste, which is fine but rougher — the wake is literally a line of text pasted into the Codex pane. So my recommendation: if you want this Codex to be wakeable by peer agents, follow the README and wire up app-server + launcher together.

opencode and cursor have no dedicated wake transport and rely on tmux paste; their configs live under `docs/configs/`.

### What's next (loose plans, not commitments)

- Short term: get contracts polished enough to be useful as lightweight cross-agent interface descriptions; actually live on the shared task list.
- Medium term: cross-machine. Right now everything is strictly localhost; once it goes off-box, auth, isolation, and proxying all need a fresh design pass.
- Not planning to do: an agent orchestration framework. The boundary stays at transport + inbox; how agents collaborate is left to the user's own prompts and workflow.

### Already dogfooding it

`xats` is already in use on its own development. Several releases leading up to 0.5.0 — including the channel-proxy refactor and the collapse of `register_*_self` into a single unified `register_agent` — were done with Claude Code + Codex + xats working together: Claude Code wrote part of the implementation, Codex did review and ran independent checks alongside, and they coordinated progress and findings through xats instead of through me as a human relay. That experience is more convincing than any abstract list of features.

If you're also juggling several coding agents on the same machine and have hit the "they can't talk to each other" wall, give it a try. Feedback welcome.
