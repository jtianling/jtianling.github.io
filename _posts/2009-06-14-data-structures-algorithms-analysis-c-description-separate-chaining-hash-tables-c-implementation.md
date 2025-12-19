---
layout: post
title: "《数据结构与算法分析C++描述》 分离链接(separate chaining)哈希表的C++实现"
categories:
- "算法"
tags:
- C++
- HashTable
- "《数据结构与算法分析C++描述》"
- "哈希表"
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

本文分享了分离链接哈希表的C++实现，通过vector存储链表解决冲突，并附有完整的代码与测试示例。

<!-- more -->



《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第138-142面，分离链接(separate chaining)哈希表,侯捷将其翻译成开链

这应该是最容易实现的哈希表方法了,次容易的应该是线性搜索.

想起我到目前公司干的第二件事情，就是实现了一个文件系统，其核心模块就是一个类似MPQ的打包文件格式.而这个打包格式的核心模块就是一个线性哈希表的实现。只不过这次的实现不是在内存中，而是在文件上。这里顺便想说明是MPQ的实现是个很有意思的东西，感兴趣的可以去看看

[http://shadowflare.samods.org/inside_mopaq/](<http://shadowflare.samods.org/inside_mopaq/>)

inside mopaq是我见过最详细也最有用的资料，至于我刚开始工作的一些原始的资料记录就是非常凌乱了，但是希望有人在做同样工作的时候还能有一些参考价值吧。

[http://www.jtianling.com/archive/2008/06/02/2504503.aspx](<http://www.jtianling.com/archive/2008/06/02/2504503.aspx>)

[http://www.jtianling.com/archive/2008/06/02/2504515.aspx](<http://www.jtianling.com/archive/2008/06/02/2504515.aspx>)

并且，因为我以前已经实现了这么一个线性搜索的哈希表了，所以此次也不准备再实现一次了。

最后。。。。暴雪那个哈希算法的确是很不错，要求和一般的哈希算法不一样，一般的要求是哈希表总数为质数，其要求为2的幂。我在一次测试中发现，2万个文件的冲突次数大概在2千次,即1/10,远远低于书中低于1.5次的预期.

这一次是在VS中实现的,直接拷贝过来了,没有用vim了.

## 分离链接(separate chaining)哈希表的实现：

```cpp
#ifndef
__SL_HASH_TABLE_H__

#define
__SL_HASH_TABLE_H__

#include


#include


#include

using
namespace
std;

// 两个Hash函数,第一个由书上的例子提供，散列效果不明

int
hash( const
string& key)

{

  int
  liHashVal = 0;

  for( int
  i = 0; i < key.length(); ++i)

  {

    liHashVal = 37 * liHashVal \+ key[i];

  }
  return
  liHashVal;

}

// 书中没有提供这个散列函数的实现。。。。。郁闷了,随便写一个了。。。。

int
hash( int
key)

{

  return
  key;

}

// 参考了<>

static
const
int
gPrimesCount = 10;

static
unsigned
long
gPrimesArray[gPrimesCount] =

{

  53, 97, 193, 389, 769,

  1543, 3079, 6151, 12289, 24593

};

inline
unsigned
long
NextPrime(unsigned
long
n)

{

  const
  unsigned
  long* first = gPrimesArray;

  const
  unsigned
  long* last = gPrimesArray \+ gPrimesCount;

  const
  unsigned
  long* pos = lower_bound(first, last, n);

  return
  pos == last ? *(last \- 1) : *pos;

}

template <typename
HashedObj>

class
CSLHashTable

{

public:

  // 书中无实现，无提示,我第一次编译才发现。。。。。

  explicit
  CSLHashTable(size_t
  aiSize = 101) : miCurrentSize(aiSize)

  {

    moLists.resize(aiSize);

  }

  bool
  Contains( const
  HashedObj& x ) const

  {

    const
    list<HashedObj> & liListFinded = moLists[ MyHash(x)];

    return
    find( liListFinded.begin(), liListFinded.end(), x) != liListFinded.end();

  }

  void
  MakeEmpty()

  {

    for( int
    i=0; i<moLists.size(); ++i)

    {

      moLists[i].clear();

    }

  }

  bool
  Insert( const
  HashedObj& x)

  {

    list<HashedObj> & liListFinded = moLists[ MyHash(x)];

    if( find( liListFinded.begin(), liListFinded.end(), x) != liListFinded.end() )

    {

      return
      false;

    }

    liListFinded.push_back(x);

    if(++miCurrentSize > moLists.size())

    {

      ReHash();

    }

    return
    true;

  }

  bool
  Remove( const
  HashedObj& x)

  {

    list<HashedObj>& liListFinded = moLists[ MyHash(x)];

    list<HashedObj>::iterator
    lit = find(liListFinded.begin(), liListFinded.end(), x);

    if(lit == liListFinded.end())

    {

      return
      false;

    }

    liListFinded.erase(lit);

    \--miCurrentSize;

    return
    true;

  }

private:

  vector<list<HashedObj> > moLists;

  size_t
  miCurrentSize;

  void
  ReHash()

  {

    vector<list<HashedObj> > loOldLists = moLists;

    // 书中又一次的没有提供相关关键函数的实现,而且没有一点提示，NextPrime的含义自然是移到下一个素数上

    moLists.resize( NextPrime( 2 * moLists.size()));

    for( int
    j=0; j<moLists.size(); ++j)

    {

      moLists[j].clear();

    }

    miCurrentSize = 0;

    for(int
    i=0; i<loOldLists.size(); ++i)

    {

      list<HashedObj>::iterator
      lit = loOldLists[i].begin();

      while(lit != loOldLists[i].end())

      {

        Insert(*lit++);

      }

    }

  }

  int
  MyHash( const
  HashedObj& x) const

  {

    int
    liHashVal = hash(x);

    liHashVal %= moLists.size();

    if(liHashVal < 0)

    {

      liHashVal += moLists.size();

    }

    return
    liHashVal;

  }

};

#endif
// __SL_HASH_TABLE_H__
```

## 测试代码

```cpp
#include
"SLHashTable.h"

#include


#include


using
namespace
std;

// 这里为了稍微纠正我最近用宏上瘾的问题。。。。强制自己使用了模板

// 其实还是有个问题。。。呵呵，具体的名字没有办法输出来了，当然，每次调用函数

// 输入字符串永远不在考虑的范围内

// 另外.....看到最后标准库的类型全名的时候,总是会感叹一下...实在是太长了,记得

// 有一次,一个复杂的带string的map,我根本没有办法从鼠标下面看到即时显示的调试信息

// 原因是类型太长了,加起来超出了一个屏幕!!!,所以实际的调试数值被挤到了屏幕以外!

// 所以只能通过添加watch的方式才能看到值-_-!!

template <typename
HashedObj, typename
Table >

void
Test(HashedObj
x, Table& table)

{

  if(table.Contains(x))

  {

    cout <<typeid(table).name() <<" Constains " <<x <<endl;

  }

  else

  {

    cout <<typeid(table).name() <<" don't Constains " <<x <<endl;

  }

}

int
main()

{

  // test Int

  CSLHashTable<int> loIntTable;

  loIntTable.Insert(10);

  loIntTable.Insert(20);

  loIntTable.Insert(30);

  loIntTable.Insert(40);

  loIntTable.Insert(50);

  Test(20, loIntTable);

  Test(30, loIntTable);

  Test(40, loIntTable);

  Test(60, loIntTable);

  Test(70, loIntTable);

  CSLHashTable<string> loStrTable;

  loStrTable.Insert(string("10"));

  loStrTable.Insert(string("20"));

  loStrTable.Insert(string("30"));

  loStrTable.Insert(string("40"));

  loStrTable.Insert(string("50"));

  Test(string("20"), loStrTable);

  Test(string("30"), loStrTable);

  Test(string("40"), loStrTable);

  Test(string("60"), loStrTable);

  Test(string("70"), loStrTable);

  return 0;

}
```

