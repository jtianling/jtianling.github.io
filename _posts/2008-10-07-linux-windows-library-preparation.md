---
layout: post
title: linux/windows库准备工作
categories:
- Linux
tags: []
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '8'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

计划用C++、Python、Lua和Shell四种语言，开发一个适合开发使用的Makefile自动生成工具，以解决实际问题并锻炼编程能力。

<!-- more -->

既然准备尝试在linux下开发程序，一些准备工作是必须的，比如makefile,shell,等等，目前学习了一下makefile文件的写法，的确大有学问，趁着这个学习的机会，翻看了一下公司目前的通用makefile，发现其实写的并不是很好，这点到时候和总监去说说，虽然改起来方便，但是实际上对于文件的依赖性处理的有问题。

另外，看了一下automake的东西，发现那东西只适合程序的发布时使用，不适合开发的时候使用。

于是，自己想写一个开发用的make文件自动生成工具，也有些思路，顺便熟悉一下这段时间囫囵吞枣式的语言学习，以前就有想法，将数据结构的课程习题全部用C++，Python两种语言来完成，当时的确是水平不济，加不想用太多时间在python上。现在不一样了，其实作为一个游戏开发人员，脚本语言的掌握是很必要的：）另外，linux下的shell（bash）编程也挺有意思和用途。

所以，和那时比较，现在的野心也更大了，我决定用bash shell,C++,lua,python四种语言来实现这个适合工程用的自动make文件生成：）

希望能够顺利，这个工作不大，是锻炼语言的好机会。
