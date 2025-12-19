---
layout: post
title: boost::thread库，奇怪的文档没有Tutorial的库，但是却仍然相当强大
categories:
- C++
tags:
- Boost
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '28'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文探讨boost::thread库，其文档虽差但功能强大。它通过函数对象创建线程，支持灵活、类型安全的参数传递，并与boost其他库良好集成。

<!-- more -->

**boost::thread 库，奇怪的文档没有Tutorial的库，但是却仍然相当强大**

[**write by 九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

一直以来感觉boost的库作为开源的库文档是非常详细的，绝大部分库的文档由浅入深，一般先有Overview,从Introduction到简单的Tutorial到复杂的example,再到rationale，应有尽有，但是boost::thread是个例外，没有任何Introduction,Tutorial的内容，上来就是class/type的member function，头文件列举，列举完了了事，连一个example也没有，最奇怪的 boost库文档绝对非其莫属，甚至《Beyond the C++ Standard Library: An Introduction to Boost》这本书中也只字未提thread库，这样的确为学习boost::thread库加大了难度。对于初学者就更难受了，毕竟，本来多线程就是一个不那么容易的东西。。。。

但是，不要以为此库就是boost中最默默无名的库了，为C++添加多线程库的呼声一直比较高（虽然B.S.以前在D&E中认为其应该由第三方库来完成这样和操作平台相关性比较大的内容），亏boost::thread库还提案了好几次，结果文档都没有完善-_-!起码也算是可能进入C++标准的东西，咋能这样呢？

最新的提案信息，可以在其文档中搜寻到，已经进入Revision 1的阶段了。《[Multi-threading Library for Standard C++ (Revision 1)](<http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2497.html>)》

其实，个人认为，一个多线程库可以很简单，实现简单的临界区用于同步就足够应付绝大部分情况了，相对而言，boost::thread这样的库还是稍微庞大了一点。类似于Python中的thread库其实就不错了（据《Programming Python》作者说原型来自于JAVA），通过继承形式使用线程功能（template method模式），还算比较自然，其实我们公司自己内部也实现了一套与之类似的C++版的线程库，使用也还算方便。但是boost::thread走的是另一条路。由于其文档中没有Introduction和Tutorial，我纯粹是摸石头过河似的实验，有用的不对的地方那也就靠大家指出来了。

# 一、 Introduction：

boost::thread不是通过继承使用线程那种用了template method模式的线程模型，而是通过参数传递函数(其实不仅仅是函数，只要是Callable，Copyable（因为需要复制到线程的本地数据）的就行)。这种模型是好是坏，我一下也没有结论，但是boost::thread库的选择总归是有些道理的，起码从个人感觉来说，也更符合标准库一贯的优先使用泛型而不是继承的传统和作风，这样的模型对于与boost::function,boost::bind等库的结合使用的确也是方便了很多，

## 1. 题外话：

假如你对win32/linux下的多线程有一定的了解有助于理解boost::thread的使用，假如没有win32/linux的多线程使用经验，那么起码也需要对多线程程序有概念性的了解，起码对于3个概念要有所了解，context switching,rare conditions, atomic operation，最好也还了解线程间同步的一些常见形式，假如对于我上面提及的概念都不了解，建议先补充知识，不然，即便是HelloWorld，估计也难以理解。 另外，毕竟本文仅仅是个人学习boost::thread库过程中的一些记录，所以不会对操作系统，线程等知识有透彻的讲解，请见谅。

## 2. boost::thread的HelloWorld:

example1:

```cpp
#include <windows.h>
#include <boost/thread.hpp>
#include <iostream>

using namespace std;
using namespace boost;

void HelloWorld()
{
    char* pc = "Hello World!";
    do
    {
       cout <<*pc;
    }while(*pc++);
    cout <<endl;
}

void NormalFunThread()
{
    thread loThread1(HelloWorld);
    thread loThread2(HelloWorld);
    HelloWorld();

    Sleep(100);
}

int main()
{
    NormalFunThread();

    return 0;
}
```

不知道如此形式的程序够不够的上一个thread的helloworld程序了。但是你会发现，boost::thread的确是通过构造函数的方式，（就是构造函数），老实的给我们创建了线程了，所以我们连一句完成的helloworld也没有办法正常看到，熟悉线程的朋友们，可以理解将会看到多么支离破碎的输出，在我的电脑上，一次典型的输出如下：

HHeellloHl eoWl olWrool rdWl!od

l d

!

呵呵，其实我不一次输出整个字符串，就是为了达到这种效果-_-!这个时候需要同步，join函数就是boost::thread为我们提供的同步的一种方式，这种方式类似于利用windows API WaitForSingleObject等待线程结束。下面利用这种方式来实现。

example2:

```cpp
#include <boost/thread.hpp>
#include <iostream>

using namespace std;
using namespace boost;

void HelloWorld()
{
    char* pc = "Hello World!";
    do
    {
       cout <<*pc;
    }while(*pc++);
    cout <<endl;
}

void NormalFunThread()
{
    thread loThread1(HelloWorld);
    loThread1.join();
    thread loThread2(HelloWorld);
    loThread2.join();
    HelloWorld();

}

int main()
{
    NormalFunThread();

    return 0;
}
```

这样，我们就能完成的看到3句hello world了。但是这种方式很少有意义，因为实际上我们的程序同时还是仅仅存在一个线程，下一个线程只在一个线程结束后才开始运行，所以，实际中使用的更多的是其他同步手段，比如，临界区就用的非常多，但是我在boost::thread中没有找到类似的使用方式，倒是有mutex（互斥），其实两者对于使用是差不多的。下面看使用了mutex同步线程的例子：

example3:

```cpp
#include <windows.h>
#include <boost/thread.hpp>
#include <boost/thread/mutex.hpp>
#include <iostream>

using namespace std;
using namespace boost;

mutex mu;
void HelloWorld()
{
    mu.lock();
    char* pc = "Hello World!";
    do
    {
       cout <<*pc;
    }while(*pc++);
    cout <<endl;
    mu.unlock();
}

void NormalFunThread()
{
    thread loThread1(HelloWorld);
    thread loThread2(HelloWorld);
    HelloWorld();

    loThread1.join();
    loThread2.join();
}

int main()
{
    NormalFunThread();

    return 0;
}
```

我们还是能看到3个完好的helloworld，并且，这在实际使用中也是有意义的，因为，在主线程进入HelloWorld函数时，假如第一个线程还没有执行完毕，那么，可能同时有3个线程存在，第一个线程正在输出，第二个线程和主线程在mu.lock();此句等待（也叫阻塞在此句）。其实,作为一个多线程的库，自然同步方式不会就这么一种，其他的我就不讲了。

作为boost库，有个很大的有点就是，互相之间结合的非常好。这点虽然有的时候加大了学习的难度，当你要使用一个库的时候，你会发现一个一个顺藤摸瓜，结果都学会了,比如现在，关于boost库的学习进行了很久了，（写了4，5篇相关的学习文章了），从boost::for_each,boost::bind,boost::lambda,boost::function,boost:: string_algo,到现在的boost::thread，其实原来仅仅是想要好好学习一下boost::asio而已。当你真的顺着学下来，不仅会发现对于C++语言的理解，对STL标准库的理解，对于泛型的理解，等等都有更深入的了解，我甚至在同时学习python的时候，感觉到boost库改变了C++的很多语言特性。。。虽然是模拟出来的。呵呵，题外话说多了，其实要表达的意思仅仅是boost::thread库也是和其他boost库有很多紧密结合的地方，使得其使用会非常的方便。这里一并的在一个例子中演示一下。

example4:

```cpp
#include <boost/thread.hpp>
#include <boost/thread/mutex.hpp>
#include <iostream>

#include <boost/function.hpp>
#include <boost/bind.hpp>
#include <boost/lambda/lambda.hpp>
#include <boost/lambda/bind.hpp>
using namespace std;
using namespace boost;

void HelloWorld()
{
    char* pc = "Hello World!";
    do
    {
       cout <<*pc;
    }while(*pc++);
    cout <<endl;
}

void NormalFunThread()
{
    thread loThread1(HelloWorld);
    thread loThread2(HelloWorld);
    HelloWorld();

    loThread1.join();
    loThread2.join();
}

void BoostFunThread()
{
    thread loThread1(HelloWorld);
    function< void(void) > lfun = bind(HelloWorld);
    thread loThread2(bind(HelloWorld));
    thread loThread3(lfun);

    loThread1.join();
    loThread2.join();
    loThread3.join();
}

int main()
{
//  NormalFunThread();
    BoostFunThread();

    return 0;
}
```

一如既往的乱七八糟：

HHHeeelllllolo o W WoWoorrrlldld!d!

但是，正是这样的乱七八糟，告诉了我们，我们进入了真实的乱七八糟的多线程世界了-_-!

还记得可怜的Win32 API怎么为线程传递参数吗？

看看其线程的原型

```c
**DWORD ThreadProc(**

  **LPVOID** _lpParameter_

**);**
```

这里有个很大的特点就是，运行线程的函数必须是这样的，规矩是定死的，返回值就是这样，参数就是LPVOID(void*)，你没有选择，函数原型没有选择，参数传递也没有选择，当你需要很多数据时，唯一的办法就是将其塞入一个结构，然后再传结构指针，然后再强行使用类型转换。其实这是很不好的编程风格，不过也是无奈的折衷方式。

注意到没有，其实我们的HelloWold根本就是没有符合这个要求，不过我们一样使用了，这也算是boost::thread的一个很大优点，最大的优点还是在于参数传递的方式上，彻底摆脱了原来的固定死的框架，让你到了随心所欲的使用线程的地步。

看个例子：

example5:

```cpp
#include <boost/thread.hpp>
#include <boost/thread/mutex.hpp>
#include <iostream>

#include <boost/function.hpp>
#include <boost/bind.hpp>
#include <boost/lambda/lambda.hpp>
#include <boost/lambda/bind.hpp>
using namespace std;
using namespace boost;

mutex mu;
void HelloTwoString(char *pc1, char *pc2)
{
    mu.lock();
    if(pc1)
    {
       do
       {
           cout <<*pc1;
       }while(*pc1++);
    }
    if(pc2)
    {
       do
       {
           cout <<*pc2;
       }while(*pc2++);
       cout <<endl;
    }
    mu.unlock();
}

void BoostFunThread()
{
    char* lpc1 = "Hello ";
    char* lpc2 = "World!";
    thread loThread1(HelloTwoString, lpc1, lpc2);
    function< void(void) > lfun = bind(HelloTwoString, lpc1, lpc2);
    thread loThread2(bind(HelloTwoString, lpc1, lpc2));
    thread loThread3(lfun);

    loThread1.join();
    loThread2.join();
    loThread3.join();
}

int main()
{
    BoostFunThread();

    return 0;
}
```

这里不怀疑线程的创建了，用了同步机制以方便查看结果，看看参数的传递效果，是不是真的达到了随心所欲的境界啊：）

最最重要的是，这一切还是建立在坚实的C++强类型机制磐石上，没有用hack式的强制类型转换，这个重要性无论怎么样强调都不过分，这个优点说他有多大也是合适的。再一次的感叹，当我责怪牛人们将C++越弄越复杂的时候。。。。。。。。先用用这种复杂性产生的简单的类型安全的高效的库吧。。。。。。关于boost::thread库就了解到这里了，有点浅尝辄止的感觉，不过，还是先知其大略，到实际使用的时候再来详细了解吧，不然学习效率也不会太高。

[**write by****九天雁翎****(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)
