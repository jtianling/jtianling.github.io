---
layout: post
title: "和实现有关的各类型大小简易输出模版"
categories:
- C++
tags:
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '2'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

这是一个C++模板，用于输出任意数据类型的大小和取值范围，方便在不同平台或编译器下检查类型信息。

<!-- more -->

```cpp
/*Copyright (c) 2007,九天雁翎
* All rights reserved.
* 和机器有关的类型大小简易输出模版
* 完成日期：年月日*/
#include "stdafx.h"

#include <iostream>
#include <typeinfo>
#include <limits>

template<typename T>
class Type
{
public:
    static void print()
    {
        std::cout<< "sizeof(" << typeid(T).name() << ") = "
                 << sizeof(T) <<" and its range is ("
                 << std::numeric_limits<T>::min() <<", "
                 << std::numeric_limits<T>::max() << ")"<< std::endl;
    }
};

int main()
{
    Type<long long>::print();  //检查long long类型的大小及其范围
    return 0;
}

//在学习的过程中，及换到不同编译系统，不同电脑的时候都有所需要，
//虽然编写上的确没有什么技术含量。
```
