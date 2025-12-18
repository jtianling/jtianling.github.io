---
layout: post
title: "非典型2D游戏引擎 Orx 源码阅读笔记(2) 基础模块与模块管理模块"
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

 上一节中对Orx的整体框架及结构进行了梳理，本节开始阅读Orx底层的各个模块。本节的主要内容是基础模块和用于管理模块的部分代码。

## 基础部分

### orxDecl.h,orxType.h/orxType.c:

对于每个跨平台的库总会有些杂事需要处理，比如统一每个长度的变量命名，为各平台的换行符，路径分隔符进行统一命名，大小头等。这两个文件就是做类似的事情。列举一些特别典型的：

变量：  

```c
/*
 Windows
*/

#ifdef __orxWINDOWS__

  typedef
 void
 *                  orxHANDLE;

  typedef
 unsigned
  long
          orxU32;

  typedef
 unsigned
  short
         orxU16;

  typedef
 unsigned
  char
          orxU8;

  typedef
 signed
    long
          orxS32;

  typedef
 signed
    short
         orxS16;

  typedef
 signed
    char
          orxS8;

  typedef
 unsigned
  long
          orxBOOL;

  typedef
 float
                   orxFLOAT;

  typedef
 double
                   orxDOUBLE;

  typedef
 char
                     orxCHAR;
  #define orxSTRING               orxCHAR *

  typedef
 orxU32                 orxENUM;

  #define orx2F(V)                ((orxFLOAT)(V))

  #define orxENUM_NONE             0xFFFFFFFFL

  /*
 Compiler specific
*/

  #ifdef __orxGCC__

    typedef
 unsigned
  long
 long
   orxU64;

    typedef
 signed
    long
 long
   orxS64;

  #endif
 /*
 __orxGCC__
*/


  #ifdef __orxMSVC__

    typedef
 unsigned
  __int64     orxU64;

    typedef
 signed
    __int64     orxS64;

  #endif
 /*
 __orxMSVC__
*/

#else
 /*
 __orxWINDOWS__
*/

  /*
 Linux / Mac
*/


  #if defined(__orxLINUX__) || defined(__orxMAC__) || defined(__orxGP2X__) || defined(__orxWII__) || defined(__orxIPHONE__)

    typedef
 void
 *                orxHANDLE;

    typedef
 unsigned
  long
 long
   orxU64;

    typedef
 unsigned
  long
        orxU32;

    typedef
 unsigned
  short
       orxU16;

    typedef
 unsigned
  char
        orxU8;

    typedef
 signed
    long
 long
   orxS64;

    typedef
 signed
    long
        orxS32;

    typedef
 signed
    short
       orxS16;

    typedef
 signed
    char
        orxS8;

    typedef
 unsigned
  long
        orxBOOL;

    typedef
 float
                 orxFLOAT;

    typedef
 double
                orxDOUBLE;

    typedef
 char
                  orxCHAR;
    #define orxSTRING             orxCHAR *

    typedef
 orxU32                orxENUM;

    #define orx2F(V)              ((orxFLOAT)(V))

    #define orxENUM_NONE          0xFFFFFFFFL

  #endif
 /*
 __orxLINUX__ || __orxMAC__ || __orxGP2X__ || __orxWII__ || __orxIPHONE__
*/

#endif
 /*
 __orxWINDOWS__
*/
```

换行符：  

```c
#define orxCHAR_CR                 '/r'

#define orxCHAR_LF                 '/n'



#ifdef __orxWINDOWS__

  const
 orxCHAR    orxCHAR_EOL         = '/n'
;

  const
 orxSTRING  orxSTRING_EOL       = "
/r/n
"
;

#elif defined(__orxLINUX__) || defined(__orxGP2X__) || defined(__orxWII__) || defined(__orxIPHONE__)

  const
 orxCHAR    orxCHAR_EOL         = '/n'
;

  const
 orxSTRING  orxSTRING_EOL       = "
/n
"
;

#elif defined(__orxMAC__)

  const
 orxCHAR    orxCHAR_EOL         = '/r'
;

  const
 orxSTRING  orxSTRING_EOL       = "
/r
"
;

#endif
```

目录分割符：  

```c
/*
 *** Directory separators ***
*/

const
 orxCHAR     orxCHAR_DIRECTORY_SEPARATOR_WINDOWS    = '//'
;
const
 orxCHAR     orxCHAR_DIRECTORY_SEPARATOR_LINUX      = '/'
;
const
 orxSTRING   orxSTRING_DIRECTORY_SEPARATOR_WINDOWS  = "
//
"
;
const
 orxSTRING   orxSTRING_DIRECTORY_SEPARATOR_LINUX    = "/"
;

#ifdef __orxWINDOWS__

  const
 orxCHAR      orxCHAR_DIRECTORY_SEPARATOR         = '//'
;

  const
 orxSTRING    orxSTRING_DIRECTORY_SEPARATOR       = "
//
"
;

#else
 /*
 __orxWINDOWS__
*/

  /*
 Linux / Mac / GP2X / Wii
*/


  #if defined(__orxLINUX__) || defined(__orxMAC__) || defined(__orxGP2X__) || defined(__orxWII__) || defined(__orxIPHONE__)

    const
 orxCHAR    orxCHAR_DIRECTORY_SEPARATOR         = '/'
;

    const
 orxSTRING  orxSTRING_DIRECTORY_SEPARATOR       = "/"
;

  #endif
 /*
 __orxLINUX__ || __orxMAC__ || __orxGP2X__ || __orxWII__ || __orxIPHONE__
*/

#endif
 /*
 __orxWINDOWS__
*/
```

