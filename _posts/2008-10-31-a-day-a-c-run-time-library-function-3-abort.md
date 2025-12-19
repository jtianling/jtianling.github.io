---
layout: post
title: "一天一个C Run-Time Library 函数（3）  abort"
categories:
- C++
tags:
- abort
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '9'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

C函数abort()通过引发SIGABRT信号来终止程序。文章对比了其在Windows和Linux下的不同表现，并讲解了如何用signal函数捕获此信号，最后探讨了跨平台使用信号的挑战。

<!-- more -->

## 一天一个C Run-Time Library 函数（3）  abort


头文件： <stdlib.h>

## msdn:

Aborts the current process and returns an error code.

```c
void
abort( void );
```

## 测试程序3.1：

```c
#include <stdlib.h>
#include <stdio.h>

int main()
{
    
    printf("Running/n");
    
    abort();
    
    printf("Still Running/n");
    return 0;
}
```

以上函数在windows上输出为Running，然后弹出对话框。点终止即终止程序，点忽略还会输出类似`"``This application has requested the Runtime to terminate it in an unusual way. ``Please contact the application's support team for more information``。"的信息。```

`在``linux``下运行输出``Running`

`Aborted`

## 说明：

总算碰到一个真正的函数了，可惜一开始真正的函数问题就复杂了，比如关于abort相关的知识可以写2，3天。

首先abort函数是一个导致消息发生的函数，引发的消息为SIGABRT，说起来就很复杂了吧，什么是消息呢？在windows下编程我还从来没有用过类似的东西。事实上UNIX/Linux才是消息用的多的地方。

简而言之，消息是软件中断的一种。abort函数和消息的主要（也是最简单的）函数signal已经是ANSI C标准中的一员了。

signal函数也在这里附带讲了算了，MSDN声明如下：

Sets interrupt signal handling.

```c
void
(__cdecl *signal(   int _sig_ ,    void (__cdecl *_func_ ) (int [, int ] )))   (int);
```

事实上感觉微软实现消息系统似乎仅仅是为了稍微合乎点ANSI C的标准，因为在众多的消息中，其只实现了六种，而以下的六种其实都是ANSI.我没有去查ANSI C的标准，但是MS在signal函数的实现前有注释说明。

**_sig_****value** |  **Description**  
---|---  
**SIGABRT** |  Abnormal termination  
**SIGFPE** |  Floating-point error  
**SIGILL** |  Illegal instruction  
**SIGINT** |  CTRL+C signal  
**SIGSEGV** |  Illegal storage access  
**SIGTERM** |  Termination request  

SIGABRT这个由abort函数引发的消息是其中之一。

要知道，在一般的UNIX系统中，消息起码有五十种以上。这也是在windows中很少有人使用消息，而在Unix/linux中使用的很多的原因吧。

另外，MSDN中虽然MS明确说明调用abort函数的返回码是3，事实上经过我的实际测试，测试方法为用CreateProcess运行一个新的用abort函数结束的进程，然后调用GetExitCodeProcess函数获得返回值，返回值一直为0.我也很纳闷，觉得我不对的请自己测试一下，我也希望你们能指出我方式的错误。因为MS一般不会犯这样的错误，所以我都怀疑自己的正确性。（好啰嗦啊。。。）

在linux下(未有说明仅仅实在我的系统环境中测试)测试结果为返回134.

然后，顺便也给出一个signal函数的用法，这样才能理解abort函数的作用和消息的作用。

例子3.2

```c
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>

void Abort(int ai)
{
    printf("catch the SIGABRT and agrument is %d", ai);
}

int main()
{
    
    printf("Running/n");
    
    signal(SIGABRT, Abort);
    
    abort();
    
    printf("Still Running/n");
    return 0;
}
```

此例子在windows下和linux下效果一致，都是在调用abort函数后引发SIGABRT消息，因为先用signal捕获了此消息并指定此时调用Abort函数，所以最后的输出都是

Running

catch the SIGABRT and agrument is %d

有所不同的是，在windows下%d为22，linux下为6，不知道为什么windows要特意做的和别人不一样，然后特意声明一个

```c
#define SIGABRT_COMPAT  6       
/* SIGABRT compatible with other platforms, same as SIGABRT */
```

这一点我比较不解。

另外，通过对signal使用的例子可以看出来，响应的函数的参数实际就是消息定义的值。这样的好处是你可以为所有的消息定义一个函数，然后通过参数来判断到底是哪个消息。就类似与windows下可以SetTimer多次，而只OnTimer一个函数中响应，通过Timer的ID来判断到底是哪个时间到了。

再次说明一下，我并不是来说明函数的用法的。。。所以signal函数的参数什么的都省略了，请参考MSDN或者<advanced programming in the UNIX environment>一书。

另外，说明一下的是，假如在Abort这个响应函数中提前用exit函数退出程序，那么在linux下就不会再次触发系统的默认响应，并且程序的退出代码也由exit函数指定了。

在windows下，总是会触发系统的默认响应并弹出对话框。。。。。

另外，试图忽略SIGABORT消息（在signal函数的第二参数用SIG_IGN），我总是没有成功输出过Still running的语句，并且总是会触发系统默认响应，无论在windows还是linux下都是这样，希望有人可以告诉我为什么。

最后，需要注意的是Aborted这个linux下的输出实际实在错误流中输出的，比如以上例子编译为test程序，通过echo `./test`你可以看到，实际只有Running输出到标准输出。

## 实现：

MS:（删除次要部分）

