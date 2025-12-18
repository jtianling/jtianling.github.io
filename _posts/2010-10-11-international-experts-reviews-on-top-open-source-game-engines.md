---
layout: post
title: "国外大牛对几大著名开源图形/游戏引擎的点评"
categories:
- "翻译"
tags:
- "游戏引擎"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '55'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**

[**讨论新闻组及文件**  
](<http://groups.google.com/group/jiutianfile/>)

    其实早就看到了（很老了，写于Sunday, December 9, 2007），最近写Bullet相关文章的时候又翻看到了，想到常常有人会问到底哪个开源引擎比较好，这里就顺便简单的翻译一下吧。虽然是一家之言，而且Wolfgang Engel这个大牛（不了解有多牛可以[参考这里](<http://www.linkedin.com/in/wolfgangengel> "参考这里")  
）的话是针对移动平台的，但是还是有一些普遍的参考价值的。[来源](<http://diaryofagraphicsprogrammer.blogspot.com/2007/12/porting-open-source-engine-to-iphone.html> "来源")  
。这也是Wolfgang写乌龙引擎（[oolongengine](<http://code.google.com/p/oolongengine/> "oolongengine")  
）的初衷。

 

## 译文：

（括号里面的话都是我加的，单纯的翻译好无聊啊。。。。。。。）

对几大开源引擎的点评：

Ogre：架构和设计不太关注效率。其C++的用法导致使用和重新设计都比较困难。一个例子：每个材质都有它自己的一个C++文件并且这里还有一个复杂的继承链.... (现在Ogre已经官方支持iPhone了，也不需要Wolfgang来移植了，但是效率的确是个问题)

Irrlicht:我尝试的Mac OS X版本看起来像Quake 3引擎。它看起来缺少很多现代3D引擎设计的元素，除了看起来非常适合移动设备。因此，你可能也就想使用原来的Quake3引擎..... （的确很适合移动设备）

Quake 3:这是个很显然有很多优秀工具，非常有效率的引擎，我以前开发荣誉勋章系列的时候就使用了这个引擎，但是我想要更加灵活一些，并且我想以更加高级的硬件为目标。 （Quake 3实在也太老了点,现在也支持iPhone了）

Crystal Space:为什么每个东西都是一个插件？想不通。

C4：这是我最习惯的引擎之一，但是它是闭源的:-(  (对开源引擎的评价怎么会加上这个闭源引擎?-_-!)

所以，我现在想要写我自己的，基于底层框架的引擎。（也就是乌龙引擎）

 

## 原文：

Evaluated several open source engines:

  * Ogre:  
the architecture and design is not very performance friendly. The usage  
of C++ makes the usage and re-design here quite difficult. An example:  
each material has its own C++ file and there is an inheritance chain  
from a base class ... 
  * Irrlicht: the Mac OS X version I tried  
looks like a Quake 3 engine. It also seems to lack lots of design  
elements of a modern 3D engine. Other than this it looks quite good for a  
portable device. You might also use the original Quake 3 engine then  
...
  * Quake 3: this is obviously a very efficient game engine with  
rock-solid tools, I worked with this engine in the Medal of Honor  
series before, but I wanted a bit more flexibility and I wanted to  
target more advanced hardware.
  * Crystal Space: why is everything a plug-in? Can't get my head around this.
  * C4: this is one of my favourite engines, but it is closed source :-(

So I want to write my own based on the low-level framework I have in place now.

 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**