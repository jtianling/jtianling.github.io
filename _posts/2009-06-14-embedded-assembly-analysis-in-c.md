---
layout: post
title: "在C++中内嵌汇编代码分析"
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
  views: '22'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文讲解C++内嵌汇编的使用，通过实例分析了不同调用约定下的汇编代码实现，并强调其为性能优化的利器，但需程序员手动管理栈和寄存器，风险较高。

<!-- more -->



用JAVA或者Python的人常常会告诉你，现在的硬件已经太快了，以至于你可以完全不再考虑性能，快速的开发才是最最重要的。这是个速食者的年代，什么都是，甚至是编程。

但是。。。。。。永远有但是，任何C/C++程序员在工作一段时间后都会发现，不关心性能的C/C++程序员是干不下去的。。。。。C语言的程序员犹甚，C++的程序员也许还可以光靠着MFC等类库混口饭吃。。。

C/C++程序员常常会发现自己只有有限的内存，要占用更小的CPU资源（或者仅仅只有速度非常有限的嵌入式CPU可用），但是却得完成非常复杂的任务，这时候能够利用的工具却非常有限。。。唯一可能有用的就是自己的大脑。。。呵呵，改进算法永远是最重要的，但是一个非常优秀的算法也没有办法满足要求的时候，你再剩下的东西可能就是无限的优化原有的C/C++代码，接着就是汇编了。

这里从内嵌汇编将起，然后讲讲用MASM独立编译，然后链接的方法，都以VS2005为例子，其他编译器请参考。

## 内嵌汇编：

内嵌汇编的使用是很简单并且方便的，在VS中以的形式就可以简单的使用。对于此语法我没有必要再多说了，各类资料都有介绍，可以参考参考《加密与解密》（第3版）附录2.这里想举几个的函数的调用例子来说明一下，因为在函数调用时需要特别注意调用的约定，各类调用约定有不同的规矩需要留意，因为一旦使用了汇编，出现问题没有东西可以保护你，唯一可以看到的就是程序崩溃。

对于各类调用约定也可以参考《加密与解密》（第3版），其中的分类还比较详细。

我在《 反汇编时的函数识别及各函数调用约定的汇编代码分析》，《 C++中通过指针,引用方式做返回值的汇编代码分析》中也有一些实例的分析，但是不能代替完整的说明，仅供参考。

http://www.jtianling.com/archive/2009/01/20/3844768.aspx
http://www.jtianling.com/archive/2009/01/20/3844520.aspx

以下形式就是最方便的内嵌汇编用法：

```cpp
__asm
{
 
}
```

例1：

```cpp
//  仅仅返回参数
int __cdecl GetArgument(int ai)
{
    int li = 0;
    __asm
    {
       mov eax, ai;
       mov li, eax
    }
    return li;
}
```

以上程序就是一个仅仅返回参数的函数，用__cdecl调用约定，需要注意的是，mov li, ai的形式是不允许的。。。。与在普通汇编中不允许从内存mov到内存的限制一致。

其实上面的例子中，程序可以优化为如下形式：

例2：

```cpp
//  仅仅返回参数
int __cdecl GetArgument(int ai)
{
    __asm
    {
       mov eax, ai
    }
}
```

在函数中没有指定返回值时，eax就是返回值了。。。这和普通的汇编代码一致。。。。顺便看看生成的代码：

```plaintext
    printf("%d/n",GetArgument(100));

0041142E  push        64h 
00411430  call        GetArgument (41100Ah) 
00411435  add         esp,4
```

足够人性化的，栈由编译器自动的平衡了，不需要我们额外操心，这是很愉快的事情。

再看例三：

```cpp
//  仅仅返回参数
int __stdcall GetArgument(int ai)
{
    __asm
    {
       mov eax, ai
    }
}
```

这次改成了__stdcall，那么编译器还会帮我们吗？答案还是肯定的。所以也可以放心用。

调用时：

```plaintext
0041142E  push        64h 
00411430  call        GetArgument (4111DBh) 
00411435  mov         esi,esp
```

原函数：

