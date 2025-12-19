---
layout: post
title: "非典型2D游戏引擎 Orx 源码阅读笔记(5) core部分(config,event)"
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
  views: '11'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

分析Orx引擎源码，重点探讨其Event和Config核心模块。Event系统实现独特，Config系统功能强大，是引擎的配置驱动核心，颇具学习价值。

<!-- more -->



有的引擎的源代码是越看越吸引人的，越看越让人惊呼设计之精巧，实现之完美的，很遗憾的，Orx的源码不是属于那一类，使用的感觉也不像那一类，反而越看越觉得其设计思想上与主流思想格格不入。。。。。在[上一节](<http://www.jtianling.com/archive/2010/08/04/5786973.aspx> "上一节")中list,tree的设计中，这种感觉达到了顶峰。。。。。但是，对于一个这样跨平台的引擎，我还是会看下去，也许看完美的作品，我只能惊叹，看不完美的作品，我却可以了解到更多值得改进的地方吧。在看Orx的源代码的过程中，起码我是对C语言怎么来组织一个相对规模较大的工程有了一些了解，对于常年使用C++的我，这方面知识其实还是相对欠缺。

Core部分主要包含5个部分，Clock,Config,Event,Locale,System。其中Clock，Config和Event比较在Orx中占很重要的地位，会看的详细点，其他略看。另外，因为Clock依赖于structure部分，会等到看完structure以后再看。

System部分主要是用于获取系统事件，以及delay的，太过简单了，就这一句话了。
Locale虽然有些意思，但是算不是Orx的核心模块，对于对整个Orx的理解没有帮助，这个留在自己需要实现多语言的时候再回来参考吧。

## Event

Event在Orx也算是比较核心的内容了，贯穿整个系统，很多功能的使用，比如物理的碰撞处理等都是通过事件响应来完成的。
先看结构：
外部结构：

```c
/*
 * Public event structure
 */

typedef struct __orxEVENT_t
{
  orxEVENT_TYPE     eType;                      /* < Event type : 4   */
  orxENUM           eID;                        /* < Event ID : 8   */
  orxHANDLE         hSender;                    /* < Sender handle : 12   */
  orxHANDLE         hRecipient;                 /* < Recipient handle : 16   */
  void             *pstPayload;                 /* < Event payload : 20   */

} orxEVENT;
```

内部结构：

```c
/*
**************************************************************************
 * Structure declaration
 **************************************************************************
*/

/* Static structure */

typedef struct __orxEVENT_STATIC_t
{
  orxU32        u32Flags;                      /* < Control flags   */
  orxHASHTABLE *pstHandlerTable;               /* < Handler table   */

} orxEVENT_STATIC;

/*
**************************************************************************
 * Module global variable
 **************************************************************************
*/

static orxEVENT_STATIC sstEvent;
```

看了结构已经了解的差不多了，内部实现以Orx自己的hashtable为核心，实现快速的查找及事件的发送，外部以orxEVENT结构的eType,eID区分事件，pstPayload用于事件实际结构的存储。
着重看两个实现：
添加事件关注的orxSTATUS orxFASTCALL orxEvent_AddHandler(orxEVENT_TYPE _eEventType, orxEVENT_HANDLER _pfnEventHandler)：

```c
/*
 No bank yet?
 */

if (pstBank == orxNULL)
{
  /*
   Creates it
  */

  pstBank = orxBank_Create(orxEVENT_KU32_HANDLER_BANK_SIZE, sizeof(orxEVENT_HANDLER), orxBANK_KU32_FLAG_NONE, orxMEMORY_TYPE_MAIN);

  /*
   Valid?
  */

  if (pstBank != orxNULL)
  {
    /*
     Tries to add it to the table
    */

    if (orxHashTable_Add(sstEvent.pstHandlerTable, _eEventType, pstBank) == orxSTATUS_FAILURE)
    {
      /*
       Deletes bank
      */

      orxBank_Delete(pstBank);
      pstBank = orxNULL;
    }
  }
}
```

从以上代码我惊讶的发现，hashTable保存的不是一个个Handler的值，而直接是每个eventType对应的一个bank。bank的知识参考[以前的文章](<http://www.jtianling.com/archive/2010/08/01/5780357.aspx> "以前的文章")。
然后直接从bank中分配内存并赋值：

```c
/*
 Valid?
 */

if (pstBank != orxNULL)
{
  orxEVENT_HANDLER *ppfnHandler;

  /*
   Creates a new handler slot
  */

  ppfnHandler = (orxEVENT_HANDLER *)orxBank_Allocate(pstBank);

  /*
   Valid?
  */

  if (ppfnHandler != orxNULL)
  {
    /*
     Updates it
    */

    *ppfnHandler = _pfnEventHandler;

    /*
     Updates result
    */

    eResult = orxSTATUS_SUCCESS;
  }
}
```

我开始很奇怪这种使用方式，直接就对分配的内存赋值然后就不管了。后来想了想，因为bank毕竟是Orx自己的内存管理模块，这里将来对eventHandler的使用也肯定是遍历，那么Orx中就直接省去了对bank分配内存指针的保存，将来直接遍历bank了。。。。。起码现在是这样猜测的。

看Send部分后一定见分晓。
由于Send函数的源代码较短，全部贴出来了：

```c
orxSTATUS orxFASTCALL orxEvent_Send(const orxEVENT *_pstEvent)
{
  orxBANK  *pstBank;
  orxSTATUS eResult = orxSTATUS_SUCCESS;

  /*
   Checks
  */

  orxASSERT(orxFLAG_TEST(sstEvent.u32Flags, orxEVENT_KU32_STATIC_FLAG_READY));
  orxASSERT(_pstEvent != orxNULL);

  /*
   Gets corresponding bank
  */

  pstBank = (orxBANK *)orxHashTable_Get(sstEvent.pstHandlerTable, _pstEvent->eType);

  /*
   Valid?
  */

  if (pstBank != orxNULL)
  {
    orxEVENT_HANDLER *ppfnHandler;

    /*
     For all handler
    */

    for (ppfnHandler = (orxEVENT_HANDLER *)orxBank_GetNext(pstBank, orxNULL);
         ppfnHandler != orxNULL;
         ppfnHandler = (orxEVENT_HANDLER *)orxBank_GetNext(pstBank, ppfnHandler))
    {
      /*
       Calls handler
      */

      if ((*ppfnHandler)(_pstEvent) == orxSTATUS_FAILURE)
      {
        /*
         Updates result
        */

        eResult = orxSTATUS_FAILURE;

        break;
      }
    }
  }

  /*
   Done!
  */

  return eResult;
}
```

果然如我在Add Handler中看到Orx的操作后的猜测一样，获取bank，然后遍历bank.................虽然这样的确也能够实现功能，虽然这样可以省去一个容器变量用于存储handler，但是个人还是感觉这样的用法类似hack。。。。想象一下，你使用Win32 API的时候，直接遍历内存链是什么效果。。。。。。或者，bank在设计时就考虑了这样的用法吧。。。。即使如此，还是将bank一物两用了，又作为内存分配的缓存容器，同时还是个实际数据的缓存容器。。。。。

## Config

对于以Config为驱动的Orx的来说，这应该算是最最核心的模块了，假如说Orx哪个部分我是最希望抽出来以后独立使用的话，估计也就是这个部分了。Orx的Config部分，不仅仅实现了一个普通Windows INI所需要的简单的那一部分，包括section和key=value的读取，还包括section的继承，key的引用，value的随机，vector value的读取等强大功能，很多功能甚至凌驾于Json等通用配置。当时，这样强大的config不是没有代价的，换来的是较为庞大的配置代码。光是orxConfig.c一个文件，代码行数就超过了4K。

还是先看结构：

```c
/*
**************************************************************************
 * Structure declaration
 **************************************************************************
*/

/* Config value type enum */

typedef enum __orxCONFIG_VALUE_TYPE_t
{
  orxCONFIG_VALUE_TYPE_STRING = 0,
  orxCONFIG_VALUE_TYPE_FLOAT,
  orxCONFIG_VALUE_TYPE_S32,
  orxCONFIG_VALUE_TYPE_U32,
  orxCONFIG_VALUE_TYPE_BOOL,
  orxCONFIG_VALUE_TYPE_VECTOR,

  orxCONFIG_VALUE_TYPE_NUMBER,

  orxCONFIG_VALUE_TYPE_NONE = orxENUM_NONE

} orxCONFIG_VALUE_TYPE;

/* Config value structure */

typedef struct __orxCONFIG_VALUE_t
{
  orxSTRING             zValue;             /* < Literal value : 4   */
  orxCONFIG_VALUE_TYPE  eType;              /* < Value type : 8   */
  orxU16                u16Flags;           /* < Status flags : 10   */
  orxU8                 u8ListCounter;      /* < List counter : 11   */
  orxU8                 u8CacheIndex;       /* < Cache index : 12   */

  union
  {
    orxVECTOR           vValue;             /* < Vector value : 24   */
    orxBOOL             bValue;             /* < Bool value : 16   */
    orxFLOAT            fValue;             /* < Float value : 16   */
    orxU32              u32Value;           /* < U32 value : 16   */
    orxS32              s32Value;           /* < S32 value : 16   */
  };                                        /* < Union value : 24   */

  union
  {
    orxVECTOR           vAltValue;          /* < Alternate vector value : 36   */
    orxBOOL             bAltValue;          /* < Alternate bool value : 28   */
    orxFLOAT            fAltValue;          /* < Alternate float value : 28   */
    orxU32              u32AltValue;        /* < Alternate U32 value : 28   */
    orxS32              s32AltValue;        /* < Alternate S32 value : 28   */
  };                                        /* < Union value : 36   */

} orxCONFIG_VALUE;

/* Config entry structure */

typedef struct __orxCONFIG_ENTRY_t
{
  orxLINKLIST_NODE  stNode;                 /* < List node : 12   */
  orxSTRING         zKey;                   /* < Entry key : 16   */
  orxU32            u32ID;                  /* < Key ID (CRC) : 20   */

  orxCONFIG_VALUE   stValue;                /* < Entry value : 56   */

  orxPAD(56)
} orxCONFIG_ENTRY;

/* Config section structure */

typedef struct __orxCONFIG_SECTION_t
{
  orxLINKLIST_NODE  stNode;                 /* < List node : 12   */
  orxBANK          *pstEntryBank;           /* < Entry bank : 16   */
  orxSTRING         zName;                  /* < Section name : 20   */
  orxU32            u32ID;                  /* < Section ID (CRC) : 24   */
  orxU32            u32ParentID;            /* < Parent ID (CRC) : 28   */
  orxS32            s32ProtectionCounter;   /* < Protection counter : 32   */
  orxLINKLIST       stEntryList;            /* < Entry list : 44   */

  orxPAD(44)
} orxCONFIG_SECTION;

/* Config stack entry structure */

typedef struct __orxCONFIG_STACK_ENTRY_t
{
  orxLINKLIST_NODE    stNode;               /* < Linklist node : 12   */
  orxCONFIG_SECTION  *pstSection;           /* < Section : 16   */

} orxCONFIG_STACK_ENTRY;

/* Static structure */

typedef struct __orxCONFIG_STATIC_t
{
  orxBANK            *pstSectionBank;       /* < Section bank   */
  orxCONFIG_SECTION  *pstCurrentSection;    /* < Current working section   */
  orxBANK            *pstHistoryBank;       /* < History bank   */
  orxBANK            *pstStackBank;         /* < Stack bank   */
  orxLINKLIST         stStackList;          /* < Stack list   */
  orxU32              u32Flags;             /* < Control flags   */
  orxU32              u32LoadCounter;       /* < Load counter   */
  orxSTRING           zEncryptionKey;       /* < Encryption key   */
  orxU32              u32EncryptionKeySize; /* < Encryption key size   */
  orxCHAR            *pcEncryptionChar;     /* < Current encryption char   */
  orxLINKLIST         stSectionList;        /* < Section list   */
  orxHASHTABLE       *pstSectionTable;      /* < Section table   */
  orxCHAR             zBaseFile[orxCONFIG_KU32_BASE_FILENAME_LENGTH]; /* < Base file name   */

} orxCONFIG_STATIC;

/*
**************************************************************************
 * Static variables
 **************************************************************************
*/

/* static data */

static orxCONFIG_STATIC sstConfig;
```

还是那句话，看结构比看流程实在是更加有用，对于Orx来说，说了它再多的不是，它每个模块的结构之清晰，（虽然每个模块之间关系有点乱）真是很多软件设计根本没法比的。

所有的配置由sstConfig存储。orxHASHTABLE *pstSectionTable; 用于快速的查找section，完整的section信息保存在stSectionList中。

每个orxCONFIG_SECTION结构本身又包含stEntryList表示的list，存储的是orxCONFIG_ENTRY结构，表示一组key=value对。zKey自然表示完整的key,u32ID表示CRC过的key。value保存在orxCONFIG_VALUE结构的成员变量stValue中。

orxCONFIG_VALUE就是很多时候能在C/C++语言中看到的万能结构，用于保存一个可能为各种类型的变量。

zValue用于保存原始的value字符串，然后eType表示类型，具体的value由此type决定，保存在下面两个union中。

出去一些辅助成员，（比如stack，CurrentSection等用于暂时缓存现在config操作的成员变量），主要的config变量是多层容器结构。

由config保存着section容器列表，每个section容器又包含entry容器列表，entry容器保存key=value对。

其实看到结构已经对Orx的Config了解的很清楚了，但是回头想想，对于类似的需求，真的也不会以其他方式实现，还不就是上层的东西包含一个下层东西的列表啊。

另外，section结构中是包含一个u32ParentID变量的，用于表示继承自哪个父section。

没有在结构中看到Orx拥有的引用，随机等内容，说明这些都是都是在解析config的时候搞定的。

下面只看一个函数orxConfig_Load，搞定这一个，基本其他也不用看了。

主要解析config的过程是下列这样一个for循环结构

```c
for (u32Size = orxFile_Read(acBuffer, sizeof(orxCHAR), orxCONFIG_KU32_BUFFER_SIZE, pstFile),
     u32Offset = 0, bFirstTime = orxTRUE;
     u32Size > 0;
     u32Size = orxFile_Read(acBuffer + u32Offset, sizeof(orxCHAR), orxCONFIG_KU32_BUFFER_SIZE - u32Offset, pstFile) + u32Offset,
     bFirstTime = orxFALSE)
{
```

.............

很夸张的for运用方式。。。。。。。。但是理解上没有什么问题，也就是遍历读取文件到一个叫acBuffer的buffer中。

然后遍历buffer中的每个字符开始解析：

每一行的解析直到这个时候为止：

```c
/*
 Comment character or EOL out of block mode or block character in block mode?
*/

if ((((*pc == orxCONFIG_KC_COMMENT)
       || (*pc == orxCHAR_CR)
       || (*pc == orxCHAR_LF))
      && (bBlockMode == orxFALSE))
    || ((bBlockMode != orxFALSE)
      && (*pc == orxCONFIG_KC_BLOCK)))
{
```

............

上面也就是找到了行结尾了。

当发现当前行有section的时候（通过[]来判断）

用 orxConfig_SelectSection(pcLineStart + 1);来完成section的创建及选择（假如已经创建了的话）

这样的意义在于无论多少个section，最后都会拼接成一个，并且实现Orx配置中后面出现的配置会覆盖前面的配置的特性。

static orxINLINE orxCONFIG_SECTION *orxConfig_CreateSection(const orxSTRING _zSectionName, orxU32 _u32SectionID, orxU32 _u32ParentID)中有两句关键的代码：

```c
orxLinkList_AddEnd(&(sstConfig.stSectionList), &(pstSection->stNode));

/* Adds it to table */
orxHashTable_Add(sstConfig.pstSectionTable, _u32SectionID, pstSection);
```

以此完成section的添加，如看结构的时候分析的一样，分别添加进list和hashTable中。

而当发现当前行有key和value的时候：

if((pcKeyEnd != orxNULL) && (pcValueStart != orxNULL))

处理一下数据，通过orxConfig_AddEntry函数，添加一个入口。

AddEntry中会复制key和value到config中，

其中orxConfig_ComputeWorkingValue函数中处理了value的引用，继承，随机等问题。当然，其实也没有什么技术含量，实际也就是对value进行类似上面的字符解析而已。

然后用以下语句解答了结构中的分析。

orxLinkList_AddEnd(&(sstConfig.pstCurrentSection->stEntryList), &(pstEntry->stNode));

以上代码对当前选中的section的EntryList中添加了新的entry节点，也就是表示当前的key=value对。

以上代码基本已经完成了从section列表的创建到entry列表创建。

## 小结

其实，开始的时候我以为中间包含的字符解析，文件包含，继承，引用等内容，还有些看头，后来看了才发现，由于都用了很特殊的字符来表示，实际也就是找到相关的字符，然后处理的过程，没有啥技术含量。。。。。。。。。大失所望。。。。。。不过回头来想想，Martin Fowler说，傻子都会写让计算机理解的代码；而优秀程序员写的是人能看懂的代码。从这个角度看，config写的是很成功的了。。。。。只是抱着商业大片的人结果看的是平淡无奇的文艺片，可能有些失望吧。