做跨平台应用的总会感叹有个标准多好，因为不同厂商在自己系统上定义的东西总是那么的千差万别，甚至感觉故意为了不同而不同，上面这些都不多说了。想起OpenGL和D3D中右手左手坐标系，纵优先行优先矩阵等问题就脑袋疼。

### orxModule.h/orxModule.c：

这两个文件算是Orx的模块的基础，因为他们就是管理各个模块的。

记得有个编程中的话是这么说的，“你给我看流程图后，我什么都还不清楚，你给我看你的表结构，我就知道你的流程图会是怎么样了。”

所以这里先看Orx模块管理中的基础结构，看了以后的确不用看具体函数实现了。  

```c
/*
**************************************************************************

 * Structure declaration                                           *

**************************************************************************
*/

/*
* Internal module info structure

 */

typedef
 struct
 __orxMODULE_INFO_t

{

  orxU64                    u64DependFlags;                 /* *< Dependency flags : 8   */

  orxU64                    u64OptionalDependFlags;         /* *< Optional dependency flags : 16   */

  orxMODULE_SETUP_FUNCTION  pfnSetup;                       /* *< Setup function : 20   */

  orxMODULE_INIT_FUNCTION   pfnInit;                        /* *< Init function : 24   */

  orxMODULE_EXIT_FUNCTION   pfnExit;                        /* *< Exit function : 28   */

  orxU32                    u32StatusFlags;                 /* *< Status flags : 32   */

} orxMODULE_INFO;

/*
* Static structure

 */

typedef
 struct
 __orxMODULE_STATIC_t

{

  orxMODULE_INFO astModuleInfo[orxMODULE_ID_NUMBER];

  orxU32 u32InitLoopCounter;

  orxU32 u32Flags;

} orxMODULE_STATIC;

/*
**************************************************************************

 * Static variables                                                *

**************************************************************************
*/

/*
* static data

 */

static
 orxMODULE_STATIC sstModule;
```

所有的相关函数都是操作sstModule这个全局的变量。此变量的主要结构是orxMODULE_INFO  
类型的数组，每个orxMODULE_INFO  
类型的变量都包含自己的依赖标志，可选依赖标志和状态标志，以及3个函数指针变量。3个函数指针变量分别是Init,Setup,Exit。

结构定义完以后，该怎么操作就和能清晰了。首先为每个模块指定确定的3大函数，指定各模块自己依赖的模块，每次操作后修改状态标志。

 

各函数实现概述：

orxModule_Register:指定"三大函数"：

```c
/* Stores module functions */

sstModule.astModuleInfo[_eModuleID].pfnSetup  = _pfnSetup;

sstModule.astModuleInfo[_eModuleID].pfnInit   = _pfnInit;

sstModule.astModuleInfo[_eModuleID].pfnExit   = _pfnExit;
```

Setup函数设置模块依赖的模块，Init用于初始化，Exit用于退出。

orxModule_RegisterAll：依次用orxModule_Register注册所有的模块：

并且，orx作者为了方便，使用了一个宏：

#define orxMODULE_REGISTER(MODULE_ID, MODULE_BASENAME)  orxModule_Register(MODULE_ID, MODULE_BASENAME##_Setup, MODULE_BASENAME##_Init, MODULE_BASENAME##_Exit)

宏的意义很明显，即用MODULE_BASENAME来按对应规则生成对应的Setup,Init,Exit函数。

比如说，Orx的内存管理模块的ID是orxMODULE_ID_BANK，

定义的三个函数是：  

```c
/*
* Setups the bank module

 */

extern
 orxDLLAPI void
 orxFASTCALL           orxBank_Setup();

/*
* Inits the bank Module

 * @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

 */

extern
 orxDLLAPI orxSTATUS orxFASTCALL      orxBank_Init();

/*
* Exits from the bank module

 */

extern
 orxDLLAPI void
 orxFASTCALL           orxBank_Exit();
```

注册的时候，使用宏就简单的用

orxMODULE_REGISTER(orxMODULE_ID_BANK, orxBank);

效果相当于

```c
orxModule_Register(orxMODULE_ID_BANK
, orxBank_Setup
, orxBank_Init()
, orxBank_Exit()
)
```

 

其实也没有什么太多好说的，就是个宏扩展的使用而已。

 

orxModule_AddDependency:

