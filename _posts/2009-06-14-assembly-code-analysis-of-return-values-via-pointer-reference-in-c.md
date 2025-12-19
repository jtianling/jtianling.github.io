---
layout: post
title: C++中通过指针,引用方式做返回值的汇编代码分析
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
  views: '7'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文通过汇编分析，解释了C++指针解引用操作的底层原理，即通过寄存器和内存寻址实现。

<!-- more -->



源代码因为是《加密与解密》（第3版）一书中的代码，我就不贴了，不然好像是侵犯版权吧。见书中79面。

基本原理可以讲讲，其实就是一个max(int*,int*)的函数，将大的值放入第一个参数返回，原书可能是在debug下编译的版本，我是在release下编译的，反汇编结果如下：

```asm
.text:00401040 ; void __cdecl max(int *, int *)

.text:00401040 void __cdecl max(int *, int *) proc near ; CODE XREF: _main+1Dp

.text:00401040

.text:00401040 arg_0 = dword ptr 4

.text:00401040 arg_4 = dword ptr 8

.text:00401040

.text:00401040 000 mov eax, [esp+arg_4]

.text:00401044 000 mov ecx, [esp+arg_0]

.text:00401048 000 mov eax, [eax] ; 相当于C语言中的dereference操作

.text:0040104A 000 mov edx, [ecx]

.text:0040104C 000 cmp edx, eax ; Compare Two Operands

.text:0040104E 000 jge short locret_401052 ; Jump if Greater or Equal (SF=OF)

.text:00401050 000 mov [ecx], eax ; 假如dex>=eax（a>=b)直接跳到locret_401052返回，即不变

.text:00401050 ; 假如dex****

.text:00401050 ; 此处相当于*ecx = eax，：）注释扭曲了

.text:00401052

.text:00401052 locret_401052: ; CODE XREF: max(int *,int *)+Ej

.text:00401052 000 retn ; Return Near from Procedure

.text:00401052 void __cdecl max(int *, int *) endp
```

这里唯一需要注意的就是这4句了，先将一个地址传入，eax/ecx，然后通过[eax]/[ecx]取值，就相当于dereference的操作，即相当于*操作符的作用。

```asm
mov eax, [esp+arg_4]
mov ecx, [esp+arg_0]
mov eax, [eax]
mov edx, [ecx]
```

