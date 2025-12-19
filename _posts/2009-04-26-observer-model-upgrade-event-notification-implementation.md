---
layout: post
title: Observer模式的升级版,Event通知实现
categories:
- "未分类"
tags:
- C++
- Observer
- "设计模式"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '9'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

介绍Observer模式的Event通知升级版，通过事件ID实现精准通知，避免了传统模式遍历所有观察者的低效问题。

<!-- more -->

**Observer 模式的升级版,Event通知实现**



本来这段程序是为mmgwg小组程序做示范写的，但是想想最近也很少有时间在家这样写程序了。。。。还是放上来吧，应该对有类似需求的兄弟们也有一些示范作用，对于程序的类层次结构就没有更多的深究了，仅仅是表达大概的意思，并不是希望大家都像我一样所有的实现都跑到父类中去。切记。

要说明的是，原始的Observer模式仅仅说明了一种思想，但是使用价值并不高，因为很简单的道理，作为一个系统基础的行为模式，其仅仅支持一种通知方式，并且是遍历通过。。。（这也可以看做模式的说明仅仅是实现了一种很通用的情况，并不是最好的实现），我们使用的也可以看作是Observer模式的延伸，也可以看做Observer模式的另一种实现，是所谓的 Event通知方式。在实际代码中使用非常多。在我们公司代码中似乎不论是服务器还是客户端代码都需要用到。服务器代码中甚至为了实现策划编辑数据另外做了一套（也就是并行的两套）。

