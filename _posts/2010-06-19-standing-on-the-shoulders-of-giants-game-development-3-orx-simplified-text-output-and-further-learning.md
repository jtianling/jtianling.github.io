---
layout: post
title: "站在巨人的肩膀上开发游戏(3) -- Orx 文字输出的简化及进一步学习"
categories:
- "游戏开发"
tags:
- Orx
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '17'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文介绍如何利用Orx配置API简化文字输出。通过编写函数整合配置，使文本创建更简单。文章还展示了如何通过配置文件调整文字位置、对齐等属性。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

## 前言

在上一节构建了一个用Orx完成的Hello World程序，想起以前有的用N中方式完成Hello World程序的例子，也许这个算是其中最最复杂的了。有个问题问题在于Orx中文字的输出为了与Object一致，所以弄的非常麻烦，毕竟简单的文字完全没有Object那么多属性需要配置。（参考前一节）事实上，经过与iarwain的沟通，最后确认了简化的办法，那就是写自己的函数做为包装。做为前置条件，先学习Orx中config相关API的使用。

## 配置相关的API

在Orx的WIKI上有个[详尽的页面描](<http://orx-project.org/orx/doc/html/> "详尽的页面描")述此API。主要的API以orxConfig_SetXXX及orxConfig_GetXXX组成，比较简单。不举太多例子了。section的处理也比较简单，push,pop用于使用某个section并且还原，seclect用于选择某个工作的section，但是有个特别的地方，这些API会在section不存在的时候，创建section。这也是我需要的。

## 文字输出的简化

下面就开始文字输出的简化，上一节分析了在Orx中输出文字为什么那么复杂，主要原因在于文字模拟了Object的创建，并享有Object的所有其他功能，所以一个简单的文字属性被分成了3段，这样就变得复杂了，我的思路是将所有的属性都放在一段中，并且还是走原来的路，按照Object的创建方式来创建，事实上，因为orxObject_CreateFromConfig的实现比较复杂，就不重复其原有步骤了，我通过从配置文件中的一段配置，动态构建出此API需要的三段，然后再用原API来创建，这样虽然效率上可能会低一点，但是最大程度的利用了原有函数。

简单的例子，原有的HelloWorld例子中，HelloWorld的配置就有3段，如下：

```ini
[HelloWorld]

Graphic             = 
 HelloWorldGraphic

[HelloWorldGraphic]

Text                 = 
 HelloWorldString
Color                = 
 (255.0, 0.0, 0.0)

[HelloWorldString]

String               = 
 "HelloWorld"
```

事实上，我们需要的有效内容就只有2个
```ini
Color                = 
 (255.0, 0.0, 0.0)  

String               = 
 "HelloWorld"
```

也就是说，我希望通过

```ini
[HelloWorld]

Color                = 
 (255.0, 0.0, 0.0)
String               = 
 "HelloWorld"
```

这样的配置，就能达到原有的效果。想想，7行配置，结果只有3行有用，其他4行都是浪费的无谓link和section，怎么说都无法忍受。为了完全还原原有效果，并且使其名字也能一样，只需要这样使用Orx的配置API即可。

```c
orxOBJECT *CreateText(orxSTRING _zTextSection)
{
    orxConfig_PushSection(_zTextSection);
    orxConfig_SetString("Graphic", _zTextSection);
    orxConfig_SetString("Text", _zTextSection);

    orxOBJECT *pstReturn = orxObject_CreateFromConfig(_zTextSection);

    orxConfig_PopSection();

    return pstReturn;
}
```

也就是说，通过将需要的Graphic和Text段都连接到自身，这样的config使用方法的想法，完全来自于iarwain.......我只能说，简化了太多太多东西，小小的INI配置，竟然能够玩弄的这样出神入化，可能是MS都无法想象到的。。。。。。。。。。。。。。

## 进一步学习

其实在Orx中普通的文字与Object共享了太多的东西，讲的太多，就会出现我前面讲的情况，因为讲解一个API而贯穿了整个Orx，这里仅仅提出几个特别的配置来说明。（虽然说是特别的配置，但是并不是对文字特别，也完全适用于普通的object，仅仅表示比较有用）

### 位置

首先，Position属性，表示位置。提到Position，又得将Orx的世界坐标系讲一讲，因为比较特殊。Orx作为一个2D引擎，没有完全的使用屏幕坐标系，而是将屏幕坐标系移到了屏幕的中心点，（严格来说是创建viewport的中心点，以下都以此方式表述）也就是说，以屏幕中心点为原点，右边为X的正轴，下边为Y的正轴。并且，因为Orx使用了Z buffer来解决遮挡的问题，还有Z轴坐标，Z轴坐标是从屏幕外指向屏幕内的。也就是屏幕外为负，屏幕内为正。起码，在默认情况下，Orx的世界坐标就是这样。于是，Position的使用方式来了。指定坐标就可。

![](http://docs.google.com/File?id=dhn3dw87_113dr8mpzcs_b)

比如，原来我没有指定任何Position，那么就默认在原点创建了文字，我现在指定到-100,-100，就表示文字显示在离屏幕中心点，左100像素，上100像素的位置显示文字。如下图：

![](http://docs.google.com/File?id=dhn3dw87_114d5jd3xgn_b)

### 中心点

其实，对于文字来讲，有很多排版问题。比如向左对齐，向右对齐啥的，对于object来说就是中心点的问题。这里文字可以利用中心点来完成排版。当然，多行文字的问题就更加复杂了，需要手动排版。首先看属性Pivot
Pivot = center(+truncate|round)|left|right|top|bottom|[Vector]; NB: Truncate and round will adjust pivot values if they are not integers; z is ignored for 2D graphics;

将HelloWorld的配置设为下面这样时：

```ini
[HelloWorld]

Color       = 
 (255.0, 0.0, 0.0)
String      = 
 "HelloWorld"
Position    = 
（0.0, 0.0, 0.0)
Pivot       = 
 center
```

显示效果如下图：

![](http://docs.google.com/File?id=dhn3dw87_115f6wnmwds_b)

与没有设定中心点时比较一下：

![](http://docs.google.com/File?id=dhn3dw87_116hgwt6jjk_b)

可以发现，默认的时候，中心点是在左边的。可以选择配置的选项在上面的说明中都有了，并且允许组合，比如left top, left bottom，天哪，不可思议吧。。。。。。。。

甚至，你可以缩放和对其富裕初速度。。。。。。。。。

```ini
[HelloWorld]

Color       = 
 (255.0, 0.0, 0.0)
String      = 
 "HelloWorld"
Position    = 
 (0.0, 0.0, 0.0)
Pivot       = 
 left + bottom
Speed       = 
 ( 10.0, 0.0, 0.0 )
Scale       = 
 2.0
```

大家自己去尝试吧，要知道，你可以将HelloWorld显示成各种各样的样子，却不用改变一行代码，也不用再次编译程序了，只需要改变配置。。。。。。。现在还没有好用的编辑器，很难想象，做个好用的编辑器后Orx会怎么样。。。。。。。。。。。。

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)**
