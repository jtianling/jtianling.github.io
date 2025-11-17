---
layout: post
title: "从易到难编写C++程序，（5）问题：实现满足各种需求的随机整数生成类RandCreater"
categories:
- C++
tags:
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '4'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

因为在问题（3）中需要解决这个随机数产生的问题，我感觉还比较复杂，当然光是需要产生一个普通的整数还是比较简单，但是有的时候不仅仅是需要这样。现在实现以下几个要求，为这个类定义一些接口。目前只要求所有产生的都是整数。

1，RandCreater(int i) 在 0~i 范围内

2，RandCreater(int i，int j)在i~j范围内

3，RandCreater(LargeInt linta)在0~ivec范围内 LargeInt的意义见问题（4）

4，RandCreater(LargeInt linta, LargeInt lintb) 在linta~lintb范围内

5，产生的数有两种形式，（1）可以是内置类型的int,（2）也可以产生问题（4）定义的LargeInt。

暂定接口，觉得不适合可以更改。
