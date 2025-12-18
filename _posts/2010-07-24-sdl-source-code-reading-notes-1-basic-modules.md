---
layout: post
title: SDL源码阅读笔记（1） 基本模块
categories:
- "图形技术"
tags:
- SDL
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '18'
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

## 前言  

    对于大牛来说，写关于阅读源码的文章都会叫源码剖析或者深入浅出啥的，对于我，自己阅读阅读源码，写一些自己的阅读笔记吧。

    SDL我就不多介绍了，很多使用过的人都说很好，我自己实际使用的感觉  
SDL也是非常成熟易用，绝对对得起其  
simple两字。

 

## 基本模块  

通过SDL.h中看到SDL作者对SDL进行的划分，可以看出SDL大概包含的内容：

```c
#include "SDL_main.h"
#include "SDL_stdinc.h"
#include "SDL_audio.h"   //   声音
#include "SDL_cdrom.h"
#include "SDL_cpuinfo.h"
#include "SDL_endian.h"
#include "SDL_error.h"
#include "SDL_events.h"
#include "SDL_loadso.h"  // Unix/Linux   动态库
#include "SDL_mutex.h"   //   多线程互斥量
#include "SDL_rwops.h"
#include "SDL_thread.h"  //   多线程
#include "SDL_timer.h"   //   计时器
#include "SDL_video.h"   // video  模块
#include "SDL_version.h"
```

 

有声音模块，cdrom模块，有事件模块，多线程模块，计时器模块，video模块等6大模块。

 

SDL_InitSubSystem的参数，可以看出SDL的作者将SDL划分为下列可选子系统：

```c
#define SDL_INIT_TIMER
       0x00000001

#define SDL_INIT_AUDIO
      0x00000010

#define SDL_INIT_VIDEO
      0x00000020

#define SDL_INIT_CDROM
      0x00000100

#define SDL_INIT_JOYSTICK
   0x00000200

#define SDL_INIT_NOPARACHUTE
    0x00100000 /**< Don't catch fatal signals */

#define SDL_INIT_EVENTTHREAD
    0x01000000 /**< Not supported on all OS's */

#define SDL_INIT_EVERYTHING
0x0000FFFF
```

 

这里的可选模块与包含的头文件并不是太一致。

 

除了声音我的确不是很了解以外，其他模块会在这里逐一来看看，因为个人爱好，将以video模块为主，当然，事实上这也应该是SDL中最重要的模块，虽然video模块的字面意义上是显示模块，但是实际上SDL主要的平台相关函数几乎都集中在了video模块中了。其中，对源码的最主要分析在于SDL是怎么使用C语言对各类接口进行抽象并实现跨平台的，并不会逐句逐句的理解，那样非常没有必要。当然，我不能理解所有SDL支持的平台，这里仅以我熟悉的3大平台为例，Win32,Unix/Linux,Macos，事实上这也是目前最为流行的平台，应该也算是最具代表性了。

 

 

## 计时器  
(timer)

计时器和时间相关的东西是几乎每个有意义的游戏都会用到的，将其接口抽象出来并实现跨平台几乎是每个跨平台库的必要工作，相对来说还比较简单，这里以此作为第一篇，也算是热热身。

以下是SDL的timer.h头文件中有的计时器API：

```c
extern DECLSPEC Uint32 SDLCALL SDL_GetTicks(void);

extern DECLSPEC void SDLCALL SDL_Delay(Uint32 ms);

typedef Uint32 (SDLCALL *SDL_TimerCallback)(Uint32 interval);

extern DECLSPEC int SDLCALL SDL_SetTimer(Uint32 interval, SDL_TimerCallback callback);

typedef Uint32 (SDLCALL *SDL_NewTimerCallback)(Uint32 interval, void *param);

typedef struct _SDL_TimerID *SDL_TimerID;

extern DECLSPEC SDL_TimerID SDLCALL SDL_AddTimer(Uint32 interval, SDL_NewTimerCallback callback, void *param);

extern DECLSPEC SDL_bool SDLCALL SDL_RemoveTimer(SDL_TimerID t);
```

 

