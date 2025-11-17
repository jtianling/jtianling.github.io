---
layout: post
title: "【转】【翻译】Orx官方教程：05.视口与摄像机 (viewport & camera)"
categories:
- "翻译"
- "转载"
tags:
- Camera
- Orx
- Viewport
- "摄像机"
- "视口"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '2'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文译自 orx tutorials 的[视口与摄像机  
(viewport & camera)](<http://orx-project.org/wiki/en/orx/tutorials/viewport>)  
  
落后的簔羽鹤译。最新版本见Orx [官方中文Wiki](<http://orx-project.org/wiki/cn/orx/tutorials/viewport>)  
。  
本文转自落后的簔羽鹤的[博客](<http://blog.csdn.net/wind2006>)  
。原文链接在：<http://blog.csdn.net/wind2006/archive/2010/07/07/5717831.aspx>  
。望有新人能够加入这个翻译者的队伍，早日将Orx的WIKI页中文化。有兴趣的请加入qq群73063577，并与我取得联系，防止重复翻译。

 

## 综述  

请阅读前面的基本教程  
basic object creation(基本类创建),clock handling（时钟） ,fremes hierarchy（层次结构） 和  
animations（动画）。

此教程显示了如何使用有多个摄像机的多视口技术。教程中将同时创建4个视口。

分别为左上角的（Viewport1），右下角的（Viewport4），它们共用一个摄像机  
(Camera1)，实现此功能，只需要在配置文件中配置2个视口的Camera属性，为同一个(也就是Camera1)。当我们使用鼠标的左右键旋转摄  
像机(Camera1),left Control或left  
Shift键+方向键进行摄像机的缩放操作，关联的两个Viewport1和Viewport4将相应的发生变化。

右上角视口（Viewport2）是基于另一个摄像机（Camrea2），此摄像机的视锥较第一  
个窄，所以显示时比例是其的两倍大。在教程的程序中，我们不能通过任何操作设置此视口。

最后一个视口（Viewport3）是基于Camera3的，Camera3的配置与  
Camera1完全一样。

NB：当两个视口重叠，较先创建的将显示在顶层。

最后，有一个固定不动的箱子和一个世界坐标随着鼠标实时移动的小兵，也就是说无论如何设置视口的  
摄像机，无论鼠标在那个视口上移动，小兵在它所属的视口中，相对于鼠标在在屏幕中的位置移动。

在配置文件中使用随机关键字符‘~’,使的视口和基本对象的颜色和大小可以随机创建。

NB：摄像机将它的坐标/缩放尺度/旋转存放在  
orxFRAME  
结构中，在[[frame|frame]]教程中我们看到他们是orxFrame继承体系的一部分。另一方面Object应该置于其Camera所关联的  
Viewport中。

## 详细说明  

  
  通常我们需要首先载入配置文件，创建时钟和注册回调的Update函数，最后创建主要的Object信息。关于实现的详情，请联系前面的教程。

  
  虽然这次我们创建了4个视口，却没有什么新东西，仅仅是以下4行代码。

```c
pstViewport = orxViewport_CreateFromConfig("Viewport1");
orxViewport_CreateFromConfig("Viewport2");
orxViewport_CreateFromConfig("Viewport3");
orxViewport_CreateFromConfig("Viewport4");
```

 

正如你所看到的，我们只使用了  
Viewport1的引用，以便后面进行操作。

让我们直接跳到Update函数的代码。

首先我们通过捕捉鼠标的坐标，  
设置士兵的位置。我们已经在frame  
tutorial里实现过了。这里我们做了一样的事情，但在4个视口中工作的都很完美。当鼠标离开视口时，世界坐标的指针，将被orxNull值所代替，  
也就不会触发士兵的移动了。

```c
orxVECTOR vPos;

if(orxRender_GetWorldPosition(orxMouse_GetPosition(&vPos), &vPos) != orxNULL)
{
    orxVECTOR vSoldierPos;

    orxObject_GetWorldPosition(pstSoldier, &vSoldierPos);
    vPos.fZ = vSoldierPos.fZ;

    orxObject_SetPosition(pstSoldier, &vPos);
}
```

在操作视口之前，我们先关注下视口所关联的摄像机，我们可以移动，旋转和缩放它。获  
取摄像机的代码如下所示：

pstCamera =  
orxViewport_GetCamera(pstViewport);

非常简单。让我们实现旋转。  
  
((其他方向仅仅只有部分代码，但是逻辑是一样的)).

```c
if(orxInput_IsActive("CameraRotateLeft"))
{
    orxCamera_SetRotation(pstCamera, orxCamera_GetRotation(pstCamera) + orx2F(-4.0f) * _pstClockInfo->fDT);
}
```

我们再次看到旋转的角度时间并  
不依赖于FPS而且可以做时间的伸缩控制（译者注：比代码依然很简单。

现在让们来看看视口的数据配置情况。如慢动作）  
 因为用的是时钟的DT。

我  
们再次看到旋转的角度时间并不依赖于FPS而是时钟的DT。我们也可以通过设置System这个配置选项来设置旋转速度，而不是使用硬编码。

实现缩放如下：

```c
if(orxInput_IsActive("CameraZoomIn"))
{
    orxCamera_SetZoom(pstCamera, orxCamera_GetZoom(pstCamera) * orx2F(1.02f));
}
```

 

因为这个代码没有使用时钟信息，所以他将会被时钟频率和帧率所影响。

最后让我们移动摄像机。

```c
orxCamera_GetPosition(pstCamera, &vPos);

if(orxInput_IsActive("CameraRight"))
{
    vPos.fX += orx2F(500) * _pstClockInfo->fDT;
}

orxCamera_SetPosition(pstCamera, &vPos);
```

好  
了，与摄像机有关的先到这里吧。

在下面的配置中我们将看到，同一个摄像机被连接到两个不同的视口。操作摄像机将同时  
影响两个视口。

我们可以直接修改视口的位置和尺寸，如下所示：

```c
orxFLOAT fWidth, fHeight, fX, fY;

orxViewport_GetRelativeSize(pstViewport, &fWidth, &fHeight);

if(orxInput_IsActive("ViewportScaleUp"))
{
    fWidth *= orx2F(1.02f);
    fHeight*= orx2F(1.02f);
}

orxViewport_SetRelativeSize(pstViewport, fWidth, fHeight);

orxViewport_GetPosition(pstViewport, &fX, &fY);

if(orxInput_IsActive("ViewportRight"))
{
    fX += orx2F(500) * _pstClockInfo->fDT;
}

orxViewport_SetPosition(pstViewport, fX, fY);
```

 

如上 所示，没有什么惊奇的，非常简单。

让我们来接着看看  
viewport的配置方面的东西。

 

```ini
[Viewport1]
Camera           = Camera1
RelativeSize     = (0.5, 0.5, 0.0)
RelativePosition = top left
BackgroundColor  = (0, 100, 0) ~ (0, 255, 0)

[Viewport2]
Camera           = Camera2
RelativeSize     = @Viewport1
RelativePosition = top right
BackgroundColor  = (100, 0, 0) ~ (255, 0, 0)

[Viewport3]
Camera           = Camera3
RelativeSize     = @Viewport1
RelativePosition = bottom left
BackgroundColor  = (0, 0, 100) ~ (0, 0, 255)

[Viewport4]
Camera           = @Viewport1
RelativeSize     = @Viewport1
RelativePosition = bottom right
BackgroundColor  = (255, 255, 0)#(0, 255, 255)#(255, 0, 255)
```

一共有3个摄像机，它们关联了4个视口，其中Camera1关联了  
Viewport1和Viewport4。

我们注意到Viewport1的配置文件中relativeSize设置为  
（0.5,0.5,0）.它代表的意思在x轴和y轴方向上分别使用一半的显示尺寸（z轴被忽略）。也就是说，任何一个视口实际上显示部分的内容是可调的，  
可以是全屏或者非全屏。

接下来我们注意到其他视口的RelativeSize属性被设置成@Viewport1。它的意  
思是RelativeSize属性继承Viewport1的RelativeSize属性，也就是说它们的RelativeSize属性和  
Viewport1的RelativeSize属性一样。我们也可以看到Viewport4的Camera属性被设置成@Viewport1,表明它继承  
自Viewport1的摄像机。

为了避免视口在屏幕中互相重叠遮盖，我们可以设置RelativePosition属性为常量字  
符或者使用vector（向量）设置它们的合理位置。

最后前三个视口使用随机的红色作为背景颜色，设置如下：

BackgroundColor  
= (200, 0, 0) ~ (255, 0, 0)

如果我们希望通过准确的随机颜色进行设置，可以使用一下列表的形式设置，随机的颜色  
分别为黄、青和品红，设置如下：

BackgroundColor = (255, 255, 0)#(0, 255, 255)#(255, 0, 255)

这种使用方式是相当于在三个颜色（黄色，蓝绿色，品红）中进行随机。

最后让我们关注摄像机的设置。

```ini
[Camera1]
FrustumWidth  = @Display.ScreenWidth
FrustumHeight = @Display.ScreenHeight
FrustumFar    = 1.0
FrustumNear   = 0.0
Position      = (0.0, 0.0, -1.0)

[Camera2]
FrustumWidth  = 400.0
FrustumHeight = 300.0
FrustumFar    = 1.0
FrustumNear   = 0.0
Position      = (0.0, 0.0, -1.0)

[Camera3@Camera1]
```

  

基本属性frustum（视  
锥），被摄像机所拍摄的世界空间的一部分，将被映射到视口显示。

NB：使用2D摄像机视锥的形状是  
长方体  
。

我们可以发现Camera3完  
全继承自Camera1，它没有覆盖Camera1的任何属性。

NB：使用完全继承所有属性可以写成：  
[MySection@ParentSection]。

为什么实用两个不同的摄像头呢？仅仅因为可以有  
两个不同的物理实体(physical entities)：我们在代码中修改了Camera1的属性，而 Camara3将保持不变。

我们注意到Camera1的  
FrustumWidth和FrustumHeight属性继承自Display的屏幕设置。

NB: 当继承某个属性，可以写成MyKey =  
@ParentSection.ParentKey.当两个key一样时，其中父选关键字可以省略如：SameKey =  
@ParentSection.

最后我们注意到Camera2具有较小的视锥。

也就是说Camera2只能看  
到世界空间的较小部分。所以视口看起来具有了放大的效果。

 

## 资源  

源代码：   
[05_Viewport.c  
](<https://orx.svn.sourceforge.net/svnroot/orx/trunk/tutorial/src/05_Viewport/05_Viewport.c>)

[配置文件  
](<https://orx.svn.sourceforge.net/svnroot/orx/trunk/tutorial/src/05_Viewport/05_Viewport.c>)  
：   
[05_Viewport.ini  
](<https://orx.svn.sourceforge.net/svnroot/orx/trunk/tutorial/bin/05_Viewport.ini>)

[](<https://orx.svn.sourceforge.net/svnroot/orx/trunk/tutorial/bin/05_Viewport.ini>)

1) very useful  
for making HUD & UI, for example

在HUD和UI中很有用

2)   
其他方向仅仅只有部分代码，但是逻辑是一样的

3) composed of  
keywords top, bottom, center, right and left

由关键字  
top,bottom,center,right和left组成

4) the '~' character is used as a  
random operator between two numeric values

'~'  
字符被用在两个数字之间，作为随机操作符