具体的例子我打包放到 [http://groups.google.com/group/jiutianfile/](<http://groups.google.com/group/jiutianfile/>) 中了，文件名为Event Drive sample code.rar

程序没有经过调试，仅仅是编译通过,请仅仅作为示范使用。其中唯一比较难掌握的可能就是类成员函数的指针了，但是难的主要是语法，真正的使用上没有太多问题。

Observer.h

```cpp
#ifndef __OBSERVER_H__
#define __OBSERVER_H__

#include "BaseDefines.h"

class CSubject;
class CObserver
{
typedef LRESULT (CObserver:: *EventFunc)(LPARAM , WPARAM , WPARAMEX );

public:
    CObserver(CSubject* apSubject);
    virtual ~CObserver(void);

    bool InitEvent();

    // 此接口相当于原设计模式中的Update
    LRESULT OnEvent(EventID_t aiEventID, LPARAM aLParam, WPARAM aWParam, WPARAMEX aWParamEx);

    typedef map<EventID_t, EventFunc> EventMap_t; 
    typedef EventMap_t::iterator EventIter_t;
    EventMap_t moEvents;


    // 以下仅为示例，即是各个事件的相应
    LRESULT OnEvent1( LPARAM aLParam, WPARAM aWParam, WPARAMEX aWParamEx);
    LRESULT OnEvent2( LPARAM aLParam, WPARAM aWParam, WPARAMEX aWParamEx);
    LRESULT OnEvent3( LPARAM aLParam, WPARAM aWParam, WPARAMEX aWParamEx);

    CSubject *mpSubject;
};

#endif
```

Observer.cpp

```cpp
#include "StdAfx.h"
#include "Observer.h"
#include "Subject.h"

CObserver::CObserver(CSubject* apSubject):mpSubject(apSubject)
{
    InitEvent();
}

CObserver::~CObserver(void)
{
}

// 此实现中通过aiEventID分发事件，具体方式类似于MFC的消息映射
LRESULT CObserver::OnEvent( EventID_t aiEventID, LPARAM aLParam, WPARAM aWParam, WPARAMEX aWParamEx )
{
    EventIter_t lit = moEvents.find(aiEventID);
    if(lit == moEvents.end())
    {
       // 表示Observer实际没有订阅此事件。
       return -1;
    }

    // 假如有订阅，则调用相应的响应函数
    return ( this->*(lit->second))(aLParam, aWParam, aWParamEx);
}

bool CObserver::InitEvent()
{
    moEvents.insert(make_pair(1, &CObserver::OnEvent1));
    moEvents.insert(make_pair(2, &CObserver::OnEvent2));
    moEvents.insert(make_pair(3, &CObserver::OnEvent3));

    return true;
}

LRESULT CObserver::OnEvent1( LPARAM aLParam, WPARAM aWParam, WPARAMEX aWParamEx )
{

    return 1;
}

LRESULT CObserver::OnEvent2( LPARAM aLParam, WPARAM aWParam, WPARAMEX aWParamEx )
{

    return 1;
}

LRESULT CObserver::OnEvent3( LPARAM aLParam, WPARAM aWParam, WPARAMEX aWParamEx )
{

    return 1;
}
```

Subject.h

```cpp
#ifndef __SUBJECT_H__
#define __SUBJECT_H__

#include "BaseDefines.h"
#include <map>
#include <list>
using namespace std;

class CObserver;
class CSubject
{
public:
    CSubject(void);
    virtual ~CSubject(void);

    bool Attach( EventID_t aiEventID, CObserver *apObs);
    bool Detach( EventID_t aiEventID, CObserver *apObs);

    // 类似原Observer模式中的Notice消息
    LRESULT SendEvent(EventID_t aiEventID, LPARAM aLParam, WPARAM aWParam, WPARAMEX aWParamEx );

    typedef list<CObserver*> ObsList_t;
    typedef ObsList_t::iterator ObsIter_t;

    typedef map<EventID_t, ObsList_t> EventObsMap_t;
    typedef EventObsMap_t::iterator EventObsIter_t;
    EventObsMap_t moEventObsMap;
};

#endif
```

Subject.cpp

```cpp
#include "StdAfx.h"
#include "Subject.h"
#include "Observer.h"
#include <boost/bind.hpp>

CSubject::CSubject(void)
{
}

CSubject::~CSubject(void)
{
}

bool CSubject::Attach( EventID_t aiEventID, CObserver *apObs )
{
    EventObsIter_t lit = moEventObsMap.find(aiEventID);
    if(lit != moEventObsMap.end())
    {// 已经有相关的事件响应Obs列表
       ObsList_t& lObsList = lit->second;
       ObsIter_t litList = find(lObsList.begin(), lObsList.end(), apObs);
       if(litList != lObsList.end())
       {// 重复Attach
           return false;
       }

       lObsList.push_back(apObs);
       return true;
    }

    // 实际上先添加list到map然后再添加bos效率会略高。
    ObsList_t lObsList;
    lObsList.push_back(apObs);

    // 此insert必成功
#ifdef _DEBUG
    pair<EventObsIter_t, bool> lpairResult = moEventObsMap.insert(make_pair(aiEventID, lObsList));
    ASSERT(lpairResult.second);
#else
    moEventObsMap.insert(make_pair(aiEventID, lObsList));
#endif

    return true;
}

bool CSubject::Detach( EventID_t aiEventID, CObserver* apObs )
{
    EventObsIter_t lit = moEventObsMap.find(aiEventID);
    if(lit == moEventObsMap.end())
    {// 根本没有订阅此消息
       return false;
    }

    ObsList_t& lObsList = lit->second;
    ObsIter_t litList = find(lObsList.begin(), lObsList.end(), apObs);
    if(litList == lObsList.end())
    {// 根本没有订阅此消息
       return false;
    }

    // 这里当list为空的时候也不删除map中的对应item，添加的时候速度更快，也没有删除的时间，消耗多一点内存，但是减少内存碎片
    lObsList.erase(litList);

    return true;
}

LRESULT CSubject::SendEvent( EventID_t aiEventID, LPARAM aLParam, WPARAM aWParam, WPARAMEX aWParamEx )
{
    EventObsIter_t lit = moEventObsMap.find(aiEventID);
    if(lit == moEventObsMap.end())
    {// 根本没有Observer订阅此消息
       return 0;
    }

    ObsList_t& lObsList = lit->second;
    for(ObsIter_t litList = lObsList.begin(); litList != lObsList.end(); ++litList)
    {
       (*litList)->OnEvent(aiEventID, aLParam, aWParam, aWParamEx);
    }

    return 1;
}
```