个人感觉是没有什么值得学习的，叫100个人来设计计时器接口，基本99个与这个类似。无论是用过Unix/Linux还是用过Windows 计时器的人都可以对SDL的计时器API与相应平台的计时器接口对号入座。接口是简单，但是实现并不算简单，各个平台之间的计时器和时间函数还是有些差异。当然，作为C语言的跨平台库，首先要习惯的就是满篇满篇的宏了，这是C语言库跨平台的必要装备。

 

 

### SDL_GetTicks  
  
：  
  
  

Win32主要由QueryPerformanceCounter或者timeGetTime实现。

Unix主要由clock_gettime或者更常见的gettimeofday实现。

MacOS下首先实现了一套FastTimer的函数，然后再调用这些函数实现，虽然我没有完全明白作者为什么不直接使用MacOS freeBSD相关的系统调用来实现，但是看了源代码感觉主要的问题在于现在MacOS都是64位的，所以作者需要进行一些处理。另外，还有PowerPC的MacOS部分，作者甚至使用了汇编来完成。

总的来说，很明显支持MacOS是最不容易的。。。。。假如作者原意在MacOS部分使用Objective C的代码的话，可能会好很多，但是估计作者是想尽量保持SDL简单的C库特征。

另外，此函数返回的并不是一般的从开机开始的计时，而是SDL自己计算的从SDL_StartTicks开始的计时。此函数在SDL的计时模块初始化的时候调用。

 

### SDL_Delay：  

Win32下是最清晰简单的函数，sleep而已。

Unix下有nano sleep的话调用nanosleep自然是最简单的，没有的话调用select来进行等待。当年看《Unix网络编程》的时候，作者用select实现了一个定时器，想不到还真有这样用的。

Macos下完全自己计时进行循环。。。。。。。这个应该是效率最低的了，不明白为啥这样做。

 

 
### SDL_SetTimer，  
SDL_AddTimer，  
SDL_RemoveTimer：  

我原以为每个平台都会有的函数

Win32完全靠计时线程加一个SDL自己的timerID列表来完成，不明白为什么不用Win32自己的Timer来完成。

Unix下用setitimer开始，也用setitimer结束。

MacOS下用InsXTime，PrimeTime开始，然后用RmvTime停止。

 

 

## 多线程模块  

```c
extern DECLSPEC SDL_Thread * SDLCALL SDL_CreateThread(int (SDLCALL *fn)(void *), void *data);

#endif

extern DECLSPEC Uint32 SDLCALL SDL_ThreadID(void);

extern DECLSPEC Uint32 SDLCALL SDL_GetThreadID(SDL_Thread *thread);

extern DECLSPEC void SDLCALL SDL_WaitThread(SDL_Thread *thread, int *status);

extern DECLSPEC void SDLCALL SDL_KillThread(SDL_Thread *thread);
```

 

 

多线程模块应该是最一致的模块了，Win32下分别上述接口在的一一对应的接口。

Unix,MacOS下使用pthread，接口也几乎一一对应，只是命名上有些差异，没有什么好说的。

这应该是最最简单的模块了。

 

## 事件模块  

在事件模块中，SDL统一了所有的输入，将所有的输入最大的与上层逻辑解耦。

