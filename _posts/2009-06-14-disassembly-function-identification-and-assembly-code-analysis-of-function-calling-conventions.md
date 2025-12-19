---
layout: post
title: "反汇编时的函数识别及各函数调用约定的汇编代码分析"
categories:
- "汇编和反汇编"
tags:
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '17'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文通过反汇编实例，深入解析了C++的__cdecl、__stdcall、__fastcall等调用约定，阐明了参数传递与栈清理机制，助力逆向分析。

<!-- more -->



其实在刚开始工作的时候，我就因为工作中需要处理异常处理时的dump，就分析过C++的函数调用原理，也写过一篇文章，现在因为另外的原因（反外挂）而重新提起，回头看以前写的文章，实在是略显稚嫩：）也是，那是9个月前的事情了。

原文《C++函数调用原理理解》http://www.jtianling.com/archive/2008/06/01/2501238.aspx

首先看一个很简单的例子（此例子的更简单原型（一个add函数）来自于《加密与解密》一书第三版第4章的第2节），这里列举出了各种函数调用约定的ADD函数（其实还有PASCAL调用约定，但是作为C++程序员我忽略了那种，所以我提到的几种函数调用约定都是参数反向入栈的，此点再下面不再提起）这里的编译器选择了VC6，不是我喜欢仿古。。。但是，因为VS2005（我平时用的）的优化太过于激进。。。。不知道此词妥否。。。。起码一般的小测试程序几乎不能反汇编得到什么信息，一般就是直接在编译器完成了很多操作了。这个我在以前也提到过，

比如在《Inside C++ Object 》 阅读笔记(1)， NRV（Named Return Value）一文中：

http://www.jtianling.com/archive/2008/12/09/3486211.aspx

示例源代码1：

```cpp
1 **int** __cdecl Add1(**int** x,**int** y) // default  
2 {  
3  **return**(x+y);  
4 }  
5   
6 **int** __stdcall Add2(**int** x,**int** y)  
7 {  
8  **return**(x+y);  
9 }  
10   
11 **int** __fastcall Add3(**int** x,**int** y)  
12 {  
13  **return**(x+y);  
14 }  
15   
16 **int** **inline** Add4(**int** x,**int** y)  
17 {  
18  **return**(x+y);  
19 }  
20   
21 **int** main( )  
22 {  
23  **int** a=5,b=6;  
24  Add1(a,b);  
25  Add2(a,b);  
26  Add3(a,b);  
27  Add4(a,b);  
28  **return** 0;  
29  }  
```

Release编译后，反汇编代码及其注释如下：

```plaintext
.text:00401030 ; main函数

.text:00401030

.text:00401030 ; int __cdecl main(int argc, const char **argv, const char *envp)

.text:00401030 _main proc near ; CODE XREF: _mainCRTStartup+AFp

.text:00401030 push 6

.text:00401032 push 5

.text:00401034 call Add1 ; 将参数压入栈中，并调用Add1（__cdecl调用约定函数，

.text:00401034 ; 即C语言的调用规范，调用者负责栈的维护）

.text:00401039 add esp, 8 ; 此处由调用者维护调用了Add1后的栈，

.text:00401039 ; esp加8是因为两个参数

.text:0040103C push 6

.text:0040103E push 5

.text:00401040 call Add2 ; 参数入栈，并调用Add2（__stdcall调用规范，windows

.text:00401040 ; API的默认调用规范，由被调用者负责维护栈）所以

.text:00401040 ; 此函数调用完后，main函数中不需要有维护栈的操作

.text:00401045 mov edx, 6

.text:0040104A mov ecx, 5

.text:0040104F call Add3 ; 将参数赋值给寄存器edx,ecx，调用Add3(Fastcall调用约定，

.text:0040104F ; 函数尽量通过寄存器传递，也是由被调用者自己维护栈）

.text:00401054 xor eax, eax ; 此处清空eax作为main函数的返回值返回了，注意到并没有

.text:00401054 ; Add4（inline函数）的调用，并且因为返回值并没有用，

.text:00401054 ; 所以此函数即使在VC6中，也忽略了。

.text:00401056 retn

.text:00401056 _main endp
```

例2，稍微复杂一点

源码：

