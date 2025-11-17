---
layout: post
title: "【转】【翻译】Orx官方教程：10.独立程序和本地化 stand alone & localization"
categories:
- "翻译"
- "转载"
tags:
- Localization
- Orx
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '7'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

  

# 本文译自 orx tutorials 的  
[独立程序与本地化教程  
](<http://orx-project.org/wiki/en/orx/tutorials/standalone>)  
（stand alone &  
localization），六月流光 译。最新版本见Orx  
[ 官方中文Wiki  
](<http://orx-project.org/wiki/cn/orx/tutorials/standalone>)  
。 本文转自六月流光的  
[博客  
](<http://yatusiter.blogbus.com/>)  
。原文链接在：  
[http://yatusiter.blogbus.com/logs/68485225.html  
](<http://yatusiter.blogbus.com/logs/68485225.html>)  
。望有新人能够加入这个翻译者的队伍，早日将  
Orx的WIKI页中文化。有兴趣的请加入qq群73063577，并与我取得联系，防止重复翻译。  

# StandAlone tutorial  

独立程序与本地化教程（stand alone  
& localization）  

## Summary  

综述  

This is our first basic C++ tutorial. It also  
shows how to write a stand alone executable using orx and how to use  
the localization module (orxLOCALE).

 

这是我们的第一个C++基础教程。它也展示了如何使用orx编写独立的可执行文件和使用本地化模  
块（orxLOCALE）。

 

As  
we are NOT using the default executable anymore for this tutorial, its  
code will be directly compiled into the executable and not into an  
external library.

 

由  
于我们在此教程中不再使用默认的可执行文件，它的代码会被直接编译成可执行文件而不是外部库。

 

This implies that we  
will NOT have the default hardcoded behavior we had in the previous  
tutorials:

 

这暗示了我们不再有前几个教程中的如下默认行  
为：（译注：内置于默认可执行文件，同时下面的几点原本也都是否定句式，但与这里的否定矛盾，原意应该是下面这些特性会在StandAlone版本中失  
效）

  * F11 will not affect vertical sync toggler
  * Escape  
won't automatically exit
  * F12 won't capture a  
screenshot
  * Backspace won't reload configuration files
  * the  
[Main] section in the config file won't be used to load a plugin  
(“GameFile” key)

 

  * F11 切换垂直同步
  * Escape  
退出
  * F12 截屏
  * 退格键(Backspace)  
重新载入全部配置文件
  * 配置文件中的[Main] 配置段被用于加载一个插件（“GameFile” 键）

A program based  
directly on orx   
[1)  
](<http://orx-project.org/wiki/en/orx/tutorials/standalone#fn__1>)  
, by default, will  
also NOT exit     if  it receives the orxSYSTEM_EVENT_CLOSE event.To do  
so, we will either have to use the helper orx_Execute() function (  
[see below  
](<http://orx-project.org/wiki/en/orx/tutorials/standalone#details>)  
) or handle it  
ourselves.

 

一个直接基于orx的程序(注释1，即不再依靠  
ORX 启动器)，默认收到orxSYSTEM_EVENT_CLOSE事件后不退出。为了改变这种情况，我们必须使用orx_Execute()  
函数（如下link）或者自己处理。

 

See  
previous   
[basic tutorials  
](<http://orx-project.org/wiki/en/orx/tutorials/main#basic>)  
for more info about  
basic   
[object creation  
](<http://orx-project.org/wiki/en/orx/tutorials/object>)  
,   
[clock handling  
](<http://orx-project.org/wiki/en/orx/tutorials/clock>)  
,   
[frames hierarchy  
](<http://orx-project.org/wiki/en/orx/tutorials/frame>)  
,   
[animations  
](<http://orx-project.org/wiki/en/orx/tutorials/anim>)  
,   
[cameras &  
viewports  
](<http://orx-project.org/wiki/en/orx/tutorials/viewport>)  
,  
  
[sounds &  
musics  
](<http://orx-project.org/wiki/en/orx/tutorials/sound>)  
,  
  
[FXs  
](<http://orx-project.org/wiki/en/orx/tutorials/fx>)  
,   
[physics  
](<http://orx-project.org/wiki/en/orx/tutorials/physics>)  
and   
[scrolling  
](<http://orx-project.org/wiki/en/orx/tutorials/scrolling>)  
.

 

查看之前关于basic   
[object creation  
](<http://orx-project.org/wiki/en/orx/tutorials/object>)  
,   
[clock handling  
](<http://orx-project.org/wiki/en/orx/tutorials/clock>)  
,   
[frames hierarchy  
](<http://orx-project.org/wiki/en/orx/tutorials/frame>)  
,   
[animations  
](<http://orx-project.org/wiki/en/orx/tutorials/anim>)  
,   
[cameras &  
viewports  
](<http://orx-project.org/wiki/en/orx/tutorials/viewport>)  
,  
  
[sounds &  
musics  
](<http://orx-project.org/wiki/en/orx/tutorials/sound>)  
,  
  
[FXs  
](<http://orx-project.org/wiki/en/orx/tutorials/fx>)  
,   
[physics  
](<http://orx-project.org/wiki/en/orx/tutorials/physics>)  
and   
[scrolling  
](<http://orx-project.org/wiki/en/orx/tutorials/scrolling>)  
的基础教程以获得更多的信息。

 

As we're on our own  
here, we need to write the main function and initialize orx manually.The  
good thing is that we can then specify which modules we want to use,  
and deactivates display or any other module at will, if needed.

 

我们现在只能靠自己了，所以必须自己写main  
函数和手动初始化orx。

好  
处是如果需要，我们可以任意指定要使用哪些模块，停用显示模块或其他模块。

 

If we still want a semi-automated  
initialization of orx, we can use the orx_Execute() function.This  
tutorial will cover the use of orx with this helper function, but you  
can decide not to use it if its behavior doesn't suit your needs.

 

如果我们还是想要半自动初始化orx，我们可以  
使用orx_Execute()函数。

本教程将通过这个辅助函数使用orx，但是如果它的行为不符合你的需求也可以不使用。

 

This helper function  
will take care of initializing everything correctly and exiting  
properly.

It  
will also make sure the clock module is constantly ticked (as it's part  
of orx's core) and that we exit if the orxSYSTEM_EVENT_CLOSE event is  
sent.

This  
event is sent when closing the windows, for example, but it can also be  
sent under your own criteria (escape key pressed, for example).

 

这个辅助函数将会确保所有部分正确初始化和妥善  
退出。

它  
也将确保clock模块正常运作（作为 orx的核心部分）并且当（备注，一个模块不断被触发，不太好理解，事实上是表示clock一直在正常计时)

orxSYSTEM_EVENT_CLOSE事  
件发送时退出。

此  
事件在关闭窗口时发送，但是也可以按你的标准发送（例如按下Esc键）。

 

This code is also a basic C++ example to show  
how to use orx without having to write C code.

This tutorial could  
have been architectured in a better way (cutting it into pieces with  
headers files, for example) but we wanted to keep a single file per  
*basic* tutorial.

 

这  
些代码同样也是一个基础的C++示例，用来演示如何通过C语言以外的语言来使用orx。

本教程本来应该用另外一种更好的方式组织起来  
（例如分割成多个头文件）但是我们希望每个基础教程都只有一个文件。

 

This stand alone executable also creates a  
console (as does the default orx executable), but you can have you own  
console-less program if you wish.

In order to achieve that, you only need to  
provide an argc/argv style parameter list that contains the executable  
name.

If  
you don't, the default loaded config file will be orx.ini instead of  
being based on our executable name (ie. 10_StandAlone.ini).

这个独立可执行文件会创建一个终端（和默认的  
orx可执行文件一样），但是如果你喜欢也可以创建一个没有终端的可执行文件。

为了实现上述目标，你只需要提供一个包含该可执行文件名的argc/argv风格的  
参数表即可。

如  
果不这样的话，默认加载的配置文件是orx.ini，取代基于可执行文件名的配置文件（例如  10_StandAlone.ini）。

 

For   
[visual studio  
](<http://en.wikipedia.org/wiki/visual_studio>)  
users (windows), it  
can easily be achieved by writing a WinMain() function instead of  
main(), and by getting the executable name (or hardcoding it, as it's  
shamelessly done in this tutorial   
![](https://lh5.googleusercontent.com/-4gXsjwaFw8xTG2zE6iNdn0iQr0NAk3M0CB_hy1MHpLbWj2bQdm_dCaPn-SmK3aieI42WjW_eFFupoEwjnfw3d_rKJcOORKLQjqQs9Kodxe3p1Sp)

 

对visual studio  
用户（windows）而言，可以轻松通过撰写WinMain() 替代main()  
函数，并且获取可执行文件的名称（或者硬编码实现，正如本教程中可耻地这么做鸟^.^) 。

 

This tutorial simply  
display orx's logo and a localized legend. Press space or click left  
mouse button to cycle through all the availables languages for the  
legend's text.

 

本  
教程简单的现实了orx的logo和一个本地化的说明。按空格键或者点击鼠标左键以循环显示所有可用语言的说明文本。

 

Some explanations  
about core elements that you can find in this tutorial:

 

下面是一些你可以在本教程中找到的核心元素的解  
释：

 

  * Run  
function: Don't put *ANY* logic code here, it's only a backbone where  
you can handle default core behaviors (tracking exit or changing locale,  
for example) or profile some stuff. As it's directly called from the  
main loop and not part of the clock system, time consistency can't be  
enforced. For all your main game execution, please create (or use an  
existing) clock and register your callback to it.

 

  * 运行  
函数（Run  
function)：不要在这里放置任何逻辑代码，它只是一个处理默认核心行为（例如跟踪退出或者更改locale）或简要描述一些东西的主干。由于它直  
接从main循环中调用并且不是clock系统的的一部分，时间一致性无法被强制执行。对你所有的主游戏可执行文件，请在此创建（或者使用已有  
的）clock并且注册你的回调函数。

 

  * Event handlers: When  
an event handler returns orxSTATUS_SUCCESS, no other handler will be  
called after it for the same event. On the other hand, if  
orxSTATUS_FAILURE is returned, event processing will continue for this  
event if other handlers are listening this event type. We'll monitor  
locale events to update our legend's text when the selected language is  
changed.

 

  * 事件处理器（Event  
handlers）：当一个事件响应函数返回orxSTATUS_SUCCESS后，对此事件就不会再调用其他事件响应函数。另一方面，如果返回的是  
orxSTATUS_FAILURE，事件会传递给其他正在监听这个事件的响应函数。我们将监视locale事情以便当选择的语言切换时更新我们的说明文  
本。（备注：这个翻译有点乱，主要要了解Orx的事件处理方式）

 

  * orx_Execute():  
Inits and executes orx using our self-defined functions (Init, Run and  
Exit). We can of course not use this helper and handles everything  
manually if its behavior doesn't suit our needs. You can have a look at  
the content of orx_Execute()   
[2)  
](<http://orx-project.org/wiki/en/orx/tutorials/standalone#fn__2>)  
to have a better idea  
on how to do this.

 

  * orx_Execute()：通过我们自定义  
的函数（Init，Run和Exit）初始化和执行orx。当然，如果它不符合我们的需求，我们可以不使用这个辅助函数并且手动处理所有事情。你可以通过  
参考orx_Execute()的内容（注2，在orx.h中实现）了解怎么这样做。（备注，作者的better  
idea不是说更好的注意，而是对于how to do this的修饰，就是我们不知道时候说，I have no idea一样）

Details  
  
详细说明  

Let's start with the  
includes.

让  
我们从包含的文件开始。

 

#include "orx.h"

That's all you need to  
include so as to use orx. This include works equally with a C or a C++  
compiler   
[3)  
](<http://orx-project.org/wiki/en/orx/tutorials/standalone#fn__3>)  
.

  
    这就是你要使用orx所需要包含的唯一文件。它在C和C++（注释3，在这种情 况下预编译宏 __orxCPP__  
会被自动定义）编译器下都工作良好。

Let's  
now have a look at our StandAlone class that contains orx's Init(),  
Run() and Exit() callbacks.

现在看下我们的StandAlone类，包含orx  
Init()、Run()和Exit()回调函数。

class StandAlone   
  
{   
  
public:   
  
    static orxSTATUS  
orxFASTCALL EventHandler(const orxEVENT *_pstEvent);  
  
      static  
orxSTATUS orxFASTCALL Init();  
  
      static void orxFASTCALL Exit();  
  
      static  
orxSTATUS orxFASTCALL Run();  
  
    void SelectNextLanguage();

    StandAlone() :  
m_poLogo(NULL), s32LanguageIndex(0) {};  
  
      ~StandAlone()  
{};     
  
private:  
  
  
     
orxSTATUS InitGame();     
  
    Logo *m_poLogo;   
  
    orxS32  
s32LanguageIndex;   
  
};

All  
the callbacks could actually have been defined out of any class. This  
is done here just to show how to do it if you need it.  
  
We see that our  
StandAlone class also contains our Logo object and an index to the  
current selected language.

所有的回调函数实际上都可以定义在任何类之外。这里这么做只是演示当你需要的时候你可以这么做。  
我们看到StandAlone类也包含了我们的logo对象和一个当前选中的语言的索引。

Let's now have a look  
to our Logo class definition.  
  
现在看一下Logo类的定义：

class Logo   
  
{   
  
   private:   
  
    orxOBJECT  
*m_pstObject;   
  
    orxOBJECT *m_pstLegend;   
  
    public:   
  
    Logo();   
  
    ~Logo();  
  
};

Nothing fancy here, we  
have a reference to an orxOBJECT that will be our logo and another one  
that will be the displayed localized legend.  
  
As you'll see we won't  
use the reference at all in this executable, we just keep them so as to  
show a proper cleaning when our Logo object is destroyed. If we don't  
do it manually, orx will take care of it when quitting anyway.

这里没有什么特别的，我们用指针指向一个  
orxOBJECT作为我们的logo，另一个用来指向显示的本地化说明。如你所见，我们在这个可执行文件里将不会使用这个可执行文件的所有引用，我们只  
是保持它们以便显示在销毁Logo对象时被正确地清理。如果我们不手动做，在退出的时候orx会替我们搞定。

Let's now see its  
constructor.  
  
现在让我们看一下它的构造函数：  
  
Logo::Logo()   
  
{   
  
    m_pstObject =  
orxObject_CreateFromConfig("Logo");  
  
       
orxObject_SetUserData(m_pstObject, this);  
  
    m_pstLegend =  
orxObject_CreateFromConfig("Legend");  
  
}

As seen in the previous tutorials we  
create our two objects (Logo and Legend) and we link our Logo C++ object  
to its orx equivalent using orxObject_SetUserData().

用前面的教程中讲的方法，我们创建了两个对象  
（Logo和Legend）并且我们通过  
  
orxObject_SetUserData()把Logo C++对象链接到它对应的orx对象上。

Logo::~Logo()  
  
{  
  
       
orxObject_Delete(m_pstObject);  
  
      orxObject_Delete(m_pstLegend);  
  
}

Simple cleaning here  
as we only delete our both objects.

这里只是简单的删除了我们的两个对象。

Let's now see our main  
function.  
  
现  
在看看我们的main函数：

int  
main(int argc, char **argv)  
  
{  
  
      orx_Execute(argc, argv,  
StandAlone::Init, StandAlone::Run, StandAlone::Exit);   
  
    return  
EXIT_SUCCESS;  
  
}

As  
we can see, we're using the orx_Execute() helper that will initialize  
and execute orx for us.  
  
In order to do so, we need to provide it our  
executable name and the command line parameters along with three  
callbacks: Init(), Run() and Exit().

正如我们看见的，我们使用 orx_Execute()  
辅助函数来初始化和执行orx。  
  
这样我们需要提供我们的可执行文件名称和命令行参数和三个回调函数：Init()、Run() 和Exit()。

We will only exit from  
this helper function when orx quits.

只有当orx退出时我们才从这个辅助函数退出。

Let's have a quick  
glance at the console-less version for windows.  
  
我们快速浏览一下windows的无终端版本。

#ifdef __orxMSVC__    
  
int WINAPI  
WinMain(HINSTANCE hInstance, HINSTANCE PrevInstance,  
  
        LPSTR  
lpCmdLine, int nCmdShow) {  
  
    // Inits and executes orx  
  
     
orx_WinExecute(StandAlone::Init, StandAlone::Run, StandAlone::Exit);  
  
    // Done!   
  
    return  
EXIT_SUCCESS;   
  
}   #endif

Same as for the traditional main() version  
except that we use the orx_WinExecute() helper that will compute the  
correct command line parameters and use it.   
[4)（the ones given  
as parameter don't contain the executable name which is needed to  
determine the main config file name  
](<http://orx-project.org/wiki/en/orx/tutorials/standalone#fn__4>)  
）  
  
[](<http://orx-project.org/wiki/en/orx/tutorials/standalone#fn__4>)  
  
This only works for a  
console-less windows game   
[5)  
](<http://orx-project.org/wiki/en/orx/tutorials/standalone#fn__5>)  
.(which uses WinMain()  
instead of main())

和  
旧的main()  
版本一样除了我们使用orx_WinExecute()辅助函数来计算正确的命令行参数并使用它（注释4，这些给出的参数并没有包含我们需要的用来决定主  
配置文件名的可执行文件的名字）。  
  
这只能在一个无命令行（终端）的windows游戏下工作。（注释5，使用WinMain()替代main()）

Let's now see how our  
Init() code looks like.  
  
现在看看我们的Init() 代码是怎么样的：

orxSTATUS  
StandAlone::Init()  
  
{  
  
      orxLOG("10_StandAlone Init() called!");  
  
    return  
soMyStandAloneGame.InitGame();  
  
}

We simply initialize our StandAlone instance  
by calling its InitGame() method.

我们简单地用StandAlone实例中的InitGame()方法来初始化。

Let's see its content.  
  
让我们看看它的内容：

orxEvent_AddHandler(orxEVENT_TYPE_LOCALE,  
EventHandler);  
  
m_poLogo = new Logo();  
  
std::cout << "The available  
languages are:" << std::endl;  
  
for(orxS32 i = 0; i <  
orxLocale_GetLanguageCounter(); i++)  
  
{  
  
      std::cout << " \- "  
<< orxLocale_GetLanguage(i) << std::endl;  
  
}   
  
orxViewport_CreateFromConfig("Viewport");

We simply register a  
callback to catch all the orxEVENT_TYPE_LOCALE events.  
  
We then instanciate  
our Logo object that contains both logo and legend.  
  
We also outputs all  
the available languages that have been defined in config files. We could  
have used the orxLOG() macro to log as usual (on screen and in file),  
but we did it the C++ way here to show some diversity.  
  
We finish by creating  
our viewport, as seen in all the previous tutorials.

我们简单地注册了一个捕捉所有  
orxEVENT_TYPE_LOCALE事件的回调函数。  
  
然后实例化所有在配置文件中定义的可用语言。我们通常可以用orxLOG()  
宏来记录（在屏幕上和文件里），但是我们这里用C++的方式来实现以表示多样性。  
  
我们通过创建一个视口来结束，就像我们在之前所有教程中做的那样。

Let's now see our  
Exit() callback.

现  
在看下我们的Exit()回调函数：

void  
StandAlone::Exit()  
  
{  
  
    delete soMyStandAloneGame.m_poLogo;   
  
     
soMyStandAloneGame.m_poLogo = NULL;     
  
    orxLOG("10_StandAlone Exit()  
called!");  
  
}

Simple Logo object  
deletion here, nothing surprising.

没有什么特别的，简单地在这里销毁了Logo对象。

Now let's have a look  
to our Run() callback.  
  
让我们看下Run()回调函数：

orxSTATUS  
StandAlone::Run()  
  
{  
  
    orxSTATUS eResult = orxSTATUS_SUCCESS;  
  
     
if(orxInput_IsActive("CycleLanguage") &&  
orxInput_HasNewStatus("CycleLanguage"))  
  
          {  
  
                
soMyStandAloneGame.SelectNextLanguage();  
  
    }

     
if(orxInput_IsActive("Quit"))  
  
          {  
  
                
orxLOG("Quit action triggered, exiting!");  
  
        eResult =  
orxSTATUS_FAILURE;  
  
    }  
  
    return eResult;  
  
}

Two things are done here.  
  
First when the input  
CycleLanguage is activated we switch to the next available language,  
then when the Quit one is activated, we simply return orxSTATUS_FAILURE.  
  
When the Run()  
callback returns orxSTATUS_FAILURE orx (when used with the helper  
orx_Execute()) will quit.

这里完成了两件事情。  
  
首先我们当CycleLanguage被激活时，我们切换到下一个可用的语言，其次  
如果Quit被激活，我们简单地返回orxSTATUS_FAILURE。  
  
当Run()回调函数返回orxSTATUS_FAILURE时orx（使用  
orx_Execute()辅助函数）将会退出。

Let's have a quick look to the  
SelectNextLanguage() method.

让我们快速的浏览一下 SelectNextLanguage() 方法。

void  
StandAlone::SelectNextLanguage()  
  
{

s32LanguageIndex = (s32LanguageIndex ==  
orxLocale_GetLanguageCounter() - 1) ? 0 : s32LanguageIndex + 1;

  
orxLocale_SelectLanguage(orxLocale_GetLanguage(s32LanguageIndex));

}

We basically go to the  
next available language (cycling back to the beginning of the list when  
we reached the last one) and selects it with the  
orxLocale_SelectLanguage() function.  
  
When doing so, all created orxTEXT  
objects will be automatically updated if they use a localized string.  
We'll see how to do that below in the config description.  
  
We can also catch any  
language selection as done in our EventHandler callback.

基本上我们只是移动到下一个可用的语言（如果到  
最后一个则循环到列表的开头）并通过orxLocale_SelectLanguage()函数选择它。  
  
当我们这么做时，如果使用一个本地化字符串的已  
创建orxTEXT对象将会被自动更新。我们会在下面的配置描述中看到如何实现。  
  
我们可以在EventHandler回调函数中做捕捉任意语言的选择事件。

orxSTATUS orxFASTCALL  
StandAlone::EventHandler(const orxEVENT *_pstEvent)  
  
{  
  
  
 switch(_pstEvent->eID)  
  
 {  
  
   case orxLOCALE_EVENT_SELECT_LANGUAGE:  
  
  
  
  
     orxLOCALE_EVENT_PAYLOAD *pstPayload;  
  
     pstPayload =  
(orxLOCALE_EVENT_PAYLOAD *)_pstEvent->pstPayload;  
  
  
     orxLOG("Switching to '%s'.", pstPayload->zLanguage);  
  
     break;  
  
  
  
   default:  
  
  
  
     break;  
  
 }  
  
  
  
 return  
orxSTATUS_FAILURE;  
  
}

As  
you can see, we only track the orxLOCALE_EVENT_SELECT_LANGUAGE event  
here so as to display which is the new selected language.

如你所见，我们只跟踪  
orxLOCALE_EVENT_SELECT_LANGUAGE事件来显示新选择的语言。

We're now done with  
the code part of this tutorial. Let's now have a look at the config.

现在我们完成了本教程代码的部分。让我们看看配  
置吧。

First of all, as you  
might have seen, we use different folder for different architectures.  
  
In other words, the  
tutorials for Mac OS X are in the /mac folder, the ones for Linux in the  
/linux and so on. By default orx will look in the current folder to  
find the main config file.  
  
As we don't want to duplicate the config file  
in all the architecture folders, we create a very simple one which  
purpose is only to include the one that contains all the info and which  
is in the parent folder.

首选，正如你已经见到的，我们使用对不同的平台使用不同的文件夹。  
  
换而言之，Mac OS X的教程放在  
/mac文件夹，Linux的教程放在/linux，以此类推。默认的情况下，orx会查找当前目录下的主配置文件。  
  
为了避免在不同的平台下都有重复的配置文件，我  
们创建了一个简单地配置文件包含了父文件夹中配置文件的全部信息。

Let's see how we do this by looking at the  
content of 10_StandAlone.ini from one of the sub-folder (ie. one that is  
stored in the same folder than the tutorial executable).

让我们通过其中一个子目录（即和教程可执行文件  
存储位置相同的文件夹）下的10_StandAlone.ini 的内容看看怎么实现的。

@../10_StandAlone.ini@

That's all we can find  
in it. As you can see in the   
[template files  
](<http://orx-project.org/wiki/en/orx/config/settings_structure/main>)  
, we can include other  
config files by writing @path/to/FileToInclude@.

所有的内容如上。就像你在  
[配置语法说明  
](<http://orx-project.org/wiki/en/orx/config/syntax>)  
中看到的，我们可以通过@path/to  
/FileToInclude@ 在一个配置文件中包含其他的配置文件。（译注：这里怀疑是作者的问题,template  
files实际是想链接到WIKI的配置的说明上去）

Let's now have a look at the config file  
which is stored in the parent folder (ie.   
[../10_StandAlone.ini  
](<https://orx.svn.sourceforge.net/svnroot/orx/trunk/tutorial/bin/10_StandAlone.ini>)  
).

现在我们看看父文件夹中存储的配置文件（即  
[../10_StandAlone.ini  
](<https://orx.svn.sourceforge.net/svnroot/orx/trunk/tutorial/bin/10_StandAlone.ini>)  
link）：

First let's define our  
display.

首先定义我们的display配置段：

[Display]  
  
ScreenWidth   = 800  
  
ScreenHeight  = 600  
  
Title         = Stand  
Alone/Locale Tutorial

As you can see, we're creating a window of  
resolution 800×600 and define its title.

如你所见，我们将要创建一个分辨率为  
800×600的窗口，并且定义了他的标题。

We now need to provide info for our viewport  
and camera.

现在我们要提供视口（viewport）和摄像  
头（camera）配置段的信息：

[Viewport]  
  
Camera          =  
Camera  
  
BackgroundColor  
= (20, 10, 10)  
  
  
  
[Camera]  
  
FrustumWidth  = @Display.ScreenWidth  
  
FrustumHeight =  
@Display.ScreenHeight  
  
FrustumFar    = 2.0  
  
Position      = (0.0,  
0.0, -1.0)

Nothing new here as  
everything was already covered in the   
[viewport tutorial  
](<http://orx-project.org/wiki/en/orx/tutorials/viewport>)  
.

与我们在  
[视口教程  
](<http://orx-project.org/wiki/cn/orx/tutorials/viewport>)  
（viewport  
tutorial）中提到的没有任何区别。

Let's now see which inputs are defined.

现在看看输入（inputs）是怎么定义的：

[Input]  
  
SetList = MainInput  
  
  
  
[MainInput]  
  
KEY_ESCAPE  = Quit  
  
KEY_SPACE   =  
CycleLanguage  
  
MOUSE_LEFT  = CycleLanguage

In the Input section, we define all our  
input sets. In this tutorial we'll only use one called MainInput but we  
can define as many sets as we want (for example, one for the main menu,  
one for in-game, etc…).  
  
The MainInput sets contain 3 mapping:

  * KEY_ESCAPE  
will trigger the input named Quit
  * KEY_SPACE  
and MOUSE_LEFT will both trigger the input named CycleLanguage

在Input配置段，我们定义我们所有的输入集  
合。本教程中我们只会用到一个叫做MainInput的集合，但我们也定义其他任意想要使用的集合（例如，主菜单一个，游戏中一个，等等）。  
  
MainInput集合包括3个映射：

  * KEY_ESCAPE  
会触发名为Quit的输入
  * KEY_SPACE 和 MOUSE_LEFT 都会触发名为CycleLanguage的输入

We can add as many  
inputs we want in this section and bind them to keys, mouse buttons  
(including wheel up/down), joystick buttons or even joystick axes.

我们可以在这个配置段加入任意多的输入集合并且  
将它们绑定到按键、鼠标按钮（包括滚轮上/下）、游戏摇杆按钮甚至游戏摇杆的方向轴。

Let's now see how we  
define languages that will be used by the orxLOCALE module.

现在让我们看看怎么定义将要被  
orxLOCALE模块使用的语言。

[Locale]  
  
LanguageList =  
English#French#Spanish#German#Finnish#Swedish#Norwegian  
  
  
  
[English]  
  
Content = This is  
orx's logo.  
  
Lang  
   = (English)  
  
  
  
[French]  
  
Content = Ceci est le logo d'orx.  
  
Lang    = (Fran?ais)  
  
  
  
[Spanish]  
  
Content = Este es el  
logotipo de orx.  
  
Lang    = (Espa?ol)  
  
  
  
[German]  
  
Content = Das ist orx Logo.  
  
Lang    = (Deutsch)  
  
  
  
[Finnish]  
  
Content = T?m? on orx  
logo.  
  
Lang  
   = (Suomi)  
  
  
  
[Swedish]  
  
Content = Detta ?r orx logotyp.  
  
Lang    = (Svenska)  
  
  
  
[Norwegian]  
  
Content = Dette er orx  
logo.  
  
Lang  
   = (Norsk)

To  
define languages for localization we only need to define a Locale  
section and define a Language List that will contain all the languages  
we need.  
  
After  
that we need to define one section per language and for every needed  
keys (here Content and Lang) we set their localized text.

为了定义本地化需要的语言我们要定义一个  
Locale配置段和一个包含我们所需要全部的语言的列表。

As the localization system in based on orx's  
config one, we can use its inheritance capacity for easily adding new  
languages to the list (in another extern file, for example), or even for  
completing languages that have been partially defined.

由于本地化系统是基于orx配置部分，我们可以  
使用它的继承能力来简化把语言加入列表的过程（例如在另一个外部文件中），甚至也可以完善曾经只被部分定义的语言。

Let's now see how we  
defined our Logo object.

现在看看我们是怎么定义Logo对象：

[LogoGraphic]  
  
Texture =  
../../data/object/orx.png  
  
Pivot   = center  
  
  
  
[Logo]  
  
Graphic   =  
LogoGraphic  
  
FXList  
   = FadeIn # LoopFX # ColorCycle1  
  
Smoothing = true

Again, everything we  
can see here is already covered in the   
[object tutorial  
](<http://orx-project.org/wiki/en/orx/tutorials/object>)  
.

又一次，所有的内容我们都已经在  
[对象教程  
](<http://orx-project.org/wiki/cn/orx/tutorials/object>)  
（object tutorial）中涵盖了。

If you're curious you  
can look directly at   
[10_StandAlone.ini  
](<https://orx.svn.sourceforge.net/svnroot/orx/trunk/tutorial/bin/10_StandAlone.ini>)  
to see which kind of  
FXs we defined, but we won't cover them in detail here.

如果你对我们定义了哪些FX感到好奇，你可以直  
接查看   
[10_StandAlone.ini  
](<https://orx.svn.sourceforge.net/svnroot/orx/trunk/tutorial/bin/10_StandAlone.ini>)  
，但是我们不会在这里讨论它们的细节。  
  
   
  
Next thing to check:  
our Legend object.

下  
一个要查看的是：我们的Legend对象：

[Legend]  
  
ChildList = Legend1 # Legend2

Surprise! Actually  
it's an empty object that will spawn two child objects: Legend1 and  
Legend2.   
![](https://lh5.googleusercontent.com/oMkO2zZVDx3jNHDrlkwt_peOZHdGzWWgtSMCVVlTC8u8Jun-1xXC6gz2WzK-_S3914iOS5hQoCQCFIcrlXVf41G3P6AEt4FeovsYlpFWtnpBaw3l)

奇怪吧！其实它只是一个我们由两子对象繁衍出来的空对象。

Code-wise we were  
creating a single object called Legend but apparently we'll end up with  
more than one object.  
  
The same kind of technique can be used to  
generated a whole group of objects, or a complete scenery for example,  
without having to create them one by one code-wise.  
  
It's even possible to  
chain objects with ChildList and only create a single object in our code  
and having hundreds of actual objects created.  
  
However, we won't have  
direct pointers on them, which means we won't be able to manipulate  
them directly.  
  
That being said, for all non-interactive/background object  
it's usually not a problem.  
  
Be also aware that their frames (cf.   
[frame tutorial  
](<http://orx-project.org/wiki/en/orx/tutorials/frame>)  
) will reflect the  
hierarchy of the ChildList 'chaining'.

通过这样的编码方式，我们创建了一个叫做Legend的单独对象但显然最终将超过一  
个对象。同样的技术也可以用来创建一组的对象，或者是完成一个场景，而不是一个一个创建。同样可以将对象通过ChildList串联起来并只在我们的代码  
中创建一个单独的对象而同时有数百个对象被创建。  
  
然而我们对它们不会有直接的指针，这意味着我们将不可能直接操作它们。  
  
话虽这么说，对所有非交互/后台对象这却不是一  
个问题。  
  
同时  
请注意他们的帧（参考：frame tutorial LINK）会影响ChildList ‘串联’的继承。

Ok, now let's get back  
to our two object, Legend1 and Legend2.

好了，现在让我们回到Legend1  
和Legend2两个对象。

[Legend1]  
  
Graphic       =  
Legend1Graphic  
  
Position      = (0, 0.25, 0.0)  
  
FXList        =  
ColorCycle2  
  
ParentCamera  
 = Camera  
  
  
  
[Legend2]  
  
Graphic       =  
Legend2Graphic  
  
Position      = (0, 0.3, 0.0)  
  
FXList        =  
@Legend1  
  
ParentCamera  
 = @Legend1

They  
look very basic, they're both using the same FX (ColorCyle2), they both  
have a Position and each of them has its own Graphic.

它们看起来很基本，都是用了相同的  
FX（ColorCyle2），它们也都有一个位置并且各自有它们的Graphic。

NB: We can also see  
that we defined the ParentCamera attribute for both of them. This means  
that their actual parent will become the camera and not the Legend  
object in the end.

注  
意：我们也可以看到我们为它们定义了ParentCamera属性。这意味着最终它们实际的父对象为Camera而不是Legend对象。

However Legend will  
still remain their owner, which means that they'll automatically be  
erased when Legend will be deleted.

然而Legend还将是它们的拥有者，这说明它们将会在Legend被销毁时自动被  
销毁。

Let's now finish by  
having a look at their Graphic objects.

现在让我们看一下它们的Graphic对象作为  
结束。

[Legend1Text]  
  
String = $Content  
  
  
  
[Legend2Text]  
  
String = $Lang  
  
  
  
[Legend1Graphic]  
  
Pivot = center  
  
Text  = Legend1Text  
  
  
  
[Legend2Graphic]  
  
Pivot = center  
  
Text  = Legend2Text

We can see that each  
Graphic has its own Text attribute: Legend1Text and Legend2Text.  
  
They both have a  
different String.  
  
The leading $ character indicates that we won't display a raw  
text but that we'll use the content as a key for the localization  
system.  
  
So  
in the end, the Legend1 object will display the localized string with  
the key Content, and Legend2 the one which has the key Lang.

我们可以看到每一个Graphic都有自己的  
Text属性：Legend1Text和Legend2Text。  
  
它们都有不同的String字段。（译注：这里的String是指配置）  
  
开头的$字符说明我们不会显示一个原始的文本但  
内容作为我们将会把内容作为本地化系统的关键字。  
  
所以在最后，Legend1对象会显示该关键字Content的本地化字符串，Legend2会  
显示关键字Lang的本地化字符串。

Everytime  
we will switch to another language, both orxTEXT objects (ie.  
Legend1Text and Legend2Text) will have their content updated  
automagically in the new selected language.   
![](https://lh6.googleusercontent.com/xGdZjxcFJWBqpJDEUoT78HRi7Q4CAc7xqo9DwXJ_oPWnIZwh9KhQfYnbuTLonGqAcg8yXAFARqs3IonJeDTeGD3k0a51yr1MpeW_bG3LRXZVWhgh)  
  
As we saw earlier, we can catch the  
orxLOCALE_EVENT_SELECT_LANGUAGE event to do our own specific processing  
in addition, if needed.

每一次我们会切换到另一个语言，所有的orxTEXT对象（例如Legend1Text和  
Legend2Text）会根据新选择的语言自动更新它们的内容。：）  
  
正如我们早前看到的，如果需要，我们还可以捕获  
orxLOCALE_EVENT_SELECT_LANGUAGE事件来进行特定的处理。

## Resources  

资源  

源代码：  
[10_StandAlone.cpp  
](<https://orx.svn.sourceforge.net/svnroot/orx/trunk/tutorial/src/10_StandAlone/10_StandAlone.cpp>)

配置文件：   
[10_StandAlone.ini  
](<https://orx.svn.sourceforge.net/svnroot/orx/trunk/tutorial/bin/10_StandAlone.ini>)

[](<https://orx.svn.sourceforge.net/svnroot/orx/trunk/tutorial/bin/10_StandAlone.ini>)

[1)  
](<http://orx-project.org/wiki/en/orx/tutorials/standalone#fnt__1>)  
即不再依靠ORX 启动器

[2)  
](<http://orx-project.org/wiki/en/orx/tutorials/standalone#fnt__2>)  
在orx.h中实现

[3)  
](<http://orx-project.org/wiki/en/orx/tutorials/standalone#fnt__3>)  
在这种情 况下预编译宏  
__orxCPP__ 会被自动定义

[4)  
](<http://orx-project.org/wiki/en/orx/tutorials/standalone#fnt__4>)  
  
这些给出的参数并没有包含我们需要的用来决定主配置文件名的可执行文件的名字

[5)  
](<http://orx-project.org/wiki/en/orx/tutorials/standalone#fnt__5>)  
  
使用WinMain()替代main()

 