```c
/** Event enumerations */

typedef enum
{

       SDL_NOEVENT = 0,         /**< Unused (do not remove) */

       SDL_ACTIVEEVENT,         /**< Application loses/gains visibility */

       SDL_KEYDOWN,         /**< Keys pressed */

       SDL_KEYUP,        /**< Keys released */

       SDL_MOUSEMOTION,         /**< Mouse moved */

       SDL_MOUSEBUTTONDOWN,     /**< Mouse button pressed */

       SDL_MOUSEBUTTONUP,       /**< Mouse button released */

       SDL_JOYAXISMOTION,       /**< Joystick axis motion */

       SDL_JOYBALLMOTION,       /**< Joystick trackball motion */

       SDL_JOYHATMOTION,    /**< Joystick hat position change */

       SDL_JOYBUTTONDOWN,       /**< Joystick button pressed */

       SDL_JOYBUTTONUP,         /**< Joystick button released */

       SDL_QUIT,         /**< User-requested quit */

       SDL_SYSWMEVENT,          /**< System specific event */

       SDL_EVENT_RESERVEDA,     /**< Reserved for future use.. */

       SDL_EVENT_RESERVEDB,     /**< Reserved for future use.. */

       SDL_VIDEORESIZE,         /**< User resized video mode */

       SDL_VIDEOEXPOSE,         /**< Screen needs to be redrawn */

       SDL_EVENT_RESERVED2,     /**< Reserved for future use.. */

       SDL_EVENT_RESERVED3,     /**< Reserved for future use.. */

       SDL_EVENT_RESERVED4,     /**< Reserved for future use.. */

       SDL_EVENT_RESERVED5,     /**< Reserved for future use.. */

       SDL_EVENT_RESERVED6,     /**< Reserved for future use.. */

       SDL_EVENT_RESERVED7,     /**< Reserved for future use.. */

       /** Events SDL_USEREVENT through SDL_MAXEVENTS-1 are for your use */

       SDL_USEREVENT = 24,

       /** This last event is only for bounding internal arrays
        *  It is the number of bits in the event mask datatype -- Uint32
        */
       SDL_NUMEVENTS = 32

} SDL_EventType;
```

 

 

通过这个枚举，可以看到，除了输入，还包括一些系统事件，比如SDL_VIDEORESIZE和SDL_QUIT。

虽然说大部分以C语言实现的事件系统都实现不了类型安全以及订阅-发布的模式，所以都避免不了需要通过事件类型来决定事件的输入，并且进行强转的操作，然后形成一个很长的switch case，

但是SDL中的事件系统还算实现的不错了。

事件的参数是一个这样的联合结构：

```c
/** General event structure */

typedef union SDL_Event
{
    Uint8 type;

    SDL_ActiveEvent active;

    SDL_KeyboardEvent key;

    SDL_MouseMotionEvent motion;

    SDL_MouseButtonEvent button;

    SDL_JoyAxisEvent jaxis;

    SDL_JoyBallEvent jball;

    SDL_JoyHatEvent jhat;

    SDL_JoyButtonEvent jbutton;

    SDL_ResizeEvent resize;

    SDL_ExposeEvent expose;

    SDL_QuitEvent quit;

    SDL_UserEvent user;

    SDL_SysWMEvent syswm;

} SDL_Event;
```

 

所以可以不进行强转，在相应的事件中，直接通过指定对应的成员变量来获取信息。虽然并不是完全类型安全，但是起码减少了强转的步骤。

事件模块有的API如下：

```c
extern DECLSPEC void SDLCALL SDL_PumpEvents(void);

typedef enum
{
    SDL_ADDEVENT,

    SDL_PEEKEVENT,

    SDL_GETEVENT

} SDL_eventaction;

extern DECLSPEC int SDLCALL SDL_PeepEvents(SDL_Event *events, int numevents,
              SDL_eventaction action, Uint32 mask);

extern DECLSPEC int SDLCALL SDL_PollEvent(SDL_Event *event);

extern DECLSPEC int SDLCALL SDL_WaitEvent(SDL_Event *event);

extern DECLSPEC int SDLCALL SDL_PushEvent(SDL_Event *event);

typedef int (SDLCALL *SDL_EventFilter)(const SDL_Event *event);

extern DECLSPEC void SDLCALL SDL_SetEventFilter(SDL_EventFilter filter);

extern DECLSPEC SDL_EventFilter SDLCALL SDL_GetEventFilter(void);

#define SDL_QUERY -1

#define SDL_IGNORE   0

#define SDL_DISABLE  0

#define SDL_ENABLE   1

extern DECLSPEC Uint8 SDLCALL SDL_EventState(Uint8 type, int state);
```

 

其中各个接口的含义还算比较好理解，与Win32的API中消息相关的接口类似，只是命名有差异而已。另外，事件模块本身的实现是与各个操作系统并不太相关的，属于依靠ANSI C跨平台的代码。

我用的最多的是SDL_PollEvent接口，比如在主循环中：

