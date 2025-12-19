---
layout: post
title: "非典型2D游戏引擎 Orx 源码阅读笔记 完结篇(7) 渲染流程"
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
  views: '14'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文深入剖析了Orx引擎的渲染流程，详解了位图从载入到显示的底层实现，并评述了其数据驱动设计的优缺点。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[讨论新闻组及文件](<http://groups.google.com/group/jiutianfile/>)

本文应该是该系列的最后一篇，看看一个物体在Orx中从载入到显示的完整流程。

在Orx，渲染部分，一直与object纠缠在一起，一般不直接由外部使用。最主要的函数是2个：

orxDisplay_LoadBitmap orxDisplay_BlitBitmap

假如还需要加一个，那就是 orxDisplay_ClearBitmap

事实是向作者讨教过显示一个位图最快的方式，大概是下面这个样子的：

```cpp
void
 GameApp::Update(const
 orxCLOCK_INFO *_pstClockInfo, void
 *_pstContext) {

    //m_states.top()->Update(_pstClockInfo->fDT);  

  orxDisplay_ClearBitmap(orxDisplay_GetScreenBitmap(), orx2RGBA(0
, 0
, 0
, 0
));

  orxDisplay_BlitBitmap(orxDisplay_GetScreenBitmap(), spstBitmap, 100.0f
, 000.0f
, orxDISPLAY_BLEND_MODE_ALPHA);

}
```

```cpp
orxSTATUS GameApp::Init() {

  spstBitmap = orxDisplay_LoadBitmap("Dragon.png"
);

  //orxDisplay_SetDestinationBitmap(orxDisplay_GetScreenBitmap());  

  orxCLOCK *pstClock = orxClock_Create(orx2F(0.05f
), orxCLOCK_TYPE_USER);

  

  /*  
 Registers our update callback   
 */  

  orxClock_Register(pstClock, sUpdate, orxNULL, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL);

  return
 orxSTATUS_SUCCESS;

}
```

也就是说，事实上也可以在Orx不通过配置，直接通过API，调用上面的3个函数完成图形的绘制。

## orxDisplay_LoadBitmap

图形信息载入后保存的结构是：
```c
/*
 * Internal bitmap structure

 */

struct
 __orxBITMAP_t
{
  GLuint                    uiTexture;
  orxBOOL                   bSmoothing;
  orxFLOAT                  fWidth, fHeight;
  orxU32                    u32RealWidth, u32RealHeight, u32Depth;
  orxFLOAT                  fRecRealWidth, fRecRealHeight;
  orxCOLOR                  stColor;
  orxAABOX                  stClip;
};
```

在图形的载入过程中，在Orx中使用了SOIL这个外部的库，用于支持多种图形格式，而又可以不直接与jpeg和png的那一堆解压库打交道，说实话，就我使用那些库的感觉来说，为了通用及功能强大，API还是太复杂了一些，而且文档并不详细，而是用SOIL，Orx仅仅用
/* Loads image */
pu8ImageData = SOIL_load_image(_zFilename, (int *)&uiWidth, (int *)&uiHeight, (int *)&uiBytesPerPixel, SOIL_LOAD_RGBA);
这么一句，就支持了多种图形文件。

在orxDisplay_LoadBitmap的函数调用中，对图形的宽和高还是进行了修正，代码如下：

```c
     /* Gets its real size */
     uiRealWidth   = orxMath_GetNextPowerOfTwo(uiWidth);
     uiRealHeight  = orxMath_GetNextPowerOfTwo(uiHeight);
```

使得宽高都位置在2的幂上，以支持更多的显卡。

然后保存好图形的相关信息，手工调用OpenGL进行纹理绑定：

```c
      /*
 Creates new texture   
*/  

      glGenTextures(1
, &pstResult->uiTexture);
      glASSERT();
      glBindTexture(GL_TEXTURE_2D, pstResult->uiTexture);
      glASSERT();
      glTexImage2D(GL_TEXTURE_2D, 0
, GL_RGBA, pstResult->u32RealWidth, pstResult->u32RealHeight, 0
, GL_RGBA, GL_UNSIGNED_BYTE, pu8ImageBuffer);
      glASSERT();
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
      glASSERT();
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
      glASSERT();
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, (pstResult->bSmoothing != orxFALSE) ? GL_LINEAR : GL_NEAREST);
      glASSERT();
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, (pstResult->bSmoothing != orxFALSE) ? GL_LINEAR : GL_NEAREST);
      glASSERT();
```

用下面的语句删除临时载入的资源：

```c
    /*
 Deletes surface */
    SOIL_free_image_data(pu8ImageData);
```

最后图形的相关信息，包括通过OpenGL载入的纹理的句柄，都保存__orxBITMAP_t 结构中。

## orxDisplay_ClearBitmap

主要就是如下几句：

```c
    /*
 Clears the color buffer with given color   
*/  

    glClearColor((1.0f
 / 255.f
) * orxU2F(orxRGBA_R(_stColor)), (1.0f
 / 255.f
) * orxU2F(orxRGBA_G(_stColor)), (1.0f
 / 255.f
) * orxU2F(orxRGBA_B(_stColor)), (1.0f
 / 255.f
) * orxU2F(orxRGBA_A(_stColor)));
    glASSERT();
    glClear(GL_COLOR_BUFFER_BIT);
```

只要了解OpenGL，这个没有什么好说的。

## orxDisplay_BlitBitmap

此函数是渲染流程中最主要的函数，其中又调用了如下函数完成绘制：

orxDisplay_GLFW_DrawBitmap(_pstSrc, _eSmoothing, _eBlendMode);

## orxDisplay_GLFW_DrawBitmap

orxDisplay_GLFW_DrawBitmap分两部分：

1。用orxDisplay_GLFW_PrepareBitmap指定当前的纹理，及通过当前渲染的配置，调整OpenGL渲染状态，比如是否抗锯齿，是否应用定点色等。

2。实际进行纹理的映射，然后最终调用

```c
/* Draws arrays */
glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
```

完成图形的绘制。

## 全系列小结

到这里，全部的Orx源代码阅读就结束了。Orx算是一个相对较小，实现游戏相关概念不多，但是相对完整，并且有特色的的一个游戏引擎了。完整的看下来，会发现，在2D游戏引擎中，其实渲染的这一部分代码非常少，基本上也就是一个OpenGL使用纹理映射显示位图的翻版，（可参考[这里](<http://www.jtianling.com/archive/2010/03/27/5422477.aspx> "这里")）主要的部分在于整个游戏引擎的组织。这一点上，作为完全使用C语言完成的Orx来说，代码的组织上还是非常有可借鉴之处的。每个单独的模块都是用几个关键的结构，构成一个局部的（单文件中）全局结构实现，然后仅对外开放必要的接口，基本上能做到仅仅看到结构，就能了解整个模块的大概实现，看起来非常的清晰。在部分模块的实现中，也借鉴的面向对象的实现方式，实现了可配置的简单的update及init，setup等操作。这些都是引擎中的亮点。

假如说Orx有什么缺点的话，通过通读代码，我最大的感觉就是因为其实现的大量可配置的特点，给引擎带来的太多额外的负担，比如update,init,setup等模块的实现，几乎都是从这个目的出发的，是引擎变得复杂了很多，而且，因为这个关系，引擎内部之间的模块设计，从物理设计上来看，太多的交错，离正交太远。

这些可能是从一开始作者对Orx的数据驱动的理念是相关的，在作者看来，外部使用者甚至就不应该直接使用其更多的API，而是直接仅仅使用配置。而从我个人的感觉，已经在推广Orx的过程中一些中国使用者的反馈来看，在没有合适编辑的情况下，config的配置负担在Orx比编写和修改代码的负担要重更多，而且总体结合起来的易用性及开发的速度上面并不比一个不需要配置驱动但是API设计合理的传统2D引擎要强。而且，在使用上并没有获得更好的易用性，在实现上由于一开始的理念存在，也使得实现更加复杂。个人感觉有点得不偿失。Orx的设计是超前，但是目前来看，传统之所以成为传统，还有有其道理所在。

个人认为，Orx可改进的方向有几个：

其一，Orx的底层就是应该通过传统的手法去构建，不要弄的配置那么深入，各个模块需要那么灵活的配置，实现上的负担可以减轻很多。并且，这一部分的API设计也是可以对外的。也有文档指明各个API的搭配使用，外部使用者可以在完全不使用配置的情况下，将Orx作为一个普通的不是数据驱动的引擎来使用。虽然这个比较不符合作者的初衷。

其二，配置驱动的设计完全构建在上面那一层传统的不是数据驱动的那一层游戏引擎上，只要下层的API设计合理，这完全可以做到。对于普通使用者来说，学习曲线也可以更加平缓，在学习和了解了底层的API使用后，配置仅仅是用于加速自己设计的实现，而不是仅仅知道配置，一旦某个地方的配置出现隐晦的错误就一筹莫展（这个问题我自己和很多中国用户都出现过），因为了解底层的API 的使用，出现类似问题，通过在上层的调试，（即读取配置使用底层接口这一层）就能很容易的发现。而且，配置的使用不应该成为强制性的，这仅仅是使用者提高开发速度的一种方式，假如使用者认为底层的API已经足够使用，完全可以不用配置层。前面这两条说简单点就是将数据驱动与传统的接口相分离，而不是真的作为引擎的强制项。

其三，配置其实不能完全等同与一般意义的数据，需要手工编写的格式严格的配置，会给使用者带来很大的负担，我有时甚至觉得写代码比写配置更加容易，起码出错了更加方便调试。这些问题就需要能够保证生成正确配置的工具来解决了。作为了游戏引擎，Orx在这方面还比较欠缺，因为作者“憎恨”写UI的特点，估计这也不能靠作者来完成了，需要Orx的社区力量来完成。没有工具生成配置的配置驱动，根本就称不上真正的数据驱动，不过是将写代码的负担移到写配置而已。。。。。。。。。。。。。。。。。。。。

以上纯属个人看法，而历史证明，由于懂得东西不是很多，所以我的个人看法很多是不正确的，比如前面我提到的Orx的list实现[很奇怪的问题](<http://orx-project.org/forum?func=view&catid=17&id=968#974> "很奇怪的问题")。。。。。。。。。。。。。。。。。。。。所以请读者不要轻信上述问题，那仅仅是一家之言。

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**
