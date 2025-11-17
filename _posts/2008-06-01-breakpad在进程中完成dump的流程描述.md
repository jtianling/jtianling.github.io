---
layout: post
title: Breakpad在进程中完成dump的流程描述
categories:
- C++
tags:
- Breakpad
- C++
- dump
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '23'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

Breakpad在进程中完成dump的流程描述

 

ExceptionHandler构造函数调用Initialize函数完成初始化.

当pipe_name不为空的时候,利用智能指针创建一个CrashGenerationClient对象,并注册后赋值给成员变量crash_generation_client_.

这是调用IsOutOfProcess成员函数,确定是否正常创建了CrashGenerationClient,这里的注释说明, CrashGenerationClient和CrashGenerationServer的创建主要是为了一个进程外的dump,也就是说,在不影响原程序运行的情况下,正常的dump,这里解释了在原测试程序中为何不调用CrashGenerationServer也可以正常dump,因为当CrashGenerationClient没有正常创建和注册的时候,程序就开始一个进程内的dump,也就是说,原程序将没有办法正常运行的dump.

因为这个简单的测试程序中调用的是五参数的构造函数构造ExceptionHandler,更没有开启CrashGenerationServer,所以这里走的是进程内dump流程.

关于ExceptionHandler构造函数参数的主要信息在<Breakpad 使用方法理解文档>.中

 

此时ExceptionHandler自己创建线程来处理异常.首先还创建了信标handler_start_semaphore_,handler_finish_semaphore_,都设为无信号状态.

 

创建新线程用的是CreateThread函数，新线程调用的函数名为ExceptionHandlerThreadMain，参数为this．

此线程的作用是无限的等待handler_start_semaphore_的Semaphore信号，等到Semaphore信号后，直接就调用WriteMinidumpWithException函数，开始dump．Dump后打开handler_finish_semaphore_的Semaphore信号.

 

在开启等待线程后, Initialize函数继续进行,并载入相关库文件,初始化了两个函数指针成员变量,并设置好dump路径,

 

最后根据handler_types标志位,调用windows API确定取得各种异常情况下调用的函数.这些函数最后得到异常信息,处理后再通过判断IsOutOfProcess()调用WriteMinidumpOnHandlerThread()开启handler_start_semaphore_的semaphore信号,开始dump.

 

```cpp
if (handler_types & HANDLER_EXCEPTION)
    previous_filter_ = SetUnhandledExceptionFilter(HandleException);

#if _MSC_VER >= 1400  // MSVC 2005/8
if (handler_types & HANDLER_INVALID_PARAMETER)
    previous_iph_ = _set_invalid_parameter_handler(HandleInvalidParameter);
#endif  // _MSC_VER >= 1400

if (handler_types & HANDLER_PURECALL)
    previous_pch_ = _set_purecall_handler(HandlePureVirtualCall);
```

以上三个函数的含义分别是

SetUnhandledExceptionFilter(HandleException)确定出现没有控制的异常发生时调用的函数为HandleException.

_set_invalid_parameter_handler(HandleInvalidParameter)确定出现无效参数调用发生时调用的函数为HandleInvalidParameter.

_set_purecall_handler(HandlePureVirtualCall)确定纯虚函数调用发生时调用的函数为HandlePureVirtualCall.

 

在其定义的三个函数中,流程基本一样,都是先通过定义一个AutoExceptionHandler成员变量,通过上述三个函数恢复上一个用户的异常控制函数,以处理在此次异常处理中发生的异常.然后通过一些数据处理,再判断IsOutOfProcess(),这里我没有用CrashGeneration机制,自然还是返回false,此时这三个函数都是调用WriteMinidumpOnHandlerThread(),开启handler_start_semaphore_的semaphore信号,效果就是开始调用ExceptionHandlerThreadMain线程开始dump.接下来,他们判断此次异常控制是否成功,不成功就将交给上一层的异常处理函数处理.

 

这一步具体的实现上:

在HandleException()函数中,如同SHE常过滤器要求的那样,当成功时,返回EXCEPTION_EXECUTE_HANDLER,表示控制了异常,不成功时,此函数先判断是否有用户的上层异常过滤器函数,有的话,直接先利用它处理,没有就返回EXCEPTION_CONTINUE_SEARCH,告诉操作系统开始上一层异常处理的搜索.这里可以参看结构化异常处理程序理解文档第25章内容.

 

在HandleInvalidParameter()中,成功就直接通过exit(0)退出主线程了,不成功就调用上一层此类异常函数处理.当没有上一层此类异常函数,并且在Debug时,其调用_invalid_parameter()函数,向编译器报告一个无效参数的信息.

 

在HandlePureVirtualCall()函数中,之前加入了额外写入dump文件的信息,一个MDRawAssertionInfo结构,type被设为MD_ASSERTION_INFO_TYPE_PURE_VIRTUAL_CALL.其他流程类似.

 

以上基本就是不使用CrashGeneration在进程中完成dump的流程