设定标志位而已。

sstModule.astModuleInfo[_eModuleID].u64DependFlags |= ((orxU64)1) << _eDependID;

可以看到，对于依赖的标志位是以一个无符号64位的整数来指定的，每一位表示对一个模块的支持，所以Orx目前最多支持64个模块。

 

Setup,SetupAll,InitAll,Exit,ExitAll的函数感觉没有什么太多好说的了，就是调用对应模块/所有模块Register好的3大函数指针指向的函数。

Init,单独初始化某个模块的部分可以稍微分析一下：

首先，初始化时，会先通过

if(!(sstModule.astModuleInfo[_eModuleID].u32StatusFlags & (orxMODULE_KU32_STATUS_FLAG_INITIALIZED|orxMODULE_KU32_STATUS_FLAG_TEMP)))

来判断当前模块是否已经初始化，已经初始化的话就直接返回了。

在确认当前模块需要进行初始化时，需要先初始化此模块的依赖的模块，在初始化所有依赖的模块后，为正在初始化模块的状态位或上orxMODULE_KU32_STATUS_FLAG_TEMP标志

表示开始初始化，然后调用Register过此模块Init的函数指针指向的函数进行实质的初始化，初始化过后，再加置orxMODULE_KU32_STATUS_FLAG_INITIALIZED标志。

 

 

同时在初始化模块开始时

```c
/* Increases loop counter */
sstModule.u32InitLoopCounter++;
```

结束时

```c
/* Decreases loop counter */
sstModule.u32InitLoopCounter--;
```

然后通过

  /* Was external call? */

  if(sstModule.u32InitLoopCounter == 0)

来判断什么时候一整轮初始化的结束，结束时调用

```c
     /* For all modules */
     for(u32Index = 0; u32Index < orxMODULE_ID_NUMBER; u32Index++)
     {
       /* Cleans temp status */
       sstModule.astModuleInfo[u32Index].u32StatusFlags &= ~orxMODULE_KU32_STATUS_FLAG_TEMP;
     }
```

取消所有本轮初始化的临时状态。

 

光是讲流程的话可能有些混乱，形象的描述一下初始化单独一个模块的过程。

因为模块之间的依赖问题，初始化一个模块就相当于需要初始化此模块依赖的所有模块，也需要初始化依赖模块依赖的模块，最后形成的是一个树状结构。只有当依赖关系到达树的叶节点（也就表示此模块是最基础的模块了，没有其他依赖）时才进行叶节点实际的初始化。同时，没初始化一个都置标志位，防止同一个模块初始化两次。当sstModule.u32InitLoopCounter为0时，表示此轮初始化已经又回到了最开始初始化的那个模块(根节点)，此轮初始化结束。

从这个描述中也说明了一个问题，那就是Orx不允许模块的循环依赖，否则会初始化失败。但是多个模块依赖一个模块和一个模块依赖多个模块都是允许的。

同时，稍微看一下Orx的模块之间的依赖关系，可以发现相互的依赖非常复杂，我本来想做一个依赖图的，发现难度太大。。。。。。。。。Orx的模块依赖关  
系虽然总体上是个树形结构，但是该树没有太良好的层级结构，大量跨层的依赖，导致显得非常混乱。

## 小结

首先，这么一大堆模块管理代码存在的必要性。从作用来看，假如非要讲优点的话，我感觉模块管理的作用有下面几个：

1。正常初始化，释放各模块，对于C语言来讲，没有构造函数，没有析构函数，对于一个模块只能使用一个结构来完成，初始化和退出都需要手动来做，使用Orx这样的模块管理可以在模块级别实现稍微自动化一些的初始化和退出。

2。集中管理各模块之间的依赖，使得初始化更加自动化，不易出错。

3。依赖于第2点，对于完全不需要的模块，可以完全不初始化。

 

但是，这些作用（其实我也不知道真实目的）都没有太好的完成。

首先，初始化的依赖问题虽然比较麻烦，但是可以在一个集中的初始化函数中一次完成，没有必要弄这么多代码出来。另外，虽然现在Orx的模块管理代码可以使得不需要的模块不初始化，但是因为每个模块都是用一个相关结构的全局变量来实现的，所以仅仅只能省一些初始化时间而已，内存上并没有节省，另外，对于不想初始化的代码，直接去掉初始化函数的调用就可以了，费不着用这么多代码来实现自动化。即使说初始化什么模块可能是通过配置来决定的，所以自动化有必要，但是仅仅剩下一些初始化时间的必要性并不大，还不如全部都初始化了。

 

但是，我还是很欣赏这种将模块管理起来的代码，虽然有些冗余，但是将模块统一管理在一个数组之中，比在某些巨大的Init,Exit函数去一一调用各模块的相应函数要来的漂亮。新添加模块的时候，只需要添加对应的3大函数就能自动化的完成一些初始化及收尾工作，也比每添加一个就需要在巨大的Init,Exit函数中添加一条来的方便。

 

 

 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**