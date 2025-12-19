---
layout: post
title: "非典型2D游戏引擎 Orx 源码阅读笔记(3) 内存管理"
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

剖析Orx内存管理，批评其无意义封装与手动缓存设计，并指出透明化方案更优。

<!-- more -->

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

内存管理在任何希望达到高效的游戏引擎中都是基础，我以前恰好做过类似的工作，所以这里先看看Orx的实现，再谈谈自己以往做类似工作时的经验。

## Memory模块

个人感觉这是非常没有必要成为一个模块的模块。因为实质上没有任何必要的全局变量需要初始化，退出的时候也没有任何需要的扫尾工作，仅仅是几个函数而已，为啥Orx中这些函数会集中在一起作为一个Orx的模块，除了出于逻辑上一致的考虑，我感觉纯粹属于过度设计。。。。。。。。起码从目前来看是这样。

```c
extern
 orxDLLAPI void
 *orxFASTCALL     orxMemory_Allocate(orxU32 _u32Size, orxMEMORY_TYPE _eMemType);
extern
 orxDLLAPI void
 orxFASTCALL       orxMemory_Free(void
 *_pMem);
extern
 orxDLLAPI void
 *orxFASTCALL     orxMemory_Copy(void
 *_pDest, const
 void
 *_pSrc, orxU32 _u32Size);
extern
 orxDLLAPI void
 *orxFASTCALL     orxMemory_Move(void
 *_pDest, void
 *_pSrc, orxU32 _u32Size);
extern
 orxDLLAPI orxU32 orxFASTCALL     orxMemory_Compare(const
 void
 *_pMem1, const
 void
 *_pMem2, orxU32 _u32Size);
extern
 orxDLLAPI void
 *orxFASTCALL     orxMemory_Set(void
 *_pDest, orxU8 _u8Data, orxU32 _u32Size);
extern
 orxDLLAPI void
 *orxFASTCALL     orxMemory_Zero(void
 *_pDest, orxU32 _u32Size);
extern
 orxDLLAPI void
 *orxFASTCALL     orxMemory_Reallocate(void
 *_pMem, orxU32 _u32Size);
```

除了allocate多了一个type，其余全部的有用接口其实都是C语言中对应接口的直接包装，都只需要一条C语句就能完成。

从内存的type上：

```c
typedef enum __orxMEMORY_TYPE_t
{
  orxMEMORY_TYPE_MAIN = 0,              /**< Main memory type */

  orxMEMORY_TYPE_VIDEO,                 /**< Video memory type */
  orxMEMORY_TYPE_SPRITE,                /**< Sprite memory type */
  orxMEMORY_TYPE_BACKGROUND,            /**< Background memory type */
  orxMEMORY_TYPE_PALETTE,               /**< Palette memory type */

  orxMEMORY_TYPE_CONFIG,                /**< Config memory */
  orxMEMORY_TYPE_TEXT,                  /**< Text memory */

  orxMEMORY_TYPE_TEMP,                  /**< Temporary / scratch memory */

  orxMEMORY_TYPE_NUMBER,                /**< Number of memory type */

  orxMEMORY_TYPE_NONE = orxENUM_NONE    /**< Invalid memory type */

} orxMEMORY_TYPE;
```

可以看到作者的一些想法，但是事实上，物理上都没有区分的内存，（除了显存）无论怎么按类型分都是没有实际价值的。事实上，现在Orx也没有关心这个type。

```c
void
 *orxFASTCALL orxMemory_Allocate(orxU32 _u32Size, orxMEMORY_TYPE _eMemType)
{
  /*
 Module initialized ? 
*/

  orxASSERT((sstMemory.u32Flags & orxMEMORY_KU32_STATIC_FLAG_READY) == orxMEMORY_KU32_STATIC_FLAG_READY);

  /*
 Valid parameters ? 
*/

  orxASSERT(_eMemType < orxMEMORY_TYPE_NUMBER);

  /*
 Returns system allocation function 
*/

  return
((void
  *)malloc(_u32Size));
}
```

对C语言中标准的函数进行无意义的封装个人感觉除了影响效率，没有任何好处，这些C标准的东西本身也是跨平台的，封装它们干什么？从优化效率上考虑，稍微有些必要封装的也就是malloc和free两个而已。（realloc用的实在不多）除非Orx的作者看的更远，希望将来对包括内存Copy,compare在内的内存操作函数都进行自己针对特定CPU/平台的汇编级优化。

## bank模块

这是Orx用于优化性能实现的内存缓存的模块。
主要结构如下：

