---
layout: post
title: 用 Dart 加 Pixijs 写 HTML 游戏
date: 2020-03-09
comments: true
categories: 编程
published: true
tags:
- 编程
- pixi.js
- Dart
---

最近 [Flutter](https://flutter.dev/) 的流行, 让 [Dart](https://dart.dev/) 这个似乎已经要死的语言又复活了.  最近在找能同时在 iOS 和 H5 两端同时运行的编程语言, 没想到 Dart 竟然是非常合适的对象, 有点意外, 于是看了看 Dart.  

<!-- more -->
# 提要

实在的说, 语法特性并没有什么亮点. 类型系统除了添加了类似 Mixin 这种相对靠谱的东西外, 写起来和 C++ 的感觉都差不多, 并发上, 添加了类似 JavaScript 的 Async-Await 异步写法, 暂时没有尝试, 不过就使用 JavaScript 的经验来说, 可能真用来写服务器, 并不能很好的写 多线程/多协程 的程序, 可能要用单线程-多进程的思维来实现并发.  

# dart with pixijs
为了熟悉语法, 把最近 [用 Python 写游戏](http://www.jtianling.com/learn-python-by-game-examples-2.html)里面的例子实现了一下. 也算有些坑, 主要是在 Dart 和 JS/Dom 的交互上的, 比如获取键盘响应等事件上.  


[源代码](https://github.com/jtianling/dart-pixi-test)放在 Github 上了, 因为是写的第一个 Dart 程序, 写的难看的地方, 就不要太在意了...

因为是 H5 版本, 可以直接通过这个链接看到效果:
<http://www.jtianling.com/dart-pixi-test>

# 引用的库
pixi 的 Dart 封装:
<https://pub.dev/packages/pixi>

pixijs:
<https://www.pixijs.com>
