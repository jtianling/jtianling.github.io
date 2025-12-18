---
layout: post
title: 'Orx官方教程: 08.物理特性(Physics)教程'
categories:
- "翻译"
- "转载"
tags:
- Orx
- Physics
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '6'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文译自 orx tutorials 的  
[physics tutorial](<http://orx-project.org/wiki/en/orx/tutorials/physics>)  
，六月的流光 译。最新版本见Orx [官方中文Wiki](<http://orx-project.org/wiki/cn/orx/tutorials/physics>)  
。 本文转自六月的流光的[博客](<http://yatusiter.blogbus.com/>)

。原文链接在：<http://yatusiter.blogbus.com/logs/68692886.html>  
[  
](<http://yatusiter.blogbus.com/logs/68692886.html>)  
。

 

Physics  
tutorial

物理特性教程

 

Summary

综述

See previous   
[basic  
tutorials  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fmain%23basic&sa=D&sntz=1&usg=AFQjCNGD60-uDWY8298pt5SNbsteJ7br1g>)  
for more info about basic   
[object  
creation  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fobject&sa=D&sntz=1&usg=AFQjCNHdsd7wGhQ73McycidEnXoGIce3HQ>)  
,   
[clock  
handling  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fclock&sa=D&sntz=1&usg=AFQjCNGtKbZ3TyeTZs7hsPKoNxScOLS-YQ>)  
,   
[frames  
hierarchy  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fframe&sa=D&sntz=1&usg=AFQjCNHrYq_B4mZoe4Y1LMU-ixeUr4mmAQ>)  
,   
[animations  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fanim&sa=D&sntz=1&usg=AFQjCNE2fCn-gZK16c33CVl9KLZTt-nhuw>)  
,   
[cameras  
& viewports  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fviewport&sa=D&sntz=1&usg=AFQjCNGeKxNpJK7MLQhtc_lwYRS7SKXIhA>)  
,   
[sounds  
& musics  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fsound&sa=D&sntz=1&usg=AFQjCNETs6gcgDXVkqpHqZOgDWOrU13_5g>)  
and   
[FXs  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Ffx&sa=D&sntz=1&usg=AFQjCNGZ1gFiiajZKynohb5XzDrQRKNy5g>)  
.

 

查看之前关于  
basic   
[object  
creation  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fobject&sa=D&sntz=1&usg=AFQjCNHdsd7wGhQ73McycidEnXoGIce3HQ>)  
,   
[clock  
handling  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fclock&sa=D&sntz=1&usg=AFQjCNGtKbZ3TyeTZs7hsPKoNxScOLS-YQ>)  
,   
[frames  
hierarchy  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fframe&sa=D&sntz=1&usg=AFQjCNHrYq_B4mZoe4Y1LMU-ixeUr4mmAQ>)  
,   
[animations  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fanim&sa=D&sntz=1&usg=AFQjCNE2fCn-gZK16c33CVl9KLZTt-nhuw>)  
,   
[cameras  
& viewports  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fviewport&sa=D&sntz=1&usg=AFQjCNGeKxNpJK7MLQhtc_lwYRS7SKXIhA>)  
,   
[sounds  
& musics  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fsound&sa=D&sntz=1&usg=AFQjCNETs6gcgDXVkqpHqZOgDWOrU13_5g>)  
and   
[FXs  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Ffx&sa=D&sntz=1&usg=AFQjCNGZ1gFiiajZKynohb5XzDrQRKNy5g>)  
.以获得更多的  
信息。

 

This  
tutorial shows how to add physical properties to objects and handle  
collisions.

 

本  
教程展示了如何为对象添加物理属性和处理碰撞。

 

As you can see, the physical properties are  
completely data-driven. Thus, creating an object with physical  
properties (ie. with a body) or without results in the exact same line  
of code.

 

如你所见，物理  
属性完全是数据驱动的。因此，可以在完全相同的一行代码创建一个拥有物理属性（即通过一个body）或没有物理属性的对象。

 

Objects  
can be linked to a body which can be static or dynamic.

 

对象可以动态或  
静态地链接到一个body（译注：body为Box2D中的一个概念，表示一个物理实体的概念）。

 

Each  
body can be made of up to 8 parts.

 

每一个body可以由8部分组成。

 

A body  
part is defined by:

 

一个body部分可以定义如下：

 

●  
      
its shape (currently box,  
sphere and mesh (ie. convex polygon) are the only available)

●  
      
information about the shape size (corners for  
the box, center and radius for the sphere, vertices for the mesh)

●  
      
if no size data is specified, the shape will try  
to fill the complete body (using the object size and scale)

●  
      
collision “self” flags that defines this part

●  
      
collision “check” mask that defines with which  
other parts this one will collide   
[1)  
  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fphysics%23fn__1&sa=D&sntz=1&usg=AFQjCNFhwRrutgbEmNeLceejGOVAiWkdDQ>)  
[（  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fphysics%23fn__1&sa=D&sntz=1&usg=AFQjCNFhwRrutgbEmNeLceejGOVAiWkdDQ>)  
  
  
two  
parts in the same body will never collide  
[）  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fphysics%23fn__1&sa=D&sntz=1&usg=AFQjCNFhwRrutgbEmNeLceejGOVAiWkdDQ>)

●  
      
a flag (Solid) specifying if this shaped should  
only give information about collisions or if it should impact on the  
body physics simulation (bouncing, etc…)

●  
      
various attributes such as  
restitution, friction, density, …

 

●  
      
它的形状（目前可用的只有箱子（  
box，译注：长方体）、球体（sphere）和多边形（即 mesh，凸多边形））

●  
      
关于形状大小的信息（箱子的拐角点，球体的球心和半径以及  
凸多边形的顶点）

●  
      
如果有没指定形状的大小数据，形状会尝试填满整个body（根据对象的大小和缩放）

●  
      
“self”标记定义产生碰撞的部分

●  
      
“check”掩码定义了与这部分产生碰撞的其他部分  
（注释1 同一个物理的两个部分永远不会碰撞）

●  
      
一个标记（Solid）指定了这个形状是否只给出碰撞的  
信息还是应该影响body的模拟物理运动（弹跳等）

●  
      
其他的各种属性如  
弹性  
（restitution）  
   
、摩擦  
（friction）、密度（density）……

In this tutorial we create static solid  
walls around our screen. We then spawn boxes in the middle.

The  
number of boxes created is tweakable through the config file and is 100  
by default.

 

在  
本教程中我们创建环绕我们屏幕的静态固体墙。然后我们在中间放置箱子。

要创建的箱子数目是可以通过配置文件调整的，默认为100。

 

The  
only interaction possible is using left and right mouse buttons (or left  
and right keys) to rotate the camera.

As we rotate it, we also update the  
gravity vector of our simulation.

Doing so, it gives the impression that  
the boxes will be always falling toward the bottom of our screen no  
matter how the camera is rotated.

 

唯一可能的交互操作是使用鼠标的左右键（或者键盘左右方向键）来旋转摄像头。

在旋转时也将会  
更新我们的模拟的重力矢量。

如此，会让我们有无论摄像头怎么旋转那些箱子都一直往我们屏幕底部掉落的感觉。

 

We also  
register to the physics events to add a visual FXs on two colliding  
objects.

By  
default the FX is a fast color flash and is, as usual, tweakable in  
realtime (ie. reloading the config history will apply the new settings  
immediately as the FX isn't kept in cache by default).

 

我们也可以注册  
物理事件来为两个碰撞的物体添加可视的特效（FXs）。

默认特效（FX）是一种快速的颜色闪烁，通常也是可以实时调整的（即，重新读取配置文  
件会使新设置立即生效，因为特效默认是不保存在缓冲中的）。

 

Updating an object scale (including  
changing its scale with FXs) will update its physical properties (ie.  
its body).

Keep in mind that scaling an object with a  
physical body is more expensive as we have to delete the current shapes  
and recreate them at the correct size.

This is done this way as our current  
single physics plugin is based on Box2D which doesn't allow realtime  
rescaling of shapes.

 

更新一个对象的缩放比（包括通过FX改变它的缩放比）会更新它的物理属性（即 它的body）。

请注意改变一个  
有物理特性的body对象代价是很高的，因为我们必须删除当前的形状并按正确的大小重建。

这么做是因为我  
们目前唯一的物理引擎插件是基于Box2D的，它不支持实时重新缩放形状。

 

This tutorial does only show basic  
physics and collision control, but, for example, you can also be  
notified with events for object separating or keeping contact.

 

本教程只展示了  
简单的物理特性和碰撞控制，但是，比如说，你也可以获取到对象碰撞和结束碰撞的事件。

 

Details

详细说明

 

As usual, we begin by loading our config  
file, creating a clock and registering our Update function to it.

Please  
refer to the  
[   
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fmain%23basic&sa=D&sntz=1&usg=AFQjCNGD60-uDWY8298pt5SNbsteJ7br1g>)  
[previous  
tutorials  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fmain%23basic&sa=D&sntz=1&usg=AFQjCNGD60-uDWY8298pt5SNbsteJ7br1g>)  
for more details.

 

就像往常一样，  
我们会以加载配置文件，创建一个时钟并注册我们的更新函数作为开始。

请参考前面的教程（LINK）以获得更多信息。

 

We also  
creates our walls. Actually we won't create them one by one, we'll  
group them in a ChildList of a parent object.

 

我们也创建了我  
们的墙。实时上我们并不是一个一个的创建，我们把它们在父对象中的一个ChildList组合起来。

 

orxObject_CreateFromConfig("Walls");

 

This  
looks like we only create one object called Walls, but as we'll see in  
the config file, it's actually a container that will spawn a couple of  
walls.

 

这看起来我们只  
是创建了一个叫做Walls的对象，但我们会在配置文件中看到，它实际上是一个会产生一堆墙的容器。

 

Lastly,  
we create our boxes.

 

接着，我们创建我们的箱子。

 

```c
for (i = 0; i < orxConfig_GetU32("BoxNumber"); i++)
{
    orxObject_CreateFromConfig("Box");
}
```

 

As you  
can see, we don't specify anything regarding the physics properties of  
our walls or boxes, this is entirely done in the config file and is  
fully data-driven.

 

如你所见，我们并没有指定任何关于墙或箱子的属性，这些都在配置文件中完成了并且完全是数据驱动的。

 

We then  
register to physics events.

 

然后我们注册到物理事件。

 

orxEvent_AddHandler(orxEVENT_TYPE_PHYSICS,  
EventHandler);

 

Nothing  
really new here, so let's have a look directly to our EventHandler  
callback.

 

这  
里没有什么新东西，所以我们直接看下EventHandler回调函数。

 

```c
if (_pstEvent->eID == orxPHYSICS_EVENT_CONTACT_ADD)
{
    orxOBJECT *pstObject1, *pstObject2;

    pstObject1 = orxOBJECT(_pstEvent->hRecipient);
    pstObject2 = orxOBJECT(_pstEvent->hSender);

    orxObject_AddFX(pstObject1, "Bump");
    orxObject_AddFX(pstObject2, "Bump");
}
```

 

Basically  
we only handle the new contact event and we add a FX called Bump on  
both colliding objects. This FX will make them flash in a random color.

 

基本上我们只处  
理了新的联系事件并且我们增加了一个叫做Bump的FX在两个碰撞的对象上。这个FX会使得它们闪烁一种随机的颜色。

 

Let's  
now see our Update function.

 

现在看看我们的Update函数。

 

```c
void orxFASTCALL Update(const orxCLOCK_INFO *_pstClockInfo, void *_pstContext)
{
    orxFLOAT fDeltaRotation = orxFLOAT_0;

    if (orxInput_IsActive("RotateLeft"))
    {
        fDeltaRotation = orx2F(4.0f) * _pstClockInfo->fDT;
    }
    if (orxInput_IsActive("RotateRight"))
    {
        fDeltaRotation = orx2F(-4.0f) * _pstClockInfo->fDT;
    }

    if (fDeltaRotation != orxFLOAT_0)
    {
        orxVECTOR vGravity;

        orxCamera_SetRotation(pstCamera, orxCamera_GetRotation(pstCamera) + fDeltaRotation);

        if (orxPhysics_GetGravity(&vGravity))
        {
            orxVector_2DRotate(&vGravity, &vGravity, fDeltaRotation);
            orxPhysics_SetGravity(&vGravity);
        }
    }
}
```

 

 

As you can see, we get the rotation  
update from the RotateLeft and RotateRight inputs.

If a  
rotation needs to be applied, we then update our camera with  
orxCamera_SetRotation() and we update our physics simulation gravity  
accordingly.

This way, our boxes will always look like they  
fall toward the bottom of our screen, whichever the camera rotation is.

Note  
the use of orxVector_2DRotate() so as to rotate the gravity vector.

 

如你所见，我们  
从RotateLeft和RotateRight输入得到了旋转的更新。

如果需要旋转，那么我们就用orxCamera_SetRotation()  
来更新摄像头并且我们更新相应的物理特性模拟的重力（矢量）。

这么做，无论摄像头怎么旋转，我们的箱子总会来看起来是向我们屏幕的底部运动。

注意使用  
orxVector_2DRotate()以便旋转重力矢量。

 

NB: All rotations in orx's code are  
always expressed in radians!

 

注意：orx代码中的所有的旋转总是用弧度表示!

 

Let's  
now have a look at our config data. You can find more info on the config  
parameters in the   
[body  
section of config settings  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Fconfig%2Fsettings_structure%2Forxbody&sa=D&sntz=1&usg=AFQjCNE3M1m4HHNUYoYE5WsvB3EZis1qcw>)  
. 

First, we created implicitely many walls  
using the ChildList property. See below how it is done.

 

现在我们看一下  
我们的配置数据。你可以在  
[body  
section of config settings  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Fconfig%2Fsettings_structure%2Forxbody&sa=D&sntz=1&usg=AFQjCNE3M1m4HHNUYoYE5WsvB3EZis1qcw>)  
（LINK 配置设置中的body 配置段）找到更多关于配置参数的信息。

首先，我们通过  
ChildList属性隐式地((译者注：原文中的implicitely应为implicitly，应该是作者笔误))创建了许多墙。实现如下：

[Walls]

ChildList  
= Wall1 # Wall2 # Wall3 # Wall4; # Wall5 # Wall6

 

As we  
can see, our Walls object is empty, it will just create Wall1, Wall2,  
Wall3 and Wall4 (note the ';' ending the list there).You can remove this  
';' to create 2 additional walls.  
 

 

正如我们看到的，我们的墙对象为空，只是创建了Wall1、Wall2、Wall3  
和Wall4 （注意 ‘;’ 在列表的结尾）。你可以移除这个 ‘;’ 新增两堵墙。

 

Let's now see how we define our walls  
and their physical properties.

Let's begin with the shape we'll use for  
both WallBody and BoxBody.

 

现在让我们看看怎么定义我们的墙和它们的物理属性。

让我们从我们将  
要在WallBody和BoxBody中都用到的形状开始。

 

```ini
[FullBoxPart]
Type        = box
Restitution = 0.0
Friction    = 1.0
SelfFlags   = 0x0001
CheckMask   = 0xFFFF
Solid       = true
Density     = 1.0
```

 

Here we  
request a part that will use a box shape with no Restitution (ie. no  
bounciness) and some Friction.

We also define the SelfFlags and  
CheckMask for this wall.

The first ones defines the identity  
flags for this part, and the second ones define to which   
idendity(应  
该是 identity)  
flags it'll be sensitive (ie. with who it'll  
collide).

Basically, if we have two objects: Object1 and  
Object2. They'll collide if the below expression is TRUE.

 

这里我们创造了  
一个没有Restitution(弹性）和一点Friction(摩擦)的box (长方体)形状。

同样我们也为这  
堵墙定义了 SelfFlags 和 CheckMask。

第一个（译注：SelfFlags）定义了标识标记，第二个定义了那些它会碰撞到的标  
识标记

基  
本上，如果我们有两个对象：Object1和Object2.如果以下条件为TRUE，它们就会发生碰撞。

(Object1.SeflFlags  
& Object2.CheckMask) && (Object1.CheckMask &  
Object2.SelfFlags)

 

NB: As we don't specify the TopLeft and  
BottomRight attributes for this FullBoxPart part, it will use the full  
size of the body/object that will reference it.

 

注意：我们没有  
为这个FullBoxPart指定TopLeft 和 BottomRight 属性，所以它会使用所引用的body/object的完整尺寸。

 

Now we  
need to define our bodies for the boxes and the walls.

 

现在我们需要为  
这些箱子和墙定义我们的body。

 

```ini
[WallBody]
PartList = FullBoxPart

[BoxBody]
PartList = FullBoxPart
Dynamic  = true
```

We can see they both use the same part   
[2)  
](<http://www.google.com/url?q=http%3A%2F%2Forx-project.org%2Fwiki%2Fen%2Forx%2Ftutorials%2Fphysics%23fn__2&sa=D&sntz=1&usg=AFQjCNFMLoo28DNz9Ct4TSLYczyPR0YeJg>)  
. （they  
can have up to 8 parts, but only 1 is used here）

As  
Dynamic is set to true for the BoxBody, this object will move according  
to the physics simulation.

For the WallBody, nothing is specified  
for the Dynamic attribute, it'll then default to false, and walls won't  
move no matter what happen to them.

NB: As there can't be any collision  
between two non-dynamic (ie. static) objects, walls won't collide even  
if they touch or overlap.

 

我们可以看到他们都使用相同的部分（注释2  
它们最多可以使用8个部分，但这里只使用了一个）。

由于BoxBody（箱子的body）的Dynamic属性被设置为TRUE，这个对  
象会根据物理特性的模拟移动。

对WallBody（墙的body），没有特别指定Dynamic属性（的值），则会默认设置为  
FALSE，并且无论发生什么这些墙都不会移动。

注意：由于两个non-dynamic（即  
static，译注设置Dynamic属性为FALSE或不设置）的对象之间不能发生碰撞，即便两堵墙接触或重叠它们也不会碰撞。

 

Now  
that we have our bodies, let's see how we apply them to our objects.

First,  
our boxes.

 

```ini
[Box]
Graphic   = BoxGraphic
Position  = (50.0, 50.0, 0.0) ~ (750.0, 550.0, 0.0)
Body      = BoxBody
Scale     = 2.0
```

 

As you  
can see, our Box has a Body attribute set to BoxBody.

We can  
also notice it's random position, which means everytime we create a new  
box, it'll have a new random position in this range.

 

如你所见，我们  
的箱子有一个被设置为BoxBody的Body属性。

我们也注意到它的位置随机，这意味着每一次我们创建一个新的箱子，它会有一个在这个范  
围内的随机位置。

 

Let's  
now see our walls.

 

现在看看我们的墙。

 

```ini
[WallTemplate]
Body = WallBody

[VerticalWall@WallTemplate]
Graphic = VerticalWallGraphic;
Scale   = @VerticalWallGraphic.Repeat;

[HorizontalWall@WallTemplate]
Graphic = HorizontalWallGraphic;
Scale   = @HorizontalWallGraphic.Repeat;

[Wall1@VerticalWall]
Position = (0, 24, 0)

[Wall2@VerticalWall]
Position = (768, 24, 0)

[Wall3@HorizontalWall]
Position = (0, -8, 0)

[Wall4@HorizontalWall]
Position = (0, 568, 0)

[Wall5@VerticalWall]
Position = (384, 24, 0)

[Wall6@HorizontalWall]
Position = (0, 284, 0)
```

 

As  
we can see we use inheritance once again.

First  
we define a WallTemplate that contains our WallBody as a Body attribute.

We then  
inherits from this section with HorizontalWall and VerticalWall. They  
basically have the same physical property but a different Graphic  
attribute.

Now that we have our wall templates for both  
vertical and horizontal wall, we only need to specify them a bit more by  
adding a position.

That's what we do with Wall1, Wall2, etc…

 

正如我们看到的  
我们再一次使用到了继承。

首先我们定义一个包含设置为WallBody的Body属性的WallTemplate。

然后  
HorizontalWall和VerticalWall从这个配置段继承。基本上它们除了一个不同的Graphic属性外拥有相同的物理属性。

现在我们有水平  
和垂直的墙模板了，我们只需要再给它们添加一个位置。

这就是我们对Wall1、Wall2，等……所做的

 

Resources

资源

 

源代码：   
[08_Physics.c  
](<http://www.google.com/url?q=https%3A%2F%2Forx.svn.sourceforge.net%2Fsvnroot%2Forx%2Ftrunk%2Ftutorial%2Fsrc%2F08_Physics%2F08_Physics.c&sa=D&sntz=1&usg=AFQjCNEgpYEi4SU3HB8YZ0CroWGsPQK_fQ>)

[配置文件  
](<http://www.google.com/url?q=https%3A%2F%2Forx.svn.sourceforge.net%2Fsvnroot%2Forx%2Ftrunk%2Ftutorial%2Fsrc%2F08_Physics%2F08_Physics.c&sa=D&sntz=1&usg=AFQjCNEgpYEi4SU3HB8YZ0CroWGsPQK_fQ>)  
：   
[08_Physics.ini  
](<http://www.google.com/url?q=https%3A%2F%2Forx.svn.sourceforge.net%2Fsvnroot%2Forx%2Ftrunk%2Ftutorial%2Fbin%2F08_Physics.ini&sa=D&sntz=1&usg=AFQjCNHtgFVbcqmYipgpHn7OgekNLe6peQ>)

 

 

术语：

restitution：  
弹性

  
gravity vector ：重力矢量