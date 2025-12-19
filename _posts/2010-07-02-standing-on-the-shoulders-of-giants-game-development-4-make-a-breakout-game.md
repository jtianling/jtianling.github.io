---
layout: post
title: "站在巨人的肩膀上开发游戏(4) -- 做一个打砖块游戏"
categories:
- "游戏开发"
tags: []
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '9'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

虽然很早就想用做一个完整游戏来完成此教程，但是在做什么游戏的问题上很纠结，太大太好的游戏太费精力，太小的游戏又不足以展示Orx的特点，选来选去也没有自己感觉最合适的，最后还是选择打砖块吧，此游戏虽然不能展示Orx的全部特点，但是很好的展示了其内嵌物理引擎的特点。因为Orx内嵌Box2D物理引擎，所以在游戏中使用物理，从来没有这么方便过，也许，哪天我该写一篇用Cocos2D+Box2D的类似文章来做比较。

<!-- more -->

## Orx 中的Object概述

在Orx中一个Object到底表示什么？简单的说，表示一切。一切有形的无形的，可见的不可见的东西。在Orx中，所有所有的概念全部归结于 Object。所有其他的东西，都是Object的属性。包括通常概念里面的sprite,animation等等，在Orx中还包括特效(fx)，物理属性等。在几乎所有的2D游戏引擎中，几乎都是是Sprite为基础的，而在Orx中，是以Object为基础的。

## 显示一个 Object

