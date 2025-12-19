---
layout: post
title: "一天一个C Run-Time Library 函数(4)  abs _abs64"
categories:
- C++
- Linux
tags:
- abs
- C++
- _abs64
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '12'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文解析C/C++绝对值函数abs，对比了C和C++对不同类型的处理差异，并分析了其简单实现，指出该函数常被编译器内联优化。

<!-- more -->

## 一天一个C Run-Time Library 函数(4) abs _abs64


## msdn:

Calculate the absolute value.

---

```cpp
int abs(
   int _n_ ); long
abs(     long _n_ );   // C++ only double
abs(     double _n_ );   // C++ only long
double abs(    long double _n_ );   // C++ only float
abs(    float _n_ );   // C++ only __int64
_abs64(     __int64 _n_ );
```

这里要说明的是c++因为有重载的技术，所以都可以用abs来表示，而C语言里面实际还有labs函数，用来表示long类型的绝对值。

## 测试程序：

虽然MSDN都有example,但是对于这么简单的函数，就没有必要贴了。

## 说明：

功能很简单，也很实用的函数。以前学习c++的时候有用到过，可是实际上工作以后竟然一次也没有用过。

## 实现：

MS:

```c
int __cdecl abs (

        int number

        )

{

        return(
number>=0 ? number
: -number );

}
```

gcc:

```c
/* Return
the absolute value of I.  */

int

abs (int
i)

{

    return i
< 0 ? -i : i;

}
```

再次验证了一件事情，那就是gcc和MS的势不两立，（突然觉得把gcc与MS并称很奇怪，因为根本不是同一类的事物。。。。就以MS代指VC2005吧。。。）

这么一个简单的函数，实现方式上几乎没有选择，即便是同样的?:结构，MS选择了判断>=，gcc选择了判断<，再次发挥我BT的精神，决定看一下他们生成的汇编代码。为了公正，先都在VS2005看看生成的代码。

MS:

```asm
0041140E  cmp         dword ptr [number],0
00411412  jl          MSabs+2Fh (41141Fh)
00411414  mov         eax,dword ptr [number]
00411417  mov         dword ptr [ebp-0C4h],eax
0041141D  jmp         MSabs+3Ah (41142Ah)
0041141F  mov         ecx,dword ptr [number]
00411422  neg         ecx
00411424  mov         dword ptr [ebp-0C4h],ecx
0041142A  mov         eax,dword ptr [ebp-0C4h]
```

gcc:

```asm
004113BE  cmp         dword ptr [i],0
004113C2  jge         GCCabs+31h (4113D1h)
004113C4  mov         eax,dword ptr [i]
004113C7  neg         eax
004113C9  mov         dword ptr [ebp-0C4h],eax
004113CF  jmp         GCCabs+3Ah (4113DAh)
004113D1  mov         ecx,dword ptr [i]
004113D4  mov         dword ptr [ebp-0C4h],ecx
004113DA  mov         eax,dword ptr [ebp-0C4h]
```

DEBUG下才能看到老实的逐句解析的代码，Release下简单的abs函数调用都直接在编译期间就计算完了。说实话，即使在DEBUG版本中我看不出来两者有什么区别。两者在参数为正，或为负的时候都需要一次jmp。唯一也许有不同的可能就是neg eax的时候也许比neg ecx会快一点。（这还是个人猜想，因为毕竟eax是最常用也是CPU设计时提供最快操作的寄存器）

## 效率测试：

实在不想再测试效率了，对于这样简单的函数测试一百亿次也看不出什么东西。这也是我为什么去看汇编出来的东西。何况，release的时候还被优化了呢。。。

## 相关函数：

无

## 个人想法：

对于这样简单的函数想怎么用就怎么用吧。假如用的是纯C，那么可能需要注意64位的实现是由MS实现的，linux下没有。但是c99已经定义了新的long long类型的abs。用gcc的人就可以用这个，函数名为llabs。

用c++的话根本不需要操心类似的东西，也不需要关心到底使用labs,llabs还是其他，因为我们有重载。在libstdc++中abs(long)就调用glibc的labs来完成，而abs(long long)在libstdc++中也有实现。

另外，不知道为什么这里即便是C语言的实现MS,GCC也都没有用习惯的宏，因此在这里，c++的函数调用会比C语言的版本快一点，因为C++还有inline。

今天对我来说是周末，偷懒了：）其实这么一个简单的函数也没有太多好说的。想用就用吧。

