---
layout: post
title: net-use 发布：监控 macOS app 实际访问了哪些 IP
date: 2026-03-13
comments: true
categories: 编程
published: true
tags:
- macOS
- Rust
- 网络
- 防火墙
- net-use
---

有时候想给某个 app 配防火墙白名单, 最麻烦的不是配规则, 而是根本不知道它到底连了哪些地址. 而且现在很多 app 都不只是一个主进程, 还会拉起 helper, renderer, crash reporter 之类的子进程, 只盯着一个 PID 往往不够. 于是写了个小工具 `net-use`, 用来实时追踪指定 app 及其整个子进程树访问过的远端 IP, 并把结果去重输出出来.

仓库地址：<https://github.com/jtianling/net-use>

<!-- more -->

### 一句话说明

`net-use` 是一个 macOS 上的应用网络连接监控工具. 它基于 `proc_pidfdinfo` 系统调用枚举 socket 信息, 能实时抓到指定 app 以及它的所有子进程访问过的 TCP/UDP 远端地址. 为了更适合防火墙白名单这个场景, IPv4 默认会聚合成 `/24` 子网, IPv6 则保留完整地址.

### 为什么做这个

我自己的需求很简单, 就是想知道一个 app 实际在访问什么地方, 并且把结果整理成一份后续可直接使用的白名单.

如果只是临时看一下网络连接, 其实有很多工具能凑合用. 但是一旦要落到具体 app 上, 尤其是桌面 app 还会拉起很多子进程的时候, 事情就开始变麻烦了: 进程会变, PID 会变, 连接是动态出现的, 还要自己做去重. 所以干脆写了一个专门做这件事情的小工具.

### 使用

安装:

```bash
cargo install net-use
```

最简单的用法是直接进入 TUI 模式:

```bash
sudo net-use
```

启动后可以浏览本机已安装 app, 输入文字筛选, 回车选中以后开始监控. 监控过程中支持导出到文件、复制到剪贴板、切换排序方式, 也可以在子网聚合显示和原始 IP 显示之间切换.

如果你不想进界面, 也可以直接走 CLI:

```bash
# 按 Bundle ID 监控
sudo net-use --bundle com.google.Chrome --no-tui

# 按进程名监控
sudo net-use --name curl --no-tui

# 按 PID 监控
sudo net-use --pid 1234 --no-tui
```

输出是去重后的地址列表, 例如:

```text
142.250.80.0/24
172.217.14.0/24
2607:f8b0:4004:800::200e
```

这样拿去做白名单就比较直接了.

### 另外几个我觉得比较有用的点

- 支持监控尚未启动的 app, 检测到启动后自动开始采集
- app 退出后历史数据不会丢, 下次再出现会继续累加
- 可以暂停/恢复监控
- 支持把历史结果持久化到文件

### 限制

这个工具目前只支持 macOS, 并且需要 `sudo`, 因为读取进程 socket 信息本身就需要权限.

另外它是基于轮询实现的, 默认 200ms 一次, 所以生命周期特别短的连接理论上还是可能漏掉. 再有就是某些通过 `launchd` 拉起的 XPC service, 不一定能完全落在同一棵进程树里, 这也是目前的一个限制.

总之, 如果你也有“一个 app 到底连了哪些 IP”这种需求, 可以试试看. 对我自己来说, 至少终于不用一边盯 Activity Monitor, 一边再手动整理白名单了.
