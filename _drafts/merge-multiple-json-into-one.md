---
layout: post
title: HTML5游戏的 loading速度优化
date: 2016-09-13
comments: true
categories: 编程
published: false
tags: 
- HTML5
- 游戏
- javascript
---

据说以前的页游的 loading时间一旦超过 5秒, 就会流失大量用户, 现在的微信 H5游戏既然也是页游, 既然也想很好的利用网页游戏不用安装, 即点即玩的好处, 对 loading的要求应该也是一样的.  
最近优化了一下我们的游戏, 用到了一些手段, 这里收集整理如下.

<!-- more -->

**目录**:

* TOC
{:toc}

# 调试和验证方法
1. 在 chrome中开启 developer工具后, 选择 Network, 查看每个资源载入的时间和大小, 用于查看各个资源的大小和载入时间, 可以排序选择最大的入手.
2. 在 chrome中开启 developer工具后, 选择 Timeline, 然后刷新网页, 会自定 record, 出现比较直观的时间流程图, 可以看到各个脚本应该并行加载的时候正的并行, 看到每次 HTTP的交互是否是必要的, 是否可以合并.
3. 自己在各个程序运行的关键点输出时间, 主要用于脚本载入以后, 脚本执行初始化流程, 包括登录验证等逻辑流程,  直到游戏画面正常出现过程中的优化.

# loading速度优化的主要方法
## 减少资源的载入大小
这个是最核心和关键的因素. 你 loading 10M的资源, 怎么优化也优化不过只 loading 10K的.  

这里特别明确一下的目的, 我们需要的是将玩家进入游戏的 loading等待之间尽量缩短, 也就是说, 把进入游戏前 loading的资源尽量缩小就好了, 进入游戏以后, 再异步 loading的资源和原来其实差不多大, 但是玩家进入游戏的体验还是提升了.

图片资源, 游戏配置文件, UI布局文件, 都只 loading游戏启动必要的部分, 其他可以留到需要的时候再加载.

代码本身, 在稍微大规模项目中, 在将图片和配置减少到一定程度, 代码反而会成为最大的资源, 目前没有特别好的优化手段, 考虑过将代码模块化, 特别是 UI部分的代码, 实现 UI操作的时候动态载入运行, 理论上可行, 没有验证. 

## 减少 HTTP的交互次数
因为 HTTP的交互比较慢, 减少交互的次数可以显著提高载入速度.  

对于图片, 载入期必要图片都应该打包成图集, 最好是能打包成 1个文件, 我们项目中最后做到了, 我命名为 gamemin, 这个图集可以进一步的考虑压缩, 比如 png8.

游戏配置, 成规模的项目, 又是策划写 excel导出的话, 往往有几十个, 可以合并成一个, 去掉空格换行等. 为此我写了个合并工具:


# CDN的配置
首先 CDN 需要支持和开启 gzip 压缩, 并且在源栈配置好合适的类型, js和 json都是可以通过 gzip 压缩的, 效果明显.  

看 headers的话, js是
Content-Encoding:gzip
Content-Type:application/x-javascripto

json是
Content-Encoding:gzip
Content-Type:application/json

表示已经开启了 gzip 压缩, 实际传输大小可以减少很多.  在


# 更进一步 (未验证 0 





# 安装及使用

在 [Github](https://github.com/jtianling/toc-auto-add)上下载源码, 在 target/release目录中有编译好的程序. 实际使用的时候, 用文件名作为参数执行程序, 即可:

~~~ bash
$./toc-auto-add filename.md
~~~

假如想要执行多个文件, 可以一次传递进去, 如下面这样:

~~~ bash
$./toc-auto-add filename1.md filename2.md filename3.md
~~~

假如想要执行目录下非常多的文件, 就没有在本程序中实现了, 按照 Unix的哲学, 你可以使用其他程序组合起来使用, 比如下面这样, 就是转换本目录下所有的 md文件:

~~~ bash
$ls *.md | xargs -tI {} ./toc-auto-add {}
~~~

需要重复执行的话, 请用上面的命令自行制作 sh文件即可.

# 使用须知
对于没有耐心看完原理的人, 也不会自己去修改源代码满足自己需求, 希望直接用, 需要理解这个工具因为是为我自己写的, 所以有比较强的环境依赖, 需要满足以下条件:

1. 需要有`<!-- more -->`锚点, 工具才知道把 toc添加到什么位置
2. 要想文章后的链接有效, 必须使用 redcarpet这个 markdown的 html生成引擎
3. 假如有代码的话, 请用`~~~`这种形式, 也就是老外说的**fenced code blocks**形式
4. 我分析文章实际是没有 markdown那么强大, 就是简单的文本分析, 请在标题中不要再使用类似`**`强调这种 markdown语法了, 会导致链接生成错误
5. 添加一次以后, 文章更新以后, 只要保证 toc区域没有被破坏, 可重复执行以刷新 toc内容

假如你同样是使用 Github Pages, 那么相关配置大概是这样子的:

~~~ yaml
markdown:      redcarpet
markdown_ext:  md

excerpt_separator: "<!-- more -->"

redcarpet:
  extensions: ["fenced_code_blocks", "with_toc_data"]
~~~

# 说明
在新版本的 github page中, 默认使用了 kramdown这个 markdown解析引擎, 直接可支持 toc, 我这个工具已经不需要使用了. 使用了 kramdown后, 只需要添加以下文字, 会自动生成目录:

~~~
* TOC
{:toc}
~~~

