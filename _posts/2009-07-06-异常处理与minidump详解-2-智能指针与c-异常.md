---
layout: post
title: "异常处理与MiniDump详解(2)  智能指针与C++异常"
categories:
- "未分类"
tags:
- C++
- Exception
- MiniDump
- "异常"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '19'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

# 异常处理与MiniDump详解(2)  智能指针与C++异常

[**write by****九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)****

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

# 一、   综述

《[异常处理与MiniDump详解(1) C++异常](<http://www.jtianling.com/archive/2009/07/02/4317423.aspx>)》稍微回顾了下C++异常的语法及其类似于函数参数传递的抛出异常对象的copy,引用语义，但是有个问题没有详细讲，那就是C++异常的绝佳搭档，智能指针。在没有智能指针的时候会感觉C++的异常少了一个用于释放资源的finally语法，但是C++没有这样的语法是有理由的，因为C++的智能指针。假如不用智能指针仅仅使用异常，那就像是吃一道没有放肉的辣椒炒肉一样。。。。。。。。。。。

智能指针对于C++的重要性很多人可能并没有认识到，看看C++相关的书籍吧，几乎每本都有其痕迹，从《C++ Primer》,TCPL到《C++沉思录》《C++编程艺术》《C++Templates》，Meyes的《Effective C++》中讲过，《More Effective C++》再讲，无论是概念，用法，实现都是一本一本反复提起，这样反复提起，反复讲解的知识，自然是有其作用的，其作用也很简单，为了弥补C++对于内存管理的不足。众所周知，C++对于内存管理的方式称为手动管理，说白了就是C++本身不管理，都由程序员管理，事实上导致的问题一片一片，不记得多少次反复的在公司的服务器程序中去查内存泄露了，几乎随着每次大规模功能的更新，都会有新的内存泄露出现。。。。。C++相信程序员的原则告诉我们，程序员总是对的，那么即使是内存泄露了，也是有他的理由。。。。。。他的理由就是下一次可以进行内存泄露检查的工作，以浪费一天又一天的时间。随着BoundsChecker这样的工具出现，虽然简化了一部分明显的内存泄露检查，但是实际上复杂情况下的内存泄露还是只能靠自己完成，BoundsChecker误报的本事太强了，并且根本无法正常运行公司的地图服务器并退出，可能因为随后的内存泄露正常报告+误报超出了BoundsChecker的整数上限，总是会将BoundsChecker拉入无响应的状态。

事实上，我工作中也用的相对较少，毕竟C++标准库中的auto_ptr是个比较扭曲的东西，不仅使用语义奇怪，碰到稍微复杂的应用就根本胜任不了了，这是很无奈的事情。这一点可以参考我很久以前的文章《[C++可怜的内存管理机制漫谈及奇怪补救auto_ptr介绍](<http://www.jtianling.com/archive/2007/10/12/1821091.aspx>)》，文中可以看到，在加入了类，异常机制，并且延续着C语言中手动管理内存方式的C++中，auto_ptr其实最多也就算种奇异的补丁机制。

但是我们可以求助于boost的智能指针库，那里丰富的资源改变了很多事情，但是我工作中是不允许使用boost库的。。。。又一次的无奈。

 

# 二、   智能指针

## 1.      什么是智能指针

要知道什么是智能指针，首先了解什么称为 “资源分配即初始化”这个翻译的异常扭曲的名词。RAII—Resource Acquisition Is Initialization，外国人也真有意思，用一个完整的句子来表示一个应该用名词表示的概念，我们有更有意思了，直接翻译过来，相当扭曲。。。。。

在《C++ Primer》这样解释的，“通过定义一个类来封装资源的分配和释放，可以保证正确释放资源”

而智能指针就是这种技术的实现，《More Effective C++》中这样描述的：“Smart pointers are objects that are designed to look,act,and feel like build-in pointers,but to offer greater functionality.They have a variety of applications, including resource management.”

《Effective C++》给出的关键特点是：

1.     资源分配后立即由资源管理对象接管。

2.     资源管理对象用析构函数来确保资源被释放。

基本上，这就是智能指针的核心概念了，至于智能指针实现上的特点，比如所有权转移，所有权独占，引用计数等，都是次要的东西了。

 

目前我见过关于各种智能指针分类，介绍，使用方法说明最详细的应该是《Beyond the C++ Standard Library: An Introduction to Boost》一书，此书第一章第一个专题库就是关于智能指针的，除了对标准库中已有的auto_ptr没有介绍（因为本书是讲Boost的嘛），对Boost库中的智能指针进行了较为详细的描述，推荐想了解的都去看看。

       文中论及的智能指针包括

scoped_ptr，scoped_array:所有权限制实现

shared_ptr，shared_array：引用计数实现

intrusive_ptr：引用计数插入式实现

weak_ptr：无所有权实现

关于智能指针的实现及原理，本人看过最详细的介绍是在More Effective C++ Items 28,29

这里仅仅介绍最广泛使用的智能指针shared_ptr，加上以前写过的auto_ptr(《[C++可怜的内存管理机制漫谈及奇怪补救auto_ptr介绍](<http://www.jtianling.com/archive/2007/10/12/1821091.aspx>)》)给出智能指针的一些用法示例，其他的智能指针因为实现上的区别导致使用上也有一些区别，但是核心概念是一样的，都是上面提及的两条关键特点。

 

## 2.      shared_ptr介绍

shared_ptr是通过引用计数计数实现的智能指针，应用也最为广泛，也是早在TR1就已经确认会进入下一版C++标准的东西，现在我还会因为标准库中没有，boost库不准用而遗憾，过几年，总有一天，我们就能自由使用类似shared_ptr的指针了。

原型如下：

```cpp
namespace boost {

    template<typename T> class shared_ptr {
    public:
       template <class Y> explicit shared_ptr(Y* p);
       template <class Y,class D> shared_ptr(Y* p,D d);

       ~shared_ptr();

       shared_ptr(const shared_ptr & r);
       template <class Y> explicit
           shared_ptr(const weak_ptr<Y>& r);
       template <class Y> explicit shared_ptr(std::auto_ptr<Y>& r);

       shared_ptr& operator=(const shared_ptr& r);

       void reset(); 

       T& operator*() const;
       T* operator->() const;
       T* get() const;

       bool unique() const;
       long use_count() const;

       operator unspecified_bool_type() const; 

       void swap(shared_ptr<T>& b);
    };

    template <class T,class U>
    shared_ptr<T> static_pointer_cast(const shared_ptr<U>& r);
}
```

首先，为了查看资源分配方便，引入一个方便查看资源转移，拷贝情况的类：

```cpp
#include <string>
#include <iostream>

template<class T>
class CResourceObserver
{
public:
    CResourceObserver()
    {
       cout <<typeid(T).name() <<" Construct." <<endl;
    }

    CResourceObserver(const CResourceObserver& orig)
    {
       cout <<typeid(T).name() <<" Copy Construct." <<endl;
    }

    operator=(const CResourceObserver& orig)
    {
       cout <<typeid(T).name() <<" operator = " <<endl;
    }

    virtual ~CResourceObserver(void)
    {
       cout <<typeid(T).name() <<" Deconstruct." <<endl;
    }

};
```

这个类，利用了运行时类型识别及模板，这样发生与资源有关的操作时，都能通过输出恰当的反映出来。

 

### shared_ptr的最简单应用

这里看个最简单的shared_ptr使用的例子，顺便看看CResourceObserver的使用。在最简单的一次性使用上，shared_ptr几乎没有区别。

例一：

```cpp
#include <boost/smart_ptr.hpp>
#include "ResourceObserver.h"
using namespace std;
using namespace boost;

class MyClass : public CResourceObserver<MyClass>
{
};

void Fun()
{
    shared_ptr<MyClass> sp(new MyClass);
}

int _tmain(int argc, _TCHAR* argv[])
{
    cout <<"Fun called." <<endl;
    Fun();
    cout <<"Fun ended." <<endl;

    return 0;
}
```

输出如下：

Fun called.

class MyClass Construct.

class MyClass Deconstruct.

Fun ended.

我们只new,并没有显式的delete，但是MyClass很显然也是析构了的。

这里将shared_ptr替换成auto_ptr也是完全可以的，效果也一样。

 

### shared_ptr的与auto_ptr的区别

shared_ptr与auto_ptr的区别在于所有权的控制上。如下例：

例二：

```cpp
#include <boost/smart_ptr.hpp>
#include <memory>
#include "ResourceObserver.h"
using namespace std;
using namespace boost;

class MyClass : public CResourceObserver<MyClass>
{
public:
    MyClass() : CResourceObserver<MyClass>()
    {
       mstr = typeid(MyClass).name();

    }

    void print()
    {
       cout <<mstr <<" print" <<endl;
    }

    std::string mstr;
};

typedef  shared_ptr<MyClass> spclass_t;
//typedef  auto_ptr<MyClass> spclass_t;

void Fun2(spclass_t& asp)
{
    spclass_t sp3(asp);
    cout <<asp.use_count() <<endl;

    asp->print();
    return;
}

void Fun()
{
    spclass_t sp(new MyClass);
    cout <<sp.use_count() <<endl;

    spclass_t sp2(sp);
    cout <<sp.use_count() <<endl;

    Fun2(sp);
    cout <<sp.use_count() <<endl;
}

int _tmain(int argc, _TCHAR* argv[])
{
    cout <<"Fun called." <<endl;
    Fun();
    cout <<"Fun ended." <<endl;

    return 0;
}
```

输出：

Fun called.

class MyClass Construct.

1

2

3

class MyClass print

2

class MyClass Deconstruct.

Fun ended.

此例中将shared_ptr分配的资源复制了3份（实际是管理权的复制，资源明显没有复制）,每一个shared_ptr结束其生命周期时释放一份管理权。每一个都有同等的使用权限。输出的引用计数数量显式了这一切。在这里，可以尝试替换shared_ptr到auto_ptr,这个程序没有办法正确运行。

 

### shared_ptr的引用计数共享所有权

因为没有拷贝构造及operator=的操作，我们可以知道，对象没有被复制，为了证实其使用的都是同一个资源，这里再用一个例子证明一下：

例3：

```cpp
#include <boost/smart_ptr.hpp>
#include <memory>
#include "ResourceObserver.h"
using namespace std;
using namespace boost;

class MyClass : public CResourceObserver<MyClass>
{
public:
    MyClass() : CResourceObserver<MyClass>()
    {
       mstr = typeid(MyClass).name();

    }

    void set(const char* asz)
    {
       mstr = asz;
    }

    void print()
    {
       cout <<mstr <<" print" <<endl;
    }

    std::string mstr;
};

typedef  shared_ptr<MyClass> spclass_t;

void Fun2(spclass_t& asp)
{
    spclass_t sp3(asp);

    sp3->set("New Name");
    return;
}

void Fun()
{
    spclass_t sp(new MyClass);
    spclass_t sp2(sp);

    Fun2(sp);

    sp->print();
    sp2->print();
}

int _tmain(int argc, _TCHAR* argv[])
{
    cout <<"Fun called." <<endl;
    Fun();
    cout <<"Fun ended." <<endl;

    return 0;
}
```

输出：

Fun called.

class MyClass Construct.

New Name print

New Name print

class MyClass Deconstruct.

Fun ended.

 

### shared_ptr与标准库容器

在标准库容器中存入普通指针来实现某个动态绑定的实现是很普遍的事情，但是实际上每次都得记住资源的释放，这也是BoundsChecker误报的最多的地方。

例4：

```cpp
#include <boost/smart_ptr.hpp>
#include <vector>
#include "ResourceObserver.h"
using namespace std;
using namespace boost;

class MyClass : public CResourceObserver<MyClass>
{
public:
    MyClass() : CResourceObserver<MyClass>()
    {
       mstr = typeid(MyClass).name();

    }

    void set(const char* asz)
    {
       mstr = asz;
    }

    void print()
    {
       cout <<mstr <<" print" <<endl;
    }

    std::string mstr;
};

typedef  shared_ptr<MyClass> spclass_t;
typedef  vector< shared_ptr<MyClass> > spclassVec_t;

void Fun()
{
    spclassVec_t spVec;
    spclass_t sp(new MyClass);
    spclass_t sp2(sp);

    cout <<sp.use_count() <<endl;
    cout <<sp2.use_count() <<endl;

    spVec.push_back(sp);
    spVec.push_back(sp2);

    cout <<sp.use_count() <<endl;
    cout <<sp2.use_count() <<endl;

    sp2->set("New Name");
    sp->print();
    sp2->print();

    spVec.pop_back();
    cout <<sp.use_count() <<endl;
    cout <<sp2.use_count() <<endl;

    sp->print();
    sp2->print();

}

int _tmain(int argc, _TCHAR* argv[])
{
    cout <<"Fun called." <<endl;
    Fun();
    cout <<"Fun ended." <<endl;

    return 0;
}
```

输出：

Fun called.

class MyClass Construct.

2

2

4

4

New Name print

New Name print

3

3

New Name print

New Name print

class MyClass Deconstruct.

Fun ended.

当在标准库容器中保存的是shared_ptr时，几乎就可以不考虑资源释放的问题了，该释放的时候自然就释放了，当一个资源从一个容器辗转传递几个地方的时候，常常会搞不清楚在哪个地方统一释放合适，用了shared_ptr后，这个问题就可以不管了，每次的容器Item的添加增加计数，容器Item的减少就减少计数，恰当的时候，就释放了。。。。方便不可言喻。

 

 

## 3.      智能指针的高级应用：

已经说的够多了，再说下去几乎就要脱离讲解智能指针与异常的本意了，一些很有用的应用就留待大家自己去查看资料吧。

1.     定制删除器，shared_ptr允许通过定制删除器的方式将其用于其它资源的管理，几乎只要是通过分配，释放形式分配的资源都可以纳入shared_ptr的管理范围，比如文件的打开关闭，目录的打开关闭等自然不在话下，甚至连临界区，互斥对象这样的复杂对象，一样可以纳入shared_ptr的管理。

2.     从this创建shared_ptr  。

以上两点内容在《Beyond the C++ Standard Library: An Introduction to Boost》智能指针的专题中讲解了一些，但是稍感不够详细，但是我也没有看到更为详细的资料，聊胜于无吧。

3.     Pimpl：

《Beyond the C++ Standard Library: An Introduction to Boost》中将智能指针的时候有提及，在《C++ Coding Standards: 101 Rules, Guidelines, and Best Practices》 第43 条Pimpl judiciously中对其使用的好处，坏处，方式等都有较为详细的讲解，大家可以去参考一下，我就不在此继续献丑了。

但是，事实上，很多时候并不是只能使用智能指针（比如pimpl），只是，假如真的你合理的使用了智能指针，那么将会更加安全，更加简洁。

以下是《Beyond the C++ Standard Library: An Introduction to Boost》对shared_ptr使用的建议：

1.当有多个使用者使用同一个对象，而没有一个明显的拥有者时

2.当要把指针存入标准库容器时

3.当要传送对象到库或从库获取对象，而没有明确的所有权时

4.当管理一些需要特殊清除方式的资源时

 

# 三、   智能指针与C++异常

因为考虑到大家可能对智能指针不够熟悉，所以讲到这里的时候对智能指针进行了较多的讲解，几乎就脱离主题了，在这里开始进入正题。

一开始我就讲了智能指针对于C++的异常机制非常重要，到底重要在哪里呢？这里看两个C++异常的例子，一个使用了没有使用智能指针，一个使用了智能指针。

```cpp
void Fun()
{
    MyClass* lp1 = NULL;
    MyClass* lp2 = NULL;
    MyClass* lp3 = NULL;

    lp1 = new MyClass;
    try
    {
       lp2 = new MyClass;
    }
    catch(bad_alloc)
    {
       delete lp1;
    }

    try
    {
       lp3 = new MyClass;
    }
    catch(bad_alloc)
    {
       delete lp1;
       delete lp2;
    }

    // Do Something.....

    delete lp1;
    delete lp2;
    delete lp3;
}

void Fun2()
{
    try
    {
       spclass_t sp1(new MyClass);
       spclass_t sp2(new MyClass);
       spclass_t sp3(new MyClass);
    }
    catch(bad_alloc)
    {
       // No need to delete anything
    }

    // Do Something

    // No need to delete anything

}
```

区别，好处，明眼人不用看第二眼。这里为了简单，用内存的作为示例，虽然现在内存分配的情况很少见了，但是其他资源原理上是一样的，个人经验最深的地方实在Python的C API使用上，哪怕一个简单的C++，Python函数相互调用，都会有N个PyObject*出来，一个一个又一个，直到头昏脑胀，使用了智能指针后，简化的不止一半代码。

其实从本质上来讲，异常属于增加了程序从函数退出的路径，而C++原来的内存管理机制要求每个分支都需要手动的释放每个分配了的资源，这是本质的复杂度，在用于普通return返回的时候，还有一些hack技巧，见《[do...while(0)的妙用](<http://www.cnblogs.com/flying_bat/archive/2008/01/18/1044693.html>)》，但是异常发生的时候，能够依赖的就只有手动和智能指针两种选择了。

       在没有智能指针的光使用异常的时候，甚至会抱怨因为异常增加了函数的出口，导致代码的膨胀，说智能指针是C++异常处理的绝佳搭档就在于其弥补的此缺点。

另外，其实很多语言还有个finally的异常语法，JAVA,Python都有，SEH也有，其与使用了智能指针的C++异常比较在刘未鹏关于异常处理的文章《[错误处理(Error-Handling)：为何、何时、如何(rev#2)](<http://blog.csdn.net/pongba/archive/2007/10/08/1815742.aspx>)》中也有详细描述，我就不在此多费口舌了，将来讲SEH的时候自然还会碰到。个人感觉是，有也不错。。。。毕竟，不是人人都有机会在每个地方都用上智能指针。

 

# 四、   参考资料

1.C++ Primer，中文版第4版，Stanley B.Lippman, Josee lajoie, Barbara E.Moo著 人民邮电出版社

2.Effective C++，Third Edition 英文版,Chapter 3 Resource Management， Scott Meyes著，电子工业出版社

3.More Effective C++（英文版）,Scott Meyes著，Items 28,29,机械工业出版社

4.Beyond the C++ Standard Library: An Introduction to Boost，By Björn Karlsson著，Part 1,Library 1，Addison Wesley Professional

5.C++ Coding Standards: 101 Rules, Guidelines, and Best Practices

Herb Sutter, Andrei Alexandrescu著， Addison Wesley Professional

 

 

[**write by****九天雁翎****(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)