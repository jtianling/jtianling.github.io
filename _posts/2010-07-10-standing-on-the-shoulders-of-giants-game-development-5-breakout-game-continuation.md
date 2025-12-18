---
layout: post
title: "站在巨人的肩膀上开发游戏(5) -- 打砖块游戏制作续"
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
  views: '20'
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

   其实在上一节，游戏已经基本成型了，但是还不能算是完整的游戏，本篇将需要完善的部分完成吧。

## 游戏加个边框

    这个实在不需要我额外讲方法了，按原来的办法加上四周的边框即可。不过这里讲几个个人总结的技巧，边框需不需要显示呢？需要显示的话，那没有话说，直接创造一个边框就可以了，不需要显示呢？我想出了两个办法，其一，将边框创造在显示范围以外，那么自然是看不见了。其二，创建完全透明的图，那么你就可以将边框放置在任何你想要加碰撞阻挡，却不希望玩家看到的位置了。其三，不透明的图其实也行，只需要放置在Z轴超出视景体即可（大于远剪裁面，小于等于近剪裁面），由于box2D是2D的物理引擎，会忽略Z轴，同样的，只要X,Y轴对了，你还是能够获取到你想要的碰撞效果。

这里由于懒得做资源了，直接使用Orx作者的资源和配置，所以使用第一种方法。  
首先，用作者的wall.png创造四周的墙壁，为了先看到直观的看到碰撞效果，同时也为了大概确认位置正确，我们首先将墙壁置为可见。  
配置如下：  

```ini
; Wall

[WallTemplate]

Graphic   =
 WallGraphic
Body      =
 WallBody
BlendMode =
 alpha

[WallGraphic]

Texture =
 data/wall.png
Pivot   =
 center

[Walls]

ChildList =
 Wall1 # Wall2 # Wall3 # Wall4

[Wall1@WallTemplate]

Position  =
 (0.0, 250, 0.0)
Rotation  =
 90.0

[Wall2@WallTemplate]

Position  =
 (-170, 0.0, 0.0)

[Wall3@WallTemplate]

Position  =
 (0.0, -250, 0.0)
Rotation  =
 90.0

[Wall4@WallTemplate]

Position  =
 (170, 0.0, 0.0)

[WallBody]

PartList  =
 WallBox
Dynamic =
 false

[WallBox]

Type        =
 box
Friction    =
 1.0
Restitution =
 0.0
SelfFlags   =
 0x0001
CheckMask   =
 0x0001
Solid       =
 true
```

我新建了一个名为wall.ini的配置文件，此时在原来的game.ini中添加下面这条语句表示包含。  

@wall.ini@

其他的配置的含义在上一节中已经提到过，这里不重复了。

然后，在初始化的时候新添加一条代码创造墙壁。

```cpp
 if (orxObject_CreateFromConfig("Walls") == NULL) {
     result = orxSTATUS_FAILURE;
 }
```

看到这里，提一下Orx作者iarwain推荐的方法，iarwain推荐大量的不需要直接获取指针的对象可以通过一个类似于scene的配置端来配置，然后通过ChildList字段串起来，由于一个ChildList的列表长度是255个，（已经够多了）假如还不够的话，任意一个ChildList指定的对象还可以是仅包含ChildList的字段。。。。。如此串起来，无穷尽也。。。。以此构建整个场景。。。。。好处是可以动态添加新的东西，完全不用像我一样添加代码。

然后，就可以看到正常的碰撞效果了。而且也可以看到墙壁存在。要将难看的墙壁消去，只需要修改配置将墙壁移到显示范围外即可（记得计算墙壁本身的宽度）

