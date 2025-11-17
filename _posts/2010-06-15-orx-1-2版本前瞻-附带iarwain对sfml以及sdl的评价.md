---
layout: post
title: Orx 1.2版本前瞻 附带iarwain对SFML以及SDL的评价
categories:
- "游戏开发"
tags:
- Orx
- SDL
- SFML
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '18'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

    Orx不是一个非常成熟的引擎，我一直这样觉得，相对于很多成熟的引擎，Orx还有很多功能上的缺失，还缺少很多有用的游戏概念的添加，但是，我们能够看到作者iarwain的不懈努力。他曾经提到，他在Ubisoft工作之余，一边要带孩子，一边将其他所有的业余时间全部都投入到了Orx的开发中。。。。。而且，iarwain开发Orx,仅仅是for fun.....

    在1.2版本中，iarwain添加了新的功能，在官网上如此描述“

custom bitmaps support and UTF-8 support.

”，呵呵，UTF-8

是个作者没有定在1.2版本Road map中的功能，仅仅是因为来自东亚（比如中国）人对Orx的增多的兴趣，而决定在新版本中添加的。。。。。^^

    另外，虽然作者在最新的news中没有提及，但是我知道1.2版本的新的其他改动，对IPhone,IPad的支持，以及其他系统的版本从SFML库改到了SDL这个更为成熟，大家也更加熟悉的库。

    这里顺便提及SFML与SDL的比较，不浪费任何有用的经验：）作为iarwain这样一个经验丰富的程序员，他对SFML与SDL的比较时，这样描述SFML，buggy,但是实现的特性更加多，可惜有很多是游戏引擎本身就会实现的，所以事实上多出的特性很多有重复了，由于使用C++及面向对象的方式提供接口，对于使用C++的人来说，会更加易于使用。。。。当然，buggy一词，完全的打消了我对SFML的兴趣。而SDL,提供的接口更加底层，效率更高，（因此，1.2版本的Orx效率也会更高），更加成熟，稳定。
