---
layout: post
title: C/C++与汇编的函数相互调用分析
categories:
- "汇编和反汇编"
tags:
- C++
- "汇编和反汇编"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '11'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

# C/C++与汇编的函数相互调用分析

[**write by****九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)****

[**讨论新闻组及 相关文件下载**](<http://groups.google.com/group/jiutianfile/>)****

昨天好好研究了一下内嵌汇编的情况。。。。。更进一步的，该是看看独立编译的汇编程序与C/C++互相调用的情况了。

呵呵，最近怎么好像老在搞这个，想当年学习的时候，一门心思的学C++，到现在老是在弄诸如怎么在C/C++中调用LUA函数，或者反过来，怎么C/C++中调用Python函数，或者反过来，今天又是怎么在C/C++中调用汇编的函数，或者反过来。。。。。。。。。。。。。呵呵，自从学习的语言越来越多，类似的情况碰到的也就越来越多了，但是，只懂一门语言就不能在合适的时候使用合适的语言来解决问题，并且看问题会带有狭隘的偏见，谁说的来着？毕竟无论是lua,python,asm都会有用的上的时候，我最近似乎老是喜欢说闲话。。。。这是某些哥们说的自己的见解，还是某些时候无聊的牢骚呢？谁知道呢，过年了嘛，还不让人多说几句话啊。。。。。。-_-!

首先来看

## C中调用汇编的函数

先添加一个汇编文件写的函数吧，在VS2005中对此有了明显的进步，因为就《加密与解密》一书描述，在2003中需要自己配置编译选项，但是在VS2005中很明显的，当你添加asm文件后，可以自己选定masm的编译规则，然后一切就由IDE把你做好了，这也算是IDE的一个好用的地方吧。。。。

非常不好的一点就是，VS2005中对于汇编没有任何语法高亮。。。。damnit!IDE怎么做的？就这点而言，其甚至不如一般的文本编辑工具！。。。又是废话了。。

因为是C，这个目前全世界可能是最具有可移植性的语言，所以问题要简单的多。但是。。。也不全是那么简单，先看看直觉的写法：

汇编代码：

```asm
PUBLIC GetArgument

.486                      ; create 32 bit code

.model flat       ; 32 bit memory model

;option casemap :none      ; case sensitive

_TEXT SEGMENT PUBLIC 'CODE'

GetArgument PROC

    MOV EAX, [ESP+4]

    RETN 

GetArgument ENDP

_TEXT ENDS

END
```

C语言代码：

```c
#include <stdio.h>
#include <windows.h>

int GetArgument(int);
int _tmain(int argc, _TCHAR* argv[])
{

    printf("%d/n",GetArgument(10));

    system("PAUSE");

    return 0;
}
```

声明是必不可少的，毕竟汇编没有头文件给你包含，不过多的话，可以考虑组织一个专门用于包含汇编函数实现的头文件。但是在编译时却不会通过。

```text
1>InlineAsm.obj : error LNK2001: 无法解析的外部符号_GetArgument
1>    D:/My Document/Visual Studio 2005/Projects/InlineAsm/Release/InlineAsm.exe : fatal error LNK1120: 1 个无法解析的外部命令
```

看到错误原因也知道是怎么回事了，C中的函数名被编译器处理时多了个前置的下划线，当然，这个问题好解决。

一种方式是改变汇编代码的函数，直接添加一个前置下划线就完了，一种方式是将其声明为C语言的方式，那么链接程序也知道正确的链接了。两种方式分别如下：

直接改变函数名：

```asm
PUBLIC _GetArgument

.486                      ; create 32 bit code

.model flat       ; 32 bit memory model

;option casemap :none      ; case sensitive

_TEXT SEGMENT PUBLIC 'CODE'

_GetArgument PROC

    MOV EAX, [ESP+4]

    RETN 

_GetArgument ENDP

_TEXT ENDS

END
```

改变.model声明：

```asm
PUBLIC GetArgument

.486                      ; create 32 bit code

.model flat,c       ; 32 bit memory model

;option casemap :none      ; case sensitive

_TEXT SEGMENT PUBLIC 'CODE'

GetArgument PROC

    MOV EAX, [ESP+4]

    RETN 

GetArgument ENDP

_TEXT ENDS

END
```

个人推荐第2种方式，因为看起来最舒服，将改变函数名的工作交给编译和链接程序吧。

假如是在C++中调用ASM函数的话，相对复杂一点,因为没有.model C++的生命方式。。。这个世界是不公平对待C和C++的。。。。呵呵，但是C++有完整的向C靠拢的机制，这就够了。

汇编代码不变，C++调用时用如下形式：

```cpp
#include <stdio.h>
#include <windows.h>

extern "C" int _cdecl GetArgument(int);
int _tmain(int argc, _TCHAR* argv[])
{

    printf("%d/n",GetArgument(10));

    system("PAUSE");

    return 0;
}
```

即将C++函数完整的声明为C语言的形式。。。。。但是我在MSDN中看到了.model起码有stdcall的声明方式，有这种声明方式为什么不用呢？呵呵，用一下。

将汇编语言的.model声明改成下面这样：

```asm
.model flat,c,stdcall       ; 32 bit memory model
```

C++中函数声明为下面这样：

extern "C" int __stdcall GetArgument(int);

结果却是链接错误：

1>    InlineAsm.obj : error LNK2001: 无法解析的外部符号_GetArgument@4

当我自以为声明一致时，却不知道发生了什么，假如是以前，我可能得一筹莫展。。。但是现在嘛。。。。既然知道obj文件其实也是可读的，那么，看看链接的时候出了什么问题，为什么汇编出来的obj文件中没有这个符号呢？可以在obj文件的最后一行看到答案：

原来汇编的代码声明stdcall后函数符号被解析成_GetArgument@0了，那不是表示没有参数吗？看来是我汇编写错了。

改成如下形式：

```asm
PUBLIC GetArgument

.486                      ; create 32 bit code

.model flat,c,stdcall       ; 32 bit memory model

;option casemap :none      ; case sensitive

_TEXT SEGMENT PUBLIC 'CODE'

GetArgument PROC x:DWORD

    MOV EAX, x

    RETN 4

GetArgument ENDP

_TEXT ENDS

END
```

然后再运行程序，崩溃。。。。。。

看看原因：

```asm
GetArgument PROC x:DWORD

00401030  push        ebp 
00401031  mov         ebp,esp 
    MOV EAX, x
00401033  mov         eax,dword ptr [x] 
    RETN 4
00401036  ret         4   
```

很明显汇编编译后自动加了push        ebp；mov         ebp,esp这两句来保护栈指针esp，问题是却没有自动生成还原的代码。。。那还不崩溃？典型的栈错误。可以用下面的方式修复

```asm
GetArgument PROC x:DWORD

    MOV EAX, x

    pop ebp

RETN 4
```

但是这样做个人感觉实在是太不优美了。。。。。。。奇怪的是编译器为什么要这样解析代码。。。。呵呵，即便你是用汇编。。。特别是伪汇编。。。你都会发现编译器在你的背后动了太多手脚，很多，是你根本不想要它去做的。这一点也可能是我汇编代码声明或写的有问题，导致编译器奇怪的处理了，有知道正确结果的高人请指点一下.

## 下面，在汇编中调用C/C++函数：

在此不分辨C和C++了，差别仅在于一个extern “C”而已，调用约定采用__stdcall其他请参考

汇编代码如下：

```asm
PUBLIC GetArgument2

.486                      ; create 32 bit code

.model flat,stdcall       ; 32 bit memory model

;option casemap :none      ; case sensitive

GetArgument PROTO  :DWORD   ; 函数声明

_TEXT SEGMENT PUBLIC 'CODE'

GetArgument2 PROC x:DWORD

    INVOKE GetArgument,x

    MOV EAX, x

    POP EBP

    RETN 4

GetArgument2 ENDP

_TEXT ENDS

END
```

C++代码：

```cpp
#include <stdio.h>
#include <windows.h>

extern "C" int __stdcall GetArgument(int ai)
{
    return ai;
}

extern "C" int __stdcall GetArgument2(int ai);

int _tmain(int argc, _TCHAR* argv[])
{

    printf("%d/n",GetArgument2(10));

    system("PAUSE");

    return 0;
}
```

至此，你会高兴的发现，一个10，从C++中调用汇编的函数GetArgument2，再从汇编中调用C++的函数GetArgument再返回，得到正确结果。。。真不容易啊。。。这例子举得真够折腾的：）呵呵，说明问题就好了。最重要的一句就在于GetArgument PROTO  :DWORD    ; 函数声明

一行，另外，这一行应该在.model声明以后，不然编译器不知道你该采用那种调用约定和名字编码方式。

参考资料：MSDN

[**write by****九天雁翎****(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)