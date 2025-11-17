---
layout: post
title: "正则表达式测试器0.4(Boost Regex Tester 0.4) （最新版本）"
categories:
- "我的程序"
tags:
- "正则表达式"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '19'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

这个死程序从年尾做到年头，中间过年休息了太久，结果就像分成两次来做一样。首次在正则表达式测试器中用了MFC的文档结构，实际上让这个本来很小的程序越来越大，而事实上功能稍微多了 一点而已。

本版本在利用Boost.Regex库实现正则表达式的功能上基本已经完整，而且使用方法上有点类似Windows内置的查找替换功能（其实那个东西就可以利用正则表达式）。余下的版本不准备再进行大的更新，仅仅准备加入常用表达式这一个内容，由于对于学习了一下OLE DB，但是感觉还比较麻烦，不知道怎么简单的插入此程序，以及其与VS 2005的联合使用，又不准备利用普通文档格式来实现，所以此功能准备等我真正学好了数据库编程后再实现。除非有重大BUG，不然我不准备在别的方面对此程序进行更新了。另外，讲此文档作为一个在线帮助文档长期更新，并在程序中加入博客链接。有任何BUG请在此文留言反应，建议也可以。

本程序的截图：）

[![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/Regex Tester0.4.jpg)](<http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/Regex Tester0.4.jpg>)

 

界面基本还算满意。另外，不得不说说编写这个程序的感受，真的感到要写一个好程序有多么累了。特别是感觉到MFC视图文档结构的复杂性，因为用了太多分割视图，UpdateAllViews的我郁闷的要死。程序源码看起来也完全没有标准C++的命令行程序那么简洁优美，看到的都是非常丑陋的代码。。。。。当然，也许和我MFC的功力不够有关。。。。。

源代码和文件都在以下下载地址

下载地址：<http://disk24.sh.com/?vagr>

原下载地址也可用：<http://groups.google.com/group/jiutianfile/files>