```cpp
//  仅仅返回参数
int __stdcall GetArgument(int ai)
{
004113C0  push        ebp 
004113C1  mov         ebp,esp 
004113C3  sub         esp,0C0h 
004113C9  push        ebx 
004113CA  push        esi 
004113CB  push        edi 
004113CC  lea         edi,[ebp-0C0h] 
004113D2  mov         ecx,30h 
004113D7  mov         eax,0CCCCCCCCh 
004113DC  rep stos    dword ptr es:[edi] 
       __asm
       {
              mov eax, ai
004113DE  mov         eax,dword ptr [ai] 
       }
}
004113E1  pop         edi 
004113E2  pop         esi 
004113E3  pop         ebx 
004113E4  add         esp,0C0h 
004113EA  cmp         ebp,esp 
004113EC  call        @ILT+330(__RTC_CheckEsp) (41114Fh) 
004113F1  mov         esp,ebp 
004113F3  pop         ebp 
004113F4  ret         4    
```

其实只关心外部调用者没有维持栈平衡，而函数内部最后的ret 4就够了，完全符合__stdcall的定义。

再接下来呢？thiscall?

```cpp
    int GetArgument(int ai)
    {
00411450  push        ebp 
00411451  mov         ebp,esp 
00411453  sub         esp,0CCh 
00411459  push        ebx 
0041145A  push        esi 
0041145B  push        edi 
0041145C  push        ecx 
0041145D  lea         edi,[ebp-0CCh] 
00411463  mov         ecx,33h 
00411468  mov         eax,0CCCCCCCCh 
0041146D  rep stos    dword ptr es:[edi] 
0041146F  pop         ecx 
00411470  mov         dword ptr [ebp-8],ecx 
       __asm
       {
           mov eax, ai
00411473  mov         eax,dword ptr [ai] 
           add eax, [ecx]
00411476  add         eax,dword ptr [ecx] 
       }
    }
00411478  pop         edi 
00411479  pop         esi 
0041147A  pop         ebx 
0041147B  add         esp,0CCh 
00411481  cmp         ebp,esp 
00411483  call        @ILT+330(__RTC_CheckEsp) (41114Fh) 
00411488  mov         esp,ebp 
0041148A  pop         ebp 
0041148B  ret         4 
```

最后的结果也是正确的，也符合ecx为this指针，并且函数内部维护栈的约定，这个例子也许得将测试程序也贴出来：

```cpp
int _tmain(int argc, _TCHAR* argv[])
{
    CTestThisCall lo(20);
    printf("%d/n",lo.GetArgument(10));

    system("PAUSE");

    return 0;
}
```

得出的结果是30，结果是正确的。

然后呢？fastcall?

见例4：

```cpp
int __fastcall GetArgument(int ai)
{
    __asm
    {
       mov eax, ecx
    }
}

int _tmain(int argc, _TCHAR* argv[])
{
    printf("%d/n",GetArgument(10));

    system("PAUSE");

    return 0;
}
```

结果也是正确的，fastcall的规则在VC中是已知的，但是在很多编译器中实现并不一样，所以很多书籍推荐最好不要使用fastcall来内嵌汇编，因为你不知道到底fastcall到底会使用哪些寄存器来传递参数。

MSDN中有如下描述：

In general, you should not assume that a register will have a given value when an **__asm** block begins. Register values are not guaranteed to be preserved across separate **__asm** blocks. If you end a block of inline code and begin another, you cannot rely on the registers in the second block to retain their values from the first block. An **__asm** block inherits whatever register values result from the normal flow of control.

If you use the **__fastcall** calling convention, the compiler passes function arguments in registers instead of on the stack. This can create problems in functions with **__asm** blocks because a function has no way to tell which parameter is in which register. If the function happens to receive a parameter in EAX and immediately stores something else in EAX, the original parameter is lost. In addition, you must preserve the ECX register in any function declared with **__fastcall**.