```c
void __cdecl abort (
        void
        )
{
    _PHNDLR sigabrt_act = SIG_DFL;

    if (__abort_behavior & _WRITE_ABORT_MSG)
    {
        /* write the abort message */
        _NMSG_WRITE(_RT_ABORT);
    }

................

    /* Check if the user installed a handler for SIGABRT.

     * We need to read the user handler atomically in the case

     * another thread is aborting while we change the signal

     * handler.

     */
    sigabrt_act = __get_sigabrt();
    if (sigabrt_act != SIG_DFL)
    {
        raise(SIGABRT);
    }
    _exit(3);
}
```

先调用_NMSG_WRITE函数输出abort的错误信息，此时即弹出了对话框，无论你怎么设置忽略或者响应函数都没有用。

当没有忽略此消息时调用raise(SIGABRT)产生消息。

最后调用_exit返回错误代码3作为返回值。这里明明返回了3，但是我怎么得到程序的返回值总是0？奇了怪了。

gcc:

```c
/* We must avoid to run in circles.  Therefore we remember how far we
   already got.  */
static int stage;

/* We should be prepared for multiple threads trying to run abort.  */
__libc_lock_define_initialized_recursive (static, lock);



/* Cause an abnormal program termination with core-dump.  */
void abort (void)
{
    struct sigaction act;
    sigset_t sigs;

    /* First acquire the lock.  */
    __libc_lock_lock_recursive (lock);

    /* Now it's for sure we are alone.  But recursive calls are possible.  */

    /* Unlock SIGABRT.  */
    if (stage == 0)
    {
       ++stage;
       if (__sigemptyset (&sigs) == 0 &&
           __sigaddset (&sigs, SIGABRT) == 0)
           __sigprocmask (SIG_UNBLOCK, &sigs, (sigset_t *) NULL);
    }

    /* Flush all streams.  We cannot close them now because the user
    might have registered a handler for SIGABRT.  */
    if (stage == 1)
    {
       ++stage;
       fflush (NULL);
    }

    /* Send signal which possibly calls a user handler.  */
    if (stage == 2)
    {

       /* This stage is special: we must allow repeated calls of
       `abort' when a user defined handler for SIGABRT is installed.

       This is risky since the `raise' implementation might also

       fail but I don't see another possibility.  */
       int save_stage = stage;

       stage = 0;
       __libc_lock_unlock_recursive (lock);

       raise (SIGABRT);

       __libc_lock_lock_recursive (lock);
       stage = save_stage + 1;
    }

    /* There was a handler installed.  Now remove it.  */
    if (stage == 3)
    {
       ++stage;
       memset (&act, '/0', sizeof (struct sigaction));
       act.sa_handler = SIG_DFL;
       __sigfillset (&act.sa_mask);
       act.sa_flags = 0;
       __sigaction (SIGABRT, &act, NULL);
    }

    /* Now close the streams which also flushes the output the user
    defined handler might has produced.  */
    if (stage == 4)
    {
       ++stage;
       __fcloseall ();
    }

    /* Try again.  */
    if (stage == 5)
    {
       ++stage;
       raise (SIGABRT);
    }

    /* Now try to abort using the system specific command.  */
    if (stage == 6)
    {
       ++stage;
       ABORT_INSTRUCTION;
    }

    /* If we can't signal ourselves and the abort instruction failed, exit.  */
    if (stage == 7)
    {
       ++stage;
       _exit(127);
    }

    /* If even this fails try to use the provided instruction to crash
    or otherwise make sure we never return.  */
    while (1)
       /* Try for ever and ever.  */
       ABORT_INSTRUCTION;
}
```

做的工作差不多，实现手段差好远啊，linux下多的就是一个文件的flush和close还有用static stage的方式来允许递归的abort调用。glibc中详尽的注释可帮了我不少忙。以前还真没有见到过类似的用法，今天算是长见识了。说实话，这样一个简单的函数，我并没有完全看懂，可能需要有时间一步一步跟，并创造递归abort调用的情况才能很好的理解。

windows这点可能是由操作系统自己做了，所以没有在abort函数中有体现。

另外，我怎么测试返回值都是134......但是很明显调用的是_exit(127)，原因和windows老是返回0一样不明。

## 效率测试：

略

## 相关函数：

raise，signal

## 个人想法：

虽然windows也包含消息，虽然那6个消息是ANSI的标准，但是个人推荐，对于可移植的东西来说，最好是不要用消息了，除非你确定只用windows的那6个消息。即使你只用这六个消息，你都会发现windows运行的特性与linux不同。不然，对于消息系统来说，要实现windows中没有实现的消息不是太容易的事情。。。。。所以，强大的消息系统只能在windows中找替代方案了。对于windows/linux可移植的东西来说，这也是最大最大的一个缺憾，那就是你不能用太多平台相关的东西，而偏偏很多这样的东西就是这个平台中最好的东西。比如Windows的核心对象系统，linux下的消息系统等等等等，真是缺憾啊。。。

本来因为有宏嘛，可以在所有类似的系统上再封一层，以达到虽然使用不同的东西也可以保持很好的移植性。但是对于消息系统或者Windows SEH这样彻底的破坏程序流程的东西，根本是没有办法通过宏来做到的。宏毕竟不是万能的。

在实在没有办法的时候，只能把你所封的那一层尽量的调高了（可以到类）。那样，代码量的增加几乎是一倍，除非必要，并不是太值得。（在封装网络模块的时候只能用到）

在非必要的时候，尽量做到最简单的封装（在简单的函数这一层），这样统一的程序流程和逻辑，也更加容易理解，代码量也小。

而对于消息系统这样破坏程序流程的东西，甚至想封在一个子类里面，然后使用共同的接口都不是太容易。

总而言之，非必要，个人认为，可移植程序，少用消息系统。

write by 九天雁翎(JTianLing)  
\-- www.jtianling.com
