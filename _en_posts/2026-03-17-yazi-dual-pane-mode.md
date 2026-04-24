---
layout: post_en
title: "dual-yazi: Adding the Dual-Pane Mode I Wanted to Yazi"
date: 2026-03-17 21:13:55 +0800
comments: true
categories: Programming
published: true
tags:
  - Rust
  - Yazi
  - TUI
  - File Manager
  - Open Source
---

While managing files in the terminal recently, I've been feeling a bit torn: on one hand, [Yazi](https://github.com/sxyazi/yazi), as a next-generation terminal file manager, is genuinely excellent — fast, with great preview capabilities, and a flexible plugin system; on the other hand, if you've spent years using dual-pane file managers like Midnight Commander or Total Commander as I have, many operational habits are already ingrained in your muscle memory.

So I went ahead and forked Yazi to create `dual-yazi`: <https://github.com/jtianling/dual-yazi>. It's not a ground-up rewrite of a file manager, but rather an added workflow layer on top of the original Yazi that I wanted most: fixed dual panes, independent tabs per pane, direct cross-pane copy/move, and toggling between single-pane/dual-pane and preview modes.

For me, this was a natural direction. I love Yazi's modern TUI file management experience, but I've always missed the directness of traditional dual-pane managers — having two directories side by side, always in view. Now I've finally brought these two worlds together.

![dual-yazi dual-pane mode screenshot](/public/images/2026/dual-yazi-screenshot.png)

Repository links:

- Yazi official repository: <https://github.com/sxyazi/yazi>
- My fork: <https://github.com/jtianling/dual-yazi>

<!-- more -->

### Why Yazi Is Worth the Effort

If you haven't tried Yazi yet, I think it's one of the most worthwhile terminal file managers to try in recent years.

The official README lists many features, but what I personally value most are: it's genuinely fast, with thorough async I/O and task scheduling; the preview capabilities are comprehensive — not just text, but images, PDFs, archives, and syntax-highlighted code are all covered; and the Lua plugin system is open enough that you never feel like "there are lots of features, but I can't modify anything."

In other words, it's not a simple tool that can only do basic `hjkl` directory browsing, but a terminal file manager that can seriously serve as a daily driver. The reason I want to add dual-pane support is precisely because I think the core is already good enough to build my desired interaction on top of.

### Why I Still Want Dual Panes

Tabs are useful, of course, and single-pane + preview already covers many scenarios. But it's still different from a true dual-pane workflow.

For tasks like sorting a downloads directory, comparing two directory structures, filtering files from one location to move to another, or archiving files while browsing a project directory, the dual-pane mental model is simply more direct: left is source, right is target, whichever pane has focus is where operations take effect. You don't need to constantly remember "which tab was my target directory in," and you don't need to switch back and forth to confirm your current context.

This is why many classic file managers still have loyal users today. They may not be the most modern, but for the problem of "batch file management," the workflow is incredibly smooth.

### What dual-yazi Has Now

### 1. Dual-Pane Mode

The program starts in fixed dual-pane mode by default, with a pane on each side and the left pane focused initially. Each pane has its own header and status bar, so it's not simply slicing the original interface in half — each pane is treated as a complete browsing context.

The default dual-pane layout favors directory browsing: each pane shows `parent + current`, meaning the parent directory column plus the current directory column, with preview hidden by default. The reason is simple — in dual-pane mode, the most common need is usually quick operations between two directories, not viewing large previews.

Pane switching follows familiar conventions:

- `Tab`
- `Ctrl-w w`
- `Ctrl-w Ctrl-w`
- `Ctrl-w h`
- `Ctrl-w l`

### 2. Per-Pane Independent Tabs

Dual panes and tabs are not mutually exclusive. In `dual-yazi`, each pane independently maintains its own set of tabs, with its own tab cursor and state. This means you don't just have two fixed directories — you effectively have two independent workspaces that don't interfere with each other.

I really like this aspect. For example, the left pane can permanently hold tabs for source code, documents, and downloads, while the right pane holds tabs for archives, temporary directories, and target directories. The directness of traditional dual-pane file managers is preserved, but with an additional layer of flexible organization.

More importantly, Yazi's original tab operations are mostly preserved. The default keymap includes:

- `t` to create a new tab
- `Ctrl-c` to close the current tab; exits if it's the last tab
- `1-9` to switch tabs
- `[` / `]` to cycle through tabs
- `{` / `}` to swap tabs

The `tab_rename` action still exists but doesn't have a default keybinding — you can bind it yourself in the keymap if needed.

All these operations now apply to the current pane rather than sharing a global tab list.

### 3. Cross-Pane Copy/Move (MC-style F5/F6)

This was one of the features I most wanted to add.

