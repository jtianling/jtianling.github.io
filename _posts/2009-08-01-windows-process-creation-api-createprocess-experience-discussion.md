---
layout: post
title: Windows下的进程创建API--CreateProcess使用经验漫谈
categories:
- C++
tags:
- CreateProcess
- Windows
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

分享Windows下CreateProcess API的使用经验，讲解句柄管理、进程关系、错误模式等关键点，帮助开发者避开常见陷阱，掌握高级用法。

<!-- more -->

# Windows下的进程创建API--CreateProcess使用经验漫谈



在Windows下工作久了，虽然不想多么深入的去了解它，但是实际还是多少懂了一点。这里说说问题比较多用的也非常多的一个API，CreateProcess,这里不准备举太多例子了，《Windows核心编程》和MSDN上讲的都比较详细了，这里只谈谈使用的经验。

基本的应用上，这里用MSDN的一个例子讲解：

```c
#include <windows.h>
#include <stdio.h>
#include <tchar.h>

void _tmain( VOID )
{
    STARTUPINFO si;
    PROCESS_INFORMATION pi;
    LPTSTR szCmdline=_tcsdup(TEXT("MyChildProcess"));

    ZeroMemory( &si, sizeof(si) );
    si.cb = sizeof(si);
    ZeroMemory( &pi, sizeof(pi) );

    // Start the child process. 
    if( !CreateProcess( NULL,   // No module name (use command line)
       szCmdline,      // Command line
       NULL,           // Process handle not inheritable
       NULL,           // Thread handle not inheritable
       FALSE,          // Set handle inheritance to FALSE
       0,              // No creation flags
       NULL,           // Use parent's environment block
       NULL,           // Use parent's starting directory 
       &si,            // Pointer to STARTUPINFO structure
       &pi )           // Pointer to PROCESS_INFORMATION structure
       ) 
    {
       printf( "CreateProcess failed (%d)./n", GetLastError() );
       return;
    }

    // Wait until child process exits.
    WaitForSingleObject( pi.hProcess, INFINITE );

    // Close process and thread handles. 
    CloseHandle( pi.hProcess );
    CloseHandle( pi.hThread );
}
```

1.LPTSTR szCmdline；一句很重要，而且是必须得有的，这里需要注意，因为CreateProcess的第二参数是一个非const字符串，这点比较意外，因为事实上，我也没有看到MS改动过此字符串，从理论上来讲，改动commandline也是很让人惊讶的事情。

2. CloseHandle( pi.hProcess );

    CloseHandle( pi.hThread );

后，子进程就与父进程彻底脱离关系了，在Windows下进程之间的关系比较弱，不仅没有父进程收割子进程退出状态这一回事，甚至连getppid这样的API也没有。这又导致了两个现象，

1.）Windows下不用当心Linux下的僵死进程问题。

2.）当失去句柄仅仅知道进程ID时，Windows下甚至无法判断此进程是否就是原有进程，（用OpenProcess打开的句柄无法判定是否就是原来的进程）假如此进程已经结束，也无法获取到进程的退出状态。（在Windows下获取进程退出状态必须得保留进程的句柄，然后调用GetExitCodeProcess）

3.现在一般的游戏都已经不允许直接运行了，这点的目的很简单，加大别人用反编译软件调试游戏主程序的难度。按照CreateProcess的默认参数的直接创建原游戏主程序时，会碰到一个问题，及当发生原程序发生缺少动态库等情况时，原有系统弹出的提示对话框会被调用CreateProcess的进程吞掉，使得这类错误被掩盖，因为此时CreateProcess返回值实际是成功的。这时候，将CreateProcess的参数Process Creation Flags设为CREATE_DEFAULT_ERROR_MODE就可以让原有的提示窗口弹出来。

4\. Process Creation Flags设为CREATE_SUSPENDED时，可以将欲创建进程挂起，这时想对新进程干啥都行，甚至可以尝试更改其代码段以影响程序运行，（但是大部分带监控的杀毒软件会有警告）。然后用ResumeThread API去让原进程的主线程运行起来。

5.CreateProcess创建的进程句柄实际代表的是一个Windows核心对象，适用于Windows核心对象的操作都可以对进程句柄进行，(核心对象的概念请参考《WIndows核心编程》,其中包括WaitForSingleObject等同步API。

