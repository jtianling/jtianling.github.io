---
layout: post
title: boost::function，让C++的函数也能当第一类值使用
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
  views: '38'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

boost::function解决了C++中函数、仿函数等类型不一的问题，将其统一封装，使它们能像普通变量一样存储和传递。

<!-- more -->

**boost::function，让C++的函数也能当第一类值使用**



最近在学习Python比较特殊的语法的时候，顺便也研究了一下C++中的类似实现。。。本文中的一些内容也可以参考前几天写的文章《[多想追求简洁的极致，但是无奈的学习C++中for_each的应用](<http://www.jtianling.com/archive/2009/05/15/4187209.aspx>)》《[其实C++比Python更需要lambda语法，可惜没有。。。。](<http://www.jtianling.com/archive/2009/05/21/4205134.aspx>)》最后发现类似的实现都要通过boost,并且还是比较扭曲的通过，然后，起码还算是实现那么回事了。然后前天工作正好属于配合工作，稍微有点时间，大致的看了下《Beyond the C++ Standard Library: An Introduction to Boost》，加深了一些理解，这里感叹一下，其起到的引导性作用还是不错的，可以有个大概的概念了以后再看boost的文档，那样更加事半功倍，虽然boost文档已经非常的好了，但是毕竟文档还是不同于教学。

当然，就算这个库真的进了C++09标准了其实也还是没有真的将函数作为第一类值那样简洁高效。。。。但是BS的原则嘛。。。尽量不扩张语言功能，而是去用库来实现。。。直到其没有办法，D&E上其认为C++中不需要原生的并发支持，用库就好了（虽然其实连标准库也没有）的言语还历历在目，09标准中却已基本通过增加并发的内存模型了。也不知道为啥。。。其语言只要符合需要就好，不成为特性的拼凑的思想，很显然让reflect，closure这样的特性也没有办法进入09标准了。。。无奈一下。

简单描述一下问题：在函数是第一类值的语言中，你可以保存，动态创建及传递一个函数，就像是一个普通的整数一样。比如python,lua中你就能这样。但是在C++这样的语言中，你需要用函数指针来保存一个普通的函数，然后用类对象来保存函数对象。

参考《[其实C++比Python更需要lambda语法，可惜没有。。。。](<http://www.jtianling.com/archive/2009/05/21/4205134.aspx>)》一文中的例子比如在Python中，你可以这样：

```python
 1   
 2 **def**  add1(a,b):  **return**  a + b  
 3 add2 = **lambda**  a,b : a + b  
 4   
 5 **class**  Add():  
 6     **def**  __init__(self):  
 7         self._i = 0  
 8   
 9     **def**  reset(self):  
10         self._i = 0  
11         
12     **def**  add(self, a, b):  
13         self._i += a + b  
14         **return**  self._i  
15   
16 addobj = Add()  
17 add3 = addobj.add  
18   
19 **print**  add1(1,1)  
20 **print**  add2(1,2)  
21 **print**  add3(1,3)  
22 addobj.reset()  
23   
24 fun = **lambda**  f,a,b : f(a,b)  
25   
26 **print**  fun(add1, 1, 1)  
27 **print**  fun(add2, 1, 2)  
28 **print**  fun(add3, 1, 3)  
29 **print**  fun(**lambda**  a,b : a + b, 1, 4)
```

一个函数一旦定义以后，然后在以后再使用此函数，就像任何普通的函数定义一样，调用此函数并不关心函数实际的定义方式，是用lambda语法还是实际的完整函数定义，甚至是类的一个成员函数也是一样，语法完全一模一样。

在C++中需要区别的就是，到底是函数对象还是函数指针，到底是普通函数还是对象的成员函数。。。假如加上boost库的话，还需要加上boost::lambda的定义的保存功能。假如函数真是第一类值的话，那么可以将以上的多种形式的函数语法统一，你尝试用用C++实现上述的例子就知道这些东西之间的语法差异多大了。但是，很明显，我们暂时不能奢望这一点，还好有boost::funciton库。

其实，就C++中的实现而言，光是需要实现函数的回调，通过模板来实现已经可以比较简化，因为函数模板的自动推导模板参数的功能可以让我们几乎不用写任何别扭的语法，也能实现上述的一些功能，比如普通函数，函数对象，还有boost::lambda库。

例子如下：

```cpp
#include <list>
#include <iostream>
#include <boost/lambda/lambda.hpp>
#include <boost/bind.hpp>
using namespace std;
using namespace boost;

int add1(int a, int b)
{
    return a \+ b;
}

class add2
{
public:
    int operator()(int lhs, int rhs)
    {
       return lhs \+ rhs;
    }
};

class CAdd
{
public:
    int add3(int a, int b) { return a \+ b; }
};

template<typename FUN, typename T>
T fun(FUN function, T lhs, T rhs)
{
    cout <<typeid(function).name() <<endl;
    return function(lhs, rhs);
}

int add4(int a, int b, int c)
{
    return a+b+c;
}

int main() 
{
    cout << fun(add1, 1, 1) <<endl;
    cout << fun(add2(), 1, 2) <<endl;
    cout << fun(lambda::_1+lambda::_2, 1, 3) <<endl;
    cout << fun(bind(add4, 0, _1, _2), 1, 4) <<endl;

    system("PAUSE");
}
```

直到这里，问题都不大，语法也算足够的简洁，模板的强大可见一斑。但是一旦你准备开始使用类的成员函数指针或者碰到需要将lambda生成的对象保存下来，需要将boost::bind生成的对象保存下来重复使用的时候，就碰到问题了，先不说类成员函数指针这种非要看过《Inside C++Object》一书，才能理解个大概，并且违反C++一贯常规的指针行为，甚至大小都可能超过sizeof(void*)的指针，起码在不了解boost这些库的源码的时候，我们又怎么知道bind,lambda生成的是啥吗？我是不知道。我想boost::function给了我们一个较为一致的接口来实现这些内容，虽然说实话，在上面例子中我列出来的情况中boost::function比起单纯的使用模板（如例子中一样）甚至要更加复杂，起码你得指明返回值和参数。（熟称函数签名）

我在上面例子中特意用运行时类型识别输出了lambda和bind生成的类型，分别是一下类型：

```text
int (__cdecl*)(int,int)
2
class add2
3
class boost::lambda::lambda_functor<class boost::lambda::lambda_functor_base<cl
ass boost::lambda::arithmetic_action<class boost::lambda::plus_action>,class boo
t::tuples::tuple<class boost::lambda::lambda_functor<struct boost::lambda::plac
eholder<1> >,class boost::lambda::lambda_functor<struct boost::lambda::placehold
r<2> >,struct boost::tuples::null_type,struct boost::tuples::null_type,struct b
ost::tuples::null_type,struct boost::tuples::null_type,struct boost::tuples::nu
l_type,struct boost::tuples::null_type,struct boost::tuples::null_type,struct b
ost::tuples::null_type> > >
4
class boost::_bi::bind_t<int,int (__cdecl*)(int,int,int),class boost::_bi::list
<class boost::_bi::value<int>,struct boost::arg<1>,struct boost::arg<2> > >
5
```

当我觉得int (*)(int,int)形式的函数指针都觉得复杂的是否。。。怎么样去声明一个个看都看不过来的lambda类型和bind类型啊。。。。。看看同样的用boost::function的例子。

```cpp
#include "stdafx.h"
#include <list>
#include <iostream>
#include <boost/lambda/lambda.hpp>
#include <boost/bind.hpp>
#include <boost/function.hpp>
#include <boost/ref.hpp>
using namespace std;
using namespace boost;

int add1(int a, int b)
{
    return a \+ b;
}

class add2
{
public:
    int operator()(int lhs, int rhs)
    {
       return lhs \+ rhs;
    }
};

class CAdd
{
public:
    int add3(int a, int b) { return a \+ b; }
};

template<typename FUN, typename T>
T fun(FUN function, T lhs, T rhs)
{
    cout <<typeid(function).name() <<endl;
    return function(lhs, rhs);
}

int add4(int a, int b, int c)
{
    return a+b+c;
}

int fun2(boost::function< int(int,int) > function, int a, int b )
{
    cout <<typeid(function).name() <<endl;
    return function(a,b);
}

int main() 
{
    cout << fun2(add1, 1, 1) <<endl;
    cout << fun2(add2(), 1, 2) <<endl;
    cout << fun2(lambda::_1+lambda::_2, 1, 3) <<endl;
    cout << fun2(bind(add4, 0, _1, _2), 1, 4) <<endl;

    system("PAUSE");
}
```

还是输出了最后函数中识别出来的类型：

```text
class boost::function<int __cdecl(int,int)>
2
class boost::function<int __cdecl(int,int)>
3
class boost::function<int __cdecl(int,int)>
4
class boost::function<int __cdecl(int,int)>
5
```

你会看到，当使用了boost::funciton以后，输出的类型得到了完全的统一，输出结果与前一次对比，我简直要用赏心悦目来形容了。特别是，boost::funtion还可以将这些callable(C++中此概念好像不强烈，但是在很多语言中是一个很重要的概念)的东西保存下来，并且以统一的接口调用，这才更加体现了boost::funtion的强大之处，就如我标题所说，将C++中的函数都成为第一类值一样（虽然其实还是不是），并且将callable都统一起来。

例子如下：

```cpp
#include "stdafx.h"
#include <list>
#include <iostream>
#include <boost/lambda/lambda.hpp>
#include <boost/bind.hpp>
#include <boost/function.hpp>
#include <boost/ref.hpp>
using namespace std;
using namespace boost;

int add1(int a, int b)
{
    return a \+ b;
}

class add2
{
public:
    int operator()(int lhs, int rhs)
    {
       return lhs \+ rhs;
    }
};

class CAdd
{
public:
    int add3(int a, int b) { return a \+ b; }
};

template<typename FUN, typename T>
T fun(FUN function, T lhs, T rhs)
{
    cout <<typeid(function).name() <<endl;
    return function(lhs, rhs);
}

int add4(int a, int b, int c)
{
    return a+b+c;
}

int fun2(boost::function< int(int,int) > function, int a, int b )
{
    cout <<typeid(function).name() <<endl;
    return function(a,b);
}

int main() 
{
    boost::function< int(int,int) > padd1 = add1;
    boost::function< int(int,int) > padd2 = add2();
    boost::function< int(int,int) > padd3 = lambda::_1+lambda::_2;
    boost::function< int(int,int) > padd4 = bind(add4, 0, _1, _2);

    cout << fun2(padd1, 1, 1) <<endl;
    cout << fun2(padd2, 1, 2) <<endl;
    cout << fun2(padd3, 1, 3) <<endl;
    cout << fun2(padd4, 1, 4) <<endl;

    system("PAUSE");
}
```

当你发现你能够这样操作C++中的callable类型的时候，你是不是发现C++的语言特性都似乎更加前进一步了？^^起码我是这样发现，甚至有了在Python,lua中将函数做第一类值使用的感觉。

好消息是。。。bind,function都比较有希望进C++09标准^^至于lambda嘛。。。似乎还有点悬。。。虽然BS还是会一如既往的说，一个好的编程语言绝不是一大堆有用特性的堆积，而是能在特定领域出色完成特定任务，但是。。。多一些功能，总比没有好吧，毕竟，人们还可以选择不用，没有特性。。。则只能通过像boost开发者这样的强人们扭曲的实现了，甚至将C++引入了追求高超技巧的歧途，假如一开始这些特性就有的话，人们何必这样做呢。。。。。。话说回来，那些纯Ｃ的使用者又该发言了。。。心智包袱。。。。呵呵，我倒是很想去体会一下在纯C情况下真实的开发应该是怎么样组织大规模的程序的，然后好好的体会一下没有这样的心智包袱的好处（虽然读过很多纯Ｃ的书籍。。。。但是实际开发中都没有机会用纯C，所以对C的理解其实主要还是停留在C++的层面上，这点颇为遗憾）

参考资料：

1.《Beyond the C++ Standard Library: An Introduction to Boost  
---  
》By Björn Karlsson  
  
2\. boost.org

