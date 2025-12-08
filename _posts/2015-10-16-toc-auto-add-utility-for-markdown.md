---
layout: post
title: 发布一个自动为Markdown文章添加目录的工具
date: 2015-10-16
comments: true
categories: 编程
published: true
tags: 
- Markdown
- Github Pages
- TOC
- Rust
---

因为多次看到有人在博客上说Rust的好, 最近学习了下Rust, 作为练习, 照例是要找个东西来做, 碰巧想给我的博客文章都添加一下目录(英文缩写TOC, table of content) , 于是想到了用Rust来写这个, 虽然这种任务我以前肯定是用Ruby来做, Ruby作为动态类型语言也更适合做这种工作.  本文相当于是个发布通告和使用说明, 具体的可以在[我的Github](https://github.com/jtianling/toc-auto-add)上找到源码和编译好的程序.

<!-- more -->

**目录**:

* TOC
{:toc}

# 为什么需要一个这样的工具
我的博客原来是有目录生成工具的, 依赖的是Kramdown(好像是)这个Markdown解析引擎, 但是这个解析引擎有些其他的问题(忘了什么问题了, 印象中是代码块解析不好), 所以我后来换成了Redcarpet, Redcarpet支持TOC, 但是只是在生成的HTML中含有每个目录的id, 而没有TOC本身的生成功能, 网上有很多解决方案, 不管是用Javascript动态生成还是静态生成, 都有些不太好的地方, 具体就不展开说了.  反正是能搜到很多, 但是我发现实际能用的没有一个.  

# 原理
这个工具, 目录内容本身是基于分析文章本身, 并且只分析两层, 即以#和##开头的标题.  

目录的链接基于Redcarpet这个生成工具生成的HTML, 在分析目录的时候, 会跳过`~~~`标注的代码(其他形式的代码块, 要是是类似Ruby这种注释也是#开头的, 会把代码的注释看作是文章的标题.)

实现的方式是在`<!-- more -->`标签后, 添加成对的`<!-- toc-begin -->`, `<!-- toc-end -->`标签, 实际目录在两个标签中.  
通过jeklly生成以后的效果(也就是Github Pages实际的效果)可以参考本文的目录, 更复杂的可以去本博客的其他文章中查看(新写的都添加了), 比如这篇[那篇文章](/write-blog-with-jekyll-and-github-pages.html), 效果我还算满意.

# 安装及使用

在[Github](https://github.com/jtianling/toc-auto-add)上下载源码, 在target/release目录中有编译好的程序. 实际使用的时候, 用文件名作为参数执行程序, 即可:

~~~ bash
$./toc-auto-add filename.md
~~~

假如想要执行多个文件, 可以一次传递进去, 如下面这样:

~~~ bash
$./toc-auto-add filename1.md filename2.md filename3.md
~~~

假如想要执行目录下非常多的文件, 就没有在本程序中实现了, 按照Unix的哲学, 你可以使用其他程序组合起来使用, 比如下面这样, 就是转换本目录下所有的md文件:

~~~ bash
$ls *.md | xargs -tI {} ./toc-auto-add {}
~~~

需要重复执行的话, 请用上面的命令自行制作sh文件即可.

# 使用须知
对于没有耐心看完原理的人, 也不会自己去修改源代码满足自己需求, 希望直接用, 需要理解这个工具因为是为我自己写的, 所以有比较强的环境依赖, 需要满足以下条件:

1. 需要有`<!-- more -->`锚点, 工具才知道把toc添加到什么位置
2. 要想文章后的链接有效, 必须使用redcarpet这个markdown的html生成引擎
3. 假如有代码的话, 请用`~~~`这种形式, 也就是老外说的**fenced code blocks**形式
4. 我分析文章实际是没有markdown那么强大, 就是简单的文本分析, 请在标题中不要再使用类似`**`强调这种markdown语法了, 会导致链接生成错误
5. 添加一次以后, 文章更新以后, 只要保证toc区域没有被破坏, 可重复执行以刷新toc内容

假如你同样是使用Github Pages, 那么相关配置大概是这样子的:

~~~ yaml
markdown:      redcarpet
markdown_ext:  md

excerpt_separator: "<!-- more -->"

redcarpet:
  extensions: ["fenced_code_blocks", "with_toc_data"]
~~~

# 说明
在新版本的github page中, 默认使用了kramdown这个markdown解析引擎, 直接可支持toc, 我这个工具已经不需要使用了. 使用了kramdown后, 只需要添加以下文字, 会自动生成目录:

~~~
* TOC
{:toc}
~~~

