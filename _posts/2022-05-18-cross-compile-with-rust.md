---
layout: post
title: Rust 的交叉编译
date: 2022-05-
comments: true
categories: 编程
published: true
tags:
- 编程
- Rust
- Gameshell
---

[Rust](https://www.rust-lang.org/) 作为编译型的语言, 交叉编译挺方便的, 这样开发和部署, 都能简单挺多. 本文以在 Mac 上, 交叉编译一个使用 SDL 库的程序到一个手持 ARM 设备([clockwork Gameshell](https://www.clockworkpi.com/gameshell)) 为例, 记录一下怎么使用 Rust 的交叉编译, 特别是怎么在交叉编译的时候, 还能链接类似 SDL 这种外部的库.
Rust 的生态是比较完善的, 只是相关的资料比较少的, 基本上是一步一个坑. 除了对 Rust 自身的 Rustup 等工具的了解, 还需要用到 [Docker](https://www.docker.com/), Linux 包管理等知识, 希望对同样被困住的同学有帮助. 同时, 本文也会顺便讲讲思路, 以帮助大家将相关知识应用到其他交叉编译的场景.

<!-- more -->
# 环境
先厘清几个术语, 在交叉编译的时候, 用于编译的机器, 叫做 Host(宿主), 这里用的是我的 Mac(12.1), 用来运行程序的机器叫做 Target(目标设备), 例子中是前面提到的 Clockwork GameShell, 一个 ARM 设备.  我们的目标就是在宿主机器上编译, 然后直接在目标设备上运行编译好的程序.  
这种方式的好处是宿主可以是台式机, 编译速度快, 而目标设备可以是任意设备, 包括速度很慢, 不太适合执行编译任务的嵌入式设备.  


# 最简单的情况
假如你并不需要用其他外部库, 那可以直接使用 Rust 内置的交叉编译功能, 使用还挺简单的. 
你可以通过 ```rustup target list``` 列出当前系统支持的所有交叉编译目标, 在我的 Mac 上运行以后, 有 86 个之多, 其中会有一个默认的. 显示  

```
x86_64-apple-darwin (installed)
```

这个也是我们现在本机用的.  
这么多编译目标, 那我们应该用哪一个呢? 这里有个[官方的列表](https://doc.rust-lang.org/nightly/rustc/platform-support.html), 分为几个支持的级别, 可以直接过去看.  

同样是 Linux 和 ARM, 选择也不少. 可以在目标设备上, 用 `uname -a` 命令看到一部分信息.  

```
$ uname -a
Linux clockworkpi 5.3.6-clockworkpi-cpi3 #1 SMP Tue Oct 15 17:26:44 CST 2019 armv7l GNU/Linux
```

起码知道了是 armv7, 但是 armv7 的 target 还有几个, 后来我想到的办法是, 在目标设备上安装 Rust, 然后通过前面的命令来看.  当然, 前提是目标设备也能运行 Rust 才行, 要是不行的话, 那就只能查资料和尝试了.  
在我的目标设备, 运行前面的 ```rustup target list``` 命令后, 显示

```
armv7-unknown-linux-gnueabihf (installed)
```

稍微提醒一下, 这个是刚装完 Rust 后的情况, 你要是已经按下面的操作添加了各种 target, 那这个就不准了.  
然后, 在宿主设备上, 用以下命令  

```shell
rustup target add armv7-unknown-linux-gnueabihf
```

来添加对应的交叉编译目标.  直接编译试试  

```shell
cargo build --target armv7-unknown-linux-gnueabihf
```

到这一步, 你会看到一大堆的错误(要是这就成功了, 那我就不写这篇文章了)  

```
error: linking with `cc` failed: exit status: 1
  |
  = note: "cc"
= note: clang: warning: argument unused during compilation: '-pie' [-Wunused-command-line-argument]
          ld: unknown option: --as-needed
          clang: error: linker command failed with exit code 1 (use -v to see invocation)
```

基本上的意思, 就是虽然编译是好了, 但是链接的时候发生错误了, 原因在于现在明显是使用了宿主的链接器(linker), 而不是对应的目标设备的链接器.

这里有几种解决办法
1. 手动下载目标的链接器, 参考[这篇](https://john-millikin.com/notes-on-cross-compiling-rust)
2. 直接用 brew 安装一下链接器 (不一定所有 target 都有).  参考[这篇](https://sigmaris.info/blog/2019/02/cross-compiling-rust-on-mac-os-for-an-arm-linux-router/), 

我这里是 ARM 设备, `brew` 是有的, 为了简单, 我直接用 `brew` 命令安装了  

```
brew install arm-linux-gnueabihf-binutils
```

然后, 在 `~/.cargo/config` 中, 添加如下两行配置, 修改对应 target 的链接器设置

```toml
[target.armv7-unknown-linux-gnueabihf]
linker = "arm-linux-gnueabihf-ld"
```

再用前面的命令编译试试, 此时还是会报错:  

```
  = note: arm-linux-gnueabihf-ld: cannot find -lgcc_s: No such file or directory
          arm-linux-gnueabihf-ld: cannot find -lutil: No such file or directory
          arm-linux-gnueabihf-ld: cannot find -lrt: No such file or directory
          arm-linux-gnueabihf-ld: cannot find -lpthread: No such file or directory
          arm-linux-gnueabihf-ld: cannot find -lm: No such file or directory
          arm-linux-gnueabihf-ld: cannot find -ldl: No such file or directory
          arm-linux-gnueabihf-ld: cannot find -lc: No such file or directory
```

简单的原因, 就是一切就绪了, 但是对应的一些 gnu 基础库找不到. 此时可以去找到对应的库都下到本地, 还有, 我找到一个神奇的方法, 换成 `armv7-unknown-linux-musleabihf` 这个 target, 这里用了 [musl](https://zh.m.wikipedia.org/zh/Musl) 这个库, 就不需要用 gnu 的那些库了.

```
% cargo build --target=armv7-unknown-linux-musleabihf
    Finished dev [unoptimized + debuginfo] target(s) in 0.08s
```

编译后, 你可以可以在工程的 `target/armv7-unknown-linux-musleabihf` 目录下面, 找到交叉编译后的文件. 在目标设备上实测运行, 是可以运行的.  
最后这种方式, 是绕过了配置链接需要的库, 理论上, 手动下载回来然后配置正确的话, 可以在 Mac 上直接编译链接成功, 应该会非常麻烦.  
当我准备使用 SDL 这种库, 一定需要配置正确链接的库时, 这种方法就不好用了.  
接下来, 介绍一种更全面的方法.  

# 使用 cross-rs
这个方式, 也是我个人比较推荐的方式, 万能, 而且是利用 Docker 环境来编译, 不需要在本地装一大堆纯为了编译的各种库, 当然, 代价是得装 Docker, 而众所周知, Docker 的 image 动不动就几个 G 的大小.-_-! 可能好处就是不用的时候, 清理起来方便一些了.   
而且, 使用 Docker, 可以直接基于 Ubuntu 这种 Linux 环境, apt 的包管理感觉比 Mac  的 brew 还是要更强大.  
对了, 其实接下来的步骤, 虽然是利用了 Docker, 但是除了 Docker 的部分, 也可以看做是在 Linux 上使用 Rust 交叉编译的过程. 假如你的宿主机本身是 Linux 的话, 那这些方法也是可以直接使用的(就不用 Docker 了), 怎么说呢, 果然 Linux 才是对开发者最友好的系统.  

## 安装 cross-rs
参考 [cross-rs 的页面](https://github.com/cross-rs/cross), 每一步都相对清晰.
安装 cross-rs 

```
$ cargo install cross
```

然后, 在交叉编译的时候, 直接用 `cross` 命令, 替换掉 `cargo`. 比如我们前面的那个简单例子, 在安装 cross-rs 后, 改成用 `cross` 命令. 

```
% cross build --target=armv7-unknown-linux-gnueabihf
```

在下载了一个 Docker image 后, 直接就成功了...有点意外加惊喜.  
此时, 能看到多了一个用于编译 armv7-unknown-linux-gnueabihf 的 docker image.

```
% docker image list
rustembedded/cross   armv7-unknown-linux-gnueabihf-0.2.1
```

## 链接外部库
这里用 SDL 为例子, 演示怎么加载外部库.  
首先随便找个 [SDL 的例子](https://sunjay.dev/learn-game-dev/opening-a-window.html).
然后继续按上面的 `cross` 命令编译, 会报链接错误  
```
  = note: /usr/lib/gcc-cross/arm-linux-gnueabihf/5/../../../../arm-linux-gnueabihf/bin/ld: cannot find -lSDL2
          /usr/lib/gcc-cross/arm-linux-gnueabihf/5/../../../../arm-linux-gnueabihf/bin/ld: cannot find -lSDL2_mixer
          /usr/lib/gcc-cross/arm-linux-gnueabihf/5/../../../../arm-linux-gnueabihf/bin/ld: cannot find -lSDL2_image
          /usr/lib/gcc-cross/arm-linux-gnueabihf/5/../../../../arm-linux-gnueabihf/bin/ld: cannot find -lSDL2_ttf
          /usr/lib/gcc-cross/arm-linux-gnueabihf/5/../../../../arm-linux-gnueabihf/bin/ld: cannot find -lSDL2_gfx
          collect2: error: ld returned 1 exit status
```

很明显, 就是前面多次碰到的找不到对应的动态库.  不过这次我们解决这个问题.  
前面我们已经能看到默认情况下, cross-rs 会给我们添加一个 image, 但是这个 image 里面没有我们需要的库.  我们来添加一下.  

### 1. 交互式运行这个 image, 创建一个 container
```
% docker run -i -t rustembedded/cross:armv7-unknown-linux-gnueabihf-0.2.1 /bin/bash
```

### 2. 在 container 中添加我们需要的库
```
# apt-get update
# dpkg --add-architecture armhf
# apt-get update
# apt-get install libsdl2-dev:armhf libsdl2-mixer-dev:armhf libsdl2-ttf-dev:armhf libsdl2-image-dev:armhf libsdl2-gfx-dev:armhf
```
这里是以 SDL 为例, 其中 `dpkg --add-architecture armhf` 的这一步, 很关键, 因为 Docker 运行的也不是目标设备的系统, 后面的 `apt-get install` 的时候, 也用了 `:armhf` 的后缀, 表示安装的是针对 ARM 的对应包. 要是没有这几步, 直接用 `apt-get` 安装也是没有用的.

### 3. 用这个做好的 container 来创建我们自定义的 image
```
% docker ps
CONTAINER ID   IMAGE                                                    COMMAND       CREATED          STATUS          PORTS     NAMES
98744316d89e   rustembedded/cross:armv7-unknown-linux-gnueabihf-0.2.1   "/bin/bash"   19 minutes ago   Up 19 minutes             naughty_mccarthy
```
此时, 注意我们正在运行的container id.

```
% docker commit 98744316d89e my/clockwork
```

### 4. 然后指定 cross-rs 使用我们自定义的 image
在工程中, 增加一个 `Cross.toml` 文件, 内容如下:
```toml
[target.armv7-unknown-linux-gnueabihf]
image = "my/clockwork"
```

准备就绪, 再次使用
```
% cross build --target=armv7-unknown-linux-gnueabihf
```
编译, 搞定. 此时可以将编译好的程序拷贝到目标设备上运行, 没有问题.
最后, 因为本身就是配置一个编译环境, 直接交互式运行 image 还是挺方便的, 以后有更多依赖库的时候, 重复上述步骤即可.


# 参考

1. [The rustup book](https://rust-lang.github.io/rustup)  
2. [cross-rs](https://github.com/cross-rs/cross)
3. [Notes on cross-compiling Rust](https://john-millikin.com/notes-on-cross-compiling-rust)
4. [Cross compiling Rust on Mac OS for an ARM Linux router](https://sigmaris.info/blog/2019/02/cross-compiling-rust-on-mac-os-for-an-arm-linux-router/)
5. [Learn Game Development in Rust](https://sunjay.dev/learn-game-dev/intro.html)