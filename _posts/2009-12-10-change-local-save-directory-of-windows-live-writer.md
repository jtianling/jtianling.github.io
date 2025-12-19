---
layout: post
title: "更改windows live writer的本地保存目录"
categories:
- "未分类"
tags:
- windows live writer
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '9'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

介绍如何通过创建符号链接，来更改Windows Live Writer的草稿保存目录，方便地将文章备份到Dropbox等其他位置以防丢失。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](http://www.jtianling.com)**

[**讨论新闻组及文件**](http://groups.google.com/group/jiutianfile/)

Technorati 标签: [WLW](http://technorati.com/tags/WLW),[本地保存目录改变](http://technorati.com/tags/%e6%9c%ac%e5%9c%b0%e4%bf%9d%e5%ad%98%e7%9b%ae%e5%bd%95%e6%94%b9%e5%8f%98),[My Weblog Posts](http://technorati.com/tags/My+Weblog+Posts)

这个世界上总是有很多片让人不爽的事情，很多事情我们没有办法改变，因为程序员也没有办法控制世界的改变，虽然事实上我们在改变着世界，但是，只要这个让人不爽的事情发生在电脑上，那么，作为程序员，我们就能让这个不爽变得极爽。。。。。。呵呵，此为一例，原文来自：<http://www.ditii.com/2009/01/30/guide-to-move-windows-live-writers-my-weblog-posts-folder-onto-a-seperate-location/>

百度知道上：<http://zhidao.baidu.com/question/63748594.html>

极为误导，枪毙之。有人有百度账号的话给他回复一下，别继续误导人了。

我仅仅是大概翻译一下：

1.都是先将整个目录拷贝到你想要放在的位置。

2.

Vista/Win 7 用户：

命令行下：

`mklink /D “目前本地保存目录” “你想要的新的保存目录”`

Windows XP用户痛苦点（比如我）

先下个[Junction](http://technet.microsoft.com/en-us/sysinternals/bb896768.aspx),（好像是微软官方提供的）

`junction “目前本地保存目录” “你想要的新的保存目录”`

其中，目前本地保存的目录就是Windows live writer默认的那个My Weblog Posts

我将其放在了DropBox的目录里面。。。。。。。。。不会丢失辛苦的劳动成果了。

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](http://www.jtianling.com)**
