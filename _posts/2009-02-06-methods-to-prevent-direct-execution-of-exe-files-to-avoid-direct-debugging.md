---
layout: post
title: "让EXE文件不能直接启动的方法以防止直接调试的方法"
categories:
- "未分类"
tags: []
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

通过破坏EXE代码使其无法直接运行，再由启动器在运行时修复代码，这是一种简单的反调试技术，可防止程序被直接调试。

<!-- more -->

# 让EXE文件不能直接启动的方法以防止直接调试的方法

[**write by****九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)****

[**讨论新闻组及文件**](<ttp://groups.google.com/group/jiutianfile/>)

游戏中经常需要这样的技术，即让游戏主程序不能直接启动，通过这样的方式，可以在一定程序上达到防止调试的目的，虽然仅仅是最最简单的防止，但是仍然有一定的作用。

这里讲讲这样的技术。。。。。其实研究甚浅。。。。

基本思路有两种，其一就是直接破坏PE头，那么此文件根本无法加载，自然更没有办法加载了。但是我们自己必须的完全模拟系统加载PE文件的过程，代价有点大。所以，虽然此方案更好，但是我没有深入的研究。其二就是仅仅破坏一段有效的代码，只要你在程序必须执行的地方插入了一堆无效数据，程序自然一运行就崩溃。目的达到了。

这里从破坏《[从最简单的Win32汇编程序，HelloWorld说起](<http://www.jtianling.com/archive/2009/01/26/3853487.aspx>)》文中介绍的一个最简单的程序开始。

原程序源代码：

```asm
**.486**                          ; create 32 bit code  
**.model**  flat, **stdcall**               ; 32 bit memory model  
**option**  casemap :none               ; case sensitive

**include**  windows.inc  
**include**  masm32.inc  
**include**  user32.inc  
**include**  kernel32.inc

**includelib**  masm32.lib  
**includelib**  user32.lib  
**includelib**  kernel32.lib

**.data**  
    szCaption **db**  "A MessageBox !",0  
    szText **db**  "Hello,World !",0

**.code**

start:  
    **invoke**  MessageBox,NULL,**offset**  szText,/  
            **offset**  szCaption,MB_OK  
    **invoke**  ExitProcess,NULL

**end**  start
```

反汇编的代码：

```asm
00401000 >/$  6A 00         PUSH    0                                ; /Style = MB_OK|MB_APPLMODAL

00401002  |.  68 00304000   PUSH    helloWor.00403000                ; |Title = "A MessageBox !"

00401007  |.  68 0F304000   PUSH    helloWor.0040300F                ; |Text = "Hello,World !"

0040100C  |.  6A 00         PUSH    0                                ; |hOwner = NULL

0040100E  |.  E8 07000000   CALL    <JMP.&user32.MessageBoxA>        ; /MessageBoxA

00401013  |.  6A 00         PUSH    0                                ; /ExitCode = 0

00401015  /.  E8 06000000   CALL    <JMP.&kernel32.ExitProcess>      ; /ExitProcess

0040101A   $- FF25 08204000 JMP     NEAR DWORD PTR [<&user32.Message>;  user32.MessageBoxA

00401020   .- FF25 00204000 JMP     NEAR DWORD PTR [<&kernel32.ExitP>;  kernel32.ExitProcess
```

这里我将其前一个字节改为55，那么其前三句将会解析成如下形式：

```asm
00401000 >/$  55            PUSH    EBP                               ; |Title = ""

00401001  |.  0068 00       ADD     BYTE PTR [EAX], CH                ; |

00401004  |.  3040 00       XOR     BYTE PTR [EAX], AL                ; |
```

这是再运行这个程序必然是崩溃的。这里必须要我们自己的程序去修复它，然后再运行它才能运行成功，这里以一个字节的修改为例，其实实际中你愿意改多少，改多少段完全是由你自己决定的。

启动程序基本思路及过程如下，首先用CreateProcess启动刚才修改过的应用程序，但是将其挂起，然后用VirtualProctectEx函数将挂起的进程需要修改的代码段属性设为可写，然后再用WriteProcessMemroy函数将正确的结果写入，然后再通过ResumeThread将挂起的进程运行。这时，就可以通过你的启动程序去启动被破坏的程序了，而正常情况下，被破坏的程序只能是由你的启动程序来启动。

全部启动源代码如下：

```c
 1 #include <windows.h>  
 2 #include <tchar.h>  
 3   
 4   
 5 **int**  main(**int**  argc, **char** * argv[])  
 6 {  
 7     STARTUPINFO si;  
 8     PROCESS_INFORMATION pi;  
 9     LPTSTR szCmdline=_tcsdup(TEXT("HelloWorld2"));  
10     
11     ZeroMemory( &si, **sizeof**(si) );  
12     si.cb = **sizeof**(si);  
13     ZeroMemory( &pi, **sizeof**(pi) );  
14     
15     // Start the child process.   
16     **if**( !CreateProcess( NULL,   // No module name (use command line)  
17         szCmdline,      // Command line  
18         NULL,           // Process handle not inheritable  
19         NULL,           // Thread handle not inheritable  
20         FALSE,          // Set handle inheritance to FALSE  
21         CREATE_SUSPENDED,              // Suspended the process, the key!  
22         NULL,           // Use parent's environment block  
23         NULL,           // Use parent's starting directory   
24         &si,            // Pointer to STARTUPINFO structure  
25         &pi )           // Pointer to PROCESS_INFORMATION structure  
26         )   
27     {  
28         printf( "CreateProcess failed (%d)./n", GetLastError() );  
29         **return**  -1;  
30     }  
31     
32     DWORD ldwOldPro = 0;  
33     **if**(!VirtualProtectEx(pi.hProcess, (**void** *)0x401000, 1, PAGE_EXECUTE_READWRITE, &ldwOldPro))  
34     {  
35         printf( "VirtualProtectEx failed (%d)./n", GetLastError() );  
36         TerminateProcess(pi.hProcess, -1);  
37         // Close process and thread handles.   
38         CloseHandle( pi.hProcess );  
39         CloseHandle( pi.hThread );  
40         **return**  -1;  
41     }  
42     
43     DWORD ldwWritten = 0;  
44     BYTE lbt = 0x6A;  
45     **if**(!WriteProcessMemory(pi.hProcess, (**void** *)0x401000, &lbt, 1, &ldwWritten))  
46     {  
47         printf( "WriteProcessMemory failed (%d)./n", GetLastError() );  
48         TerminateProcess(pi.hProcess, -1);  
49         // Close process and thread handles.   
50         CloseHandle( pi.hProcess );  
51         CloseHandle( pi.hThread );  
52         **return**  -1;  
53     }  
54     
55     **if**(!VirtualProtectEx(pi.hProcess, (**void** *)0x401000, 1, ldwOldPro, &ldwOldPro))  
56     {  
57         printf( "VirtualProtectEx failed (%d)./n", GetLastError() );  
58         TerminateProcess(pi.hProcess, -1);  
59         // Close process and thread handles.   
60         CloseHandle( pi.hProcess );  
61         CloseHandle( pi.hThread );  
62         **return**  -1;  
63     }  
64     
65     **if**(-1==ResumeThread(pi.hThread))  
66     {  
67         printf( "ResumeThread failed (%d)./n", GetLastError() );  
68         TerminateProcess(pi.hProcess, -1);  
69         // Close process and thread handles.   
70         CloseHandle( pi.hProcess );  
71         CloseHandle( pi.hThread );  
72         **return**  -1;  
73     }  
74   
75   
76   
77     // Wait until child process exits.  
78     WaitForSingleObject( pi.hProcess, INFINITE );  
79   
80     // Close process and thread handles.   
81     CloseHandle( pi.hProcess );  
82     CloseHandle( pi.hThread );  
83   
84     
85     **return**  0;  
86 }
```

再次说明，这里仅仅是示例，所以仅仅修改了一个字节，假如你改动字节比较多的话，直接通过OD或者SoftIce来调试你的应用程序就没有办法了，当然，假如你的启动程序没有任何防护，是可以先调试你的启动程序的。

但是方法有个完全的破坏方法，那就是Dump。

Dump方法：

因为此例实在是太过于简单，所以在程序运行后，也就是弹出对话框后，再调用LordPE载入进程Dump也完全可以，但是在实际中，可能因为程序在启动时修改该了一些全局的数据，此时Dump会有问题。

正确的Dump步骤应该是在程序恢复运行的一瞬间，也就是将要启动却还未启动的时候。以前在一个程序将要启动却还未启动时Dump有个小技巧，那就是将其前一个字节修改为0xCC,那么，启动的一瞬间就会出现调试中断，然后将OD等调试工具设为默认调试工具，就可以在此时中断进程，并进行Dump，但是在此例中比较特殊，因为第一个字节本来就是由程序写入的，所以你没有办法通过修改文件首字节的办法来完成工作：）而且就我注意到，目前所有可以Dump的程序（也许是我见得不多，[http://www.pediy.com/bbshtml/bbs7/pediy7-659-5.htm](<http://www.pediy.com/bbshtml/bbs7/pediy7-659-5.htm>)

一文中介绍的Dump工具我都用过）

都是先遍历进程，然后再Dump的，但是挂起还没有运行的进程它们竟然都检查不出来-_-!这点我很奇怪，我也不知道他们都是用什么来遍历进程的，但是windows的任务管理器就可以遍历出来（Windows的任务管理器其实相当的强悍，以前我做了一个进程占用CPU，内存资源百分比的监视工具，才知道要做好那么多任务不是那么简单的）。

呵呵，可以进行的办法是动态修改首字节，或者自己写一个给出进程ID就可以进行Dump的工具。。。。或者直接修改我比较习惯的LordPE的遍历进程方式，让其可以遍历出挂起的进程。。。。

这里我做个程序用于Dump上述程序。

此程序用于将指定进程ID的进程首字节动态改为CC以出现调试中断，并且将原有的首字节读取出来，并输出，以方便中断出现后，在OD中将其改为原有值，然后Dump。经测试，此方式的确可以做到Dump上述动态修改的挂起进程的目的：）

此程序也起到了很方便的作用：）

源代码如下：

```c
 1 #include "windows.h"  
 2 int main(int argc, char* argv[])  
 3 {  
 4     printf("Give me a Process ID: ");  
 5   
 6     DWORD ldwPid = 0;  
 7     scanf("%d", &ldwPid);  
 8   
 9     HANDLE lhPro = OpenProcess(PROCESS_VM_OPERATION | PROCESS_VM_WRITE | PROCESS_VM_READ,  
10         FALSE, ldwPid);  
11   
12     if(lhPro == NULL)  
13     {  
14         printf( "Error Process ID(%u) or OpenProcess failed (%d)./n",ldwPid, GetLastError() );  
15         return -1;  
16     }  
17   
18     DWORD ldwOldPro = 0;  
19     if(!VirtualProtectEx(lhPro, (void*)0x401000, 1, PAGE_EXECUTE_READWRITE, &ldwOldPro))  
20     {  
21         printf( "VirtualProtectEx failed (%d)./n", GetLastError() );  
22         CloseHandle( lhPro );  
23         return -1;  
24     }  
25   
26     DWORD ldwReaded = 0;  
27     BYTE lbtFirst = 0;  
28     if(!ReadProcessMemory(lhPro, (void*)0x401000, &lbtFirst, 1, &ldwReaded))  
29     {  
30         printf( "ReadProcessMemory failed (%d)./n", GetLastError() );  
31         CloseHandle( lhPro );  
32         return -1;  
33     }  
34   
35   
36     DWORD ldwWritten = 0;  
37     BYTE lbt = 0xcc;  
38     if(!WriteProcessMemory(lhPro, (void*)0x401000, &lbt, 1, &ldwWritten))  
39     {  
40         printf( "WriteProcessMemory failed (%d)./n", GetLastError() );  
41         CloseHandle( lhPro );  
42         return -1;  
43     }  
44   
45     printf( "First BYTE Changed to CC,and origin first BYTE is %X./n", lbtFirst);  
46   
47     if(!VirtualProtectEx(lhPro, (void*)0x401000, 1, ldwOldPro, &ldwOldPro))  
48     {  
49         printf( "VirtualProtectEx failed (%d)./n", GetLastError() );  
50         CloseHandle( lhPro );  
51         return -1;  
52     }  
53     // Close process handles.   
54     CloseHandle( lhPro );  
55   
56   
57     
58     return 0;  
59 }
```

因为此程序已经有一定的实用性，方便了目前不是太方便的动态修改头字节为CC以实现Dump动态修改并挂起的进程，为了方便不喜欢编译的兄弟，我将其编译后放到[**讨论新闻组及文件**](<ttp://groups.google.com/group/jiutianfile/>) ，名字为DynamicChangeFirstBYTE.exe

[**write by****九天雁翎****(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)
