---
layout: post
title: "从一个简单的三元结构 看C,C++"
categories:
- "算法"
tags:
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '6'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

作者用C++实现Triplet类，对比C语言后体会到，C++的类和模板等特性原生支持面向对象，比用C语言实现更简单、安全。

<!-- more -->

初到北京，适应了一下，好久学习了（大概一周多），重新开始学学。

严蔚敏的数据结构（C语言版），第一个介绍的数据结构是一个三元结构，她命名为Triple，她用类C伪码描述的。我自己用C++实现了一下。这里想说说感受。先看我写的源代码：

```cpp
#include <iostream>
#include <cassert>
using namespace std;

template <typename T>
class Triplet
{
public:
    Triplet(T v1 = T(), T v2 = T(), T v3 = T());
    T Get(size_t i);
    void Put(size_t i, const T& e);
    bool IsAscending();
    bool IsDescending();
    T Max();
    T Min();
private:
    T m_value[3];
};

template <typename T>
Triplet<T>::Triplet(T v1 = T(), T v2 = T(), T v3 = T())
{
    m_value[0] = v1;
    m_value[1] = v2;
    m_value[2] = v3;
}

template <typename T>
T Triplet<T>::Get(size_t i)
{
    assert(i >= 1 && i <= 3);
    return m_value[i - 1];
}

template <typename T>
void Triplet<T>::Put(size_t i, const T &e)
{
    assert(i >= 1 && i <= 3);
    m_value[i - 1] = e;
}

template <typename T>
bool Triplet<T>::IsAscending()
{
    return (m_value[0] < m_value[1] && m_value[1] < m_value[2]); 
}

template <typename T>
bool Triplet<T>::IsDescending()
{
    return (m_value[0] > m_value[1] && m_value[1] > m_value[2]);
}

template <typename T>
T Triplet<T>::Max()
{
    return m_value[0] > m_value[1] ? (m_value[0] > m_value[2] ? m_value[0] : m_value[2]) : (m_value[1] > m_value[2] ? m_value[1] : m_value[2]);
}

template <typename T>
T Triplet<T>::Min()
{
    return m_value[0] < m_value[1] ? (m_value[0] < m_value[2] ? m_value[0] : m_value[2]) : (m_value[1] < m_value[2] ? m_value[1] : m_value[2]); 
}
```

首先，想起来Bjarne Stroustrup说的话，所谓支持一种编程范例，指的不是能不能用一种编程语言去写这种风格的程序，而是看这个编程语言有没有对这个风格的原生的支持，能不能很简单的写出来。

比如，很多人就很喜欢说，用C语言也可以写面向对象的程序，的确，是可以，看严蔚敏《数据结构》（C语言版）你可以用C语言去实现她描述的那些数据结构，那就像在写面向对象程序一样，但是怎么样呢？

当我用C++来写同样的程序的时候，我会发现，C++增加了很多新的特性来支持面向对象，使得比用C语言来编写要简单的多。从Triplet来看，首先InitTriplet被构造函数替代了，这样更为方便，其次，因为C++的类机制，可以同时创建多个Triplet对象，而只需要写一次，并且，减少了在自由空间动态分配内存的需求，这样很大的减少了错误的发生。还有，模板机制的引进为泛型对象的编写提供了便利，这样一类对象都只需要写一次。仅仅是这样一个简单的小类，就可以看出C++一些新的机制的作用，还没有用到继承。随便说说，我也不是想说C++就是完美的，就是说用C语言去开发面向对象的程序，好像实在是费力不讨好。