```cpp
1 #include <iostream>
2   
3 **int** __cdecl Add1(**int** x,**int** y) // default  
4 {  
5  **int** z = 1;  
6  **return**(x+y+z);  
7 }  
8   
9 **int** __stdcall Add2(**int** x,**int** y)  
10 {  
11  **int** z = 1;  
12  **return**(x+y+z);  
13 }  
14   
15 **int** __fastcall Add3(**int** x,**int** y)  
16 {  
17  **int** z = 1;  
18  **return**(x+y+z);  
19 }  
20   
21 **int** **inline** Add4(**int** x,**int** y)  
22 {  
23  **int** z = 1;  
24  **return**(x+y+z);  
25 }  
26   
27 **int** main( )  
28 {  
29  **int** a=5,b=6;  
30  **int** c = 0;  
31   
32  c += Add1(a,b);  
33  c += Add2(a,b);  
34  c += Add3(a,b);  
35  c += Add4(a,b);  
36  printf("%d",c);  
37  **return** 0;  
38  }  
39  
```

比前面的例子多了一个变量c来累加返回值并输出，每个函数中再多了一个局部变量。

Release编译后，反汇编代码及其注释如下：

```plaintext
.text:00401030 ; main函数

.text:00401030

.text:00401030 ; int __cdecl main(int argc, const char **argv, const char *envp)

.text:00401030 _main proc near ; CODE XREF: _mainCRTStartup+AFp

.text:00401030

.text:00401030 argc = dword ptr 4

.text:00401030 argv = dword ptr 8

.text:00401030 envp = dword ptr 0Ch

.text:00401030

.text:00401030 push esi ; 以下可以看到，esi后来一直用作局部变量c，

.text:00401030 ; 所以此处先保存以前的值

.text:00401031 push 6

.text:00401033 push 5

.text:00401035 call Add1

.text:0040103A add esp, 8

.text:0040103D mov esi, eax ; 默认约定eax是返回值，无论哪种调用约定都是一样的，

.text:0040103D ; 并且因为C/C++函数肯定只能由一个返回值，所以确定

.text:0040103D ; 是eax这一个寄存器也没有关系

.text:0040103F push 6

.text:00401041 push 5

.text:00401043 call Add2

.text:00401048 mov edx, 6

.text:0040104D mov ecx, 5

.text:00401052 add esi, eax

.text:00401054 call Add3

.text:00401059 lea eax, [esi+eax+0Ch] ; 内联的作用，Add4还是没有函数调用，并且用一个lea指令

.text:00401059 ; 实现了c+Add3（）+5+6的操作，其中5+6的值在编译器确定

.text:0040105D push eax

.text:0040105E push offset aD ; "%d"

.text:00401063 call _printf

.text:00401068 add esp, 8 ; 可见C语言库函数的调用遵循的是__cdecl约定，所以此处

.text:00401068 ; 由main函数维护栈

.text:0040106B xor eax, eax

.text:0040106D pop esi

.text:0040106E retn

.text:0040106E _main endp
```

与前一个例子重复的内容我注释也就不重复了。

一下具体看看各个Add函数的内容

```plaintext
.text:00401000 Add1 proc near ; CODE XREF: _main+5p

.text:00401000

.text:00401000 arg_0 = dword ptr 4

.text:00401000 arg_4 = dword ptr 8

.text:00401000

.text:00401000 mov eax, [esp+arg_4] ; 因为函数是如此的简单，所以此处并没有将ebp入栈，也

.text:00401000 ; 并没有通过堆栈为z局部变量开辟空间，而是直接用esp

.text:00401000 ; 取参数，用lea指令来完成+1，以下几个函数相同

.text:00401004 mov ecx, [esp+arg_0]

.text:00401008 lea eax, [ecx+eax+1]

.text:0040100C retn ; 这里可以看到Add1函数并没有在内部维护栈，原因也说了

.text:0040100C Add1 endp ; __cdecl调用约定是由调用者来维护栈的

.text:0040100C

.text:0040100C ; ---------------------------------------------------------------------------

.text:0040100D align 10h

.text:00401010

.text:00401010 ; =============== S U B R O U T I N E =======================================

.text:00401010

.text:00401010

.text:00401010 Add2 proc near ; CODE XREF: _main+13p

.text:00401010

.text:00401010 arg_0 = dword ptr 4

.text:00401010 arg_4 = dword ptr 8

.text:00401010

.text:00401010 mov eax, [esp+arg_4]

.text:00401014 mov ecx, [esp+arg_0]

.text:00401018 lea eax, [ecx+eax+1]

.text:0040101C retn 8 ; 此处可以看到Add2自己维护了栈，retn 8相当于

.text:0040101C Add2 endp ; add esp 8

.text:0040101C ; retn

.text:0040101C ; ---------------------------------------------------------------------------

.text:0040101F align 10h

.text:00401020

.text:00401020 ; =============== S U B R O U T I N E =======================================

.text:00401020

.text:00401020

.text:00401020 Add3 proc near ; CODE XREF: _main+24p

.text:00401020 lea eax, [ecx+edx+1] ; 通过寄存器来传递参数，速度自然快，也不破坏栈，所以

.text:00401020 ; 也不用维护，此处的参数较少，所以可以达到完全不用

.text:00401020 ; 栈操作

.text:00401024 retn

.text:00401024 Add3 endp
```

