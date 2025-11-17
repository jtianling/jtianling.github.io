---
layout: post
title: "记下教训，关于SHFileOperation的使用，命令行程序的使用"
categories:
- C++
tags:
- C++
- SHFileOperation
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '20'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

假如你也一直开发的都是windows,linux下都能跑的程序，关于目录的使用你肯定就和我一样统一了，都是用"/"来表示。道理很简单，因为linux不支持"/"而windows支持"/"，一直以来都是这样，linux原生的"/"使用自然没有任何问题，windows下的fopen，CreateFile,OpenFile,CreateProcess等等使用的也不是一次两次了，用的也都没有问题。当然，今天，问题来了，一碰到就调试的人郁闷的要死。

 

关于SHFileOperation的。此该死的函数，没有错误返回代码，只能知道执行失败，通过GetLastError返回的甚至可能是在MSDN中SystemError说明以外的数值。于是，噩梦开始了。当我用按照习惯的使用"/"来表示目录，并测试代码，在目录只有一层的时候是可以成功的，即类似E:/data的目录执行没有问题。但目录为很多层的时候，SHFileOperation竟然也有时能够成功，但是有时却会失败，输入参数我一再验证没有问题。（输入参数以双零结尾也是需要注意的），直到我崩溃。准备直接用CreateProcess调用copy /y ,del 等命令来完成任务的时候，才想起来"/"在dos（windows所谓的的shell吧）中用来表示参数。。。。用"/"表示目录来调用dos命令总是会失败的。。。。。。。才联想到SH的名字。。。SHell啊。。。。。一切都明白了。。。。需要说明的是，这一点MSDN中没有任何说明，并且，即使我使用"/"来表示目录并调用SHFileOperation竟然还有成功的时候。。。。更多时候也不是完全失败，而且进行了一半。。。。。。。太没有天理了，还没有ErrorCode。。。。。。。

 

另外，今天在寻找一些解压的库，用来完成监控系统中的更新操作。找了一下午，zlib,7-zip的支持库等，找了一圈，不是不支持rar就是用法不明，或者不支持linux,最后发现都不适合，而unrar这个命令行工具其实就完成可以完成任务。。。。。。。无非就是一个熟悉的CreateProcess而已，感叹不已，想起来我以前学习的时候还特意怀旧般的为DOS命令写了一系列文章，到了工程应用的时候竟然都忘了。。。。其实有的时候用命令行提供给你的工具，比找个库要简单的多。。。。
