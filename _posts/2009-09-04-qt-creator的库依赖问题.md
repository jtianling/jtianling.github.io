---
layout: post
title: Qt Creator的库依赖问题
categories:
- "未分类"
tags:
- Qt
- Qt Creator
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '5'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**Qt Creator 的Qt库中途添加依赖的问题**

这里说一下，Qt Creator实在不是个什么好产品，在创建工程的时候可以用GUI选择你需要依赖的Qt模块，这样你可以仅仅通过包含头文件名即可正确包含头文件，但是没有选择的话，你需要包含相对目录，比如假如我开始选择了依赖QtTest模块，我仅仅需要`#include <QTest>`即可, 不过我开始没有选择QtTest（没有想到sleep在这里面），这个时候我必须 `#include <QtTest/QTest>`. 最奇怪的是，我没有办法制定工程添加QtTest的库依赖。。。。。。导致连接总是无法成功，(ld报错)，搞了一会都没有发现Creator中有哪个地方可以添加（希望有高人可以指点），pro工程中也没有任何相关的地方可以编辑，最后没有办法，在工程目录下的makefile中自己手动添加了（要是没有在Unix/Linux下搞过开发，学过Makefile+gcc的人估计要吐血了）。另外，也理解了为啥没有包含模块就必须要添加相对路径了，Makefile的Includes中没有指定相应的目录。指定后就完全等同于开始就选择了库依赖了。

 

 

 