在几乎所有的2D游戏引擎中，几乎都是是Sprite为基础的，所以最基本的操作都是显示一个Sprite，那么，换到Orx中，最基础的那就是显示一个 Object了。  
其实，在原来《[站在巨人的肩膀上开发游戏(2) -- Orx入门引导及Hello World](<http://www.jtianling.com/archive/2010/06/18/5679217.aspx>)》中，我们已经显示过一个 Object了，没错，那个Hello World的文字就是一个Object.........只不过其图形是显示文字而已。所以，我们创建Hello World的时候，调用的接口是orxObject_CreateFromConfig。  
要将其换成显示图形，只需要改配置，将其显示成一个图形即可，因为是做打砖块游戏，这里，我显示一个球。（这里的资源全部来自于《[How To Create A Breakout Game with Box2D and Cocos2D Tutorial](<http://www.raywenderlich.com/475/how-to-create-a-simple-breakout-game-with-box2d-and-cocos2d-tutorial-part-12> "How To Create A Breakout Game with Box2D and Cocos2D<br />
Tutorial")》）顺便可以将Orx版本的程序与Cocos2D + Box2D（另外一个我非常喜欢的组合）做比较。  
原代码的改动仅出于代码可读性考虑，将HelloWorld改为Ball，Orx的特点之一，不改代码，你甚至可以使用原来编译好的Hello World程序（必须是教程1老的那个，教程2新的那个我做了特殊处理），只需要将新的配置中的Ball改为HelloWorld即可。当然，出于可读性，这样做不自然，但是我还是提及这样做的可能性。  
新添加配置如下：

```ini
[Ball]
Graphic   = BallGraphic
Position  = (0.0, 0.0, 0.0)    ;球所在的位置

[BallGraphic]
Texture = data/ball.png    ;球图形的png文件的位置
Pivot   = center
```

原来的代码如下：

```cpp
// Init game function
orxSTATUS GameApp::InitGame()
{
  orxSTATUS result = orxSTATUS_SUCCESS;

  // Creates viewport
  if ( orxViewport_CreateFromConfig("Viewport") == NULL ) {
      result = orxSTATUS_FAILURE;
  }

  if (orxObject_CreateFromConfig("Ball") == NULL) {
      result = orxSTATUS_FAILURE;
  }

  // Done!
  return result;
}
```

然后，就能显示出个球了。（显示个球-_-!）

![](http://hi.csdn.net/attachment/201007/2/0_1278047688qJJ4.gif)

就这么一个Object显示出来以后，就可以继续自由发挥了，很多的想象空间。  
比如Scale     = XXX调整球的大小。  
比如Speed     = (xxx, xxx, xxx) 给球初始速度，  
(上面的属性都添加到 [Ball]段）

按照上面的方法，按打砖块游戏的特点，添加砖块及paddle。  
配置：

```ini
[Ball]
Graphic   = BallGraphic
Position  = (0.0, 180.0, 0.0)

[BallGraphic]
Texture = data/ball.png
Pivot   = center

[Paddle]
Graphic   = PaddleGraphic
Position  = (0.0, 230.0, 0.0)

[PaddleGraphic]
Texture = data/paddle.png
Pivot   = center

[Blocks]
ChildList = Block1 # Block2 # Block3 # Block4

[Block1]
Graphic   = BlockGraphic
Position  = (-50.0, -30.0, 0.0)

[Block2]
Graphic   = BlockGraphic
Position  = (50.0, -30.0, 0.0)

[Block3]
Graphic   = BlockGraphic
Position  = (-50.0, 30.0, 0.0)

[Block4]
Graphic   = BlockGraphic
Position  = (50.0, 30.0, 0.0)

[BlockGraphic]
Texture = data/block.png
Pivot   = center
```

代码：

```cpp
// Init game function
orxSTATUS GameApp::InitGame()
{
  orxSTATUS result = orxSTATUS_SUCCESS;

  // Creates viewport
  if ( orxViewport_CreateFromConfig("Viewport") == NULL ) {
      result = orxSTATUS_FAILURE;
  }

  if (orxObject_CreateFromConfig("Ball") == NULL) {
      result = orxSTATUS_FAILURE;
  }

  if (orxObject_CreateFromConfig("Paddle") == NULL) {
      result = orxSTATUS_FAILURE;
  }

  if (orxObject_CreateFromConfig("Blocks") == NULL) {
      result = orxSTATUS_FAILURE;
  }

  // Done!
  return result;
}
```

代码实在就是没有太多好说的了，在Orx中，永远是配置复杂，代码简单。说说配置中的新东西，我在这里用  
[Blocks]  
ChildList = Block1 # Block2 # Block3 # Block4  
的形式+一行创建Blocks的代码，来完成了4个砖块的创建。这是Orx中使用子列表的一种方式。  
效果如下：（我把窗口大小也改了）

![](http://hi.csdn.net/attachment/201007/2/0_1278047723mgJz.gif)

是不是有那么一点意思了？  
到目前为止，我们学到什么了？4行配置。。。。。。。。。。且只有Graphic加Texture算是新内容。只要这些，你通过position就可以完成你想要的任何图形布局了。  
当然，其实远远不止这些，请参考Orx的WIKI获取更多的信息：

* [Graphic](<http://orx-project.org/wiki/en/orx/config/settings_structure/orxgraphic> "en:orx:config:settings_structure:orxgraphic")
* [Object](<http://orx-project.org/wiki/en/orx/config/settings_structure/orxobject> "en:orx:config:settings_structure:orxobject")

## 物理的加入

好了，现在是添加真的游戏内容的时候了。光是静态图形可做不了游戏。  
在打砖块的游戏中，很重要的就是球的碰撞，反弹，以及碰撞的检测了。由于Orx中内嵌了Box2D引擎，我们能够很方便的使用，我多次提到是内嵌，而不是外挂，不是如Cocos2D那种仅仅包含一个Box2D，然后需要你调用Box2D的API去完成的那种，事实上，你可以根本不知道Box2D是啥。（其实个人感觉，了解Box2D的相关概念是必要的，不然怎么知道各个属性应该怎么配置啊）

首先，物理世界的加入：

```ini
[Physics]
DimensionRatio    = 0.1
WorldLowerBound   = (-300.0, -300.0, 0.0)
WorldUpperBound   = (300.0, 300.0, 0.0)
```

这是必须的，似乎属于Box2D为了优化而添加的，Orx为了灵活，没有自动的去配置这些属性，一般而言，将其设为包含整个游戏屏幕即可。（稍微大一点点）配置的是一个矩形的左上角和右下角。（注意Orx的坐标系啊）

然后，为各个物体添加物理属性，最主要的是Body段的属性：

```ini
[Ball]
Graphic   = BallGraphic
Body      = BallBody
Speed     = (0, -40, 0)
Position  = (0.0, 180.0, 0.0)

[BallGraphic]
Texture = data/ball.png
Pivot   = center

[BallBody]
Dynamic   = true
PartList  = BallPartTemplate

[BallPartTemplate]
Type = sphere;
Friction = 0.0;
Restitution = 1.0;
Density = 1.0;
SelfFlags = 0x0001;
CheckMask = 0x0001;
Solid = true;
```

注意Ball的中添加了一个Body     = BallBody，然后所有的物理部分都写在了BallBody和BallPartTemplate中。先说明一下，之所以我把part叫template，而且Orx的作者添加了这样一个新的段来表示物理部分，包括命名为part，是因为Orx允许一个body有多个part组合成一个object的物理。这在某些时候也极为有用。比如希望有个组合图形，一个part无法表示的时候。  
至于各个物理的属性的含义，推荐先去了解一下[Box2D 的各个定义](<http://www.box2d.org/manual.html> "Box2D的各个定义")。要图省事，看看[Orx的说明](<http://orx-project.org/wiki/en/orx/config/settings_structure/orxbody> "Orx的说明")也行。

然后，如法炮制，基本的意思就有了。

```ini
[Paddle]
Graphic   = PaddleGraphic
Body      = PaddleBody
Position  = (0.0, 230.0, 0.0)

[PaddleGraphic]
Texture = data/paddle.png
Pivot   = center

[PaddleBody]
Dynamic   = false
PartList  = PaddlePartTemplate

[PaddlePartTemplate]
Type = box;
Friction = 0.0;
Restitution = 1.0;
Density = 1.0;
SelfFlags = 0x0001;
CheckMask = 0x0001;
Solid = true;

[Blocks]
ChildList = Block1 # Block2 # Block3 # Block4

[Block1]
Graphic   = BlockGraphic
Body      = BlockBody
Position  = (-50.0, -30.0, 0.0)

[Block2]
Graphic   = BlockGraphic
Body      = BlockBody
Position  = (50.0, -30.0, 0.0)

[Block3]
Graphic   = BlockGraphic
Body      = BlockBody
Position  = (-50.0, 30.0, 0.0)

[Block4]
Graphic   = BlockGraphic
Body      = BlockBody
Position  = (50.0, 30.0, 0.0)

[BlockGraphic]
Texture = data/block.png
Pivot   = center

[BlockBody]
Dynamic   = false
PartList  = BlockPartTemplate

[BlockPartTemplate]
Type = box;
Friction = 0.0;
Restitution = 1.0;
Density = 1.0;
SelfFlags = 0x0001;
CheckMask = 0x0001;
Solid = true;
```

特别需要注意的是，Orx的设计上常常会让人感觉很多时候一个段的东西拆了几个段，写起来很麻烦，但是每个段都是可以复用的，比如此例中，所有的Block都共用一个Body。所以作者从长远考虑才这样做。

然后，再给Ball 一个速度。你就能够看到物理的作用了。球从paddle反弹到block再反弹到paddle。带角度。。。。。。。。。

## 碰撞检测

打砖块的游戏要求球碰到砖块时砖块消失的，这个需要做碰撞检测，这在Orx中也是很简单的，需要进行物理的Event响应，这是个新内容。  
首先，初始化的时候，添加关注的事件。  
orxEvent_AddHandler(orxEVENT_TYPE_PHYSICS, GameApp::EventHandler);  
这个没有什么好说的，别忘了就行。

然后，就是在注册函数中物理的响应了，此例中是GameApp::EventHandler。

```cpp
// Event handler
orxSTATUS orxFASTCALL GameApp::EventHandler(const orxEVENT *_pstEvent)
{
    orxSTATUS eResult = orxSTATUS_SUCCESS;
    if(_pstEvent->eType == orxEVENT_TYPE_PHYSICS) {
        if( _pstEvent->eID == orxPHYSICS_EVENT_CONTACT_ADD ) {
            /* Gets colliding objects */
            orxOBJECT *object_recipient = orxOBJECT(_pstEvent->hRecipient);
            orxOBJECT *object_sender = orxOBJECT(_pstEvent->hSender);

            string recipient_name(orxObject_GetName(object_recipient));
            string sender_name(orxObject_GetName(object_sender));
            if(recipient_name == "Ball" && sender_name != "Paddle") {
                orxObject_Delete(object_sender);
            }
        }
    }
  // Done!
  return orxSTATUS_SUCCESS;
}
```

有了代码后，其实基本上意思都很明显了，先判断事件的类型，然后判断事件的ID（其实相当于某类型事件中的子类型），这里判断的是物理的contact_add，表示有碰撞（外国人喜欢说有接触？）产生的时候。然后通过名字去判断两个物体是什么。这里没有考虑效率，直接用名字来判断了（事实上可以通过设定 userdate，然后通过ID判断），再进一步，为了方面直接用std::string而没有通过strcmp了。  
判断被推开的物体是球，而且还不是paddle推开的，那么就肯定是block了，此时用orxObject_Delete将其删除，实现打砖块的消除效果。

![](http://hi.csdn.net/attachment/201007/2/0_1278047707UMkM.gif)

## 需要完善的部分

游戏其实基本成型了，剩下的，就是给游戏加个边框，（这个都不需要我额外讲方法了）不然球飞出去了，然后就是操作部分了，下一节再讲。


