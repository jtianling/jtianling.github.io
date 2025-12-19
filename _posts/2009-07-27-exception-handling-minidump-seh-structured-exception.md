---
layout: post
title: "异常处理与MiniDump详解(3) SEH（Structured Exception Handling）"
categories:
- "未分类"
tags:
- C++
- Exception
- SEH
- "异常"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '22'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文介绍Windows的SEH异常处理，它能捕获系统级崩溃，但不兼容C++对象，需用函数封装等方式解决。

<!-- more -->

**异常处理与MiniDump详解(3) SEH（Structured Exception Handling）**



# 一、综述

SEH--Structured Exception Handling，是Windows操作系统使用的异常处理方式。

对于SEH，有点需要说明的是，SEH是属于操作系统的特性，不为特定语言设计，但是实际上，作为操作系统的特性，几乎就等同与面向C语言设计，这点很好理解，就像Win32 API,Linux下的系统调用，都是操作系统的特性吧，实际还是为C做的。但是，作为为C语言设计的东西，实际上可调用的方式又多了，汇编，C++对于调用C语言的接口都是比较方便的。

# 二、基础篇

还是简单介绍一下SEH的使用，但是不准备太详细的介绍了，具体的详细介绍见参考中提及的书目。关于SEH的基本应用,《Windows核心编程》绝对是最佳读物（其实个人一直认为《Windows核心编程》是Windows编程领域必看的第二本书，第一本是《Programming Windows》。关于SEH更深入的一点的知识可能就要参考一些能用汇编讲解的书籍了，《Windows用户态程序高效排错》算是其中讲的不错的一本。

首先，SEH也有像C++异常一样的语法，及类try-catch语法，在SEH中为__try-except语法，抛出异常从throw改为RaiseException,在MSDN中的语法描述为：

```cpp
__try 

{
   // guarded code
}
__except ( _expression_ )
{
   // exception handler code
}
```

见一个实际使用的例子：

例1：

```cpp
#include <iostream>
#include <windows.h>
using namespace std;

int main()
{
    __try
    {
       RaiseException(0, 0, 0, NULL);
    }
    __except(EXCEPTION_EXECUTE_HANDLER)
    {
       cout <<"Exception Raised." <<endl;

    }

    cout <<"Continue running" <<endl;
}
```

这可能是最简单的SEH的例子了，输出如下：

Exception Raised.

Continue running

这个例子和普通C++异常的try-catch类似，也很好理解。只不过catch换成了except。

因为C语言没有智能指针，那么就不能缺少finally的异常语法，与JAVA,Python等语言中的也类似，（这是C++中没有的）finally语法的含义就是无论如何（不管是正常还是异常），此句总是会执行，常用于资源释放。

例2：

```cpp
#include <iostream>
#include <windows.h>
using namespace std;

int main()
{
    __try
    { 

       __try
       {
           RaiseException(0, 0, 0, NULL);
       }
       __finally
       {
          cout <<"finally here." <<endl;

       }
    }
    __except(1)
    {

    }

    __try
    { 

       __try
       {
           int i;
       }
       __finally
       {
           cout <<"finally here." <<endl;

       }
    }
    __except(1)
    {

    }
    cout <<"Continue running" <<endl;
    getchar();
}
```

这个实例看起来过于奇怪，因为没有将各个try-finally放入独立的模块之中，但是说明了问题：

1. finally的语句总是会执行，无论是否异常finally here总是会输出。

2. finally仅仅是一条保证finally语句执行的块，并不是异常处理的handle语句（与except不同），所以，假如光是有finally语句块的话，实际效果就是异常会继续向上抛出。（异常处理过程也还是继续）

3. finally执行后还可以用except继续处理异常，但是SEH奇怪的语法在于finally与except无法同时使用，不然会报编译错误。

如下例：

```cpp
    __try
    {
       RaiseException(0, 0, 0, NULL);
    }
    __except(1)
    {

    }
    __finally
    {
       cout <<"finally here." <<endl;

    }
```

VS2005会报告

error C3274: __finally 没有匹配的try

这点其实很奇怪，难道因为SEH设计过于老了？-_-!因为在现在的语言中finally都是允许与except（或类似的块，比如catch）同时使用的。C#，JAVA,Python都是如此，甚至在MS为C++做的托管扩展中都是允许的。如下例：(来自MSDN中对finally keyword [C++]的描述)

```cpp
using namespace System;

ref class MyException: public System::Exception{};

void ThrowMyException() {
    throw gcnew MyException;
}

int main() {
    try {
       ThrowMyException();
    }
    catch ( MyException^ e ) {
       Console::WriteLine(  "in catch" );
       Console::WriteLine( e->GetType() );
    }
    finally {
       Console::WriteLine(  "in finally" );
    }

}
```

当你不习惯使用智能指针的时候常常会觉得这样会很好用。关于finally异常语法和智能指针的使用可以说是各有长短，这里提供刘未鹏的一种解释，（见参考5的RAII部分，文中比较的虽然是JAVA，C#,但是实际SEH也是类似JAVA的）大家参考参考。

SEH中还提供了一个比较特别的关键字，__leave,MSDN中解释如下

Allows for immediate termination of the __try block without causing abnormal termination and its performance penalty.

简而言之就是类似goto语句的抛出异常方式，所谓的没有性能损失是什么意思呢？看看下面的例子：

```cpp
#include <iostream>
#include <windows.h>
using namespace std;

int main()
{
    int i = 0;
    __try
    {
       __leave;
       i = 1;
    }
    __finally
    {
       cout <<"i: " <<i <<" finally here." <<endl;
    }

    cout <<"Continue running" <<endl;
    getchar();
}
```