To avoid such register conflicts, don't use the **__fastcall** convention for functions that contain an **__asm** block. If you specify the **__fastcall** convention globally with the /Gr compiler option, declare every function containing an **__asm** block with **__cdecl** or **__stdcall**. (The **__cdecl** attribute tells the compiler to use the C calling convention for that function.) If you are not compiling with /Gr, avoid declaring the function with the **__fastcall** attribute.

在《加密与解密》中有适当的翻译。。。。我就不翻译了，应该能看懂吧。其实大意就是最好别用fastcall，原因主要是不知道哪个寄存器用来传递参数，假如一个函数中你需要使用ecx一定要记得将其还原。。。呵呵，这个道理很简单，因为一个参数的时候fastcall必定是由ecx来传递参数的。两个参数就是ecx,edx，起码在VS2005中是这样。虽然个人没有感觉用起来有多大的风险，但是文中甚至提及可能通过eax传递参数。。（应该是在优化的时候），所以假如真的用了fastcall，请看汇编代码确认一下，以防万一。

再见一个更详细的例5：

```cpp
int __fastcall GetArgument(int ai1, int ai2, int ai3)
{
    __asm
    {
       mov eax, ecx
       add eax, edx
       add eax, [ebp+8]
    }
}

int _tmain(int argc, _TCHAR* argv[])
{
    printf("%d/n",GetArgument(10, 20, 30));

    system("PAUSE");

    return 0;
}
```

反汇编：

```plaintext
       printf("%d/n",GetArgument(10, 20, 30));

00411ACE  push        1Eh 
00411AD0  mov         edx,14h 
00411AD5  mov         ecx,0Ah 
00411ADA  call        GetArgument (4111F4h)
```

```cpp
int __fastcall GetArgument(int ai1, int ai2, int ai3)
{
004130B0  push        ebp 
004130B1  mov         ebp,esp 
004130B3  sub         esp,0D8h 
004130B9  push        ebx 
004130BA  push        esi 
004130BB  push        edi 
004130BC  push        ecx 
004130BD  lea         edi,[ebp-0D8h] 
004130C3  mov         ecx,36h 
004130C8  mov         eax,0CCCCCCCCh 
004130CD  rep stos    dword ptr es:[edi] 
004130CF  pop         ecx 
004130D0  mov         dword ptr [ebp-14h],edx 
004130D3  mov         dword ptr [ebp-8],ecx 
       __asm
       {
              mov eax, ecx
004130D6  mov         eax,ecx 
              add eax, edx
004130D8  add         eax,edx 
              add eax, [ebp+8]
004130DA  add         eax,dword ptr [ai3] 
       }
}
004130DD  pop         edi 
004130DE  pop         esi 
004130DF  pop         ebx 
004130E0  add         esp,0D8h 
004130E6  cmp         ebp,esp 
004130E8  call        @ILT+330(__RTC_CheckEsp) (41114Fh) 
004130ED  mov         esp,ebp 
004130EF  pop         ebp 
004130F0  ret         4    
```

说实话，ebp+8的计算我原来是搞错了，我当时直接用了esp+8，但是后来才发现在debug没有优化的时候，此处是会采用先保存esp,然后再用ebp的标准用法的。这里没有任何可健壮和移植性可言，仅仅是为了说明thiscall其实也是有规则并且符合约定的，比如上述程序在VS2005最大速度优化时也能正确运行，反汇编代码如下：

```cpp
int _tmain(int argc, _TCHAR* argv[])
{
       printf("%d/n",GetArgument(10, 20, 30));
00401010  mov         edx,14h 
00401015  push        1Eh 
00401017  lea         ecx,[edx-0Ah] ;注意此处，是编译器相当强程序优化的 成果，用此句替代了mov ecx,0Ah，原因说白了就很简单，因为此句才3个字节，而用mov的需要5个字节。。。。。
0040101A  call        GetArgument (401000h) 
0040101F  push        eax 
00401020  push        offset string "%d/n" (4020F4h) 
00401025  call        dword ptr [__imp__printf (4020A4h)] 

       system("PAUSE");
0040102B  push        offset string "PAUSE" (4020F8h) 
00401030  call        dword ptr [__imp__system (40209Ch)] 
00401036  add         esp,0Ch 

       return 0;
00401039  xor         eax,eax 
}
```