```c
while (running) {

    //While there's an event to handle

    SDL_Event event;

    while ( SDL_PollEvent( &event ) ) {

      if (event.type == SDL_QUIT) {

        running = false;

      }

    }

}
```

 

这个最常用的API是由其他API实现的：

```c
int SDL_PollEvent(SDL_Event *event)
{
    SDL_PumpEvents();

    /* We can't return -1, just return 0 (no event) on error */

    if ( SDL_PeepEvents(event, 1, SDL_GETEVENT, SDL_ALLEVENTS) <= 0 )
       return 0;
    return 1;
}
```

所以这里再看看SDL_PumpEvents()和SDL_PeepEvents：

SDL_PumpEvents主要就是调用显示模块的PumpEvent函数以获取上面那些与显示相关的事件，然后就是检测按键和摇杆了，其实很简单。

SDL_PeepEvents是事件模块中较为关键的函数，通过SDL_eventaction参数类型区别并完成

```c
typedef enum
{
    SDL_ADDEVENT,

    SDL_PEEKEVENT,

    SDL_GETEVENT

} SDL_eventaction;
```

这三类操作。添加事件，查看事件和获取事件。

看完API，来看看事件模块的内部：在内部，通过上述函数，其实都是操作同一个全局的事件列表：

```c
static struct {
    SDL_mutex *lock;
    int active;
    int head;
    int tail;
    SDL_Event event[MAXEVENTS];
    int wmmsg_next;
    struct SDL_SysWMmsg wmmsg[MAXEVENTS];
} SDL_EventQ;
```

并且，SDL通过自己的事件线程来维护事件系统的运作，在SDL_StartEventThread函数中启动了一个函数为SDL_GobbleEvents的事件线程。

此函数中是一个死循环（只要事件模块还是激活状态）以下是有删节的主要内容：

```c
while ( SDL_EventQ.active ) {

       SDL_VideoDevice *video = current_video;
       SDL_VideoDevice *this  = current_video;

       /* Get events from the video subsystem */

       if ( video ) {

           video->PumpEvents(this);

       }

       /* Queue pending key-repeat events */

       SDL_CheckKeyRepeat();

#if !SDL_JOYSTICK_DISABLED

       /* Check for joystick state change */

       if ( SDL_numjoysticks && (SDL_eventstate & SDL_JOYEVENTMASK) ) {

           SDL_JoystickUpdate();

       }
#endif

       if ( SDL_timer_running ) {

           SDL_ThreadedTimerCheck();

       }
       SDL_Delay(1);

    }
```

  

可以看到主要是调用显示模块的PumpEvents来获取显示系统相关的事件，其次就是重复按键的事件检测和摇杆了。另外，可以看到前面那个全局事件列表是带互斥量的，事实上，整个SDL的事件系统的实现都是线程安全的。  
SDL_SetEventFilter等事件过滤的函数，实现非常简单，就是根据设置的回调函数的结果来决定事件是否添加到事件列表，就不多说了。

事实上，虽然各类输入最后都统一归结到SDL的事件模块中，然后提供给用户或者SDL本身进行处理，但是在SDL中将这些输入检测本身都放在了video模块中。所以这里暂时不讲它们的实现了。

 

## 小结：  

     以一般看源码一边记录下来的方式完成本文，基本上将SDL除Video以外的一些周边模块都看了一遍，除了事件模块，这些模块的编写都没有太多值得深入了解的东西，无非就是抽象出一个大概的API，然后在不同的平台上实现，相当于SDL将很多平台相关的dirty的工作都做了，剩下clean的跨平台接口供用户使用。事件模块本身就不是平台相关的，SDL的实现相对来说使用还是比较方便的。利用联合来减少强转虽然不是第一次见，但是还是比更常见的void*表示event data+强转更加方便。看得出SDL的用心设计。

    因为这些周边模块主要抽象一些接口，然后实现，没有太多亮点，所以看的时候有的时候都不知道该写什么，所以按照自己看源码的流程记录了一些琐碎的东西，全文比较混乱。

    准备下篇文章中讲述SDL最关键的video模块，相对来说，就比这些周边模块有意思的多。

 

 

 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**