---
layout: post
title: "异常处理与MiniDump详解(1) C++异常"
categories:
- "未分类"
tags:
- C++
- Exception
- "异常"
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

本文详解C++异常机制，通过代码剖析异常的复制与传递，阐明“按值抛出、按引用捕获”的最佳实践。

<!-- more -->

**异常处理与 MiniDump详解(1) C++异常**



# 一、综述

我很少敢为自己写的东西弄个详解的标题，之所以这次敢于这样，自然还算是有点底气的。并且也以此为动力，督促自己好好的将这两个东西研究透。

当年刚开始工作的时候，第一个工作就是学习breakpad的源代码，然后了解其原理，为公司写一个ExceptionHandle的库，以处理服务器及客户端的未处理异常(unhandle exception)，并打下dump，以便事后分析，当年这个功能在有breakpad的示例在前时，实现难度并不大，无非就是调用了SetUnhandledExceptionFilter等函数，让windows在出现未处理异常时让自己的回调函数接管操作，然后利用其struct _EXCEPTION_POINTERS* ExceptionInfo的指针，通过MiniDumpWriteDump API将Dump写下来。但是仍记得，那时看到《Windows 核心编程》第五部分关于结构化异常处理的描述时那种因为得到新鲜知识时的兴奋感，那是我第一次这样接近Windows系统的底层机制，如同以前很多次说过的，那以后我很投入的捧着读完了《Windows 核心编程》，至今受益匪浅。当时也有一系列一边看源代码一边写下心得的时候，想想，都已经一年以前的事情了。

