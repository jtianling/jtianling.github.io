---
layout: post
title: "非典型2D游戏引擎 Orx 源码阅读笔记(4) 用C实现的基本容器（List,HashTable,Tree）"
categories:
- "游戏开发"
tags:
- HashTable
- List
- Orx
- Tree
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

为跨平台，Orx引擎自实现了List、HashTable等C语言容器。文章剖析了其非常规的设计，并指出了HashTable存在的性能与冲突风险。

<!-- more -->



C语言中没有标准的容器，所以为了跨平台，Orx中自己实现了一套。

在Orx中作者分别实现了HashTable,List,Tree3个容器，虽然没有实现一个自己的String，但是为orxSTRING（实际为char*的typedef)实现了一堆的辅助函数。

下面分别来看看，为了不使本文成为一个类似algorithm in C的讲算法的文章，这里只看看使用和各容器的特性^^

## List

以前有人说过，几乎每个程序员在职业生涯都会自己实现一个List,不知道是不是真这样，虽然我的确实现过。。。。。。。。。。先看结构：

```c
/*
* Node list structure
*/
typedef
 struct
 __orxLINKLIST_NODE_t
{
  struct
 __orxLINKLIST_NODE_t *pstNext;         /*
*< Next node pointer : 4
*/
  struct
 __orxLINKLIST_NODE_t *pstPrevious;     /*
*< Previous node pointer : 8
*/
  struct
 __orxLINKLIST_t     *pstList;         /*
*< Associated list pointer : 12
*/
} orxLINKLIST_NODE;

/*
* List structure
*/
typedef
 struct
 __orxLINKLIST_t
{
  orxLINKLIST_NODE *pstFirst;                   /*
*< First node pointer : 4
*/
  orxLINKLIST_NODE *pstLast;                    /*
*< Last node pointer : 8
*/
  orxU32            u32Counter;                 /*
*< Node counter : 12
*/
} orxLINKLIST;
```

从结构看，我感觉实现的有些特殊，我以前看到的一般的list实现（自然是指C语言中的）一般用一个结构就解决一切了，都是用list的node本身（一般是头结点）来表示一个list,Orx这里额外特别的抽象出了一个List结构，然后node还反过来有指针指向list，有点奇怪的是，没有看到数据存在哪里。。。。。。。。。。。然后，突然发现，我没有看到list的Create函数。。。。。。。。看了一下Orx对List的使用，原来都是直接使用orxLINKLIST。。。。。。。。。。。。再然后，没有地方存储数据（比如类似pData的指针）的疑惑也解开了。。。。。。所有使用这个list的地方都用一个以orxLINKLIST_NODE为第一个成员变量的结构，然后node的指针，就相当于整个结构的指针了。。。。。。。。。。。。比如下面这个config的结构：

```c
typedef struct __orxCONFIG_SECTION_t
{
  orxLINKLIST_NODE  stNode;                 /**< List node : 12 */
  orxBANK          *pstEntryBank;           /**< Entry bank : 16 */
  orxSTRING         zName;                  /**< Section name : 20 */
  orxU32            u32ID;                  /**< Section ID (CRC) : 24 */
  orxU32            u32ParentID;            /**< Parent ID (CRC) : 28 */
  orxS32            s32ProtectionCounter;   /**< Protection counter : 32 */
  orxLINKLIST       stEntryList;            /**< Entry list : 44 */

  orxPAD(44)
} orxCONFIG_SECTION;
```

谜底解开了，总的来说，这个List很诡异。。。。。。。。。。。。

## HashTable

一个HashTable容器拥有O(1)的查找效率，被誉为20世纪最重要的编程领域发明之一。。。。。（不记得在哪看到的了）先看看结构：

```c
#define orxHASHTABLE_KU32_INDEX_SIZE                         256
/*
* Hash table cell definition.
*/
typedef
 struct
 __orxHASHTABLE_CELL_t
{
  orxU32                        u32Key;                       /*
*< Key element of a hash table : 4
*/
  void
                         *pData;                        /*
*< Address of data : 8
*/
  struct
 __orxHASHTABLE_CELL_t *pstNext;                      /*
*< Next cell with the same index : 12
*/
  orxPAD(12)
} orxHASHTABLE_CELL;

/*
* Hash Table
*/
struct
 __orxHASHTABLE_t
{
  orxHASHTABLE_CELL  *apstCell[orxHASHTABLE_KU32_INDEX_SIZE]; /*
*< Hash table
*/
  orxBANK            *pstBank;                                /*
*< Bank where are stored cells
*/
  orxU32              u32Counter;                              /*
*< Hashtable item counter
*/
};
```

