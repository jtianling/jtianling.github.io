---
layout: post
title: "正则表达式测试器0.2(Boost Regex Tester 0.2)(老版保留)"
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
  views: '22'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---


昨晚痛苦的写了一个0.2版的程序，为什么痛苦？其实处理一些字符串，完成一些简单的菜单功能，让匹配的规则可以定义都不是什么难事。痛苦的是CEdit中用SetSel选择了文本以后MFC不会自动的为本文加亮，需要手动完成，我完成的想自杀，最后终于算是能够处理一排文本了，不过要处理多行文本还有待再努力，估计其中又会想自杀n次。没有想通这么我想都没有想到，很自然的问题，微软竟然不管，我发现这个问题都用了半天，总以为自己的SetSel索引搞错，哎。。。。难怪人都说MFC复杂。有高手知道怎么简单的处理SetSel文本加亮问题的请指教。最好自己先试试，网上这个问题我看了很多，用CtlColor函数响应反射消息的方法也试过，不过好像没有办法处理一段特定的文本。最后只能用最最原始的方法手动完成。痛苦。痛苦。

不过0.2版的程序倒是感觉还比较满意，大家试试，一般的正则表达式学习和验证估计都够了，而且在用Boost编程之前用这个先试一下可以节省很多编译的时间，我当时就是为这个而编的这个程序。

编译好的文件和源代码都在老地方http://groups.google.com/group/jiutianfile/files有下，因为是MFC程序，比较大，我一般不列出来了。来个程序截图。
![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/Boost Regex Tester 0.2.jpg)
