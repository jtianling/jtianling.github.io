---
layout: post
title: "非典型2D游戏引擎 Orx 源码阅读笔记(6) C语言实现的面向对象"
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
  views: '8'
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

    这一节，看的是我感觉Orx实现的最为"有技术"的部分了，C语言实现面向的技术，在[SDL的源码](<http://www.jtianling.com/archive/2010/07/26/5765571.aspx> "STL的源码")  
中看到过一种方法，Orx实现的是另外一种，相对来说可以支撑更加复杂和灵活的结构。

在SDL中，用一个结构中的函数指针的替换来实现了面向对象的效果。在Orx中则是一种类似大量需要最基础基类的面向对象语言一样，提供了所有对象的基类（结构）orxSTRUCTURE，其他结构需要"继承"（其实在Orx是包含orxSTRUCTURE）自这个结构，然后在使用时，可以在获取orxSTRUCTURE指针的情况下获得真正的"子类"对象指针，并且使用。虽然说是一种模拟面向对象的技术，其实也有些像handle的技术。

    在Orx中大量的结构都是在这个框架之下的。

下面是Structure的ID列表，下面这些都是属于Orx“面向对象体系”的一部分。  

```c
/*
 * Structure IDs
 *
 */

typedef
 enum
 __orxSTRUCTURE_ID_t
{
  /*
  *** Following structures can be linked to objects ***
  */

  orxSTRUCTURE_ID_ANIMPOINTER = 0,

  orxSTRUCTURE_ID_BODY,

  orxSTRUCTURE_ID_CLOCK,

  orxSTRUCTURE_ID_FRAME,

  orxSTRUCTURE_ID_FXPOINTER,

  orxSTRUCTURE_ID_GRAPHIC,

  orxSTRUCTURE_ID_SHADERPOINTER,

  orxSTRUCTURE_ID_SOUNDPOINTER,

  orxSTRUCTURE_ID_SPAWNER,

  orxSTRUCTURE_ID_LINKABLE_NUMBER,

  /*
  *** Below this point, structures can not be linked to objects ***
  */

  orxSTRUCTURE_ID_ANIM = orxSTRUCTURE_ID_LINKABLE_NUMBER,

  orxSTRUCTURE_ID_ANIMSET,

  orxSTRUCTURE_ID_CAMERA,

  orxSTRUCTURE_ID_FONT,

  orxSTRUCTURE_ID_FX,

  orxSTRUCTURE_ID_OBJECT,

  orxSTRUCTURE_ID_SHADER,

  orxSTRUCTURE_ID_SOUND,

  orxSTRUCTURE_ID_TEXT,

  orxSTRUCTURE_ID_TEXTURE,

  orxSTRUCTURE_ID_VIEWPORT,

  orxSTRUCTURE_ID_NUMBER,

  orxSTRUCTURE_ID_NONE = orxENUM_NONE

} orxSTRUCTURE_ID;
```

这里的对象与[前面讲到的](<http://www.jtianling.com/archive/2010/07/31/5777944.aspx> "前面讲到的")  
过的module其实是有些重叠的。但是总体上，module更加偏向于实现的概念，这里的对象更加倾向于游戏中实际对应的对象，也就是更加高层一些。

共有结构：

orxSTRUCTURE这个最基础基类的结构非常简单：  

```c
/*
 * Public structure (Must be first derived structure member!)
 *
 */

typedef
 struct
 __orxSTRUCTURE_t
{
  orxSTRUCTURE_ID eID;            /**< Structure ID : 4   */

  orxU32          u32RefCounter;  /**< Reference counter : 8   */

  orxU32          u32Flags;       /**< Flags : 12   */

  orxHANDLE       hStorageNode;   /**< Internal storage node handle : 16   */

} orxSTRUCTURE;
```

一个ID，一个引用计数，一个标志量，一个存储节点的HANDLE。

Handle:

typedef void *                  orxHANDLE;

在C中也就用做于任何类型的指针。。。。。。。。。

在同样的头文件中，还有下面这个type枚举：  

```c
/*
 * Structure storage types
 *
 */

typedef
 enum
 __orxSTRUCTURE_STORAGE_TYPE_t
{
  orxSTRUCTURE_STORAGE_TYPE_LINKLIST = 0,

  orxSTRUCTURE_STORAGE_TYPE_TREE,

  orxSTRUCTURE_STORAGE_TYPE_NUMBER,

  orxSTRUCTURE_STORAGE_TYPE_NONE = orxENUM_NONE,

} orxSTRUCTURE_STORAGE_TYPE;
```

但是基础结构中没有表示类型的变量，而handle到底表示什么类型的变量，就是这里面的几种了，list或者tree了，这个问题见下面的实现结构部分.

这里还看不出太多的东西，下面看看内部的实现结构：  

```c
/*
**************************************************************************

 * Structure declaration                                   *

 **************************************************************************
*/

/*
 * Internal storage structure
 *
 */

typedef
 struct
 __orxSTRUCTURE_STORAGE_t
{
  orxSTRUCTURE_STORAGE_TYPE eType;            /**< Storage type : 4   */

  orxBANK                  *pstNodeBank;      /**< Associated node bank : 8   */

  orxBANK                  *pstStructureBank; /**< Associated structure bank : 12   */

  union
  {
    orxLINKLIST             stLinkList;       /**< Linklist : 24   */

    orxTREE                 stTree;           /**< Tree : 20   */

  };                                  /**< Storage union : 24   */

} orxSTRUCTURE_STORAGE;

/*
 * Internal registration info
 *
 */

typedef
 struct
 __orxSTRUCTURE_REGISTER_INFO_t
{
  orxSTRUCTURE_STORAGE_TYPE     eStorageType; /**< Structure storage type : 4   */

  orxU32                        u32Size;      /**< Structure storage size : 8   */

  orxMEMORY_TYPE                eMemoryType;  /**< Structure storage memory type : 12   */

  orxSTRUCTURE_UPDATE_FUNCTION  pfnUpdate;    /**< Structure update callbacks : 16   */

} orxSTRUCTURE_REGISTER_INFO;

/*
 * Internal storage node
 *
 */

typedef
 struct
 __orxSTRUCTURE_STORAGE_NODE_t
{
  union
  {
    orxLINKLIST_NODE stLinkListNode;          /**< Linklist node : 12   */

    orxTREE_NODE stTreeNode;                  /**< Tree node : 16   */

  };                                  /**< Storage node union : 16   */

  orxSTRUCTURE *pstStructure;                 /**< Pointer to structure : 20   */

  orxSTRUCTURE_STORAGE_TYPE eType;            /**< Storage type : 24   */

} orxSTRUCTURE_STORAGE_NODE;

/*
 * Static structure
 *
 */

typedef
 struct
 __orxSTRUCTURE_STATIC_t
{
  orxSTRUCTURE_STORAGE      astStorage[orxSTRUCTURE_ID_NUMBER]; /**< Structure banks   */

  orxSTRUCTURE_REGISTER_INFO  astInfo[orxSTRUCTURE_ID_NUMBER];    /**< Structure info   */

  orxU32                      u32Flags;                           /**< Control flags   */

} orxSTRUCTURE_STATIC;

/*
**************************************************************************

 * Static variables                                        *

 **************************************************************************
*/

/*
 * static data
 *
 */

static
 orxSTRUCTURE_STATIC sstStructure;
```

这里的结构就没有以前那么清晰了，以前是看到结构大概就知道实现的。  
orxSTRUCTURE_STATIC  
的orxSTRUCTURE_STORAGE      astStorage[orxSTRUCTURE_ID_NUMBER];

用于为每个structure结构提供bank，bank还分成两种，

一种是pstNodeBank表示的节点的bank。一种是pstStructureBank是结构本身的bank。

此结构的

```c
union
{
  orxLINKLIST             stLinkList;       /**< Linklist : 24 */
  orxTREE                 stTree;           /**< Tree : 20 */
};                                  /**< Storage union : 24 */
```

部分很明显与

```c
union
{
  orxLINKLIST_NODE stLinkListNode;          /**< Linklist node : 12 */
  orxTREE_NODE stTreeNode;                  /**< Tree node : 16 */
};
```

正好符合要求。

然后这个节点结构的内容还包括：

  orxSTRUCTURE *pstStructure;         /**< Pointer to structure : 20 */

  orxSTRUCTURE_STORAGE_TYPE eType;    /**< Storage type : 24 */

难道是每个结构bank分配的内存指针最后都保存在这里面吗？

假如真是这样，那与

orxSTRUCTURE_STATIC  
结构成员变量orxSTRUCTURE_REGISTER_INFO不是重复吗？

因为这个结构也包含：

```c
orxSTRUCTURE_STORAGE_TYPE     eStorageType; /**< Structure storage type : 4   */

orxU32                        u32Size;      /**< Structure storage size : 8   */
```

这个问题暂时留着，等下面看流程的时候再来验证。

 

然后orxSTRUCTURE_REGISTER_INFO这个注册信息结构中还有个update函数的指针，很突出，类型是：

```c
/*
 * Structure update callback function type
 *
 */

typedef
 orxSTATUS (orxFASTCALL *orxSTRUCTURE_UPDATE_FUNCTION)(orxSTRUCTURE *_pstStructure, const
  orxSTRUCTURE *_pstCaller, const
  orxCLOCK_INFO *_pstClockInfo);
```

    一个结构注册后，每次还需要进行update?

    哈哈，到这里，已经解答了我的疑惑，既然module与Structure都是用于总体的管理整个Orx的结构的，为啥还需要两个这样的组织管理方式？而且很多类还是属于module,structure两个组织结构管理的？而且，上面看到Structure的列表也说了，Structure更加倾向于游戏中具体的概念，module倾向于底层实现。到了这里，再加上Orx一贯的一切自动化的思路，Structure的核心作用就很明显了！那就是管理所有需要对象的创建及update！没错，与module管理所有module的依赖，初始化，退出一样，Structure主要就是管理创建新对象及Update，这个在Orx这个非典型的游戏引擎中非常重要。在大部分游戏引擎中，我们需要手动的写主循环，然后控制主循环，并将update从主循环中一直进行下去，同时手动创建对象，但是Orx是配置驱动的，我们通过配置创建了对象，创建了一堆的东西，然后就都不管了，全丢给Orx了，Orx就是通过Structure这样的结构来统一管理的，也就是说，Structure是Orx运转的基石。同时Structure与module的更明显不同也显现出来了，Structure管理的是对象，一个Structure的"子类"可以有很多个创建出来的对象，module是管理模块，每个模块就是唯一的一个全局对象，所以需要统一的进行初始化及退出处理。

    知道了这个以后，再回头来看看Structure列表，什么感觉？很熟悉啊，原来都是config中能够配置自动创建的对象！

    这也是为什么Orx会费很大精力将所有配置能够创建的对象集中在这个Structure体系中管理了，无论其对象最终是什么，在Orx中都需要对通过配置其进行创建，update,所以提炼出了这个最终的基类，并且对所有对象进行统一的管理。

 

同时，上面遗留的问题，也有了一些思路了，既然是用于update的，那么分配出来的对象不一定就一定马上update，所有才会有orxSTRUCTURE_REGISTER_INFO与orxSTRUCTURE_STORAGE中的重复，很明显，Orx是在某个结构REGISTER（注册后）才开始update的。

 

基本的思路已经清晰了，下面通过流程来验证一下：

因为viewport总是需要创建的，从它入手：

首先看viewport的结构：

```c
/*
 * Viewport structure
 *
 */

struct
 __orxVIEWPORT_t
{
  orxSTRUCTURE      stStructure;              /**< Public structure, first structure member : 16   */

  orxFLOAT          fX;                       /**< X position (top left corner) : 20   */

  orxFLOAT          fY;                       /**< Y position (top left corner) : 24   */

  orxFLOAT          fWidth;                   /**< Width : 28   */

  orxFLOAT          fHeight;                  /**< Height : 32   */

  orxCOLOR          stBackgroundColor;        /**< Background color : 48   */

  orxCAMERA        *pstCamera;                /**< Associated camera : 52   */

  orxTEXTURE       *pstTexture;               /**< Associated texture : 56   */

  orxSHADERPOINTER *pstShaderPointer;         /**< Shader pointer : 60   */

};
```

符合前面  
Structure  
注释中说明的要求，也就是第一个结构是orxSTRUCTURE   
类型的成员变量。我发现Orx最喜欢利用这样的技巧，list的node也是，tree的node也是，可能iarwain最喜欢这样使用C语言吧，不过的确很有用，此时__orxVIEWPORT_t  
结构对象的指针与其第一个变量stStructure  
的指针位置是完全一样的，也就是说，此指针可以直接作为一个orxSTRUCTURE  
来使用，使用的时候，通过orxSTRUCTURE  
类型中保留的type信息，又能还原整个对象的信息，保存的时候无论多少类型这样的对象的确只需要都保存orxSTRUCTURE  
结构指针就行了。

 

 

orxViewport_Create

函数中，调用orxStructure_Create并加上自己的STRUCTURE_ID来创建了viewport。

```c
 /* Creates viewport */

 pstViewport = orxVIEWPORT(orxStructure_Create(orxSTRUCTURE_ID_VIEWPORT));
```

这个函数虽然只有一句，但是包含的信息很多，orxStructure_Create函数就像前面说的那样，利用Structure的Bank和node的bank分别为Structure和node分配缓存。分配后直接添加在orxSTRUCTURE_STORAGE的list/tree中。

前面的orxVIEWPORT类似强转，但是其实不是，因为不会如此将一个指针直接转成一个结构（非指针）了。

```c
#define orxVIEWPORT(STRUCTURE)      orxSTRUCTURE_GET_POINTER(STRUCTURE, VIEWPORT)

#define orxSTRUCTURE_GET_POINTER(STRUCTURE, TYPE) ((orx##TYPE *)_orxStructure_GetPointer(STRUCTURE, orxSTRUCTURE_ID_##TYPE))
```

这里的关键是另一个函数：

```c
/*
 * Gets structure pointer / debug mode
 *
 * @param[in]   _pStructure    Concerned structure
 *
 * @param[in]   _eStructureID   ID to test the structure against
 *
 * @return      Valid orxSTRUCTURE, orxNULL otherwise
 *
 */

static
 orxINLINE orxSTRUCTURE *_orxStructure_GetPointer(const
 void
 *_pStructure, orxSTRUCTURE_ID _eStructureID)
{
  orxSTRUCTURE *pstResult;

  /*
  Updates result
  */

  pstResult = ((_pStructure != orxNULL) && (((orxSTRUCTURE *)_pStructure)->eID ^ orxSTRUCTURE_MAGIC_TAG_ACTIVE) == _eStructureID) ? (orxSTRUCTURE *)_pStructure : (orxSTRUCTURE *)orxNULL;

  /*
  Done!
  */

  return
 pstResult;

}
```

传进一个orxSTRUCTURE的指针（orxStructure_Create的返回值），然后传出一个新的orxSTRUCTURE结构指针，再进行强转，感觉很怪异。

因为事实上，就上面的分析，只需要提供一个orxSTRUCTURE结构的指针指向的的确是一个"子类"对象的内存，是可以直接强转使用的。

所以这里的确怪异。

从orxSTRUCTURE_MAGIC_TAG_ACTIVE这个怪异的宏定义入手：

```c
/*
 * Structure magic number
 *
 */

#ifdef __orxDEBUG__
  #define orxSTRUCTURE_MAGIC_TAG_ACTIVE   
0xDEFACED0

#else
  #define orxSTRUCTURE_MAGIC_TAG_ACTIVE   
0x00000000

#endif
```

可见是为了debug准备的。并且意图是在debug的时候检验结构的eID成员变量，debug时发现此eID实际指向的是一段未分配内存（野指针时），能够返回空。

那这个0xDEFACED0  
是怎么来的呢？magic嘛。。。。我也不知道，可能是作者在debug的时候特意打上去的标记，因为与主流程无关，这里不深究了。

另外，对于viewport来说，我发现在Orx中其并没有update函数，所以在一个真正的viewport创建出来的时候就先通过

eResult = orxSTRUCTURE_REGISTER(VIEWPORT, orxSTRUCTURE_STORAGE_TYPE_LINKLIST, orxMEMORY_TYPE_MAIN, orxNULL);

注册了，最后的注册的update函数是orxNULL，应该就表示不需要update了吧。

下面看一个需要update的，比如animpointer。

在

orxObject_UpdateAll

函数中

会遍历所有的object:

```c
 /* For all objects */

 for(pstObject = orxOBJECT(orxStructure_GetFirst(orxSTRUCTURE_ID_OBJECT));
     pstObject != orxNULL;
     pstObject = orxOBJECT(orxStructure_GetNext(pstObject)))
```

并且，还会：

```c
if (pstObject->astStructure[i].pstStructure != orxNULL)
{
  /*
  Updates it
  */
  if (orxStructure_Update(pstObject->astStructure[i].pstStructure, pstObject, pstClockInfo) == orxSTATUS_FAILURE)
  {
    /*
    Logs message
    */
    orxDEBUG_PRINT(orxDEBUG_LEVEL_OBJECT, "Failed to update structure # %ld for object <%s>.", i, orxObject_GetName(pstObject));
  }
}
```

注意，这里的结构的update是pstObject  
调用的。也就是说，前面配置及自动化的那么多的部分，事实上并不是直接由Orx底层的clock直接调用的，而是由object来驱动的。

这里通过遍历Structure结构中的update函数，完成了每个object里面需要update的部分的update，因为Orx的配置几乎是以object为基础的，所以这样设计非常合理。

同时，这里也真实的再现了面向对象的基础需求之一，对不同的对象使用相同的接口，并且不关心具体是哪个对象。。。。。。。这里object就不关心内部那一个Structure指针的数组变量中每个变量具体存储的真实Structure类型了，只需要用同一的update回调即可。。。。。

 

到了这里，Orx的主要组织结构module和Structure都看过了，底层的基础结构和模块也看过了。整体的Orx主干已经清晰了，具体的每个Structure，module是怎么实现的，暂时就不看了，需要的时候看一看就很清楚了。

 

 

 

原创文章作者保留版权 转载请注明原作者 并给出链接

**[write by 九天雁翎(JTianLing) -- www.jtianling.com](<http://www.jtianling.com>)  
**