《[读windows核心编程,结构化异常部分,理解摘要](http://www.jtianling.com/archive/2008/06/13/2544944.aspx)》

《[Breakpad在进程中完成dump的流程描述](http://www.jtianling.com/archive/2008/06/01/2501260.aspx)》

《[Breakpad 使用方法理解文档](http://www.jtianling.com/archive/2008/06/01/2501244.aspx)》

直到最近，为了控制服务器在出现异常时不崩溃，（以前是崩溃的时候打Dump），对SEH（windows结构化异常）又进行了进一步的学习，做到了在服务器出现了异常情况（例如空指针的访问）时，服务器打下Dump，并继续运行，并不崩溃，结合以前也是我写的监控系统，通知监控客户端报警，然后就可以去服务器上取回dump，并分析错误，这对服务器的稳定性有很大的帮助，不管我们对服务器的稳定性进行了多少工作，作为C++程序，偶尔的空指针访问，几乎没有办法避免。。。。。。但是，这个工作，对这样的情况起到了很好的缓冲作用。在这上面工作许久，有点心得，写下来，供大家分享，同时也是给很久以后的自己分享。

# 二、为什么需要异常

《Windows核心编程》第4版第13章开头部分描述了一个美好世界，即所编写的代码永远不会执行失败，总是有足够的内存，不存在无效的指针。。。。但是，那是不存在的世界，于是，我们需要有一种异常的处理措施，在C语言中最常用的（其实C++中目前最常用的还是）是利用错误代码（Error Code）的形式。

这里也为了更好的说明，也展示一下Error Code的示例代码：

### Error Code常用方式：

1.最常用的就是通过返回值判断了：

比如C Runtime Library中的fopen接口，一旦返回NULL,Win32 API中的CreateFiley一旦返回INVALID_HANDLE_VALUE，就表示执行失败了。

2.当返回值不够用（或者携带具体错误信息不够的）时候，C语言中也常常通过一个全局的错误变量来表示错误。

比如C Runtime Library中的errno 全局变量，Win32 API中的GetLastError**，** WinSock**中的** WSAGetLastError函数就是这种实现。

既然Error Code在这么久的时间中都是可用的，好用的，为什么我们还需要其他东西呢？

这里可以参考一篇比较浅的文章。《[**错误处理和异常处理，你用哪一个**](http://blog.csdn.net/krqii/archive/2004/08/22/81420.aspx) 》，然后本人比较钦佩的pongba还有一篇比较深的文章：《[错误处理(Error-Handling)：为何、何时、如何(rev#2)](http://blog.csdn.net/pongba/archive/2007/10/08/1815742.aspx)**》，** 看了后你一定会大有收获。当pongba列出了16条使用异常的好处后，我都感觉不到我还有必要再去告诉你为什么我们要使用异常了。

但是，这里在其无法使用异常的意外情况下，（实际是《**C++ Coding Standards: 101 Rules, Guidelines, and Best Practices****》一书中所写）**

一、用异常没有带来明显的好处的时候：比如所有的错 误都会在立即调用端解决掉或者在非常接近立即调用端的地方解决掉。

二、在实际作了测定之后发现异常的抛出和捕获导致了显著的时间开销：这通常只有两种情 况，要么是在内层循环里面，要么是因为被抛出的异常根本不对应于一个错误。

很明显，文中列举的都是完全理论上理想的情况，受制于国内的开发环境，无论多么好的东西也不一定实用，你能说国内多少地方真的用上了敏捷开发的实践经验？这里作为现实考虑，补充几个没有办法使用异常的情况：

一．所在的项目组中没有合理的使用RAII的习惯及其机制，比如无法使用足够多的smart_ptr时，最好不要使用异常，因为异常和RAII的用异常不用RAII就像吃菜不放盐一样。这一点在后面论述一下。

二．当项目组中没有使用并捕获异常的习惯时，当项目组中认为使用异常是奇技淫巧时不要使用异常。不然，你自认为很好的代码，会在别人眼里不可理解并且作为异类，接受现实。

# 三、基础篇

先回顾一下标准C++的异常用法

## 1. C++标准异常

只有一种语法，格式类似：

try

{

}

catch（）

{  
}

经常简写为try-catch，当然，也许还要算上throw。格式足够的简单。

以下是一个完整的例子：

##### MyException:

```cpp
#include <string>
#include <iostream>

using namespace std;

class MyException : public exception
{
public:
    MyException(const char* astrDesc)
    {
        mstrDesc = astrDesc;
    }

    string mstrDesc;
};

int _tmain(int argc, _TCHAR* argv[])
{
    try
    {
        throw MyException("A My Exception");
    }
    catch(MyException e)
    {
        cout <<e.mstrDesc <<endl;
    }

    return 0;
}
```

这里可以体现几个异常的优势，比如自己的异常继承体系，携带足够多的信息等等。另外，虽然在基础篇，这里也讲讲C++中异常的语义，

如下例子中，

##### throwException:

```cpp
#include <string>
#include <iostream>

using namespace std;

class MyException : public exception
{
public:
    MyException(const char* astrDesc)
    {
        mstrDesc = astrDesc;
    }

    MyException(const MyException& aoOrig)
    {
        cout <<"Copy Constructor MyException" <<endl;
        mstrDesc = aoOrig.mstrDesc;
    }

    MyException& operator=(const MyException& aoOrig)
    {
        cout <<"Copy Operator MyException" <<endl;
        if(&aoOrig == this)
        {
            return *this;
        }

        mstrDesc = aoOrig.mstrDesc;
        return *this;
    }

    ~MyException()
    {
        cout <<"~MyException" <<endl;
    }

    string mstrDesc;
};

void exceptionFun()
{
    try
    {
        throw MyException("A My Exception");
    }
    catch(MyException e)
    {
        cout <<e.mstrDesc <<" In exceptionFun." <<endl;
        e.mstrDesc = "Changed exception.";
        throw;
    }
}

int _tmain(int argc, _TCHAR* argv[])
{
    try
    {
        exceptionFun();
    }
    catch(MyException e)
    {
        cout <<e.mstrDesc <<" Out exceptionFun." <<endl;
        throw;
    }

    return 0;
}
```

输出：

```text
Copy Constructor MyException
A My Exception In exceptionFun.
~MyException
Copy Constructor MyException
A My Exception Out exceptionFun.
~MyException
```

可以看出当抛出C++异常的copy语义，抛出异常后调用了Copy Constructor，用新建的异常对象传入catch中处理，所以在函数中改变了此异常对象后，再次抛出原异常，并不改变原有异常。

这里我们经过一点小小的更改，看看会发生什么：

##### throwAnotherException

```cpp
#include <string>
#include <iostream>

using namespace std;

class MyException : public exception
{
public:
    MyException(const char* astrDesc)
    {
        mstrDesc = astrDesc;
    }

    MyException(const MyException& aoOrig)
    {
        cout <<"Copy Constructor MyException" <<endl;
        mstrDesc = aoOrig.mstrDesc;
    }

    MyException& operator=(const MyException& aoOrig)
    {
        cout <<"Copy Operator MyException" <<endl;
        if(&aoOrig == this)
        {
            return *this;
        }

        mstrDesc = aoOrig.mstrDesc;
        return *this;
    }

    ~MyException()
    {
        cout <<"~MyException" <<endl;
    }

    string mstrDesc;
};

void exceptionFun()
{
    try
    {
        throw MyException("A My Exception");
    }
    catch(MyException e)
    {
        cout <<e.mstrDesc <<" In exceptionFun." <<endl;
        e.mstrDesc = "Changed exception.";
        throw e;
    }
}

int _tmain(int argc, _TCHAR* argv[])
{
    try
    {
        exceptionFun();
    }
    catch(MyException e)
    {
        cout <<e.mstrDesc <<" Out exceptionFun." <<endl;
        throw;
    }

    return 0;
}
```

这里和throwException程序的唯一区别就在于不是抛出原有异常，而是抛出改变后的异常，输出如下：

```text
Copy Constructor MyException
A My Exception In exceptionFun.
Copy Constructor MyException
Copy Constructor MyException
~MyException
~MyException
Changed exception. Out exceptionFun.
~MyException
```

你会发现连续的两次Copy Constructor都是改变后的异常对象，这点很不可理解。。。。。。。因为事实上一次就够了。但是理解C++的Copy异常处理语义就好理解了，一次是用于传入下一次的catch语句中的，还有一次是留下来，当在外层catch再次throw时，已经抛出的是改变过的异常对象了，我用以下例子来验证这点：

##### throwTwiceException

```cpp
#include <string>
#include <iostream>

using namespace std;

class MyException : public exception
{
public:
    MyException(const char* astrDesc)
    {
        mstrDesc = astrDesc;
    }

    MyException(const MyException& aoOrig)
    {
        cout <<"Copy Constructor MyException" <<endl;
        mstrDesc = aoOrig.mstrDesc;
    }

    MyException& operator=(const MyException& aoOrig)
    {
        cout <<"Copy Operator MyException" <<endl;
        if(&aoOrig == this)
        {
            return *this;
        }

        mstrDesc = aoOrig.mstrDesc;
        return *this;
    }

    ~MyException()
    {
        cout <<"~MyException" <<endl;
    }

    string mstrDesc;
};

void exceptionFun()
{
    try
    {
        throw MyException("A My Exception");
    }
    catch(MyException e)
    {
        cout <<e.mstrDesc <<" In exceptionFun." <<endl;
        e.mstrDesc = "Changed exception.";
        throw e;
    }
}

void exceptionFun2()
{
    try
    {
        exceptionFun();
    }
    catch(MyException e)
    {
        cout <<e.mstrDesc <<" In exceptionFun2." <<endl;
        throw;
    }
}

int _tmain(int argc, _TCHAR* argv[])
{
    try
    {
        exceptionFun2();
    }
    catch(MyException e)
    {
        cout <<e.mstrDesc <<" Out exceptionFuns." <<endl;
        throw;
    }

    return 0;
}
```

输出如下，印证了我上面的说明。

```text
Copy Constructor MyException
A My Exception In exceptionFun.
Copy Constructor MyException
Copy Constructor MyException
~MyException
~MyException
Changed exception. In exceptionFun2.
~MyException
Copy Constructor MyException
Changed exception. Out exceptionFuns.
```

上面像语言律师一样的讨论着C++本来已经足够简单的异常语法，其实简而言之，C++总是保持着一个上次抛出的异常用于用户再次抛出，并copy一份在catch中给用户使用。

但是，实际上，会发现，其实原有的异常对象是一直向上传递的，只要你不再次抛出其他异常，真正发生复制的地方在于你catch异常的时候，这样，当catch时使用引用方式，那么就可以避免这样的复制。

##### referenceCatch

```cpp
#include <string>
#include <iostream>

using namespace std;

class MyException : public exception
{
public:
    MyException(const char* astrDesc)
    {
        mstrDesc = astrDesc;
    }

    MyException(const MyException& aoOrig)
    {
        cout <<"Copy Constructor MyException: " <<aoOrig.mstrDesc <<endl;
        mstrDesc = aoOrig.mstrDesc;
    }

    MyException& operator=(const MyException& aoOrig)
    {
        cout <<"Copy Operator MyException:" <<aoOrig.mstrDesc <<endl;
        if(&aoOrig == this)
        {
            return *this;
        }

        mstrDesc = aoOrig.mstrDesc;
        return *this;
    }

    ~MyException()
    {
        cout <<"~MyException" <<endl;
    }

    string mstrDesc;
};

void exceptionFun()
{
    try
    {
        throw MyException("A My Exception");
    }
    catch(MyException& e)
    {
        cout <<e.mstrDesc <<" In exceptionFun." <<endl;
        e.mstrDesc = "Changed exception.";
        throw;
    }
}

void exceptionFun2()
{
    try
    {
        exceptionFun();
    }
    catch(MyException e)
    {
        cout <<e.mstrDesc <<" In exceptionFun2." <<endl;
        throw;
    }
}

int _tmain(int argc, _TCHAR* argv[])
{
    try
    {
        exceptionFun2();
    }
    catch(MyException e)
    {
        cout <<e.mstrDesc <<" Out exceptionFuns." <<endl;
        throw;
    }

    return 0;
}
```

上例中，使用引用方式来捕获异常，输出如下：

```text
A My Exception In exceptionFun.
Copy Constructor MyException: Changed exception.
Changed exception. In exceptionFun2.
~MyException
Copy Constructor MyException: Changed exception.
Changed exception. Out exceptionFuns.
~MyException
```

完全符合C++的引用语义。

基本可以发现，做了很多无用功，因为try-catch无非是一层迷雾，其实这里复制和引用都还是遵循着原来的C++简单的复制，引用语义，仅仅这一层迷雾，让我们看不清楚原来的东西。所以，很容易理解一个地方throw一个对象，另外一个地方catch一个对象一定是同一个对象，其实不然，是否是原来那个对象在于你传递的方式，这就像这是个参数，通过catch函数传递进来一样，你用的是传值方式，自然是通过了复制，通过传址方式，自然是原有对象，仅此而已。

另外，最终总结一下，《C++ Coding Standards》73条建议Throw by value,catch by reference就是因为本文描述的C++的异常特性如此，所以才有此建议，并且，其补上了一句，重复提交异常的时候用throw;

# 四、参考资料

1. Windows核心编程（Programming Applications for Microsoft Windows）,第4版，Jeffrey Richter著，黄陇，李虎译，机械工业出版社

2. MSDN—Visual Studio 2005 附带版,Microsoft

3. [**错误处理和异常处理，你用哪一个**](http://blog.csdn.net/krqii/archive/2004/08/22/81420.aspx)**，** apollolegend

4. [错误处理(Error-Handling)：为何、何时、如何(rev#2)](http://blog.csdn.net/pongba/archive/2007/10/08/1815742.aspx)**，** 刘未鹏