![](http://docs.google.com/File?id=dhn3dw87_142vt5fdwgg_b)

此例中部分配置实际的为如下内容即可：（将墙都往屏幕外移动10像素）  

```ini
[Wall1@WallTemplate]

Position  =
 (0.0, 260, 0.0)
Rotation  =
 90.0

[Wall2@WallTemplate]

Position  =
 (-180, 0.0, 0.0)

[Wall3@WallTemplate]

Position  =
 (0.0, -260, 0.0)
Rotation  =
 90.0

[Wall4@WallTemplate]

Position  =
 (180, 0.0, 0.0)
```

## 响应输入

    有人将游戏称为第9艺术，并且，游戏与电影的区别就在于更多的交互，这里，我们来谈谈交互^^当然，那就是响应玩家的输入，并且做出反应罗。这里是用Win32平台来做例子的，所以，就说键盘输入吧。

首先，为了不在Run函数中去响应键盘输入，我添加一个新的自己的Update函数，需要是用一个计时器，相关的知识可以参考[官方的中文WIKI](<http://orx-project.org/wiki/cn/orx/tutorials/clock> "官方的中文WIKI")  
。  
需要用下面两句注册一个Update的回调函数，这里创建的是20HZ的clock。  

```cpp
  orxCLOCK *pstClock = orxClock_Create(orx2F(0.05f
), orxCLOCK_TYPE_USER);
  orxClock_Register(pstClock, GameApp::Update, NULL
, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL);
```

然后就可以在Update里面处理我们的的输入了。  
首先，配置部分，很简单。  

```ini
[Input]

SetList =
 Input
KEY_LEFT  =
 GoLeft
KEY_RIGHT =
 GoRight
```

主要就是配置Input配置段，这里的SetList一般情况下可以是其他配置段的名字，并且可以是一个list,这里为求简单，我指向了自身（配置简单化大法之一），这样就可以省下一个section。这里的配置表示按左方向键表示GoLeft的动作，按右方向键表示GoRight的动作。  
我们在代码里面看GoLeft和GoRight怎么用的：

```cpp
void
 GameApp::Update(const
 orxCLOCK_INFO *_clock_info, void
 *_context)   
{
#define MOVE_SPEED   
10

    
    if
( orxInput_IsActive("GoLeft"
) ) {
    orxVECTOR pos;
    orxObject_GetPosition(gPaddle, &pos);
    pos.fX -= MOVE_SPEED;
    orxObject_SetPosition(gPaddle, &pos);

    } if
 (orxInput_IsActive("GoRight"
)) {
    orxVECTOR pos;
    orxObject_GetPosition(gPaddle, &pos);
    pos.fX += MOVE_SPEED;
    orxObject_SetPosition(gPaddle, &pos);
    }
}
```

这里的gPaddle就是全局的paddle指针。然后，此时的游戏已经可以玩了。按左右方向键移动paddle即可。  

![](http://docs.google.com/File?id=dhn3dw87_143969dqqf9_b)

这里再贴一下新的完整代码，有部分修改，还有一些改进前一节教程的内容
  1   

  2   
#include   
"orx.h"  

  3   

  4   
#include   
  

  5   
#include   
  

  6   
using  
 namespace  
 std;  
  7   
orxOBJECT* gPaddle;  
  8   
class  
 GameApp  
  9   
{  
 10   
public  
:  
 11   
  static  
 orxSTATUS orxFASTCALL  EventHandler(const  
  orxEVENT *_pstEvent);  
 12   
  static  
 orxSTATUS orxFASTCALL  Init();  
 13   
  static  
 void  
 orxFASTCALL       Exit();  
 14   
  static  
 orxSTATUS orxFASTCALL  Run();  
 15   
  static  
 void  
 orxFASTCALL   Update(const  
  orxCLOCK_INFO *_clock_info, void  
  *_context);  
 16   
  
 17   
  GameApp() {};  
 18   
  ~GameApp() {};  
 19   
  
 20   
  static  
 GameApp* Instance() {  
 21   
      static  
 GameApp instance;  
 22   
      return  
 &instance;  
 23   
  }  
 24   
  
 25   
private  
:  
 26   
  orxSTATUS                     InitGame();  
 27   
};  
 28   
  
 29   
#define BLOCK_TYPE   
1  
  
 30   
  
 31   
orxOBJECT *CreateText(orxSTRING _zTextSection)  
 32   
{  
 33   
    orxConfig_PushSection(_zTextSection);  
 34   
    orxConfig_SetString("Graphic"  
, _zTextSection);  
 35   
    orxConfig_SetString("Text"  
, _zTextSection);  
 36   
  
 37   
    orxOBJECT *pstReturn = orxObject_CreateFromConfig(_zTextSection);  
 38   
  
 39   
    orxConfig_PopSection();  
 40   
  
 41   
    return  
 pstReturn;  
 42   
}  
 43   
  
 44   
// Init game function  

 45   
orxSTATUS GameApp::InitGame()  
 46   
{  
 47   
  orxSTATUS result = orxSTATUS_SUCCESS;  
 48   
  orxCLOCK *pstClock = orxClock_Create(orx2F(0.05f  
), orxCLOCK_TYPE_USER);  
 49   
  orxClock_Register(pstClock, GameApp::Update, NULL  
, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL);  
 50   
  
 51   
  
 52   
  // Creates viewport  

 53   
  if  
 ( orxViewport_CreateFromConfig("Viewport"  
 ) == NULL  
 ) {  
 54   
       result = orxSTATUS_FAILURE;  
 55   
  }  
 56   
  
 57   
  if  
 (orxObject_CreateFromConfig("Ball"  
 ) == NULL  
 ) {  
 58   
       result = orxSTATUS_FAILURE;  
 59   
  }  
 60   
  
 61   
  
 62   
  if  
 ( (gPaddle = orxObject_CreateFromConfig("Paddle"  
 )) == NULL  
 ) {  
 63   
       result = orxSTATUS_FAILURE;  
 64   
  }  
 65   
  
 66   
  if  
 (orxObject_CreateFromConfig("Blocks"  
 ) == NULL  
 ) {  
 67   
       result = orxSTATUS_FAILURE;  
 68   
  }  
 69   
  
 70   
  if  
 (orxObject_CreateFromConfig("Walls"  
 ) == NULL  
 ) {  
 71   
       result = orxSTATUS_FAILURE;  
 72   
  }  
 73   
  
 74   
  orxEvent_AddHandler(orxEVENT_TYPE_PHYSICS, GameApp::EventHandler);  
 75   
  // Done!  

 76   
  return  
 result;  
 77   
}  
 78   
  
 79   
// Event handler  

 80   
orxSTATUS orxFASTCALL GameApp::EventHandler(const  
  orxEVENT *_pstEvent)  
 81   
{  
 82   
    orxSTATUS eResult = orxSTATUS_SUCCESS;  
 83   
    if  
 (_pstEvent->eType == orxEVENT_TYPE_PHYSICS) {  
 84   
        if  
 ( _pstEvent->eID == orxPHYSICS_EVENT_CONTACT_REMOVE ) {  
 85   
            /*  
 Gets colliding objects   
*/  

 86   
            orxOBJECT *object_recipient = orxOBJECT(_pstEvent->hRecipient);  
 87   
            orxOBJECT *object_sender = orxOBJECT(_pstEvent->hSender);  
 88   
  
 89   
            string recipient_name(orxObject_GetName(object_recipient));  
 90   
            string sender_name(orxObject_GetName(object_sender));  
 91   
            if  
 (sender_name.substr(0  
 , sender_name.length()-1  
 ) == "Block"  
 ) {  
 92   
                // 这样比直接删除要安全  

 93   
                orxObject_SetLifeTime(object_sender, orxFLOAT_0);  
 94   
            }  
 95   
        }  
 96   
    }  
 97   
  // Done!  

 98   
  return  
 orxSTATUS_SUCCESS;  
 99   
}  
100   
  
101   
void  
 GameApp::Update(const  
 orxCLOCK_INFO *_clock_info, void  
 *_context)   
102   
{  
103   
#define MOVE_SPEED   
10

104   
    if  
 ( orxInput_IsActive("GoLeft"  
 ) ) {  
105   
    orxVECTOR pos;  
106   
    orxObject_GetPosition(gPaddle, &pos);  
107   
    pos.fX -= MOVE_SPEED;  
108   
    orxObject_SetPosition(gPaddle, &pos);  
109   
  
110   
    } if  
 (orxInput_IsActive("GoRight"  
 )) {  
111   
    orxVECTOR pos;  
112   
    orxObject_GetPosition(gPaddle, &pos);  
113   
    pos.fX += MOVE_SPEED;  
114   
    orxObject_SetPosition(gPaddle, &pos);  
115   
    }  
116   
}  
117   
// Init function  

118   
orxSTATUS GameApp::Init()   
119   
{  
120   
  orxSTATUS     eResult;  
121   
  orxINPUT_TYPE eType;  
122   
  orxENUM       eID;  
123   
  
124   
  /*  
 Gets input binding names   
*/  

125   
  orxInput_GetBinding("Quit"  
 , 0  
 , &eType, &eID);  
126   
  const  
 orxSTRING zInputQuit = orxInput_GetBindingName(eType, eID);  
127   
  
128   
  // Logs  

129   
  orxLOG("  
n  
\- '  
%s  
' will exit from this tutorial"  

130   
         "  
n  
* The legend under the logo is always displayed in the current language"  
, zInputQuit );  
131   
  
132   
  orxLOG("Init() called!"  
 );  
133   
  
134   
  // Inits our stand alone game  

135   
  eResult = GameApp::Instance()->InitGame();  
136   
  
137   
  // Done!  

138   
  return  
 eResult;  
139   
}  
140   
  
141   
// Exit function  

142   
void  
 GameApp::Exit()  
143   
{  
144   
  
145   
  // Logs  

146   
  orxLOG("Exit() called!"  
 );  
147   
}  
148   
  
149   
// Run function  

150   
orxSTATUS GameApp::Run()   
151   
{  
152   
  orxSTATUS eResult = orxSTATUS_SUCCESS;  
153   
  
154   
  
155   
  // Done!  

156   
  return  
 eResult;  
157   
}  
158   
  
159   
  
160   
// Main program function  

161   
int  
 main(int  
 argc, char  
 **argv)   
162   
{  
163   
  // Inits and runs orx using our self-defined functions  

164   
  orx_Execute(argc, argv, GameApp::Init, GameApp::Run, GameApp::Exit);  
165   
  
166   
  // Done!  

167   
  return  
 EXIT_SUCCESS  
 ;  
168   
}  
169   
  
170   
  
171   
#ifdef __orxMSVC__  

172   
  
173   
// Here's an example for a console-less program under windows with visual studio  

174   
int  
 WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int  
 nCmdShow)  
175   
{  
176   
  // Inits and executes orx  

177   
  orx_WinExecute(GameApp::Init, GameApp::Run, GameApp::Exit);  
178   
  
179   
  // Done!  

180   
  return  
 EXIT_SUCCESS  
 ;  
181   
}  
182   
  
183   
#endif  
 // __orxMSVC__
```

一共183行。我并没有特意的精简代码，比如有两个可供切换的Main函数部分，有很多可以Init部分其实也都可以通过iarwain的方式缩减。  
全部的源代码在:https://orx-sample.jtianling.googlecode.com/hg/  
上，可以通过mercurial直接获取。  
这里同样提供一个对比的参考。  
《[How To Create A Breakout Game with Box2D and Cocos2D Tutorial: Part 1/2](<http://www.raywenderlich.com/475/how-to-create-a-simple-breakout-game-with-box2d-and-cocos2d-tutorial-part-12> "How To Create A Breakout Game with Box2D and Cocos2D Tutorial: Part 1/2")  
》  
《[How To Create A Breakout Game with Box2D and Cocos2D Tutorial: Part 2/2](<http://www.raywenderlich.com/505/how-to-create-a-simple-breakout-game-with-box2d-and-cocos2d-tutorial-part-22> "How To Create A Breakout Game with Box2D and Cocos2D Tutorial: Part 2/2")  
》  
点击链接下载源代码：[Cocos2D and Box2D Breakout Game](<http://www.raywenderlich.com/downloads/Box2DBreakout2.zip>)  

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**