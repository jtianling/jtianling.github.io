---
layout: post
title: "关于C++标准库泛型算法reverse的学习笔记"
categories:
- C++
tags:
- C++
- reverse
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

C++ Primer中这样描述reverse 反向排列元素

一个容器为 9,8,7,6,5,4,3,2,1,0，sort后为0,1,2,3,4,5,6,7,8,9。

一个容器为0,1,2,3,4,5,6,7,8,9，sort后还为0,1,2,3,4,5,6,7,8,9。

假设一个容器为0,1,2,3,4,5,6,7,8,9你认为reverse以后为什么呢？没有错，9,8,7,6,5,4,3,2,1,0。

但是一个容器本来就为 9,8,7,6,5,4,3,2,1,0呢？还是9,8,7,6,5,4,3,2,1,0吗？他们不是本来就降序排列了吗？

我以前就是这样理解的，不过实际使用才知道reverse不时排序算法，仅仅是反向排列。9,8,7,6,5,4,3,2,1,0

reverse后变成0,1,2,3,4,5,6,7,8,9。要得到降序排列的方法，好像可以先sort,后reverse.不知道我说的对不对。

具体的验证代码就很简单，不列出来了。