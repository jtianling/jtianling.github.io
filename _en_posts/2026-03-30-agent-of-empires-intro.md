---
layout: post_en
title: "Agent of Empires: A tmux-Based AI Agent Session Manager"
date: 2026-03-30 15:21:39 +0800
comments: true
categories: Programming
published: true
tags:
  - AI Coding Tools
  - tmux
  - git worktree
  - Agent of Empires
  - Claude Code
---

I've been trying out all kinds of AI coding agents lately. After going back and forth between them, I've realized that the real pain point often isn't the model itself — it's managing multiple agents at once: who's working on which branch, what task is each one running, is one stuck waiting for input, do I need to take over, and will it keep running after I close the window? Managing all of this by hand gets messy fast once you have more than a couple of agents going.

After using [Agent of Empires](https://github.com/njbrake/agent-of-empires) for about half a month, I think it's worth a proper write-up. The name is a bit grand (AoE for short), but what it does is quite practical: rather than building an entire "AI IDE" from scratch, it builds on `tmux` and `git worktree` — tools that already work great — to create a session manager specifically for AI agents. AoE recently hit v1.0.0 and has become quite mature overall.

Repository links:

- Upstream: <https://github.com/njbrake/agent-of-empires>
- My fork: <https://github.com/jtianling/agent-of-empires>

<!-- more -->

### In One Sentence

`Agent of Empires` is essentially an AI agent dispatch panel for your terminal. It runs different agents in their own `tmux sessions` and can leverage `git worktree` to work on multiple branches of the same project simultaneously. Currently supported agents include Claude Code, Codex CLI, Gemini CLI, OpenCode, Cursor CLI, Copilot CLI, Mistral Vibe, Pi.dev, Factory Droid CLI, and more — basically all the mainstream terminal AI agents are covered.

### Why I Find It Interesting

When doing AI-assisted programming nowadays, the natural workflow is no longer "me and one agent going back and forth." Instead, it's more like:

- One agent writing features
- One agent running tests or fixing lint
- One agent doing code review
- Another agent looking up docs or organizing thoughts

In this scenario, just opening lots of terminal tabs technically works, but you quickly run into problems: directories get mixed up, branches get crossed, state is hard to track after closing windows, and it's not easy to tell at a glance whether an agent is busy, waiting, or finished.

`Agent of Empires` takes a systematic approach to these problems. Here are the features I find most practical:

- Built on `tmux`, so sessions persist — agents keep running after you close the TUI
- Integrates with `git worktree` for parallel work on different branches
- Has both a TUI and CLI — you don't need to stay in the interface full-time
- Shows agent status (Running / Waiting / Idle), and you can attach directly to take over
- Supports Docker sandbox for more isolated agent environments
- Built-in diff view to review agent git changes right in the TUI
- Supports sending messages to agents (`aoe send`) without needing to attach
- Per-project `.aoe/config.toml` for hooks and project-level settings
- Sound notifications when agent status changes

In short, it doesn't try to replace the terminal — it just makes "managing lots of agent terminals at once" much smoother.

What I personally find most valuable is that when I don't want my coding agents to keep getting interrupted, I can keep them running persistently on a Mac I use as a server. Even when I leave my desk — whether I'm commuting or at home — I can SSH into that Mac, run `aoe`, and instantly resume my entire working environment. This is also why I haven't switched to powerful local agent management tools like cmux: while local window splitting and agent management is very convenient, you can't easily resume a remote session.

### Installation and Basic Usage

The upstream README offers several installation methods. The simplest is probably:

```bash
curl -fsSL \
  https://raw.githubusercontent.com/njbrake/agent-of-empires/main/scripts/install.sh \
  | bash
```

Or if you use Homebrew or Nix:

```bash
# Homebrew
brew install aoe

# Nix
nix run github:njbrake/agent-of-empires
```

Once installed, the most direct way to start is:

```bash
aoe
```

You can also add sessions directly from the command line:

```bash
# Add a session for the current project
aoe add .

# Add a session in a new worktree / branch
aoe add . -w feat/my-feature -b

# Start in sandbox mode
aoe add --sandbox .
```

What I like most about this design is that it doesn't hide the underlying machinery. It's still `tmux sessions` underneath, so if anything goes wrong, you can always attach directly and inspect — no "close the UI, everything becomes a black box" feeling.

### Who Is It For

I think it's especially suitable for these scenarios:

- You're already comfortable with a terminal workflow, or at least don't mind `tmux`
- You run multiple AI agents on the same project
- You actively use `git worktree` or multi-branch parallel development
- You want agents that run persistently, not as one-shot Q&A tools

On the flip side, if you don't usually work in the terminal and aren't willing to accept the `tmux` layer of abstraction, the learning curve might feel steep. This tool clearly isn't made for people who never want to touch a terminal.

### What I Changed in My Fork

I started forking fairly early on, with about 90+ commits in total. Early additions included a profile mechanism, terminal title management, and various tmux interaction fixes. Currently, the changes in my fork beyond upstream focus on a few daily experience improvements:

- **Session navigation keybindings** -- The upstream AoE has fairly basic navigation between tmux sessions. I added a full suite: `Ctrl+.` / `Ctrl+,` for quick session switching (cycling across groups), number keys (1-99) to jump directly to a specific session in both TUI and tmux, and `Ctrl+b b` to go back to the previous session (similar to vim's `Ctrl+^`). Inside tmux, I also added vi-style pane navigation (`Ctrl+b h/j/k/l`), `Ctrl+;` to cycle through panes, and `Ctrl+Q` for one-key detach. With all these shortcuts combined, jumping between multiple agents feels much smoother — you rarely need to go back to the TUI list to select.

- **Notification Bar** -- Inspired by [Agent Deck](https://github.com/asheshgoplani/agent-deck), it displays real-time status of all sessions (Running / Waiting / Idle) with status icons directly in the tmux status bar. This way, even when you're attached to one agent session, you can see at a glance whether other sessions are waiting for your input, without switching back to the TUI. Combined with quick-switch, jumping to a session also automatically acknowledges the Waiting status.

- **Agent Restart** -- Press `R` to restart the agent pane directly without destroying and recreating the entire session. The main use case is agents like Claude Code that need a restart to refresh skill configurations — after editing a skill, just press one key instead of manually exiting and reopening. For Claude Code and Codex, I also implemented graceful resume restart: it persists the resume token so the agent can restore its conversation state after restarting.

- **Narrow-screen layout** -- On narrow terminals (iPhone portrait, Mac split-screen, small tmux panes), the TUI automatically hides the preview panel and shows only the session list at full width. When attaching to a session with split panes, the agent pane auto-zooms for a usable full-screen view; returning to a wide terminal auto-unzooms. Pane-switch keybindings (`Ctrl+b h/j/k/l`, `Ctrl+;`) are zoom-aware, so switching panes while zoomed re-zooms the target pane seamlessly.

### Overall Impression

After using it for about half a month, I think the most valuable thing about `Agent of Empires` isn't how many models it supports, but that it addresses a very practical problem: when AI agents go from "occasional use" to "running several in parallel," what you really need to manage is sessions, state, isolation, and context — not a fancier chat window.

Since reaching v1.0.0, the upstream completeness is quite high. With diff view, per-repo config, sound notifications, and send message all in place, daily use requires very little extra tinkering. If you already work in the terminal and have started getting used to running multiple agents in parallel, this tool is definitely worth a serious try.
