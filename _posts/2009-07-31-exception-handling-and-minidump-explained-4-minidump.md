---
layout: post
title: "异常处理与MiniDump详解(4) MiniDump"
categories:
- C++
tags:
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
  views: '27'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

**异常处理与 MiniDump详解(4) MiniDump**

[**write by 九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

# 一、   综述

总算讲到MiniDump了。

Dump有多有用我都无法尽数，基本上属于定位错误修复BUG的倚天剑。（日志可以算是屠龙刀）这些都是对于那些不是必出的BUG，放在外面运行的时候出现的BUG而言的，那些能够通过简单调试就能发现的BUG，一般都不足为惧。

 

# 二、   基本应用

MiniDump之所以叫MiniDump，自然是有其Mini之处。。。（废话），呵呵，MS提供了一个API函数，MiniDumpWriteDump，（在Dbghelp.h中声明，需要导入DbgHelp.lib使用）所以我才将其称为MiniDump,其实Dump也能表达同样的意思。。。。

MiniDump最简单的应用在于程序崩溃的时候，将崩溃时那一刻的信息写进一个文件，以方便以后查找错误。使用方法说简单就简单，说难也难。

## 1.             怎么感知到程序的崩溃？

Window提供了较为方便的方法去感知到程序的几种崩溃情况。

在《[Breakpad在进程中完成dump的流程描述](<http://www.jtianling.com/archive/2008/06/01/2501260.aspx>)》一文中，我描述了一下Breakpad获取到程序崩溃的方法，事实上，这也是典型的Windows下感知程序崩溃的方法，那篇文章是刚开始工作的时候，完成公司自己的ExceptionHandle库的时候写的工作笔记，现在看起来也还是有一定的参考价值。

Windows下感知程序崩溃（其实就是运行时的严重错误）的方法有3个核心的函数，分别如下：

SetUnhandledExceptionFilter(HandleException)确定出现没有控制的异常发生时调用的函数为HandleException.

_set_invalid_parameter_handler(HandleInvalidParameter)确定出现无效参数调用发生时调用的函数为HandleInvalidParameter.

_set_purecall_handler(HandlePureVirtualCall)确定纯虚函数调用发生时调用的函数为HandlePureVirtualCall.

3个函数的使用方法一致，都是在发生自己关心的（见上面的描述）异常时，调用参数传进来回调函数，Windows会将崩溃信息通过参数传入回调函数，这时候就是进行Dump的绝佳时机。详细的信息可以查阅MSDN，我这里就不复制资料了，那样有copy文档之嫌，这里以SetUnhandledExceptionFilter为例，演示实际与MiniDumpWriteDump配合使用的情况。像这些比较复杂的API,MSDN中连个Example都没有，说实话，当时掌握花了一点时间。

ExceptionExample:

```cpp
#include <windows.h>
#include <Dbghelp.h>

using namespace std;

#pragma auto_inline (off)
#pragma comment( lib, "DbgHelp" )

// 为了程序的简洁和集中关注关心的东西，按示例程序的惯例忽略错误检查，实际使用时请注意
LONG WINAPI MyUnhandledExceptionFilter(
struct _EXCEPTION_POINTERS* ExceptionInfo
    )
{
    HANDLE lhDumpFile = CreateFile(_T("DumpFile.dmp"), GENERIC_WRITE, 0, NULL, CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL ,NULL);

    MINIDUMP_EXCEPTION_INFORMATION loExceptionInfo;
    loExceptionInfo.ExceptionPointers = ExceptionInfo;
    loExceptionInfo.ThreadId = GetCurrentThreadId();
    loExceptionInfo.ClientPointers = TRUE;
    MiniDumpWriteDump(GetCurrentProcess(), GetCurrentProcessId(),lhDumpFile, MiniDumpNormal, &loExceptionInfo, NULL, NULL);

    CloseHandle(lhDumpFile);

    return EXCEPTION_EXECUTE_HANDLER;
}


void Fun2()
{
    int *p = NULL;
    *p = 0;
}

void Fun()
{
    Fun2();
}

int main()
{
    SetUnhandledExceptionFilter(MyUnhandledExceptionFilter);

    Fun();

    return 1;
}
```

API的调用仅仅作为释放，查看下MSDN就知道使用方法了，

#pragma auto_inline (off)

#pragma comment( lib, "DbgHelp" )

两句讲一下，第一句是取消掉自动内联效果，这样才能达到更好的演示效果，不然，Fun,Fun2这种简单的函数会被自动内联，那么也就没有堆栈，不好看到实际中Dump的作用。效果与VS2005编译选项的，C/C++->优化->内联函数展开->only _inline一样。

第二句是标志导入DbgHelp库，以使用MiniDumpWriteMiniDump API。与VS2005编译选项的链接器->输入->附加依赖项中添加dbgHelp.lib效果一样。

 

实际运行程序，（不能在VS中调试运行,不然异常控制权总是会被VS掌握，那么，总是没有办法让MyUnhandledExceptionFilter获得控制权，详细的描述见参考2），可以获得一个名叫DumpFile.dmp的文件，此文件就是我们折腾了半天所谓的dump文件了。其他两个函数与MiniDumpWriteMiniDump的配合使用方式也类似，就不多说了。

 

## 2.      Dump文件的使用

Dump文件的在Windows下的使用非常简单，但是就是因为太过于简单，所以网上的描述也是非常简单，想起来，那时候折腾出Dump文件时非常兴奋，解决发现拿dump文件没有办法，网上简单的描述用VS打开调试的方法总是没有头绪。。。。呵呵

正确的使用方法是，将崩溃程序的dmp, pdb,exe文件都放在同一个目录下，然后双击运行dmp,（或者用VS打开），然后就会出现一个名为dumpfile的解决方案并且包含一个dumpfile的工程，此时右键点击此工程，选择调试->启动新实例（或者启动并进入单步调试新实例）都行，此时程序会自动的调到源码中崩溃的那一行，并且在call stack中有完整的堆栈信息，并且临时变量的值也可以通过VS显示出来，还有模块信息，线程信息，

在上例中，堆栈信息是：

>     Exception.exe!Fun2()  行36       C++
>      Exception.exe!main()  行50 C++
>      Exception.exe!__tmainCRTStartup()  行597 + 0x17 字节       C
>      kernel32.dll!7c817077()       
>      [下面的框架可能不正确和/或缺失，没有为 kernel32.dll 加载符号]   
>      ntdll.dll!7c93005d()  

然后，寄存器的值为：

EAX = 00000000 EBX = 00000000 ECX = 0000B623 

EDX = 7C92E514 ESI = 00000001 EDI = 00403384 

EIP = 00401072 ESP = 0013FF7C EBP = 0013FFC0 

EFL = 00010246 

 

在normal模式下，dump文件速度较快，但是没有内存信息，你甚至可以通过调整MiniDumpWriteMiniDump的参数来将运行时的整个内存都dump下来，这些都非常简单，查看一下MSDN MiniDumpWriteMiniDump的信息即可。

有了这些信息，程序的错误定位（C++下一般是空指针的访问比较多）已经是非常明朗的了，再配合日志，一般的错误不难发现。这里顺带说明一下，当运行的程序被改名或者糅合进其他地方后运行，用这样的方式，一开始堆栈信息中是没有完整的信息的，这时候可以在堆栈信息中，用右键菜单中的加载符号，选择合适的文件pdb，这样信息就出来了。。。。。（以前这个问题困扰了我们一天）

 

# 三、   高级应用

程序崩溃的问题解决了，问题是，有很多时候，很多程序是不允许随便崩溃的，这样，在程序崩溃后再去发现问题就有些晚了，那么，有没有程序不崩溃时也能发现问题的方法呢？前面描述的SEH就是一种让程序不崩溃的方法，不过在那种方式下，按以前描述的方法，崩溃是不崩溃了，但是实际上，掩盖了很多问题，对于问题的发现有些不利的地方。本文前面描述过了，MiniDump是一种快速发现问题的好方法，但是却没有办法避免程序崩溃，那么终极办法是啥呢？我们的目的既然是程序不崩溃+快速发现问题，那么终极办法自然就是SEH+MiniDump了：）SEH和MiniDump都是Windows的特性，MS也的确提供了结合的方式。见下面的例子，呵呵，别太激动了。。。。这也是我们公司的服务器从内测时一天多次无任何通知，预告，警告的崩溃（总监甚至还曾因为我的问题，半夜3点爬起来解决服务器崩溃问题）到现在服务器基本做到永不崩溃，即便出现问题了也有充足的时间从容的解决，然后在服务器中发通告，告诉文件服务器需要临时维护。。。。呵呵，都依赖于此终极解决方案。。。。。

SEH的用法和特性讲解这里不重复了，见前面的文章。《**[异常处理与 MiniDump详解(3) SEH（Structured Exception Handling）](<http://www.jtianling.com/archive/2009/07/27/4382591.aspx>)**》

要想利用MiniDumpWriteMiniDump，需要获取的是MINIDUMP_EXCEPTION_INFORMATION结构的信息，这个结构中最重要的信息来源于PEXCEPTION_POINTERS的信息，这个信息在上述的例子中是在程序崩溃的时候，由Windows作为参数传入我们设定好的异常处理函数的，现在最主要的问题就是从哪里获取到这个异常信息了，通过MSDN，我们查到了GetExceptionInformation的函数，返回的就是这个信息，见MSDN：

LPEXCEPTION_POINTERS GetExceptionInformation(void);

不过，这里MS给出了一个notice:

The Microsoft C/C++ Optimizing Compiler interprets this function as a keyword, and its use outside the appropriate exception-handling syntax generates a compiler error.

事实上，刚开始我使用的时候，哪个地方都试遍了，果然都是报编译错误。因为此函数使用方式如此奇怪，并且没有example。。。。。最后在绝望中。。。看到了Platform Builder for Microsoft Windows CE 5.0的词函数的说明，里面有个说明，然后我吐血了。。。。

```cpp
try 
{ 
    // try block 
} 
except (FilterFunction(GetExceptionInformation()) 
{ 
    // exception handler block 
}
```

原来是这样使用的啊。。。。。。。。。。晕

HandleWithoutCrash例子：

```cpp
#include <windows.h>
#include <Dbghelp.h>

using namespace std;

#pragma auto_inline (off)
#pragma comment( lib, "DbgHelp" )

// 为了程序的简洁和集中关注关心的东西，按示例程序的惯例忽略错误检查，实际使用时请注意
LONG WINAPI MyUnhandledExceptionFilter(
struct _EXCEPTION_POINTERS* ExceptionInfo
    )
{
    HANDLE lhDumpFile = CreateFile(_T("DumpFile.dmp"), GENERIC_WRITE, 0, NULL, CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL ,NULL);

    MINIDUMP_EXCEPTION_INFORMATION loExceptionInfo;
    loExceptionInfo.ExceptionPointers = ExceptionInfo;
    loExceptionInfo.ThreadId = GetCurrentThreadId();
    loExceptionInfo.ClientPointers = TRUE;
    MiniDumpWriteDump(GetCurrentProcess(), GetCurrentProcessId(),lhDumpFile, MiniDumpNormal, &loExceptionInfo, NULL, NULL);

    CloseHandle(lhDumpFile);

    return EXCEPTION_EXECUTE_HANDLER;
}


void Fun2()
{
    __try
    {
       static bool b = false;
      
       if(!b)
       {
           b = true;
           int *p = NULL;
           *p = 0;
        }
       else
       {
           MessageBox(NULL, _T("Here"), _T(""), MB_OK);
       }

    }
    __except(MyUnhandledExceptionFilter(GetExceptionInformation()))
    {
    }
}

void Fun()
{
    Fun2();
}

int main()
{
    Fun();
    Fun();

    return 1;
}
```

这里例子中，你可以调试程序了，因为程序不会崩溃，这样VS不会和你抢异常的控制。同时，看到dump文件的同时，也可以看到，程序实际上是继续运行了下去，因为MessageBox还是弹出来了。这。。。就是我们想要的。。。。。

我突然想到一首歌。。。。“I want to nobody but you...I want nobody but you.......”呵呵，目的达到了，惊艳吗？

这里有几个要点，GetExceptionInformation()仅仅只能在__except的MS所谓的Filter中调用，其他地方会报编译错误，其次，返回的值和一般的__except的意义是一样的，要想程序运行，需要返回EXCEPTION_EXECUTE_HANDLER表示异常得到了控制。其他几个值的含义见前篇的SEH。

 

# 四、   参考资料

1.     MSDN—Visual Studio 2005 附带版,Microsoft

2.     Windows用户态程序高效排错，熊力著，电子工业出版社

前面的系列文章：

**[异常处理与 MiniDump详解(3) SEH（Structured Exception Handling）](<http://www.jtianling.com/archive/2009/07/27/4382591.aspx>)**

**[异常处理与 MiniDump详解(2) 智能指针与C++异常](<http://www.jtianling.com/archive/2009/07/06/4323962.aspx>)**

**[异常处理与 MiniDump详解(1) C++异常](<http://www.jtianling.com/archive/2009/07/02/4317423.aspx>)**

 

  

[**write by****九天雁翎****(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)