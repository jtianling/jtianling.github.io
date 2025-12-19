---
layout: post
title: "一天一个C Run-Time Library 函数（绪）"
categories:
- C++
- Linux
tags:
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '10'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

作者为研究跨平台服务器框架，决定通过实践逐一测试C运行时库函数，整理其在Windows与Linux下的可移植性差异。

<!-- more -->

继续为windows/linux通用服务器框架做研究工作，从C语言运行时库开始。

最好的可移植编程方式是什么？除了java。。。还有C。。。。，标准C是可以在几乎任何有C语言编译器的机器上运行的，这是lua作者只用标准C开发lua的原因，并谈到了lua可移植性好的理由。他说除了动态链接的模块，他用的几乎都是标准C。

其实说起来移植性最好的可能是C++，C++的标准化工作在今天看来是非常成功的，C++的标准库移植性也是非常的好，可是其实C++中大部分底层的操作还是靠C语言部分来完成，所以研究C++的库好像也没有意义，毕竟我的目的就是考察移植性而已，不是来考察库的用法。。。

作为一个服务器的框架，光用标准C好像有点难度。。。比如IOCP，epoll这些最好的服务器模型都是典型的操作系统相关。但是，用C++语言编写时，总会用到C语言的运行时库（在windows下叫CRT -- C Run-Time Library)。并且因为MS为C语言的库做了很多扩展工作，并且将很多POSIX的东西标了前置的下划线，并且都放在这个库中，使得很多时候我自己都不知道哪些是标准库的，哪些是MS扩展的了（都是常查MSDN不翻书的恶果，但是查MSDN的确快了很多）。今天又一次的碰到这个问题。

实际程序编写的时候，使用这些库函数，比使用windows API的可移植性（也许仅仅是移植的代价）要好的多。

因为没有直接的类似资料可以查看，所以我下决心，直接一个一个通过实践，决定哪个是windows/linux都可用的，哪些是新扩展，linux下不能用的。仿照很久以前看到某人写的一天一个windows API来写。我就一天一个C Run-Time Library的函数吧：）

呵呵，最近刚刚看完了一本bash的书，正好不想再学太多语言语法的东西，想好好的多编点东西，这个正好是个机会。另外。。。个人好像老是计划的多。。。实际做下去的少，希望这个计划能够对自己的计划能力做出考验，然后做一个完整的PDF/CHM，方便大家，也方便自己以后的查看：）

另外还可以将MS那些前置的下划线通过宏取消掉，最后还有一个非常非常有必要的事情也可以顺便做了，那就是为linux下的库建立一套asc/Unicode的自适应库（类似TCHAR系统）。

顺便，完整性，再贴一次我的开发及测试环境。

windows XP VS2005 VA vimemu boost 1.36

ubuntu 8.10 gcc version 4.2.4 vim+gdb boost 1.36

源代码控制统一在windows XP 中用VSS.(个人习惯问题,公司用的就是这个)

另外:

其他工具包括.IBM Rational Rose Realtime(又是习惯问题,虽然不是Realtime的程序,但是因为公司用的是这个,个人沿用此习惯)