```cpp
int __fastcall GetArgument(int ai1, int ai2, int ai3)
{
00401000 55               push        ebp 
00401001 8B EC            mov         ebp,esp 
       __asm
       {
              mov eax, ecx
00401003 8B C1            mov         eax,ecx 
              add eax, edx
00401005 03 C2            add         eax,edx 
              add eax, [ebp+8]
00401007 03 45 08         add         eax,dword ptr [ai3] 
       }
}
0040100A 5D               pop         ebp 
0040100B C2 04 00         ret         4   
```

最后，在VS2005中还有一个专门为内嵌汇编准备的函数调用方式，naked。。。裸露的调用方式？-_-!呵呵，其实应该表示是无保护的。

例6：

```cpp
int __declspec(naked) __stdcall GetArgument(int ai)
{
    __asm
    {
       mov eax, [esp+04H] 
       ret 4
    }
}

int _tmain(int argc, _TCHAR* argv[])
{
    printf("%d/n",GetArgument(10));

    system("PAUSE");

    return 0;
}
```

反汇编代码：

```cpp
int _tmain(int argc, _TCHAR* argv[])
{
    printf("%d/n",GetArgument(10));
00401010  push        0Ah 
00401012  call        GetArgument (401000h) 
00401017  push        eax 
00401018  push        offset string "%d/n" (4020F4h) 
0040101D  call        dword ptr [__imp__printf (4020A4h)] 

       system("PAUSE");
00401023  push        offset string "PAUSE" (4020F8h) 
00401028  call        dword ptr [__imp__system (40209Ch)] 
0040102E  add         esp,0Ch 

       return 0;
00401031  xor         eax,eax 
}
```

```cpp
int __declspec(naked) __stdcall GetArgument(int ai)
{
    __asm
    {
       mov eax, [esp+04H] 
00401000  mov         eax,dword ptr [esp+4] 
              ret 4
00401004  ret         4
    }
}
```

哈哈，在debug下naked函数都是如此简洁，因为我们对其有完完全全的控制，非常完全！以至于。。。在这里你想用mov eax,ai的形式都是不可以的。。。只能完全遵循普通汇编的规则来走。

但是无论此函数再怎么naked，VS也不是完全不管的，见下例7：

```cpp
int __declspec(naked) __cdecl GetArgument(int ai)
{
    __asm
    {
       mov eax, [esp+04H] 
       ret
    }
}

int _tmain(int argc, _TCHAR* argv[])
{
    printf("%d/n",GetArgument(10));

    system("PAUSE");

    return 0;
}
```

假如VS完全不管GetArgument函数，因为GetArgument函数内部无法维护栈平衡，那么程序崩溃是必然的，还好VS管理了这个问题：

```plaintext
    printf("%d/n",GetArgument(10));
00411ACE  push        0Ah 
00411AD0  call        GetArgument (4111FEh) 
00411AD5  add         esp,4
```

这里需要说明的是，当一个函数naked的时候，完全的指挥权都在程序员手中，包括栈的平衡，函数的返回都需要程序员来做，ret是必不可少的，这里想说明的是，一旦你使用了内嵌汇编，你就开始走在了悬崖边上，因为C++强健的编译时期类型检查完全帮助不了你，能够帮助你的仅仅是你的大脑和你对汇编的理解了。呵呵，既然是用汇编写代码，其实都没有反汇编的概念可言，源代码就在哪儿，看仔细了debug比什么都重要，ollydbg,softICE,windbg你爱用什么就用什么吧。

另外，当函数不是naked的时候，从理论上讲你也是可以在汇编中ret的，只不过，你冒的风险也更大了，因为VS好像还不够智能化，它无法预见你的ret,或者从设计上来讲，不是naked的时候你不应该自己处理ret的，所以，即使是你在内嵌汇编中已经有了ret，它还是会原封不动的用于函数返回的代码。。。。

见下例8：

