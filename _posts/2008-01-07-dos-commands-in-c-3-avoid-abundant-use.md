---
layout: post
title: C++ 中的DOS命令调用（3）——我不提倡大量使用DOS命令
categories:
- C++
tags:
- C++
- DOS
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

文章不提倡多用DOS命令，因其移植性差、调试难。但也承认，在特定场景下，一些DOS命令能简单高效地实现复杂功能，可作为API的补充。

<!-- more -->

虽然我个人认为DOS命令有它的可取之处，并想了办法将其更好地融入到MFC程序中来，但是我个人并不是太提倡大量的使用DOS命令，因为毕竟很多东西用了DOS命令要改都难，而且DOS版本不一，以及很多Microsoft专属的DOS加强命令都让程序的移植性差了很多，而且，很重要的是，用了太多DOS命令，对于只学了C++而没有经历过DOS时代的人来说那简直就是天书，况且，不是人人都那么想去学习DOS 的，而Windows API大家都会觉得多了解几个没有坏处。另外，绝大部分DOS命令都有相关的Windows编程解决方案，比如微软为你提供的类库或则API中都有方法解决DOS命令可以完成的任务，而DOS命令一开始我就提出了，因为都是使用char *的方式调用，所以很大程度上加大了调试的难度，很多时候只能开个CMD窗口去一次一次尝试，问题是，各种情况有的时候没有办法都考虑到，就有了产生神秘BUG的可能，而微软的类库和API这方面就要好的多。还有一点就是如同我在以前例子中演示的那样，DOS命令很多的命令输出是为了在屏幕上输出信息的，比如DIR等，所以会有很多附加信息，导致你需要得到确实需要的信息需要通过一些转换，在前面的例子中我就是使用了正则表达式来完成这些任务，虽然比一般方法可能容易点，但是还是比较复杂，而类库和API一般都能直接得到需要的信息，这也是他们的优点。

当然，我要说的也不是多么害怕使用DOS的命令，而且个人把调用命令行的程序都看做DOS命令的一种延生形式，可以作为还不明白进一步Windows API时的一种补充，而且，有的时候一个DOS命令可能只需要一步的功能要实现起来却可能需要很多行程序，另外，可以很好的利用一些别人编写的足够好的命令行程序来为自己程序增添一些本来很难以实现的功能。在这里，我还是提供几个个人认为值得一用的DOS命令：

```bash
FC,COMP： 比较文件

PING：不用说了吧

REGEDIT /E：导出注册表 REGEDIT /L：导入注册表  

XCOPY：复制文件和目录树，比SHFileOperation容易使用的多  

DELTREE：删除目录，也比SHFileOperation容易使用的多

PROXYCFG,FINGER,TRACERT,IPCONFIG,**ROUTE,TRANCE,NETSTAT,NET,FTP,TELNET ：估计要通过一般编程实现他们的功能不是那么容易的吧，但是假如使用这Windows给你的命令行程序就简单的多了。其实由于个人还不是太会网络编程，所以才会觉得使用Windows提供的网络相关程序会使得一些网络功能的实现容易很多，假如精通了网络编程不知道还是不是这样。  
**

At：计划  

SHUTDOWN：关机  

tskill:结束进程  

另外推荐Pstools工具组，还有Winrar的命令行版本RAR,UNRAR，有了他们你可以很方便地压缩和解压程序，而不需要去学习怎么调用库。基本上；也就这些了，有什么以后再补充。  
```