The original Yazi already has the `y` / `p` yank/paste workflow, which works well. But if you're used to dual-pane managers where you select items on the left and press F5 to copy to the right or F6 to move — you'd want it as a single-key action, not yank, switch pane, then paste.

Here's what's provided:

- `F5`: Copy selected items to the other pane's current directory
- `F6`: Move selected items to the other pane's current directory

These are direct cross-pane operations that don't go through the yank register. If nothing is explicitly selected, they operate on the hovered file. The advantage is that it doesn't disrupt the existing `y` / `p` workflow, while providing more MC-like muscle memory in the dual-pane context.

I also mapped `F7` / `F8` to more traditional semantics: `F7` creates a file or directory, `F8` trashes items; for permanent deletion, use the original `D`. With this setup, the terminal file management experience really does feel more like a classic dual-pane manager.

### 4. Single/Dual Toggle

While I want dual panes most of the time, it's not always necessary to see both sides.

`Ctrl-w o` toggles between dual-pane and single-pane mode. One thing I care about here: when switching to single-pane, the other pane isn't reset — just hidden. Its directory, cursor, selection, and history are all preserved. Switching back to dual-pane restores everything as it was.

This means single-pane mode isn't "exiting dual-pane" but rather "temporarily focusing attention on the current pane." You can go single-pane when you need the full width to view content, then switch back to dual-pane for two-directory operations without any context loss.

Also, in single-pane mode, the pane concept still exists. You can still switch the active pane, and you can still target `F5` / `F6` at the currently hidden pane. I find this quite practical.

### 5. Preview Toggle

Dual-pane mode defaults to directory browsing, but sometimes you want a quick preview.

`Ctrl-w p` toggles between two layouts in dual-pane mode:

- Directory mode: `parent + current`
- Preview mode: `current + preview`

This means you can switch both sides to a more "content viewing" layout without leaving dual-pane mode. Use directory mode while organizing files, switch to preview mode when you need to check file contents — both stay within the dual-pane workflow.

I find this more ergonomic than a fixed dual-pane layout. Otherwise, dual-pane easily becomes a mode that can only "move files" rather than a main interface you can use long-term.

### 6. Undo/Redo

This feature is also crucial.

`F5` / `F6` in a dual-pane manager are very convenient, but to confidently manage files in bulk, you need an "undo button." `dual-yazi` now supports `u` for undo and `Ctrl-r` for redo. Not just rename, create, copy, move, and trash — the `copy_to` / `move_to` operations from dual-pane mode also go into the undo stack.

Of course, undo currently isn't universal. Permanent delete `D`, shell commands, bulk rename, and operations performed by plugins are not covered by this undo system. But for the file management actions I use most frequently, it's more than sufficient.

### How to Try It

This is still a fork, and I haven't set up a full release process for it yet. If you're comfortable installing Rust projects from source, just go ahead:

```bash
git clone https://github.com/jtianling/dual-yazi.git
cd dual-yazi
cargo install --path ./yazi-fm
yazi
```

If you're already using the original Yazi, you can treat this as an experimental branch to try. Whether or not you like the dual-pane workflow, half an hour of use should be enough to tell.

In short, I'm not trying to prove that "dual-pane is inherently better than single-pane." I just wanted to bring a file management habit I've used for many years back into a modern tool I already love. For me, `dual-yazi` is one step closer to fitting Yazi into my daily workflow.

If you also like Yazi's speed, preview capabilities, and plugin system, but can't quite let go of the directness of dual-pane file managers, give this fork a try.

### Why a Fork, Not a Plugin

One more note: initially, I actually tried to build this using Yazi's built-in plugin system. The plugin route would be friendlier to users and wouldn't require rebasing against upstream every time, so by all accounts it should have been the preferred approach.

But once I actually started, I realized Yazi's plugins are essentially Lua scripts running on top of a Rust state machine: they can draw UI and compose existing commands, but they can't change the underlying data structures, and they can't add new commands. The things I wanted — independent tabs per pane, one-key cross-pane copy/move, single/dual toggle, preview toggle inside dual mode, undo/redo — pretty much all required changes at that lower level. It wasn't something a layout tweak could solve.

There are pure-plugin attempts out there, which take the approach of drawing the two existing tabs side by side. Visually it looks like dual-pane, but "switching panes" is really just switching tabs, cross-pane copy has to be simulated with "switch over → paste → switch back" (visible flicker), and you can't have truly independent tabs on each side. It ends up feeling more like a "two-view viewer" than a real dual-pane file manager.

So in the end I went with the fork. The cost is keeping it in sync with upstream myself, but in exchange every interaction can be shaped exactly the way I want. For me, that trade-off is worth it.