```cpp
int __cdecl GetArgument(int ai)
{
    __asm
    {
       mov eax, ai
       mov esp,ebp
       pop ecx
       ret
    }
}

int _tmain(int argc, _TCHAR* argv[])
{
    printf("%d/n",GetArgument(10));

    system("PAUSE");

    return 0;
}
```

上例在VS2005中最大速度优化，内联选项为仅仅在有inline声明才内联时可以运行正确，见汇编代码：

```cpp
int _tmain(int argc, _TCHAR* argv[])
{
    printf("%d/n",GetArgument(10));
00401020  call        GetArgument (401000h) 
00401025  push        eax 
00401026  push        offset string "%d/n" (4020F4h) 
0040102B  call        dword ptr [__imp__printf (4020A4h)] 

       system("PAUSE");
00401031  push        offset string "PAUSE" (4020F8h) 
00401036  call        dword ptr [__imp__system (40209Ch)] 
0040103C  add         esp,0Ch 

       return 0;
0040103F  xor         eax,eax 
}
```

```cpp
int __cdecl GetArgument(int ai)
{
00401000  push        ebp 
00401001  mov         ebp,esp 
00401003  push        ecx 
00401004  mov         dword ptr [ai],0Ah 
       __asm
       {
              mov eax, ai
0040100B  mov         eax,dword ptr [ai] 
              mov esp,ebp
0040100E  mov         esp,ebp 
              pop ecx
00401010  pop         ecx 
              ret
00401011  ret              
       }
}
00401012  mov         esp,ebp 
00401014  pop         ebp 
00401015  ret        
```

当你在不应该ret的时候ret，带来的往往是灾难性的后果，所以此处你必须的预见（或者先反汇编看到）原程序会做的所有操作，并且完整的重复它们，不然你在一个非naked的函数中用ret，结果几乎肯定是程序的崩溃。无论如何，除非你有特殊原因，还是按规矩办事比较好。

其实这样的代码对于反汇编来说还挺有意思的：IDA中可以看到

```plaintext
.text:00401000                      ; ===========================================================================
.text:00401000
.text:00401000                      ; Segment type: Pure code
.text:00401000                      ; Segment permissions: Read/Execute
.text:00401000                      _text           segment para public 'CODE' use32
.text:00401000                                        assume cs:_text
.text:00401000                                      ;org 401000h
.text:00401000                                      assume es:nothing, ss:nothing, ds:_data, fs:nothing, gs:nothing
.text:00401000
.text:00401000                      ; =============== S U B R O U T I N E =======================================
.text:00401000
.text:00401000                      ; Attributes: bp-based frame
.text:00401000
.text:00401000                      GetArgument     proc near               ; CODE XREF: _mainp
.text:00401000
.text:00401000                      var_4           = dword ptr -4
.text:00401000
.text:00401000 55                                  push    ebp
.text:00401001 8B EC                               mov     ebp, esp
.text:00401003 51                                  push    ecx
.text:00401004 C7 45 FC 0A 00 00 00               mov     [ebp+var_4], 0Ah
.text:0040100B 8B 45 FC                            mov     eax, [ebp+var_4]
.text:0040100E 8B E5                              mov     esp, ebp
.text:00401010 59                                  pop     ecx
.text:00401011 C3                                  retn
.text:00401011                      GetArgument     endp
.text:00401011
.text:00401012                      ; ---------------------------------------------------------------------------
.text:00401012 8B E5                               mov     esp, ebp
.text:00401014 5D                                  pop     ebp
.text:00401015 C3                                  retn
```

多余的代码IDA人性的分割掉了，这在没有源代码的人那里过去了就过去了，要是真深究的话，可能还会以为因为花指令的影响导致代码反汇编错了。。。呵呵，不然也不会有3行代码无缘无故的被分割在那里，一看也不像数据段。。。。。

另外push ecx,pop ecx的处理也是编译器极端优化的一个例子，这里本来可以用sub,add修改esp的做法的，但是那样的话一条指令就是5个字节。。。这样的话才1个字节！真是极端的优化啊。。。。。

参考资料：

1.  MSDN
2.  《加密与解密》（第3版）附录2