至此，完全没有源码，看到一个函数的调用，大概也知道参数是什么，返回值是什么，栈维护的操作是在干什么了。

这里再看两个复杂点的例子，一个是局部变量多一点的Add5,一个是参数多一点的fastcall调用的函数Add6

```cpp
1 #include <iostream>
2   
3 **int** __cdecl Add5(**int** x,**int** y) // default  
4 {  
5  **int** z1 = 1;  
6  **int** z2 = ++z1;  
7  **int** z3 = ++z2;  
8  **return**(x+y+z1+z2+z3);  
9 }  
10   
11 **int** __fastcall Add6(**int** x,**int** y,**int** z)  
12 {  
13  **return**(x+y+z);  
14 }  
15   
16   
17 **int** main( )  
18 {  
19  **int** a=5,b=6;  
20  **int** c = 0;  
21   
22  c += Add5(a,b);  
23  c += Add6(a,b,c);  
24   
25  printf("%d",c);  
26  **return** 0;  
27  }
```

反汇编：

```plaintext
.text:00401020 ; int __cdecl main(int argc, const char **argv, const char *envp)

.text:00401020 _main proc near ; CODE XREF: _mainCRTStartup+AFp

.text:00401020

.text:00401020 argc = dword ptr 4

.text:00401020 argv = dword ptr 8

.text:00401020 envp = dword ptr 0Ch

.text:00401020

.text:00401020 push esi

.text:00401021 push 6

.text:00401023 push 5

.text:00401025 call Add5

.text:0040102A add esp, 8

.text:0040102D mov esi, eax ; 保存第3个参数（即Add5的返回值）到esi

.text:0040102F mov edx, 6

.text:00401034 mov ecx, 5

.text:00401039 push esi ; 虽然时fastcall,但是edx,ecx不够用的时候，还是使用了栈

.text:0040103A call Add6

.text:0040103F add esi, eax

.text:00401041 push esi

.text:00401042 push offset aD ; "%d"

.text:00401047 call _printf

.text:0040104C add esp, 8

.text:0040104F xor eax, eax

.text:00401051 pop esi

.text:00401052 retn

.text:00401052 _main endp
```

Add函数：

```plaintext
.text:00401000 ; =============== S U B R O U T I N E =======================================

.text:00401000

.text:00401000

.text:00401000 Add5 proc near ; CODE XREF: _main+5p

.text:00401000

.text:00401000 arg_0 = dword ptr 4

.text:00401000 arg_4 = dword ptr 8

.text:00401000

.text:00401000 mov eax, [esp+arg_4]

.text:00401004 mov ecx, [esp+arg_0]

.text:00401008 lea eax, [ecx+eax+8] ; 虽然我尽量做了很多无用的操作，但是连VC6都要把这些

.text:00401008 ; 操作优化掉

.text:0040100C retn

.text:0040100C Add5 endp

.text:0040100C

.text:0040100C ; ---------------------------------------------------------------------------

.text:0040100D align 10h

.text:00401010

.text:00401010 ; =============== S U B R O U T I N E =======================================

.text:00401010

.text:00401010

.text:00401010 Add6 proc near ; CODE XREF: _main+1Ap

.text:00401010

.text:00401010 arg_0 = dword ptr 4

.text:00401010

.text:00401010 lea eax, [ecx+edx]

.text:00401013 mov ecx, [esp+arg_0] ; fastcall在VC中只会使用ecx,edx两个寄存器来传递参数，

.text:00401013 ; 当参数超过2个时，还是得通过栈来传递

.text:00401017 add eax, ecx

.text:00401019 retn 4

.text:00401019 Add6 endp

.text:00401019

.text:00401019 ; ---------------------------------------------------------------------------
```

