---
layout: post
title: Windows中多指针输入技术的实现与应用(7 分时多鼠标控制系统鼠标的问题)
categories:
- "我的程序"
tags:
- Windows
- "多鼠标"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '1'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

## Windows中多指针输入技术的实现与应用(7 分时多鼠标控制系统鼠标的问题) 

## 湖南大学 谢祁衡

在此以CPNMOUSE为例，看截图就都知道了，简而言之就是当同时操作两个鼠标的时候会导致混乱,我提供的建议是，你可以考虑完全不管系统鼠标，完全自己控制每个鼠标的输入数据，或者，你可以像SDG Toolkit那样，将系统鼠标的控制权交在某一个鼠标手中，由系统控制，而其他鼠标的输入数据完全由自己控制。

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/CPNMOUSE 问题1.JPG)

 

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/CPNMOUSE 问题3.JPG)![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/CPNMOUSE 问题4.JPG)![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/CPNMOUSE 问题5.JPG)