每个hashTable的数据自然是一个cell,存储在pData中，通过注释基本也能理解Orx的Hash table的结构了。所有的数据通过apstCell[orxHASHTABLE_KU32_INDEX_SIZE];数组来存储，并且通过某个较小的key（说明这个较小的key一定小于orxHASHTABLE_KU32_INDEX_SIZE）来索引这个数据，假如有第一个较小的key冲突的情况，通过orxHASHTABLE_CELL的*pstNext变量来保存成链状，并通过u32Key这个32位的key来区别。这个结构与一般C++ STL扩展中的hashTable实现原理基本一样。（HashTable目前还不是C++标准库的内容，所以只在扩展库中存在）谁说看结构比看流程清晰来着？说的实在是太对了。当结构是这样定的时候，流程还能玩出啥花来？

用下面这样的代码来测试一下，同时验证想法。

```c
orxHASHTABLE* hashTable = orxHashTable_Create(32
, orxHASHTABLE_KU32_FLAG_NONE, orxMEMORY_TYPE_MAIN);

char
* firstKey = "FirstKey"
;
char
* secondKey = "secondKey"
;
char
* thirdKey = "thirdKey"
;
orxHashTable_Add(hashTable, orxString_ToCRC(firstKey), firstKey);
orxHashTable_Add(hashTable, orxString_ToCRC(secondKey), secondKey);
orxHashTable_Set(hashTable, orxString_ToCRC(firstKey), secondKey);
orxHashTable_Set(hashTable, orxString_ToCRC(thirdKey), thirdKey);
char
* value = (char
*)orxHashTable_Get(hashTable, orxString_ToCRC(firstKey));
orxHashTable_Delete(hashTable);

printf("Value:
%s
"
, value);
```

解释：orxHashTable_Create实际仅仅分配了内存而已。值得一提的仅仅是cell的内存使用[上一节](<http://www.jtianling.com/archive/2010/08/01/5780357.aspx> "上一节")提到的bank来分配的。orxString_ToCRC用于将string进行CRC，没有啥好说的。只是不知道Orx的这个CRC效果怎么样，比如速度快不快，冲突几率高不高。orxHashTable_Add中先判断是否有同样key的数据存在，存在的话会报错。其中调用的下列函数非常关键，用于获取前面提到的较小的key，来合成数组的索引。原来就是取CRC出来的32位值的与orxHASHTABLE_KU32_INDEX_SIZE匹配的低位而已。（虽然这里用取模会意思更加自然一些，但是一个取模操作比一个位操作慢的不是一点点）

```c
static
 orxINLINE orxU32 orxHashTable_FindIndex(const
 _orxHASHTABLE *_pstHashTable, orxU32 _u32Key)
{
  /*
 Checks
 */
  orxASSERT(_pstHashTable != orxNULL);

  /*
 Computes the hash index
 */
  return
 (_u32Key & (orxHASHTABLE_KU32_INDEX_SIZE - 1
 ));
}
```

找到位置以后的操作就太自然了。

```c
 /*  
 Get the hash table index   
 */  
    u32Index = orxHashTable_FindIndex(_pstHashTable, _u32Key);

    /*  
 Allocate a new cell if possible   
 */  
    pstCell = (orxHASHTABLE_CELL *)orxBank_Allocate(_pstHashTable->pstBank);

    /*  
 If allocation succeed, insert the new cell   
 */  
    if (pstCell != orxNULL)
    {
      /* Set datas */
      pstCell->u32Key = _u32Key;
      pstCell->pData  = _pData;
      pstCell->pstNext = _pstHashTable->apstCell[u32Index];

      /* Insert it */
      _pstHashTable->apstCell[u32Index] = pstCell;
      eStatus = orxSTATUS_SUCCESS;

      /* Updates counter */
      _pstHashTable->u32Counter++;
    }
```

由于iarwain的注释存在，我更加没有必要说太多了。值得一提的是可以看到这里面甚至没有判断这个数组索引所在的位置是否已经被占，然后进行冲突处理的操作。原因在于先pstCell->pstNext = _pstHashTable->apstCell[u32Index];然后_pstHashTable->apstCell[u32Index] = pstCell;假如原来此位置为空，next也就是空了，假如原来此位置有原来的值（甚至可以是一个链），就将整个链接在现在新数据的后面。

然后看set函数：

```c
  /*  
 Traverse to find the key   
 */  
  pstCell = _pstHashTable->apstCell[u32Index];
  while (pstCell != orxNULL && pstCell->u32Key != _u32Key)
  {
    /* Try with next cell */
    pstCell = pstCell->pstNext;
  }

  /* Cell found ? */
  if (pstCell != orxNULL)
  {
    /* Set associated datas */
    pstCell->pData = _pData;
  }
  else
  {
    /* Allocate a new cell if possible */
    pstCell = (orxHASHTABLE_CELL *)orxBank_Allocate(_pstHashTable->pstBank);

    /* If allocation succeed, insert the new cell */
    if (pstCell != orxNULL)
    {
      /* Set datas */
      pstCell->u32Key = _u32Key;
      pstCell->pData  = _pData;
      pstCell->pstNext = _pstHashTable->apstCell[u32Index];

      /* Insert it */
      _pstHashTable->apstCell[u32Index] = pstCell;
    }
  }

  /* Done! */
  return orxSTATUS_SUCCESS;
```

用于在此数组位置进行进一步的索引，找到32位key完全一致的值。

```c
 while (pstCell != orxNULL && pstCell->u32Key != _u32Key)
  {
    /* Try with next cell */
    pstCell = pstCell->pstNext;
  }
```

而

```c
 /*  
 Cell found ?   
 */
  if (pstCell != orxNULL)
  {
    /* Set associated datas */
    pstCell->pData = _pData;
  }
  else
  {
.....
}
```

则完美回答了我博客中以前评论中的踢出来的问题，当hashTable 进行Set的时候，假如原来这个Key不存在会进行什么操作，很明显，不存在就Add。

到了这里，Get,Delete函数我感觉已经没有太多讲的必要了，只要对hashTable的概念还算熟悉的，对Orx的hashtable应该有足够的了解了，无论是实现的原理还是效率。

我小结一下：

1、Orx的HashTable定死了apstCell[orxHASHTABLE_KU32_INDEX_SIZE]这个数组的大小，orxHASHTABLE_KU32_INDEX_SIZE等于256，所以，很自然的，此hashTable在数量较小的时候才能保持较高的效率，（即HashTable的理论值O(1))假如数量远远超过256，那么查询效率几乎接近线性效率O(n)。

