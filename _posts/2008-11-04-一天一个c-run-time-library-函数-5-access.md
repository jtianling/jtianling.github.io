---
layout: post
title: "一天一个C Run-Time Library 函数(5)  access"
categories:
- C++
tags:
- access
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '2'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

  

## 一天一个C Run-Time Library 函数(5)  access

write by 九天雁翎(JTianLing) -- www.jtianling.com

 

## msdn:

Determines if a file  
is read-only or not. More secure versions are available; see [_access_s, _waccess_s](<ms-help://MS.MSDNQTR.v80.chs/MS.MSDN.v80/MS.VisualStudio.v80.chs/dv_vccrt/html/fb3004fc-dcd3-4569-8b27-d817546e947e.htm>).  
  
---  
int  
_access(     const char *_path_ ,     int _mode_ ); int  
_waccess(     const wchar_t *_path_ ,     int _mode_ );  
  
## 测试程序：

 

## 说明：

access是个很有用的函数，非常之有用。特别是在linux下。对于windows中，似乎都没有不可读和不可执行的概念，所以相对来说使用率相对低一些。另外，最标准的测试一个文件是否存在的方式可能就是用access函数了，虽然真正的可以达到目的方式有很多。

在linux下此函数的使用需求很大，因为linux的权限设置更为丰富。很多时候是否存在，可读，可写，可执行都需要判断，这样你能更容易知道你下一步该做什么，而不是真的等到某个文件打不开，写不了，执行失败时才报告错误。

对于这么重要的函数，我没有给出示例。。。只能说我是越来越懒了，不过总是发现明明我仅仅是想看看哪些函数在windows/linux下都可以用，最后却变成了函数的使用说明和实现代码分析。。。。。。。。花费时间，其实也没有实际价值，因为用法可以查msdn，man，我贴一下也没有什么用，还是把时间用在更值得用过的地方吧。****

##  实现：

windows下主要通过API  GetFileAttributes函数来完成。

linux下的实现我竟然没有找到。。。。。无语

 

## 效率测试：

此函数好像通常不太需要考虑效率，因为两个系统完全不一样，所以测试此函数效率没有任何意义。

 

## 相关函数：

 

## 个人想法：

宽字节的版本照例linux下没有实现。其实可以总结一下，起码所有的关于文件的宽字节版本的函数,linux下都没有。原因很简单，linux虽然支持unicode，但是支持的不是通常windows下所谓的unicode的版本，而是utf-8，所以不需要宽字节。

在此时完全没有办法糅合，也完全没有办法放弃功能。不可能说以后编写的都是不用文件操作的东西吧？那么只能是一方妥协于另一方。我公司的做法是向微软妥协。也就是完全使用32位的宽字节版本的unicode,这样在windows下其实效率是最高的（因为windows的核心都是unicode了，ansi版本的api需要多进行一次编码转换）。但是所有在linux下的文件操作都需要经过unicode2utf8的编码转换，还好这个转换是非常快的（起码没有编码映射的过程）。本人更喜欢linux，更喜欢让windows版本的东西经过编码转换才用。因此linux下的操作会更快（这就是我想要的）而windows版本的很多操作都需要先转换编码，带来的代价是，所有的字符串在VS中调试时将不能看到有意义的输出：）所有的命令行字符串中文都无法正确显示。（实际只能显示ASCII）。纯粹个人爱好，因为我想强迫自己去熟悉linux下的东西。真正的工程应用假如大部分在windows下开发，自然是向windows妥协的好。

所以，从此以后所有宽字节的文件操作命令我直接忽略。顺便忽略的还有MS为增强C语言库写的一族_s函数，虽然可能真的会更安全一些，但是，可移植性不需要这样特立独行的东西。直接忽略。

最后，linux下的函数命名遵循的是POSIX标准，POSIX函数的命名没有前缀。MS的函数命名遵循的是ISO标准（据说），ISO标准的函数命名都带前置下划线。这点纯属瞎猜。。。。来源于所有的POSIX函数在MSDN中都会有类似的文字：

This POSIX function is deprecated beginning in  
Visual C++ 2005. Use the ISO C++ conformant [_access](<ms-help://MS.MSDNQTR.v80.chs/MS.MSDN.v80/MS.VisualStudio.v80.chs/dv_vccrt/html/ba34f745-85c3-49e5-a7d4-3590bd249dd3.htm>) or  
security-enhanced [_access_s](<ms-help://MS.MSDNQTR.v80.chs/MS.MSDN.v80/MS.VisualStudio.v80.chs/dv_vccrt/html/fb3004fc-dcd3-4569-8b27-d817546e947e.htm>) instead.

 

 

 

write by 九天雁翎(JTianLing) -- www.jtianling.com

 
