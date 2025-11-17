---
layout: post
title: "堆栈的简单C++实现"
categories:
- "算法"
tags:
- C++
- "堆栈"
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

# 堆栈的简单C++实现

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

 头文件：

```cpp
#ifndef __STACK_H__
#define __STACK_H__

#include <iostream>
#include <vector>
using namespace std;

template <typename T>
class CStack
{
public :
    CStack() { }
    ~CStack() { }

    size_t empty()
    {
        return miDataVec.empty();
    }

    size_t size()
    {
        return miDataVec.size();
    }

    void pop()
    {
        miDataVec.pop_back();
    }

    T& top()
    {
        return miDataVec.back();
    }

    const T& top() const
    {
        return miDataVec.back();
    }

    void push(const T& aItem)
    {
        miDataVec.push_back(aItem);
    }
private :
    vector<T> miDataVec;

};

#endif
```

测试程序：

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include "stack.h"
using namespace std;

int main(int argc, char * argv[])
{
    CStack<int > loStack;

    loStack.push(1);
    cout << loStack.top() <<" ";

    loStack.push(2);
    cout << loStack.top() <<" ";

    loStack.push(1);
    cout << loStack.top() <<" ";

    loStack.push(2);
    cout << loStack.top() <<" ";

    loStack.push(3);
    cout << loStack.top() <<" ";
    
    loStack.push(4);
    cout << loStack.top() <<" ";

    cout << endl;

    while(loStack.size() != 0)
    {
        cout << loStack.top() <<" ";
        loStack.pop();
    }

    cout << endl;

    exit(0);
}
```

这里顺便说明一下，这个实现仅仅是为了说明问题。

在C++中标准的stack实现是通过adaptor设计模式来实现的，并将用于实现的容器放入了模板的参数，以方便你用vector和list,来替代默认的deque。

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**