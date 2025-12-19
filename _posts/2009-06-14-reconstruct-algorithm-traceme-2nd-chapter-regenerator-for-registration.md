---
layout: post
title: "通过纯静态分析来还原算法，获取《加密与解密》第2章的TraceMe的注册机"
categories:
- "汇编和反汇编"
tags:
- "《加密与解密》"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '6'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文使用IDA Pro纯静态分析，逆向了《加密与解密》中的TraceMe程序，还原了其注册算法并用C语言编写了注册机。

<!-- more -->

# 通过纯静态分析来还原算法，获取《加密与解密》第2章的TraceMe的注册机

**write by 九天雁翎(JTianLing) -- www.jtianling.com**

其实原书有源代码，并且也介绍了一种通过内存断点来获取注册码的方法。但是这里我是为了检验今天看静态分析这一章的成果，纯粹靠IDA Pro静态分析不带调试信息Release版本，也不动态调试的方法来分析算法。并还原算法，写出注册机。这里并没有鼓励或提倡以此方式来分析程序的意思。呵呵，书中好像也鼓励大家试试写出一个注册机来，作为购买了正版书籍的读者，自然要响应作者号召了。

另外，我虽然最近老是发一些奇怪的文章，但是我只是个C++程序员，是以开发游戏为生的，最近研究这些东西并不是准备将来以此牟利，仅仅是为了学习，最近的工作是反外挂，所以才学习这些东西。这方面我是纯粹的新手，发点文章属于记录学习过程和个人爱好，有不对或者稚嫩的地方请高手指教。

这里仅仅只看我注释的片段，全部源代码即完整程序请去下载《加密与解密》（第3版）的配套光盘第2章部分，或者购买原书。

关键函数如下：调用环境其实可知lpString1为用户输入的key,lpString2为用户输入的用户名，aiLen为长度

```asm
.text:00401340 ; int __cdecl KeyGenAndCompare(LPCSTR lpString1, LPSTR lpString2, int aiLen)

.text:00401340 KeyGenAndCompare proc near ; CODE XREF: DialogFunc+115p

.text:00401340

.text:00401340 lpString1 = dword ptr 4

.text:00401340 lpString2 = dword ptr 8

.text:00401340 aiLen = dword ptr 0Ch

.text:00401340

.text:00401340 000 push ebp

.text:00401341 004 mov ebp, [esp+4+lpString2]

.text:00401345 004 push esi

.text:00401346 008 push edi

.text:00401347 00C mov edi, [esp+0Ch+aiLen] ; 总是通过esp来操作，有点混乱，其实就是将长度保存到edi

.text:0040134B 00C mov ecx, 3

.text:00401350 00C xor esi, esi ; 清空esi

.text:00401352 00C xor eax, eax ; 清空eax

.text:00401354 00C cmp edi, ecx ; Compare Two Operands

.text:00401356 00C jle short loc_401379 ; 判断当长度小于等于3时，不进行计算了，因为肯定是错的

.text:00401358 00C push ebx

.text:00401359

.text:00401359 KeyGenLoop: ; CODE XREF: KeyGenAndCompare+36j

.text:00401359 010 cmp eax, 7 ; three below: if ( eax > 7 ) eax = 0;

.text:0040135C 010 jle short loc_401360 ; Jump if Less or Equal (ZF=1 | SF!=OF)

.text:0040135E 010 xor eax, eax ; Logical Exclusive OR

.text:00401360

.text:00401360 loc_401360: ; CODE XREF: KeyGenAndCompare+1Cj

.text:00401360 010 xor edx, edx ; Logical Exclusive OR

.text:00401362 010 xor ebx, ebx ; Logical Exclusive OR

.text:00401364 010 mov dl, [ecx+ebp] ; 这里可以知道是从第3个元素才开始比较的

.text:00401367 010 mov bl, gacCode[eax] ; 这里用eax从0增长，等于7时清零来循环遍历一个数组

.text:0040136D 010 imul edx, ebx ; Signed Multiply

.text:00401370 010 add esi, edx ; Add

.text:00401372 010 inc ecx ; Increment by 1

.text:00401373 010 inc eax ; Increment by 1

.text:00401374 010 cmp ecx, edi ; Compare Two Operands

.text:00401376 010 jl short KeyGenLoop ; Jump if Less (SF!=OF)

.text:00401378 010 pop ebx

.text:00401379

.text:00401379 loc_401379: ; CODE XREF: KeyGenAndCompare+16j

.text:00401379 00C push esi

.text:0040137A 010 push offset aLd ; "%ld"

.text:0040137F 014 push ebp ; LPSTR

.text:00401380 018 call ds:wsprintfA ; Indirect Call Near Procedure

.text:00401386 018 mov eax, [esp+18h+lpString1]

.text:0040138A 018 add esp, 0Ch ; Add

.text:0040138D 00C push ebp ; lpString2

.text:0040138E 010 push eax ; lpString1

.text:0040138F 014 call ds:lstrcmpA ; Indirect Call Near Procedure

.text:00401395 00C neg eax ; Two's Complement Negation

.text:00401397 00C sbb eax, eax ; Integer Subtraction with Borrow

.text:00401399 00C pop edi

.text:0040139A 008 pop esi

.text:0040139B 004 inc eax ; Increment by 1

.text:0040139C 004 pop ebp

.text:0040139D 000 retn ; Return Near from Procedure

.text:0040139D KeyGenAndCompare endp
```

还原的算法源代码如下：

```c
1 #include   
2 #include   
3 **int** gacCode[] = {0x0c, 0x0A, 0x13, 0x9, 0x0c, 0x0b, 0x0a, 0x08};  
4   
5 **int** __cdecl KeyGen(**char** * lpName, **int** aiLen)  
6 {  
7  **int** liTemp = 0; // means esi  
8  **int** i = 3; //just because using VC6,know 3 from ecx == 3  
9  **int** j = 0;  
10  **for**(; i  
11  {  
12  **if**(j > 7)  
13  {  
14  j = 0;  
15  }  
16  liTemp += lpName[i] * gacCode[j];  
17  }  
18   
19  **return** liTemp;  
20 }  
21   
22   
23 **int** main()  
24 {  
25  **char** lszName[] = "abcdefg";  
26  **int** liKey = KeyGen(lszName, strlen(lszName));  
27   
28  printf("%i/n",liKey);  
29  **return** 0;  
30 }  
31  
```

**write by 九天雁翎(JTianLing) -- www.jtianling.com**
