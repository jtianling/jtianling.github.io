---
layout: post
title: "非典型2D游戏引擎 Orx 源码阅读笔记(1) 总体结构"
categories:
- "游戏开发"
tags:
- Orx
- "游戏引擎"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '32'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文剖析了Orx游戏引擎的架构，介绍了其模块化设计、插件系统以及跨平台的实现方式。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

## 前言

完全不了解Orx的可以参考我写的《[orx 库简单介绍](<http://www.jtianling.com/archive/2010/06/07/5652697.aspx> "orx 库简单介绍")》以及[官方主页](<http://orx-project.org/> "官方主页")。

开始学习Orx其实很久了，但是一直仅仅是学习了一些基础的用法，没有深入研究源代码，在用Orx写游戏的时候常常会因为某个配置出现问题而完全束手无策，求助于iarwain，最近在移植一个Win32编好的游戏到IPhone上时，又碰到了问题，还是束手无策，因为我决定还是看看Orx的源代码，不然，命运总是不掌握在自己的手里，就像撞大运编程一样。这也是我当时选择引擎最大的要求之一，开源，所能带来的好处之一。而Orx这种"数据驱动"式的引擎，更加是使得了解源代码如此重要，因为我感觉对于我来说，我更加能够发现调用一个API的错误，而非常难去发现一个配置上的错误，我一直也认为这是Orx"数据驱动"的弊端之一，这也是我认为Orx非典型的原因。

## 源码阅读思路及目标

对于源码阅读，我还是用个人习惯的的先从整体上了解各个模块，然后单独了解各模块源码，最后整个的走一下主要的执行流程，了解各个模块是怎么结合在一起的。

对于Orx的源码阅读，我还是不准备达到到句句理解的地步，基本上还是以整体了解为主，顺便关心一下个人比较感兴趣的渲染部分，对源码的理解程度以最后能够完全脱离Orx的配置模块，靠自己的代码将各个模块组合起来，并实现基本的Orx功能为止。Orx作为跨平台引擎，我不能去分析所有其支持的平台，主要关心的版本是Win32版本及IPhone版本，当然，事实上因为Orx的跨平台主要是依赖于将SDL,GLFW等库作为插件来完成的，所以，其实在Orx这一层的代码其实都一样。（IPhone版本比较特殊）

为了无论在何时都能找到本文对应的源码，这里使用最新的Orx1.2版本的源码，并未使用svn上的版本。

## Orx总体结构

作为一个iarwain目标为完整game engine的Orx,模块的构成还是比较复杂的。

### 物理结构：

从Orx源代码的目录上可以基本区分出来：

Animation：动画部分

base：基础部分，包含一些为了跨平台而定义的宏，Orx本身需要的宏和常用常量,函数，还有Orx的模块处理

core：内核部分，包括时钟，配置，事件部分，本地化部分

debug：日志部分及FPS显示

display：显示部分

io：IO部分，包括文件IO，及摇杆，鼠标，键盘的输入。

main：main函数参数处理

math：数学相关部分，包括一个vector的实现

memory：内存处理部分，

object：object部分

physics:物理部分

plugin：插件部分

render：渲染部分，包括摄像机，特效，渲染器，shader，视口等部分

sound：声音部分

utils：工具类部分，包括用C语言实现的HashTable,List,Tree3大容器，一些有用的String函数，以及一个screenshot实现。（感觉这个放在display更加合适）

另外，Orx比较特殊的是包含一套插件：

通过插件来实现的部分有：Display,Joystick,Keyboard,Mouse,Physics,Render,Sound。

通用插件（实现除物理，声音以外的功能）本身现在有4套：[GLFW](<http://www.glfw.org/> "GLFW"),IPhone,[SDL](<http://www.libsdl.org/> "SDL"),[SFML](<http://www.sfml-dev.org/> "SFML")。

其中SFML是1.1版本前使用的插件。GLFW是现在(1.2版本)默认使用的插件。

其中SFML,GLFW插件支持3大主流平台(Win32,Linux,MacOS)，SDL插件仅支持Win32,Linux。

IPhone的插件是因为IPhone版本比较特殊而特别加入的，对应支持IPhone/IPad平台。

声音插件现在有SFML的插件和OpenAL的插件。SFML为1.1以前版本默认声音插件，OpenAL的实现为1.2版本默认声音插件。可能是因为OpenAL插件太好，所以作者虽然使用了SDL，但是并没有使用SDL的声音模块做SDL的声音插件。

物理插件目前仅有Box2D实现的插件。

## 逻辑结构：

从"orxModule.h"的一个枚举定义中，可以看到Orx作者为Orx整体的逻辑模块的划分。

```c
/*
 * Module enum
 */

typedef enum __orxMODULE_ID_t
{
  orxMODULE_ID_ANIM = 0,
  orxMODULE_ID_ANIMPOINTER,
  orxMODULE_ID_ANIMSET,
  orxMODULE_ID_BANK,
  orxMODULE_ID_BODY,
  orxMODULE_ID_CAMERA,
  orxMODULE_ID_CLOCK,
  orxMODULE_ID_CONFIG,
  orxMODULE_ID_DISPLAY,
  orxMODULE_ID_EVENT,
  orxMODULE_ID_FILE,
  orxMODULE_ID_FILESYSTEM,
  orxMODULE_ID_FONT,
  orxMODULE_ID_FPS,
  orxMODULE_ID_FRAME,
  orxMODULE_ID_FX,
  orxMODULE_ID_FXPOINTER,
  orxMODULE_ID_GRAPHIC,
  orxMODULE_ID_INPUT,
  orxMODULE_ID_JOYSTICK,
  orxMODULE_ID_KEYBOARD,
  orxMODULE_ID_LOCALE,
  orxMODULE_ID_MAIN,
  orxMODULE_ID_MEMORY,
  orxMODULE_ID_MOUSE,
  orxMODULE_ID_OBJECT,
  orxMODULE_ID_PARAM,
  orxMODULE_ID_PHYSICS,
  orxMODULE_ID_PLUGIN,
  orxMODULE_ID_RENDER,
  orxMODULE_ID_SCREENSHOT,
  orxMODULE_ID_SHADER,
  orxMODULE_ID_SHADERPOINTER,
  orxMODULE_ID_SOUND,
  orxMODULE_ID_SOUNDPOINTER,
  orxMODULE_ID_SOUNDSYSTEM,
  orxMODULE_ID_SPAWNER,
  orxMODULE_ID_STRUCTURE,
  orxMODULE_ID_SYSTEM,
  orxMODULE_ID_TEXT,
  orxMODULE_ID_TEXTURE,
  orxMODULE_ID_VIEWPORT,
  orxMODULE_ID_NUMBER,
  orxMODULE_ID_MAX_NUMBER = 64,
  orxMODULE_ID_NONE = orxENUM_NONE
} orxMODULE_ID;
```

因为英文命名的枚举已经很能说明各逻辑模块包含的内容了，这里就不一一介绍了。

## 引用的外部工程

现在已经不是需要所有事情都从头做起的年代了，作为游戏引擎，需要处理的各个方面内容实在太多，很难都完全自己处理，Orx使用了一些外部库来完成一些相应功能。

深蓝在Orx的官方中文论坛中进行了一些[总结](<http://orx-project.org/forum?func=view&catid=20&id=941> "总结")，较为详细，可供参考。

我这里仅仅简单的说明一下：

Box2D：物理部分

freetype：制作字体工具时使用，因为Orx引擎本身并不支持freetype即时生成的材质实现字体显示，所以事实上Orx引擎本身并不需要freetype。

glfw,SDL，SFML：作为主要模块的插件实现，主要用于解决跨平台相关的问题。

SOIL：用于支持常用的图片格式。

OpenAL：声音处理。

stb_vorbis：ogg声音格式支持。

libsndfile：wav,aiff声音格式支持。

我描述的仅仅是大概的情况，关于引用外部工程以及插件的详细使用情况可以参考Orx的[changelog](<http://orx.svn.sourceforge.net/viewvc/orx/trunk/CHANGELOG?revision=1958&view=markup> "changelog">)。

## 关于SFML

在最后提供一些额外的关于SFML信息，虽然与Orx的总体结构无关，但是也顺便在此记录。

很多外部工程的引用都是从新的1.2开始的，而且都是为了替代SFML的相关部分而引入的，也就是说，最后Orx用glfw/SDL + SOIL + OpenAL + stb_vorbis + libsndfile才实现了SFML的部分功能。这还真的仅仅是SFML的部分功能，仅仅是Orx需要的那一部分功能。这里可以看出SFML有多么强大，其作为simple and fast Multimedia library的库，与SDL(Simple DirectMedia Layer)相比真的是太不simple了。事实上，从SFML的[License页](<http://www.sfml-dev.org/license.php> "License页">)可以看到，SFML本身就使用了

  * **GLEW**
is under the [BSD license](<http://www.opensource.org/licenses/bsd-license.php> "BSD license terms">), the [SGI license](<http://glew.sourceforge.net/sgi.txt> "SGI license terms">) or the [GLX license](<http://glew.sourceforge.net/glx.txt> "GLX license terms">)
  * **OpenAL-Soft**
is under the [LGPL license](<http://www.gnu.org/copyleft/lesser.html> "LGPL license terms">)
  * **libsndfile**
is under the [LGPL license](<http://www.gnu.org/copyleft/lesser.html> "LGPL license terms">)
  * **stb_vorbis**
is public domain
  * **libjpeg**
is public domain
  * **libpng**
is under the [zlib/png license](<http://www.libpng.org/pub/png/src/libpng-LICENSE.txt> "zlib/png license terms">)
  * **zlib**
is under the [zlib/png license](<http://www.zlib.net/zlib_license.html> "zlib/png license terms">)
  * **SOIL**
is public domain
  * **freetype**
is under the [FreeType license](<http://www.freetype.org/FTL.TXT> "FreeType license terms">) or the [GPL license](<http://www.freetype.org/GPL.TXT> "GPL license terms">)

这么多的外部库。而其中Orx最后使用用于替代SFML的相应部分的库，可以看到，也基本来自于SFML本身使用的这些库。。。。。。。。#@￥#@%……￥#@……￥6

iarwain对SFML的评价是强大，简单，但是buggy。

并且，从效率上来看，iarwain也是使用了这些外部库，但是在changelog中,有这么一句：

* IMPORTANT: Added new plugins for embedded versions: SDL plugins for win/linux (35-40% than the SFML ones) and GLFW plugins for win/linux/osx (~2% faster than SDL ones).

也就是说，在1.2版本比1.1版本要快35%一样，仅仅因为使用了新的插件替代了SFML。不知道SFML在simple与fast的平衡中，是否因为太过强大，功能太过丰富，而导致实现simple的代价过大。

在[features页面](<http://www.sfml-dev.org/features.php> "features页面">)上，可以看到，SFML甚至还包含一个网络模块。。。。。

不过，SFML用C++结合了上面这么多有用的库，实现那么多功能，还有一堆的其他语言(Python,Ruby,D,C#等）绑定，并且也使用很自由的zlib/png协议，感觉还是值得一试的。特别是当对效率没有那么高的要求的时候。。。。。。

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**
