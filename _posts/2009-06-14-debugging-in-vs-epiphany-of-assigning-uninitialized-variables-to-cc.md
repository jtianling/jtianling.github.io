---
layout: post
title: "在VS中debug时，将未初始化变量都赋值为CC的顿悟"
categories:
- "汇编和反汇编"
tags:
- C++
- debug
- VS
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '11'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

VS调试时将未初始化变量赋值为0xCC，因为它是调试中断指令。若程序错误执行该内存，会立即触发中断，帮助开发者更早发现严重bug。

<!-- more -->

# 在VS中debug时，将未初始化变量都赋值为CC的顿悟


[讨论新闻组及文件](<ttp://groups.google.com/group/jiutianfile/>)

一直以来，我都不是太理解这种方式，在 [C++函数调用原理理解](<http://www.jtianling.com/archive/2008/06/01/2501238.aspx>)中，我仅仅是简单的认为，那么做，可能是因为CC平时用的少，而且好看：）所以初始化这样一个不怎么常用的变量，可以让人很快发现。。。。事实上，的确有这样的效果，当Debug时，我看一个变量为CC时的确第一时间就能反应过来，我又犯了一个不可饶恕的低级错误，又忘了初始化了，这点在变量为指针类型的时候更加严重。

但是，在学习过反汇编这么久后，今天在看《C缺陷与陷阱》时，突然顿悟了CC的意义。。。。。至于为什么是看这本和这件事完全没有关系的时候突然想到，我也不知道，反正就是那样发生了。

CC在汇编代码中表示为int 3，实际表示一个中断，在与硬件中断（CPU中加入的DR寄存器指示）做区别的时候也叫软中断。。。。几乎所有的调试工具在调试时，都是靠int 3来完成任务的。。。。。。这些我知道时间不短了。。。。但是今天才将其与VS在debug时的初始化联系起来。。。。。这样的话，假如有异常的跳转，程序运行到了不应该运行的地方。。。。那么，就会触发中断，让调试程序获得控制，这样可以更早的发现问题，而不是当运行了一堆莫名其妙的代码后才出现问题。。。。。。

至于VS在debug时的初始化，可以用debug方式编译任何程序，你都能看到

比如在[C++函数调用原理理解](<http://www.jtianling.com/archive/2008/06/01/2501238.aspx>)例子中如下：

```asm
0041136C lea edi,[ebp-0C0h] ;读入[ebp-0C0h]有效地址,即原esp-0C0h,正好是为该函数留出的临时存储区的最低位  
00411372 mov ecx,30h ;ecx = 30h(48),30h*4 = 0C0h  
00411377 mov eax,0CCCCCCCCh ;eax = 0CCCCCCCCh;  
0041137C rep stos dword ptr es:[edi] ;重复在es:[edi]存入30个;0CCCCCCCCh? Debug模式下把Stack上的变量初始化为0xcc，检查未初始化的问题
```

