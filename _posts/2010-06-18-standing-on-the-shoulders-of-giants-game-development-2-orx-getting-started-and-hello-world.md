---
layout: post
title: "站在巨人的肩膀上开发游戏(2) -- Orx入门引导及Hello World"
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
  views: '12'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文是Orx游戏引擎的Hello World教程。文章指出，Orx是高度配置驱动的引擎，虽然代码量极少，但实现简单显示也需要多个配置段，初学门槛较高。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](http://www.jtianling.com)**

[**讨论新闻组及文件**](http://groups.google.com/group/jiutianfile/)

## 前言

关于Orx的使用，iarwain自己写过一系列非常[详细的教程](http://orx-project.org/wiki/en/orx/tutorials/main "详细的教程")，推荐每个学习Orx的人阅读之。此外，学习Orx的热心人士Grey也写过一个小教程：[Grey's tutorials](http://orx-project.org/wiki/en/orx/tutorials/community/grey "en:orx:tutorials:community:grey")。

开始写本系列的时候，不打算是上述教程的翻译，（iarwain表示很期待有人将其翻译成中文。。。。。有意向的可以与我联系，我会尽可能的提供帮助，虽然我对Orx的了解并不算透彻），也不准备重复上述教程中提到过的东西，也不是以替代上述教程为目的。想以完成实际的一个游戏为脉络，但是具体是以Orx的使用为主，（那么会偏重于各个配置），还是以Orx的API使用为主，或者探求Orx的内部，探寻实现原理，在这上面笔者比较矛盾。。。。。。。。。唉。。。写点东西纯属个人学习过程中的副产品，个人爱好而已，有的时候想法太多反而混乱，很想没有拘束的乱写一气，想到哪写到哪，但是又怕写的像当年边学边写的《[Win32 OpenGL系列](http://www.jtianling.com/archive/2009/11/06/4776410.aspx)》一样乱七八糟，错误百出。。。。。。。推荐所有人看过原iarwain教程并对Orx有一定了解后再看本系列文章，不然难说看完后我俩谁更混乱。本系列仅仅作为一个完整的Orx游戏制作参考+一些源码导读吧。

## 版本选择

在原来的《[站在巨人 的肩膀上开发游戏(1) -- orx 库简单介绍](http://www.jtianling.com/archive/2010/06/07/5652697.aspx)》中已经简单介绍过Orx了。

因为最近orx更新较快，但是API已经稳定，对于Win32平台，这里我推荐使用的是iarwain(Orx主要维护者）发布的稍微老一点的稳定版，[orx1.1](http://sourceforge.net/projects/orx/files/orx/orx%20-%201.1%20%281740%29/orx-dev-msvs2008-1.1.zip/download "orx1.1")是iarwain编译好的版本，可以拿来就用。此版本有着较稳定的对Win32平台的支持。作者还发布过[1.2的beta版本](https://sourceforge.net/projects/orx/files/orx/orx%20-%201.2%20%28beta%29/orx-full-iPhone-1.2-beta.zip/download "1.2的beta版本")在此版本中，正式提供了对IPhone的支持。这里有[SVN上的最新版](http://orx.svn.sourceforge.net/viewvc/orx/trunk.tar.gz?view=tar "SVN上的最新版")，大家可以到http://orx.svn.sourceforge.net/viewvc/orx/trunk/上去下载，或者，用svn checkout https://orx.svn.sourceforge.net/svnroot/orx /trunk，这些最新的版本虽然添加了新的对IPhone,IPad的支持，但是就我在Win32试用的情况来看，还是有很多不稳定的情况，甚至有一次我编译都失败了，作者也正在将orx从SFML迁移到SDL，这也是个较大的工程，所以，我个人还是推荐大家暂时使用作者发布的1.1版本（PC）或原1.2的beta版本(IPhone），等待作者发布正式的1.2版本时再去使用新版本。iarwain曾经预计在5月末期发布orx1.2，不过因为iarwain突然想要添加一些[新的功能](http://www.jtianling.com/archive/2010/06/15/5672068.aspx "新的功能")，延期了，现在iarwain预计在6月下旬发布1.2版本，他说，"very soon now...."。

## 工程建立

我不希望所有的教程都像原来的Orx教程一样，仅仅是通过动态plugin的方式或者仅仅包含Orx Lib的方式，我希望教程与Orx源代码在一起，方便debug 进Orx的源代码和做游戏时查看Orx的源代码。这里我自己选择的是[orx1.1的源代码版本](http://sourceforge.net/projects/orx/files/orx/orx%20-%201.1%20%281740%29/orx-src-1.1.zip/download "orx1.1的源代码版本")。然后，我的[所有教程源代码](http://code.google.com/p/jtianling/source/checkout?repo=orx-sample "所有教程源代码")都会在Google Code的上托管。大家按需checkout，我还是使用了[mercurial](http://www.jtianling.com/archive/2009/09/26/4593687.aspx "mercurial")。

工程创建方面的知识本来是不与Orx特别相关的，这里仅仅提到几点特别的地方，工程中SDL的部分在1.1中并没有使用，这是iarwain将来的1.2版本使用的。Orx本身的源代码有好几个选项，这与Orx支持的一些特殊功能有关，使用时需要特别注意自己需要的到底是什么，比如我上面的工程使用的就是Embedded Dynamic Debug/Release。另外，因为SDL和SFML库的版权问题，(LGPL)推荐使用Embedded Dynamic Debug的方式，这样你才可以闭源发布自己的软件。而在IPhone平台，iarwain没有使用SDL，所以你可以完全包含Orx并闭源发布。

在https://jtianling-orx--template-1-1.googlecode.com/hg/上，就是一个附带orx,box2d源代码的工程，（也包含了所有必要的lib和dll)可以很方便的进行调试。修改好工作路径后，就可以直接编译运行了，用的是iarwain的standalone（教程10[stand alone & localization](http://orx-project.org/wiki/en/orx/tutorials/standalone "en:orx:tutorials:standalone")）的例子。

## Orx的设计（纯个人看法）

说在Hello World前面的话：仅仅想学Orx使用的人完全可以忽略，只要做到Orx 的 Hello World会比较复杂的心理准备即可。以下仅仅解释为什么会这样。

在Orx中Hello World的例子已经算是很复杂了，同时也说明了作为一个有一切完备野心的游戏引擎Orx的复杂之处。即，为了让Orx尽量的做更多的工作，为了让更多的东西可配置，事实上，Orx很难简单的作为一个库来使用，比如，简单的用一条Print语句让Orx在屏幕上显示一个Hello World。更进一步说，你要么用Orx，要么不用，很难说，我就想要Orx的某一部分，比如，就用Orx的图形显示部分，其他的东西都不要，你很难做到。

从这点上来讲，事实上，Orx本身的设计是比较缺乏正交性的，也就是说内部各模块之间关联是比较紧密的，以各种方式耦合在一起。也许你仅仅调用了一条orxObject_CreateFromConfig API语句，然后Orx使用了配置模块，读取配置，然后使用io模块，读取材质文件，使用display,render模块，显示物体，使用物理模块，模拟物理，使用FX模块来完成你配置的特效，甚至同时还使用了animation模块来播放你配置的动画，并用声音模块播放声音。简单的说，我要想将整个orxObject_CreateFromConfig的调用流程全部走一次，可以看到几乎整个Orx...........你没有看错，我说的就是一个API调用。初学者往往会在这里懵掉。

从根本上来讲，问题的关键在于配置，因为从最开始，iarwain就打算将Orx做成数据驱动的（实际是config驱动的）游戏引擎，所以，必然的，一切可配置的东西就和配置耦合在一起了。然后，为了能够在配置中能够简单的描述，iarwain提供了一个非常高级的抽象，object，object能够表示上述几乎所有模块的配置，于是乎，object也陷进了强耦合性的深渊了。。。。。最后，也就形成了上面的情况，一个orxObject_CreateFromConfig调用，你实际可能是在调用整个Orx的各个模块。

不知道iarwain是否考虑了到了这一点，所以在Orx中提供了plugin的方案，使得你可以替换掉内部使用的一些东西，比如图形plugin,物理引擎plugin等等，但是，这还是不能改变其本质，你无法不使用配置和object。

但是，随着更进一步的了解Orx，和查看Orx的源代码，会发现Orx本身的设计会比你想象的要精妙。配置，问题的关键在于配置，iarwain想要配置主宰一切，就无法避开配置与一切关联的事实，然后，其使用了object来接管整个配置，也就接管了整个引擎。再然后，iarwain尽量的保持了下面的模块的正交性，虽然也许很多模块都会有一个XXX_CreateFromConfig接口，但是除了这个以外，大部分模块完全独立，由object来使用一切，然后由配置来控制object。其实也有一些例外，比如viewport，camera等，但是，总体效果上，Orx的引擎可以看成是大的层次结构 [ 配置 -> Object -> 其他模块 ]，从这个角度上来看，Orx的分层次设计又是很优美的。

最后，从总体上来讲，作为一个游戏引擎，而不是一个游戏库来开发的Orx，自动的做了太多太多的工作，（Orx说他不喜欢重复的工作），于是乎，对于初学者来说，比如我，常常会碰到一个问题，也许是配置的问题，然后很难很难去发现和理解为什么出问题，再然后就非常痛苦的去看源代码，而这个过程，由于经过了太多层的转换，由于Orx做了太多的工作，会非常漫长。然而，当你熟悉这些配置后，你会发现，你能非常快的完成你的工作，非常的惬意。很多时候，一行代码+数行的配置，就能完成非常非常多的工作。也许，将来实现一个配置文件生成工具后，会更加惬意。

这就像你通过一个自动配置，然后看着华丽的自动化操作流水线自动的生产出了一台又一台异常华丽的汽车，最后你却发现汽车无法发动。你只能从流水线的设计上一个环节一个环节开始研究为什么。

而平时我们的工作常常是在完全手工的操作一个个流水线环节，当你焊接并安装上汽车的油箱的时候，你总会知道，新生产出来的汽车还是没有加油的。

Orx就像这个华丽的自动化操作流水线。。。。。。。。。。。。

## INI配置语法

INI不是Json，不是XML，语法那个简单啊，用过Windows配置的，用过Linux众多软件配置的总会了解一些。但是iarwain在INI的基础上对INI进行了很多扩展。在Orx的WIKI上有关于Ini[的详细的介绍](http://orx-project.org/wiki/en/orx/config/syntax "的详细的介绍")。基本上看过一遍就应该知道了。

## 应用程序的运行方式

在Orx中，可以通过将自己的应用程序编译成动态库，然后通过Orx加载的方式，来实现快速的开发，（这种方式现在似乎比较流行），因为这个过程省下了编写的应用与Orx库的链接过程，所以可以用于加快开发速度。（其实与Orx的链接时间实在也算不了多久，毕竟Orx其实很小，像OGRE那样的大工程才的确需要这样的机制）几乎所有的iarwain的教学例子都是如此。

与此对应的，将Orx的代码直接链接进自己的应用，那就叫standalone程序了。我个人比较习惯这样的开发方式，并且习惯将Orx的源码建立在同一个解决方案中，以方便查看和修改。前面提到的我建立好的工程即是如此。并且，在IPhone开发中，没得选择的，必须使用此方式。

配置，是Orx的很大一部分，这里不得不提及，Orx在启动时会自动的载入与应用程序名相同的ini，比如，运行orx.exe会自动载入orx.ini，按照我们的习惯，debug版本时，在应用程序后加d，编译成orxd.exe时，自动载入的是orxd.ini。此时，Orx config的include就能发挥作用了，一般的做法是只做一个实际的orx.ini配置，然后orxd.ini中include orx.ini。

另外，特别注意的是，这种载入是默认的操作，并且是必须的。虽然Orx中有API orxConfig_Load可以手动载入配置，但是因为Orx 的辅助函数orx_Execute，（一般的使用方法）在启动初始化各模块时就使用了配置的Display段的信息来创建窗体，而手动载入配置总是会晚于这个过程，所以在Orx中必须有默认的ini，并且，必须有合适的display字段和physics字段的配置，不然在debug模式下box2d会出现断言。（主要问题出在physics的初始化上），除非你自己写一个新的类似orx_Exccute的函数，自己手动处理主循环，各模块的初始化，显示的设置。个人感觉这是个bug。。。。。。。。已经在Orx的论坛上发帖询问了，看看再说。（BTW：由于iarwain如此的热心，你有任何疑问都可以在Orx的论坛上发帖问，几乎总是会得到回应，iarwain那是知无不言言无不尽啊。。。。。）

## Hello World

在了解了这么多之后，总算可以开始学习怎么用Orx来显示Hello world了。要显示Hello World，首先需要创建出合适的窗体，并了解Orx中的一些主要配置。可以参考[此WIKI](http://orx-project.org/wiki/en/orx/config/settings_main/main "此WIKI")。

### Display

display是其中最主要需要了解的。

```ini
[ Display]   
Decoration = <bool>  ;是否显示窗体的外观，比如标题，边框等。   
FullScreen = <bool>   
ScreenWidth = <int>   
ScreenHeight = <int>   
ScreenDepth = <nt>   
Smoothing = <bool>  ;是否扛锯齿   
Title = <string>   
VSync = <bool>
```

其他的都很好理解了。

### 其他辅助配置

```ini
[Render]  
ShowFPS = true; NB: Displays current FPS in the top left corner of the screen;
```

简单的用于显示FPS。太方便了。。。。。。。。。。。我不知道在不同场合用不同的方法实现此功能多少次了，iarwain能将此功能整合进引擎，实在是善莫大焉。

```ini
[Clock]  
MainClockFrequency = 20
```

只用于没有垂直同步的情况。不然一旦设置，会消耗大量的CPU，一般情况不要有此配置段即可。

有了上面这些，我们已经可以创建一个窗体了。。。。。。。  
调用一条语句：  
orx_Execute(argc, argv, Init, Run, Exit);  
给出3个空的回调即可。。。。

我这里给其包装了一下，全部整合进一个单件的GameApp中。

全部源代码可以整合进一个文件中，也不大：

```cpp
#include "orx.h"

#include <iostream>

class GameApp  
{  
public :  
  static  orxSTATUS orxFASTCALL  EventHandler(const  orxEVENT *_pstEvent);  
  static  orxSTATUS orxFASTCALL  Init();  
  static  void  orxFASTCALL       Exit();  
  static  orxSTATUS orxFASTCALL  Run();

  GameApp() {};  
  ~GameApp() {};

  static  GameApp* Instance() {  
      static  GameApp instance;  
      return  &instance;  
  }

private :  
  orxSTATUS                     InitGame();  
};

// Init game function   
orxSTATUS GameApp::InitGame()  
{  
  orxSTATUS eResult = orxSTATUS_SUCCESS;  
   
  // Creates viewport   
  if  ( orxViewport_CreateFromConfig("Viewport" ) == NULL  ) {  
      eResult = orxSTATUS_FAILURE;  
  }

  // Done!   
  return  eResult;  
}

// Event handler   
orxSTATUS orxFASTCALL GameApp::EventHandler(const  orxEVENT *_pstEvent)  
{

  // Done!   
  return  orxSTATUS_SUCCESS;  
}

// Init function   
orxSTATUS GameApp::Init()  
{  
  orxSTATUS     eResult;  
  orxINPUT_TYPE eType;  
  orxENUM       eID;

  /*  Gets input binding names */   
  orxInput_GetBinding("Quit" , 0 , &eType, &eID);  
  const  orxSTRING zInputQuit = orxInput_GetBindingName(eType, eID);

  // Logs   
  orxLOG(" /n \- ' %s ' will exit from this tutorial"   
         " /n * The legend under the logo is always displayed in the current language" , zInputQuit );

  orxLOG("Init() called!" );

  // Inits our stand alone game   
  eResult = GameApp::Instance()->InitGame();

  // Done!   
  return  eResult;  
}

// Exit function   
void  GameApp::Exit()  
{

  // Logs   
  orxLOG("Exit() called!" );  
}

// Run function   
orxSTATUS GameApp::Run()  
{  
  orxSTATUS eResult = orxSTATUS_SUCCESS;

  // Done!   
  return  eResult;  
}

// Main program function   
int  main(int  argc, char  **argv)  
{  
  // Inits and runs orx using our self-defined functions   
  orx_Execute(argc, argv, GameApp::Init, GameApp::Run, GameApp::Exit);

  // Done!   
  return  EXIT_SUCCESS ;  
}

#ifdef __orxMSVC__

// Here's an example for a console-less program under windows with visual studio   
int  WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int  nCmdShow)  
{  
  // Inits and executes orx   
  orx_WinExecute(GameApp::Init, GameApp::Run, GameApp::Exit);

  // Done!   
  return  EXIT_SUCCESS ;  
}

#endif  // __orxMSVC__
```

并且，封装后，使用起来就像传统的C++方式了，另外，还可以通过clock来添加Update函数，当然，这是后话。  
并且，上面演示了不从命令行运行的方式，即开启宏__orxMSVC__ 的方式，此方式下，会失去命令行，作为发布。但是也失去了日志输出，所以推荐调试时还是有命令行的为好。  
创建后的窗体能在左上角看到FPS的显示。

### viewport

Orx中的viewport如同3D中的viewport概念，可以参考《[Win32 OpenGL编程(10) 视口变换](http://www.jtianling.com/archive/2009/10/29/4741527.aspx)》，Orx WIKI中的[配置详细讲解](http://orx-project.org/wiki/en/orx/config/settings_structure/orxviewport "配置详细讲解")。

```ini
[ViewportTemplate]   
BackgroundClear =  <bool>  
BackgroundColor =  <vector>  
Camera =  CameraTemplate;  
RelativePosition =  left | right | top | bottom  
Position =  <vector>  
RelativeSize =  <vector>  
Size =  <vector>  
ShaderList =  ShaderTemplate1#ShaderTemplate2  
Texture =  path/to/TextureFile  
```

同样的，也可以通过viewport来实现一屏的多显。达到《[Win32 OpenGL编程(10) 视口变换](http://www.jtianling.com/archive/2009/10/29/4741527.aspx)》中的效果，而且iarwain的官方教程中就有这样的例子。（[例5](http://orx-project.org/wiki/en/orx/tutorials/viewport "例5")）  
要想在屏幕上显示个什么东西，确定viewport是必须的，不然Orx不知道该在哪个位置显示，但是，实际的使用会更加简单，因为Orx中的配置都是有默认值的，比如viewport一般而言。可以使用默认值，也就是说，当前的全窗口作为viewport。后面会讲到一些更复杂的应用，这里暂时一笔带过吧，毕竟还是Hello World阶段。。。。。。。。。。简单的说，viewport就是描述了在什么地方显示图形的问题。

### camera

```ini
[CameraTemplate]   
FrustumHeight =  <float>  
FrustumWidth =  <float>  
FrustumNear =  <float>  
FrustumFar =  <float>  
Position =  <vector>  
Rotation =  <float>  
Zoom =  <float>  
```

Orx WIKI中的[配置详细讲解](http://orx-project.org/wiki/en/orx/config/settings_structure/orxcamera "配置详细讲解")。

viewport配置中会绑定一个camera，此camera决定了前后剪裁面等信息（如上配置所示），因为Orx是2D引擎，事实上是没有使用透视投影的，Orx使用的是正投影。前后剪裁面的设定决定了视景体剪裁的范围，这些与一般的概念类似。不明白的推荐看看OpenGL相关的知识。简单的说就是在此范围外的东西根本就不会显示。这里Orx将一些3D概念引入了2D引擎，其实增加了一般人的理解负担，个人认为绝大部分情况，其实一般的2D游戏开发者可以暂时忽略这部分，然后稍微将视景体的前后剪裁平面调大点，平时设置Object的时候注意Z轴的坐标位置不要超过此区域即可。

其实简单的说,Camera描述了你想要从哪个位置观察viewport显示的图形，并且描述了你观察的范围。

有个图对于正交视景体的描述很有帮助，来自于红宝书的在线网页。可以看到，Camera的配置其实就是对应描述了下面图中的各个值。

![](http://hi.csdn.net/attachment/201006/18/0_1276891145Ddo5.gif)

特别需要提及的是，前后裁剪面是半开区间，也就是说，图形显示的范围事实满足此公式： near < pos <= far。特别特别注意，虽然远平面上的物体会被显示出来，但是近平面的是不会的！

一般时候，如下的配置就已经很合适了。

```ini
[Viewport]   
Camera          =  Camera  
BackgroundColor =  (0, 0, 0)

[Camera]   
; We use the same size for the camera than our display on screen so as to obtain a 1:1 ratio   
FrustumWidth  =  @Display.ScreenWidth  
FrustumHeight =  @Display.ScreenHeight  
FrustumNear   =  0  
FrustumFar    =  2.0  
Position      =  (0.0, 0.0, -1.0)  
Zoom          =  1.0  
```

在上面的例子中，Camera的显示范围大小就是在Display中设置的屏幕大小，前后剪裁面分别是距离摄像头0, 2.0，这是个相对值，相对于摄像头的位置而言的Z轴， 也就是说，上面的配置中，因为Camera的位置是-1.0，所以，其实前后剪裁面的Z轴绝对位置是-1.0和1.0。 需要特别注意。 只要在设置object位置的时候，保证在此范围内，就没有问题。

### Text显示

天哪，当我需要来讲解Orx的时候，我才发现其复杂性。。。。。。因为大量的东西可配置，所以大量的东西都需要配置，这是很郁闷的，事实上，也许说明了Orx还不够成熟，默认配置还不是足够的好。总算可以开始显示文字了，到这个部分也还不简单啊。一个Hello World需要下面3段配置。

```ini
[HelloWorld]   
Graphic              =  HelloWorldGraphic

[HelloWorldGraphic]   
Text                 =  HelloWorldString  
Color                =  (255.0, 0.0, 0.0)

[HelloWorldString]   
String               =  "HelloWorld"
```

配置讲了那么多，其实整个的游戏代码可以非常少。。。。。。  
真正需要的是在Init的时候用下面几行代码即可。

```cpp
// Init game function   
orxSTATUS GameApp::InitGame()  
{  
  orxSTATUS eResult = orxSTATUS_SUCCESS;  
   
  // Creates viewport   
  if  ( orxViewport_CreateFromConfig("Viewport" ) == NULL  ) {  
      eResult = orxSTATUS_FAILURE;  
  }

  if  ( orxObject_CreateFromConfig("HelloWorld" ) == NULL ) {  
      eResult = orxSTATUS_FAILURE;  
  }

  // Done!   
  return  eResult;  
}
```

orxViewport_CreateFromConfig 用于从配置中创建Viewport,orxObject_CreateFromConfig 用于从配置中创建Text。  
至此，Hello World算是完成了.

全部源代码可以在[http://code.google.com/p/jtianling/source/list?repo=orx-sample&r=hello_world](http://code.google.com/p/jtianling/source/list?repo=orx-sample&r=hello_world)浏览或clone后，update到tag hello_world

![](http://hi.csdn.net/attachment/201006/18/0_12768751251T3v.gif)   
在Text的创建上面，我与iarwain沟通过，我认为仅仅是创建一个文字，这样的操作繁复了，三段配置其实大部分内容都是无用的，但是iarwain的意思是他是为了尽量维护text与Object的统一，如上所示，创建text的函数都是orxObject_CreateFromConfig ,这样Text就能使用额外的很多对Object使用的函数，比如Fx啥的。  
不过，我还是觉得太麻烦了，当我用这样的方法创建了一个主菜单以后，更加如此觉得，我决定添加一个便利函数，来完成这样的工作，不过放到下一篇中吧。

## 小结

全文到此也算结束了，一个Hello World牵涉到的东西之多，也许让很多人望而却步，的确，Orx在最开始的配置上，有点过于繁复了，一方面是因为Orx需要将大量的配置放出来以方便配置，另一方面，又没有提供足够好的默认配置，使得一开始的配置较多，但是，反过来说，这些都是配置上的问题，你可以从一些教程的配置的基础上开始工作，代码量其实是非常小的，上述例子中还有几行代码，那都是因为我对Orx的封装，实际的代码也就两个API调用。至于用代码更加容易理解，还是用配置更加容易理解，那就是见仁见智的问题了，我个人其实是更倾向于代码更加容易理解的，但是配置总的来还是方便。

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](http://www.jtianling.com)**