```c
/*
**************************************************************************

 * Structure declaration                                           *

**************************************************************************
*/

typedef
 struct
 __orxBANK_SEGMENT_t
{
  orxU32                     *pu32CellAllocationMap; /* 
 *< List of bits that represents free and used elements in the segment   */

  void
                       *pSegmentData;     /* 
 *< Pointer address on the head of the segment data cells   */

  struct
 __orxBANK_SEGMENT_t *pstNext;          /* 
 *< Pointer on the next segment   */

  orxU16                      u16NbFree;        /* 
 *< Number of free elements in the segment   */

} orxBANK_SEGMENT;

struct
 __orxBANK_t
{
  orxBANK_SEGMENT  *pstFirstSegment;        /* 
 *< First segment used in the bank   */

  orxU32            u32Flags;               /* 
 *< Flags set for the memory bank   */

  orxMEMORY_TYPE    eMemType;               /* 
 *< Memory type that will be used by the memory allocation   */

  orxU32            u32ElemSize;            /* 
 *< Size of a cell   */

  orxU16            u16NbCellPerSegments;   /* 
 *< Number of cells per banks   */

  orxU16            u16SizeSegmentBitField; /* 
 *< Number of u32 (4 bytes) to represent a segment   */

  orxU32            u32Counter;             /* 
 *< Number of allocated cells   */

};

typedef
 struct
 __orxBANK_STATIC_t
{
  orxU32 u32Flags;                      /* 
 *< Flags set by the memory module   */

} orxBANK_STATIC;

/*
**************************************************************************

 * Module global variable                                         *

**************************************************************************
*/

static
 orxBANK_STATIC sstBank;
```

从结构上看，bank应该以__orxBANK_t结构为主要结构，代表一个bank,每个bank中还可以包含一个orxBANK_SEGMENT类型的列表。实际内存缓存在orxBANK_SEGMENT类型对象的pSegmentData成员变量中。

主要对外接口有4个：

```c
/*
* Creates a new bank in memory and returns a pointer on it

  * @param[in] _u16NbElem  Number of elements per segments

  * @param[in] _u32Size    Size of an element

  * @param[in] _u32Flags   Flags set for this bank

  * @param[in] _eMemType   Memory type where the datas will be allocated

  * @return  returns a pointer on the memory bank

  */

extern
 orxDLLAPI orxBANK *orxFASTCALL       orxBank_Create(orxU16 _u16NbElem, orxU32 _u32Size, orxU32 _u32Flags, orxMEMORY_TYPE _eMemType);

/*
* Frees a portion of memory allocated with orxMemory_Allocate

  * @param[in] _pstBank    Pointer on the memory bank allocated by orx

  */

extern
 orxDLLAPI void
 orxFASTCALL           orxBank_Delete(orxBANK *_pstBank);

/*
* Allocates a new cell from the bank

  * @param[in] _pstBank    Pointer on the memory bank to use

  * @return a new cell of memory (orxNULL if no allocation possible)

  */

extern
 orxDLLAPI void
 *orxFASTCALL          orxBank_Allocate(orxBANK *_pstBank);

/*
* Frees an allocated cell

  * @param[in] _pstBank    Bank of memory from where _pCell has been allocated

  * @param[in] _pCell      Pointer on the cell to free

  * @return a new cell of memory (orxNULL if no allocation possible)

  */

extern
 orxDLLAPI void
 orxFASTCALL           orxBank_Free(orxBANK *_pstBank, void
 *_pCell);
```

从流程上来看看：
先建立一个测试工程，在原来的Orx独立应用程序上改改，有下面的代码已经几乎可以做到走遍bank全部主要部分代码：

```cpp
struct
 myStruct {
  int
 i;
};
orxSTATUS GameApp::Init() {
  orxBANK *bank = orxBank_Create(2
, sizeof
(myStruct), orxBANK_KU32_FLAG_NONE, orxMEMORY_TYPE_MAIN);
  myStruct *p1 = (myStruct *)orxBank_Allocate(bank);
  myStruct *p2 = (myStruct *)orxBank_Allocate(bank);
  myStruct *p3 = (myStruct *)orxBank_Allocate(bank);
  orxBank_Free(bank, p1);
  orxBank_Free(bank, p2);
  orxBank_Free(bank, p3);
  orxBank_Delete(bank);
    
    return
 orxSTATUS_SUCCESS;
}
```

orxBank_Create与orxBank_Delete是一对，用于创建删除一个bank对象。
然后可以通过orxBank_Allocate，orxBank_Free来获取或者释放内存。使用还算是简单，对于完全不想自己写内存管理模块的，即使是自己的项目也可以使用这个内存管理的部分，因为这是Orx中最最底层的代码，没有依赖太多其他的东西，剥离出来也不是很难。

因为内存这一部分可以说是小技巧众多并且非常dirty的部分了，几乎都是一个一个字节相关的内容，我就是从编写内存管理模块和文件系统开始习惯看成篇的2进制内存/文件数据的。所以这里我也没有兴趣一句一句的去了解Orx的做法了，大概的了解一下。

