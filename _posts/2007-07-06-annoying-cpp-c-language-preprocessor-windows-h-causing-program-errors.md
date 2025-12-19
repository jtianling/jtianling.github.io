---
layout: post
title: "可恶的Cpp(c语言预处理器),windows.h，导致程序莫名错误"
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
  views: '4'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---


而且，我还持有这样的观点，

> Cpp 必须被摧毁
> ---Bjarne Stroustrup

全世界有经验的程序员都教导我们，应该多用C++中的特性，不要再停留在C语言中某些特别容易导致错误的旧特性，其中，预处理就是特别典型的一个，D&E中Bjarne Stroustrup详细解释了他为预处理提供的各个替代措施，但是，偏偏就是有人这么无聊，就是还喜欢用！比如windows.h中，一个特别特别无稽的使用宏去定义max(),min()，用宏就算了，竟然全部用的都是小写！我简直想拆了微软！因为很明显这样做是非常愚蠢的！比如下面这样一个简单的利用例子，因为包含了windows.h而无法运行。

<!-- more -->

```cpp
#include <iostream>

#include <windows.h>

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
```

不要问我为什么要包含windows.h，因为这个程序下面要用到啊，这么简单的程序，因为windows.h而不能使用，我是该怪Dennis M.Ritchie设计C预处理，还是怪Bjarne Stroustrup竟然在C++保留了这些，还是怪微软呢？这几乎是windows下编程（自然需要windows.h啊）与C++之间的矛盾啊！

另外，这时，我不得不

```cpp
#ifdef max     //因为windows.h里面竟然定义了max,min的宏
#undef max     //导致我不得不这样先让他们失效
#endif

#ifdef min
#undef min
#endif

// 木及其郁闷阿
```
