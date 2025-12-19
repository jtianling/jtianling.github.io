---
layout: post
title: Windows下多鼠标/双鼠标技术专题
categories:
- Windows
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
  views: '18'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文系列基于毕业论文，详细阐述了在Windows中实现多鼠标输入的技术方法与应用实践。

<!-- more -->

Technorati 标签: [Windows](<http://technorati.com/tags/Windows>),[MultiPoint](<http://technorati.com/tags/MultiPoint>),[多鼠标](<http://technorati.com/tags/%e5%a4%9a%e9%bc%a0%e6%a0%87>),[多指针输入](<http://technorati.com/tags/%e5%a4%9a%e6%8c%87%e9%92%88%e8%be%93%e5%85%a5>),[SDG](<http://technorati.com/tags/SDG>),[Mouse](<http://technorati.com/tags/Mouse>),[RawInput](<http://technorati.com/tags/RawInput>)

首先要说的是，此文的主要内容都来自本人在湖南大学郑善贤老师指导下写的毕业论文

可以在此<http://groups.google.com/group/Single-Display-Groupware>找到我参考的英文资料，也可以在此讨论相关问题。

建议先阅读此前言：

《[Windows中多指针输入技术的实现与应用（说在前面的话（1））](<http://www.jtianling.com/archive/2008/04/23/2316665.aspx>)》

后面是正文：

《[Windows中多指针输入技术的实现与应用（2摘要及参考论文）](<http://www.jtianling.com/archive/2008/04/23/2316666.aspx>)》

《[Windows中多指针输入技术的实现与应用（3 绪论）](<http://www.jtianling.com/archive/2008/04/23/2316669.aspx>)》

《[Windows中多指针输入技术的实现与应用(4多鼠标输入的底层实现)](<http://www.jtianling.com/archive/2008/04/23/2316688.aspx>)》

《[Windows中多指针输入技术的实现与应用（5 利用多鼠标输入框架软件实现）](<http://www.jtianling.com/archive/2008/04/23/2316676.aspx>)》

《[Windows中多指针输入技术的实现与应用（6 Single Display Groupware Toolkit的应用）](<http://www.jtianling.com/archive/2008/04/23/2316681.aspx>)》

《[Windows中多指针输入技术的实现与应用(7 分时多鼠标控制系统鼠标的问题) ](<http://www.jtianling.com/archive/2008/04/23/2316691.aspx>)》

《[Windows中多指针输入技术的实现与应用(8 总结及继续MFC的讨论 ](<http://www.jtianling.com/archive/2008/04/23/2316694.aspx>)》

《[Windows中多指针输入技术的实现与应用(9 我设想用来实现MFC多鼠标的透明窗口源代码。。。）](<http://www.jtianling.com/archive/2008/04/23/2316697.aspx>)》

《[Windows中多指针输入技术的实现与应用(10 双鼠标五子棋源代码 全系列完) ](<http://www.jtianling.com/archive/2008/11/23/3352969.aspx>)》

一篇很有价值的译文：

《[在微软Windows中支持多指针设备(Supporting Multiple Pointing Devices in Microsoft Windows）](<http://www.jtianling.com/archive/2008/04/23/2316651.aspx>)》

后记：全系列构成了本人的本科毕业论文，个人感觉基本上对得起中国的本科教育了，不说多么优秀，技术多么高，我本人还是下了功夫去学习和写的，虽然现在看起来原来那学生时代的水平，包括代码编写的风格都还是比较稚嫩的，而且现在回过头来看，其实真正核心的内容也就RawInput一点。-_-!呵呵，但是考虑到那是在几乎没有国内资料的情况下完成的，还是有一定的成就感，并且在微软举办博客征文比赛的时候曾经想以此文去蹭一个键鼠套件，结果仅仅获得优秀奖拿了件破衣服，汗颜-_-!有选择的话，我还不如混本《程序员》杂志强呢。。。。立此存照，以为纪念，相关资料还是有很多人问起的，本人懂得此文及其链接基本包括了。总结一下，以后发链接回答问题也快点。。。。。。别怪我偷懒。

[![devWOW博客获奖](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_devWOW%E5%8D%9A%E5%AE%A2%E8%8E%B7%E5%A5%96_thumb_633931259055623750.png)](<http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_devWOW%E5%8D%9A%E5%AE%A2%E8%8E%B7%E5%A5%96_2_633931258855936250.png>)

最后，今天在查看此文链接时，竟然发现有人的论文在参考文献中引用了我的论文-_-!也算没有白写。。。。。。想起中国大学的某项制度，核心刊物发表论文+被引用计数。。。。我也算被引用计数一次了………

[![FireShot capture #006 - '多鼠标交互型ＰＰＴ对中国课堂教学的启示' - www_zxqikan_cn_wz_200908_108851_2_html](http://www.jtianling.com/)](<http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/555576/o_FireShot%20capture%20_006%20-%20'%E5%A4%9A%E9%BC%A0%E6%A0%87%E4%BA%A4%E4%BA%92%E5%9E%8B%EF%BC%B0%EF%BC%B0%EF%BC%B4%E5%AF%B9%E4%B8%AD%E5%9B%BD%E8%AF%BE%E5%A0%82%E6%95%99%E5%AD%A6%E7%9A%84%E5%90%AF%E7%A4%BA'%20-%20www_zxqikan_cn_wz_200908_108851_2_html_f3337c3d-0e50-4088-a1e4-310048ecbb48.png>)