输出：

i: 0 finally here.

Continue running

实际就是类似Goto语句，没有性能损失指什么？一般的异常抛出也是没有性能损失的。

MSDN解释如下：

The __leave keyword
The __leave keyword is valid within a try-finally statement block. The effect of __leave is to jump to the end of the try-finally block. The termination handler is immediately executed. Although a goto statement can be used to accomplish the same result, a goto statement causes stack unwinding. The __leave statement is more efficient because it does not involve stack unwinding. 

意思就是没有stack unwinding，问题是。。。。。。如下例，实际会导致编译错误，所以实在不清楚到__leave到底干啥的，我实际中也从来没有用过此关键字。

```cpp
#include <iostream>
#include <windows.h>
using namespace std;


void fun()
{
    __leave;
}

int main()
{
    __try
    {
       fun();
    }
    __finally
    {
       cout <<" finally here." <<endl;
    }

    cout <<"Continue running" <<endl;
    getchar();
}
```

# 三、提高篇

## 1. SEH的优点

1) 一个很大的优点就是其对异常进程的完全控制，这一点是C++异常所没有的，因为其遵循的是所谓的终止设定。

这一点是通过except中的表达式来控制的（在前面的例子中我都是用1表示，实际也就是使用了**EXCEPTION_EXECUTE_HANDLER****方式。**

**EXCEPTION_CONTINUE_EXECUTION ( –1)** 表示在异常发生的地方继续执行，表示处理过后，程序可以继续执行下去。 C++中没有此语义。

**EXCEPTION_CONTINUE_SEARCH (0)** 异常没有处理，继续向上抛出。类似C++的throw; 

**EXCEPTION_EXECUTE_HANDLER (1)** 异常被处理，从异常处理这一层开始继续执行。 类似C++处理异常后不再抛出。

2) 操作系统特性，不仅仅意味着你可以在更多场合使用SEH（甚至在汇编语言中使用），实际对异常处理的功能也更加强大，甚至是程序的严重错误也能恢复（不仅仅是一般的异常），比如，除0错误，访问非法地址（包括空指针的使用）等。这里可以用一个例子来说明：

```cpp
#include <iostream>
#include <windows.h>
using namespace std;

int main()
{
    __try
    {
       int *p = NULL;
       *p = 0;
    }
    __except(1)
    {
       cout <<"catch that" <<endl;
    }

    cout <<"Continue running" <<endl;
    getchar();
}
```

输出：

catch that

Continue running

在C++中这样的情况会导致程序直接崩溃的，这一点好好利用，可以使得你的程序稳定性大增，以弥补C++中很多的不足。但是，问题又来了，假如异常都被这样处理了，甚至没有声息，非常不符合发生错误时死的壮烈的错误处理原则。。。。。。。很可能导致程序一堆错误，你甚至不知道为什么，这样不利于发现错误。

但是，SEH与MS提供的另外的特性MiniDump可以完美的配合在一起，使得错误得到控制，但是错误情况也能捕获到，稍微的缓解了这种难处（其实也说不上完美解决）。

这一点需要使用者自己权衡，看看到底开发进入了哪个阶段，哪个更加重要，假如是服务器程序，那么在正式跑着的时候，每崩溃一次就是实际的损失。。。所以在后期可以考虑用这种方式。

关于这方面的信息，在下一次在详细讲解。

## 2. SEH的缺点

其实还是有的，因为是为操作系统设计的，实际类似为C设计，那么，根本就不知道C++中类/对象的概念，所以，实际上不能识别并且正确的与C++类/对象共存，这一点使用C++的需要特别注意，比如下例的程序根本不能通过编译。

例一：

```cpp
int main()
{
    CMyClass o;
    __try
    {
    }
    __except(1)
    {
       cout <<"catch that" <<endl;
    }

    cout <<"Continue running" <<endl;
    getchar();
}
```

例二：

```cpp
int main()
{
    __try
    {
       CMyClass o;
    }
    __except(1)
    {
       cout <<"catch that" <<endl;
    }

    cout <<"Continue running" <<endl;
    getchar();
}
```

错误信息都为：

warning C4509: 使用了非标准扩展:"main"使用SEH，并且"o"有析构函数

error C2712: 无法在要求对象展开的函数中使用__try

这点比较遗憾，但是我们还是有折衷的办法的，那就是利用函数的特性，这样可以避开SEH的不足。

比如，希望使用类的使用可以这样：

这个类利用了上节的CResourceObserver类，

```cpp
class CMyClass : public CResourceObserver<CMyClass>
{

};
```

```cpp
void fun()
{
    CMyClass o;
}
```

```cpp
#include <iostream>
#include <windows.h>
using namespace std;


int main()
{
    __try
    {
       fun();
    }
    __except(1)
    {
       cout <<"catch that" <<endl;
    }

    cout <<"Continue running" <<endl;
    getchar();
}
```

输出：

class CMyClass Construct.

class CMyClass Deconstruct.

Continue running

可以看到正常的析构，简而言之就是将实际类/对象的使用全部放进函数中，利用函数对对象生命周期的控制，来避开SEH的不足。

# 四、参考资料

1. Windows核心编程（Programming Applications for Microsoft Windows）,第4版，Jeffrey Richter著，黄陇，李虎译，机械工业出版社

2. MSDN—Visual Studio 2005 附带版,Microsoft

3. 加密与解密，段钢编著，电子工业出版社

4. Windows用户态程序高效排错，熊力著，电子工业出版社

5. [ 错误处理(Error-Handling)：为何、何时、如何(rev#2)，刘未鹏(pongba)著](<http://blog.csdn.net/pongba/archive/2007/10/08/1815742.aspx>)

