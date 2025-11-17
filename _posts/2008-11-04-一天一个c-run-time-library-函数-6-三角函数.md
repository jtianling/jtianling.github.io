---
layout: post
title: "一天一个C Run-Time Library 函数（6）  三角函数"
categories:
- C++
tags:
- C++
- "三角函数"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '3'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

## 一天一个C Run-Time Library 函数（6）  三角函数

write by 九天雁翎(JTianLing) -- www.jtianling.com

## msdn:

太多，不列举了。包括acos,cos,asin,sin,atan,tan等等  
---  

## 测试程序：

## 说明：

**都没有太多需要解释的，三角运算时需要的函数。******

##  实现：

MS:

我只看了acos的实现，完全是汇编实现的。并且可以看到sse2的指令集，mmx指令集都有响应的优化。MS也会判断你的机器是否有此指令集。有的话就是用优化后的指令。

## 效率测试：

这里效率测试很有意思，可以看看两个编译器对于汇编代码的优化到什么地步。。。。但是由于我懒嘛。。。所以没有进行。

## 相关函数：

无

## 个人想法：

对于这么简单的函数自然可以自由使用了。并且在C++下的话通过重载可以更简单的使用。不然就只能记得使用f后缀的使用方式了。比如cosf。。。表示浮点类型的余弦函数。

write by 九天雁翎(JTianLing) -- www.jtianling.com