---
layout: post_en
title: "net-use Released: Monitor Which IPs a macOS App Actually Connects To"
date: 2026-03-13 14:52:52 +0800
comments: true
categories: Programming
published: true
tags:
- macOS
- Rust
- Networking
- Firewall
- net-use
---

Sometimes when setting up a firewall whitelist for an app, the hardest part isn't configuring rules — it's not knowing which addresses the app actually connects to. And many modern apps aren't just a single main process; they spawn helpers, renderers, crash reporters, and other child processes, so monitoring a single PID often isn't enough. So I wrote a small tool called `net-use` that tracks the remote IPs accessed by a specified app and its entire process tree in real time, outputting deduplicated results.

Repository: <https://github.com/jtianling/net-use>

<!-- more -->

### In One Sentence

`net-use` is a network connection monitoring tool for macOS. It uses the `proc_pidfdinfo` system call to enumerate socket information, capturing TCP/UDP remote addresses accessed by a specified app and all its child processes in real time. To better suit the firewall whitelist use case, IPv4 addresses are aggregated to `/24` subnets by default, while IPv6 addresses are kept in full.

### Why I Built This

My need was simple: I wanted to know what addresses an app is actually accessing and compile the results into a whitelist I can use directly.

For a quick glance at network connections, there are plenty of tools that can get the job done. But once you need to pin it down to a specific app — especially a desktop app that spawns many child processes — things get complicated: processes change, PIDs change, connections appear dynamically, and you have to deduplicate manually. So I just built a dedicated tool for this.

### Usage

Installation:

```bash
cargo install net-use
```

The simplest way is to launch TUI mode directly:

```bash
sudo net-use
```

After launching, you can browse installed apps, filter by typing, and press Enter to start monitoring. During monitoring, you can export to a file, copy to clipboard, toggle sort order, and switch between subnet-aggregated and raw IP display.

If you prefer not to use the interface, you can go straight to CLI:

```bash
# Monitor by Bundle ID
sudo net-use --bundle com.google.Chrome --no-tui

# Monitor by process name
sudo net-use --name curl --no-tui

# Monitor by PID
sudo net-use --pid 1234 --no-tui
```

Output is a deduplicated address list, for example:

```text
142.250.80.0/24
172.217.14.0/24
2607:f8b0:4004:800::200e
```

Ready to use directly as a whitelist.

### A Few Other Useful Features

- Can monitor apps that haven't launched yet — starts collecting automatically once they start
- Historical data persists after the app exits; data continues to accumulate when it reappears
- Supports pause/resume monitoring
- Supports persisting historical results to a file

### Limitations

This tool currently only supports macOS and requires `sudo`, since reading process socket information requires elevated privileges.

It's also polling-based, defaulting to once every 200ms, so extremely short-lived connections could theoretically be missed. Additionally, some XPC services launched via `launchd` may not fall entirely within the same process tree — that's another current limitation.

In short, if you also have the need to know "which IPs an app is actually connecting to," give it a try. For me at least, I finally don't have to stare at Activity Monitor while manually compiling whitelists anymore.
