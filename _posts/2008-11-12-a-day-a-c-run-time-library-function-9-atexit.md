---
layout: post
title: "一天一个C Run-Time Library 函数 （9） atexit"
categories:
- C++
tags:
- atexit
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '3'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

atexit是C库函数，可在程序正常退出时，按后进先出顺序执行注册的清理函数，常用于C语言的资源释放等收尾工作。

<!-- more -->



## msdn:

Processes the specified function at exit.

---

```c
int
atexit(   void (__cdecl *_func_ )( void ) );
```

## 测试程序：

```c
#include  
<stdlib.h>

#include  
<stdio.h>

void fn1(  
void ), fn2( void ), fn3( void ), fn4( void );

int main(  
void )

{

   atexit( fn1 );

   atexit( fn2 );

   atexit( fn3 );

   atexit( fn4 );

   printf( "This is executed  
first./n" );

}

void fn1()

{

   printf( "next./n" );

}

void fn2()

{

   printf( "executed " );

}

void fn3()

{

   printf( "is " );

}

void fn4()

{

   printf( "This " );

}
```

## 说明：

这个函数有点像一个类的析构函数。就是在程序结束的时候调用你指定的函数，按照类似堆栈的先进后出原则调用。呵呵，貌似很有用，其实从来没有用过，就我的想法可以在这里清理一下一些全局的变量，但是实际上因为类用的多，全局变量都等进程退出的时候自动析构处理了，全局打开的文件句柄也从来没有用过，一般起码放在类中，类析构的时候也会自动关闭了，所以实际我还真不太清楚什么时候需要用到这样的函数，也许仅仅是可以多提供一条更好的路径罢了。。。。也许是因为这毕竟是C语言的库，C语言的全局变量，或者全局的文件句柄可能就只能通过这样的方式来保证销毁或关闭了。

## 实现：

MS:

还真没有看懂。。。。。。

其实最主要不懂的就是以前看文件操作底层也会用到的一对函数，_encode_pointer和_decode_pointer

gcc:

用了全局的名叫__exit_funcs的链表，来不断链接你输入的函数，甚至我看到了一个可以输入参数的实现，atexit就是通过给定void参数通过那个实现来完成的。实际调用函数的时候就是在exit函数中先调用。这里顺便说一句，_exit是不调用atexit指定函数的退出方式，exit是调用atexit的退出方式。实际上，exit函数中仅仅是先执行了atexit指定的函数，然后再调用了_exit

下面贴出那个有参数调用的实现

```c
int __cxa_atexit (void (*func) (void *), void *arg, void *d)
{

    struct exit_function  
*new = __new_exitfn  
();

    if (new  
== NULL)

       return -1;

#ifdef PTR_MANGLE

    PTR_MANGLE (func);
#endif
    new->func.cxa.fn = (void (*) (void *, int)) func;
    new->func.cxa.arg = arg;
    new->func.cxa.dso_handle  
= d;
    atomic_write_barrier ();

    new->flavor  
= ef_cxa;

    return 0;

}
```

## 效率测试：

无

## 相关函数：

exit,_exit

## 个人想法：

虽然不知道这3个函数是否标准，但是就实现情况来看，放心用应该是没有问题的。另外，在APUE(Unix环境高级编程)中推荐的进程终止方式不是通过我们习惯的常用的return方式，而是用exit函数结束的方式。这点倒是和《windows核心编程》的作者对于在windows下进程退出的方式有出入，在这本书中作者说进程最佳的退出方式就是return.

具体的原因我也不太清楚，APUE中倒是有一些描述，但是看了很久了，现在忘了，《windows核心编程》作者对于推荐使用return的描述主要是和windows中的[TerminateProcess](<ms-help://MS.MSDNQTR.v80.chs/MS.MSDN.v80/MS.WINCE.v50.en/wcecoreos5/html/wce50lrfterminateprocess.htm>)，ExitProcess等API作为对比的，没有提及exit.

