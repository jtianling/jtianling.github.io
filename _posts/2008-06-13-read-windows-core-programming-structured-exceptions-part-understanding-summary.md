---
layout: post
title: "读windows核心编程,结构化异常部分,理解摘要"
categories:
- C++
tags:
- C++
- "《Windows核心编程》"
- "结构化异常"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '10'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---


## 23章

### 结束处理程序

`__try{}` `__finally{}`块语句,能保证在运行完`__try`的语句后能调用`__finally{}`块中的语句,就算是提前的`return`,`break`,`continue`,`goto`, 内存访问违规等都可以保证,但是当调用`ExitThread`或`ExitProcess`时,将立即结束线程或进程,由于调用`TerminateThread`或`TerminateProcess`而结束线程或进程,不会执行`__finally`块中的代码。

但是在`__try`块过早退出时,会导致局部展开,影响效率,应该尽量放在外面。

当碰到一些的确需要在块内部使用`return`时,可以先用`__leave`关键字代替,以直接从`__try`块转到`__finally`,并在最后调用`return`语句返回,这样避免了局部展开,提高了效率,但是额外的代价是需要加入一个表示函数成功完成的`bool`变量。

可以在`__finally`块中调用`AbnormalTermination`内部函数确定是否是非正常退出`__try`块,发生局部展开和内存访问违规等都算在内,此时返回`true`,当自然进入`__finally`块时,此函数返回`false`。可以通过这种方式决定到底在`__finally`块中执行什么代码。不能在其它地方调用。

**此结束处理程序的作用:**

简化错误处理,提高程序可读性,使代码更容易维护,使用得当具有很小的系统开销。

<!-- more -->

## 24章

### 异常处理程序

`__try{}` `__except{}`

在`__try`块中使用`return`,`break`,`continue`,`goto`语句不会带来额外开销。

*   `__try{}`
    `__except(EXCEPTION_EXECUTE_HANDLER){}`
    发生异常时,执行完`__except`块中的代码后,从其后的下一条语句开始执行。
*   `__try{}`
    `__except(EXCEPTION_CONTINUE_EXCUTION){}`
    发生异常时,执行完`__except`块中的代码后,重新从导致异常的原指令开始执行。
*   `__try{}`
    `__except(EXCEPTION_CONTINUE_SEARCH){}`
    发生异常时,不执行`__except`块中的代码,直接查找上一个匹配的`__except`块执行。

可以在`_except`块中和条件中调用`GetExceptionCode()`函数来确定到底是什么异常,不能在其它地方调用。

当一个异常发生时,操作系统向引起异常的线程的栈里压入三个结构, `EXCEPTION_RECORD`, `EXCEPTION_POINTERS`, `CONTEXT`,其中`EXCEPTION_POINTERS`就是两个指针成员,指向压入栈中的其它两个成员, `breakpad`的`exinfo`结构就是这个指针的类型。并且成员和含义完全一样。

`GetExceptionInformation`函数只能在异常过滤器中使用,也就是`__except`的条件中调用。块中都不能使用。但是可以想办法在异常过滤器中就将结果保存下来,放到以后使用。

### 软件异常

可以由
```c
void RaiseException(
  DWORD dwExceptionCode,
  DWORD dwExceptionFlags,
  DWORD nNumberOfArguments,
  const ULONG_PTR* lpArguments
);
```
引发。但是`dwExceptionCode`要遵循`winerror.h`文件中定义的一样的规则。

第二参数为是否允许异常过滤器返回`EXCEPTION_CONTINUE_EXCUTION`的标志位,当设为`0`为允许,设为`EXCEPTION_NONCONTINUABLE`为不允许,当不允许的时候,异常过滤器返回`EXCEPTION_CONTINUE_EXCUTION`时,会引发新的异常`EXCEPTION_CONTINUE_EXCEPTION`。

在异常的时候发生新的异常,旧的异常消息会保留在`EXCEPTION_RECORD`的`ExceptionRecord`链表中。

## 25章: 未处理异常和c++异常

Windows内部启动线程的方式也使用了`SHE`框架,当一个线程发生异常的时候,首先通过`UnhandledExceptionFilter(GetExceptionInformation())`处理,默认方式为弹出熟悉的报错对话框,按`close`后通过`ExitProcess(GetExceptionCode())`退出,按`debug`即传递合适的参数`CreateProcess`开启新的调试进程来调试异常的程序。

通过以`SEM_NOGPFAULTERRORBOX`为参数调用`SetErrorModel`函数,可以防止显示异常消息框。通过对每个线程和主线程的`try-except`块包装,可以自己处理每一个异常。而不调用默认的`UnhandledExceptionFilter`。windows还提供`SetUnhandledExceptionFilter`函数来定义某个进程中所有的线程发生异常时调用的异常过滤器。此函数的参数为用户自定义的异常过滤器的指针。

在`VC`中,`C++`的异常实际用`SHE`来实现,并且`SHE`比`C++`异常有更多功能,比如可以从一个硬件错误中恢复过来。可以在一个程序不同函数中同时使用两套异常系统,但是不能混合使用,也不能在一个函数中使用两套系统。