2、Orx这里的索引完全依赖于其String的32位CRC计算，但是很遗憾的，CRC的计算时会有冲突的，也就是会出现两个不同String但是计算出同样CRC的情况，我没有仔细了解这个CRC的计算，但是将整个HashTable的基础建立在这个不稳定的基石上，总的来说已经说明了这个HashTable存在问题。。。。。。。。。。。。。

Orx的HashTableKey是建立在String上的，为了提高String的比较效率，所以对String进行了CRC，效率是高了，但是引发了第2点说的问题。

但是这里其实不是没有解决方案的。

1。高效的方案：如暴雪的MPQ那样，不以一个CRC来决定一切，额外用2个来做保险，也就是进行3次不同的CRC运算，同时比较3个CRC都一样时才能确定一个真正的数据位置。此方法比Orx的方法多2次CRC计算，并且多2次整数比较，但是出错几率会比Orx的低的多。（在实际中，就算到几十万这个等级，我也没有碰到过3个CRC同时冲突）

2。而作为对比，C++中实现的hashTable（可以参考VS或者boost的hashMap实现），由于模板的存在，可以使用任何东西作为key，同时，在第一次快速索引时，使用一个hash值，当hash值冲突后，完全使用原来的key来进行比较，虽然假如是字符串的话会稍微慢一点，但是起码能保证绝对无错。

## Tree

还是先看结构：

```c
/*
* Tree node structure
*/
typedef
 struct
 __orxTREE_NODE_t
{
  struct
 __orxTREE_NODE_t *pstParent;           /*
*< Parent node pointer : 4
*/
  struct
 __orxTREE_NODE_t *pstChild;            /*
*< First child node pointer : 8
*/
  struct
 __orxTREE_NODE_t *pstSibling;          /*
*< Next sibling node pointer : 12
*/
  struct
 __orxTREE_t      *pstTree;             /*
*< Associated tree pointer : 16
*/
} orxTREE_NODE;

/*
* Tree structure
*/
typedef
 struct
 __orxTREE_t
{
  orxTREE_NODE *pstRoot;                        /*
*< Root node pointer : 4
*/
  orxU32        u32Counter;                     /*
*< Node counter : 8
*/
} orxTREE;
```

看到结构的时候，从list的诡异中我诡异的理解了这个Tree的意思，也就是，这个tree的用法也和list类似了。。。。。。。。。。。。

我虽然以前学习数据结构的时候是以伪码和C++的实现为主，没有看过太多C语言实现的数据结构，但还真不是完全没有见过，我感觉Orx的实现是很诡异的。。。。。。使用方式也是在算不上正统，为了求证，以防止是因为自己的孤陋寡闻引起的笑话，特意求证glib实现。。。。。。

比如GList

```c
typedef
 struct
 _GList GList;

struct
 _GList
{
  gpointer data;
  GList *next;
  GList *prev;
};
```

一看到结构。。。。。。。。。。。。我大呼。。。。。数据结构的书籍还是没有骗我的啊。。。。。。。。。。。。。。。。。诡异的还是Orx。。。。。。。。。哪有需要自己一定要用一个新结构来包含Node来用一个list/tree的话。。。。。我要保存一个整数怎么办？。。。。。。。。简单的说，Orx的这个容器实现的非主流，不推荐大家使用及学习。。。。我这里也仅仅为了了解Orx的源代码而看看吧。。。。。。。。