操作流程部分：在用orxBank_Create创建bank的时候，就会使用orxBank_SegmentCreate创建一个指定数量缓存的Segment，每个cell的大小当然就是第2个参数指定的。事实上，每一个Segment都是一个列表，保存着orxBank_Create第一参数指定数量的cell。在默认情况下， 当一个Segment中的缓存都分配完了的时候，会自动分配新的Segment，新的Segment中的cell数量还是一样多，并且通过前一个Segment的pstNext成员变量串起来。

内存实际分配结构：
每次分配Segment的时候实际分配的大小为：

```c
 /* Compute the segment size */
 u32SegmentSize = sizeof(orxBANK_SEGMENT) +                        /* Size of the structure */
                   _pstBank->u16SizeSegmentBitField * sizeof(orxU32) +      /* Size of bitfields */
                   _pstBank->u16NbCellPerSegments * _pstBank->u32ElemSize;  /* Size of stored Data */
```

总体的使用：

```c
  /*
 Allocate a new segent of memory 
*/

  pstSegment = (orxBANK_SEGMENT *)orxMemory_Allocate(u32SegmentSize, _pstBank->eMemType);
  if
(pstSegment != orxNULL)
  {
    /*
 Set initial segment values 
*/

    orxMemory_Zero(pstSegment, u32SegmentSize);
    pstSegment->pstNext               = orxNULL;
    pstSegment->u16NbFree             = _pstBank->u16NbCellPerSegments;
    pstSegment->pu32CellAllocationMap = (orxU32 *)(((orxU8 *)pstSegment) + sizeof
(orxBANK_SEGMENT));
    pstSegment->pSegmentData          = (void
 *)(((orxU8 *)pstSegment->pu32CellAllocationMap) + (_pstBank->u16SizeSegmentBitField * sizeof
(orxU32)));
  }
```

相当于将Segment自己的内存与其需要对外分配的内存一起分配，每次分配内存前面sizeof(orxBANK_SEGMENT)字节数的内存实际就做一个Segment结构对象使用，后面的_pstBank->u16SizeSegmentBitField * sizeof(orxU32)字节数内存作为一个标志数组使用，用于标志对应的某段内存是否已经分配，再后面的，才是实际会返回给用户使用的内存。

## 小结

Orx的内存管理模块对于习惯使用缓存并且非常需要使用缓存的地方还算是比较合适的，并且也还算容易使用。类似的技术也已经非常普遍了。
但是，个人感觉，类似的方式仅适用于的确已经常年习惯使用这种方式的人了，将这样添加缓存的功能完全的压到每个程序员头上，我感觉并不是很合适，最好的办法应该是在最底层透明的实现相关的功能，而不是这样将性能方面的要求强加给每个人。其次，对于已有项目，使用类似的技术需要对每个使用缓存的部分新加特别的代码，并不是很方便。还有，将缓存的代码遍布于项目中的每个角落，实在也不便于修改。在Orx中，memory,bank模块几乎被任何一个其他模块所依赖，很难想象需要改动的时候怎么办。

其实做的更加人性，更加好一点的办法也不难，说的简单点，在C语言下就是直接替换malloc,free的实现，在C++中就是重载new,delete操作符，直接通过内存的size来进行用户级别的缓存，而完全不考虑每次分配内存的用途(比如Orx中的内存type)，实际的内存分配模块也的确不应该考虑和关心用户到底最后用此内存来做什么，给用户需要长度的内存就好了，那样做是加大了两方面的耦合。
基于size的缓存可以做的很简单，也可以很复杂，一般来说，对很小size的内存单独成链，为了限制链表的数量，可以取2次幂的方式。比如保存4,8,16,32,64等size的链表，每次分配这些大小的内存直接从链表中取，假如分配的大小在两个大小之间，则直接取一个更大的内存返回即可。比如用户分配9字节的内存，返回16给它，虽然造成了一定的内存浪费，但是考虑到效率和实现的问题，这并不是不可以接受。另外，对于C++来说，还可以重载标准库容器的分配器，上述方法和重载容器的分配器的方法可以参考一下SGI的STL实现。（在侯捷《STL源码剖析》中有详细描述）
其实，内存管理在C/C++中不仅仅出于效率方面的考虑，在大型项目中对于内存泄露的检测（特别是隐式的）这也是很重要的。
最后，其实，就我看到的资料都说明，现在C语言实现的自动垃圾回收效率已经非常高了，甚至已经比一般人写的手工内存管理效率还要高，如此说来，一个自动或半自动的垃圾回收机制也是个不错的选择。
总之，虽然我以前写服务器代码（常常需要以空间换时间）时写过很多类似Orx这种手工管理缓存的代码，但是，我感觉还是有很多更好的替代方案的。

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)
