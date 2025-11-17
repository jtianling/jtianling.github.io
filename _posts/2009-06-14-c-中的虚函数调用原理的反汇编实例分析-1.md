---
layout: post
title: C++中的虚函数调用原理的反汇编实例分析(1)
categories:
- "汇编和反汇编"
tags:
- C++
- "虚函数"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '13'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

# C++中的虚函数调用原理的反汇编实例分析(1)

**write by****九天雁翎(JTianLing) -- www.jtianling.com**

具体的原理我并不想多讲，最好的办法是看《inside C++ Object》一书，我只是通过实际的反汇编代码来检验一下。。。。

其实仅仅是最近老在看反汇编的东西，这应该也属于逆向分析初步的知识吧，起码看到汇编代码能知道你看到的到底是什么

 

测试1：

```cpp
 1 #include <stdio.h>  
 2 #include <string.h>  
 3   
 4 **class**  CTestThisPointer  
 5 {  
 6 **public** :  
 7     CTestThisPointer(**int**  ai):mi(ai) { }  
 8     **virtual**  **int**  Add(**int**  ai)  
 9     {  
10         mi += ai;  
11         **return**  mi;  
12     }  
13      
14 **private** :  
15     **int**  mi;  
16 };  
17   
18   
19 **int**  main()  
20 {  
21     CTestThisPointer loTest(10);  
22   
23     printf("%d",loTest.Add(5));  
24     **return**  0;  
25 }  
26
```

VC6默认优化release编译

反汇编代码如下：

main函数

```asm
.text:00401000 ; Attributes: bp-based frame

.text:00401000

.text:00401000 ; int __cdecl main(int argc, const char **argv, const char *envp)

.text:00401000 _main           proc near               ; CODE XREF: _mainCRTStartup+AFp

.text:00401000

.text:00401000 var_8           = byte ptr -8

.text:00401000 argc            = dword ptr  8

.text:00401000 argv            = dword ptr  0Ch

.text:00401000 envp            = dword ptr  10h

.text:00401000

.text:00401000                 push    ebp

.text:00401001                 mov     ebp, esp

.text:00401003                 sub     esp, 8

.text:00401006                 push    0Ah

.text:00401008                 lea     ecx, [ebp+var_8]

.text:0040100B                 call    CTestThisPointer__CTestThisPointer

.text:00401010                 push    5

.text:00401012                 lea     ecx, [ebp+var_8]

.text:00401015                 call    CTestThisPointer__Add ; 呵呵，此处因为是通过对象访问的，所以其实根本没有用到

.text:00401015                                         ; 虚表，我疏忽了........

.text:0040101A                 push    eax

.text:0040101B                 push    offset aD       ; "%d"

.text:00401020                 call    _printf

.text:00401025                 add     esp, 8

.text:00401028                 xor     eax, eax

.text:0040102A                 mov     esp, ebp

.text:0040102C                 pop     ebp

.text:0040102D                 retn

.text:0040102D _main           endp
```

 

构造函数：

```asm
.text:00401030 CTestThisPointer__CTestThisPointer proc near ; CODE XREF: _main+Bp

.text:00401030

.text:00401030 this            = dword ptr -4

.text:00401030 arg_0           = dword ptr  8

.text:00401030

.text:00401030                 push    ebp

.text:00401031                 mov     ebp, esp

.text:00401033                 push    ecx

.text:00401034                 mov     [ebp+this], ecx ; 以下可以看到，此临时变量主要用于存储this指针，所以

.text:00401034                                         ; 我直接将其改名了

.text:00401037                 mov     eax, [ebp+this]

.text:0040103A                 mov     ecx, [ebp+arg_0]

.text:0040103D                 mov     [eax+4], ecx    ; 将构造函数的参数保存在this+4的位置上

.text:00401040                 mov     edx, [ebp+this]

.text:00401043                 mov     dword ptr [edx], offset const CTestThisPointer::`vftable' ;

.text:00401043                                         ; 此处可以看出在VC中虚表其实是放在一个类的最开始位置的，

.text:00401043                                          ; 这点的解释可以参考《inside C++ Ojbect》一书

.text:00401049                 mov     eax, [ebp+this] ; 此句用途不明，返回this?外部也没有使用此eax寄存器

.text:0040104C                 mov     esp, ebp

.text:0040104E                 pop     ebp

.text:0040104F                 retn    4               ; 可以看到在这里C++的函数默认是__stdcall调用约定的

.text:0040104F CTestThisPointer__CTestThisPointer endp
```

 

CTestThisPointer虚表所在位置只读代码段片段

```asm
.rdata:004070DC const CTestThisPointer::`vftable' db 60h,10h,40h,0
.rdata:004070DC                                ; DATA XREF: CTestThisPointer__CTestThisPointer+13o
.rdata:004070DC                                 ; 因为只有唯一的函数Add，此处是Add函数的地址，经检验
.rdata:004070DC                                 ; 401060的确是Add函数的地址
.rdata:004070DC                                 ; 有个疑问留待进行更多测试，那就是此虚表中没有运行时
.rdata:004070DC                                 ; 类型识别需要的标志(RTTI)，有两种可能，一是VC6没有
.rdata:004070DC                                 ; 实现此功能，二是因为此处不需要，所以优化掉了
```

 

Add函数：

```asm
.text:00401060 ; 可以看到此地址的确与虚表中的地址一致
.text:00401060 ; Attributes: bp-based frame
.text:00401060
.text:00401060 CTestThisPointer__Add proc near         ; CODE XREF: _main+15p
.text:00401060
.text:00401060 var_4           = dword ptr -4
.text:00401060 arg_0           = dword ptr  8
.text:00401060
.text:00401060                 push    ebp
.text:00401061                 mov     ebp, esp
.text:00401063                 push    ecx
.text:00401064                 mov     [ebp+var_4], ecx
.text:00401067                 mov     eax, [ebp+var_4]
.text:0040106A                 mov     ecx, [eax+4]
.text:0040106D                 add     ecx, [ebp+arg_0]
.text:00401070                 mov     edx, [ebp+var_4]
.text:00401073                 mov     [edx+4], ecx
.text:00401076                 mov     eax, [ebp+var_4]
.text:00401079                 mov     eax, [eax+4]
.text:0040107C                 mov     esp, ebp
.text:0040107E                 pop     ebp
.text:0040107F                 retn    4
.text:0040107F CTestThisPointer__Add endp
```

 

测试2：

```cpp
 1 #include <stdio.h>  
 2 #include <string.h>  
 3 #include <typeinfo.h>  
 4   
 5 **class**  CTestThisPointer  
 6 {  
 7 **public** :  
 8     CTestThisPointer(**int**  ai):mi(ai) { }  
 9     **virtual**  **int**  Add(**int**  ai)  
10     {  
11         mi += ai;  
12         **return**  mi;  
13     }  
14      
15 **private** :  
16     **int**  mi;  
17 };  
18   
19   
20 **int**  main()  
21 {  
22     CTestThisPointer loTest(10);  
23     CTestThisPointer *lp = &loTest;  
24   
25     printf("%d/n",lp->Add(5));  
26     // Test If VC6 implement RTTI  
27     printf("%s/n",**typeid**(lp).name());  
28     **return**  0;  
29 }  
30
```

 

反汇编：

主函数：

```asm
.text:00401000     ; int __cdecl main(int argc, const char **argv, const char *envp)
.text:00401000     _main   proc near                       ; CODE XREF: _mainCRTStartup+AFp
.text:00401000
.text:00401000     thisTemp2= dword ptr -0Ch
.text:00401000     thisTemp= byte ptr -8
.text:00401000     argc    = dword ptr  8
.text:00401000     argv    = dword ptr  0Ch
.text:00401000     envp    = dword ptr  10h
.text:00401000
.text:00401000 000         push    ebp
.text:00401001 004         mov     ebp, esp
.text:00401003 004         sub     esp, 0Ch                ; Integer Subtraction
.text:00401006 010         push    0Ah
.text:00401008 014         lea     ecx, [ebp+thisTemp]     ; Load Effective Address
.text:0040100B 014         call    CTestThisPointer__CTestThisPointer ; Call Procedure
.text:00401010 010         lea     eax, [ebp+thisTemp]     ; Load Effective Address
.text:00401013 010         mov     [ebp+thisTemp2], eax
.text:00401016 010         push    5
.text:00401018 014         mov     ecx, [ebp+thisTemp2]
.text:0040101B 014         mov     edx, [ecx]
.text:0040101D 014         mov     ecx, [ebp+thisTemp2]
.text:00401020 014         call    dword ptr [edx]         ; 直接调用了this指针所在位置的函数，即vtbl中唯一的函数
.text:00401020                                 ; Add，可能这也是将虚表放在整个C++对象第一个位置的原因
.text:00401020                                 ; 吧，因为这样虚函数的调用寻址最短
.text:00401022 010         push    eax
.text:00401023 014         push    offset aD               ; "%d/n"
.text:00401028 018         call    _printf                 ; Call Procedure
.text:0040102D 018         add     esp, 8                  ; Add
.text:00401030 010         mov     ecx, offset CTestThisPointer * `RTTI Type Descriptor' ; 数据段上编译器已经存在的type_info对象。。。。。
.text:00401035 010         call    type_info::name(void)   ; 此函数实现不深究了，不过咋一看就觉得效率奇低，竟然
.text:00401035                                 ; 还需要分配释放内存，malloc,free,strcpy.........晕掉了
.text:00401035                                 ; 主要实现功能的函数是系统_unDName
.text:0040103A 010         push    eax
.text:0040103B 014         push    offset aS_0             ; "%s/n"
.text:00401040 018         call    _printf                 ; Call Procedure
.text:00401045 018         add     esp, 8                  ; Add
.text:00401048 010         xor     eax, eax                ; Logical Exclusive OR
.text:0040104A 010         mov     esp, ebp
.text:0040104C 004         pop     ebp
.text:0040104D 000         retn                            ; Return Near from Procedure
.text:0040104D     _main   endp
```

 

其他内容没有变！这代表在VC6中RTTI的实现不是通过在虚表中加内容的方式实现的（《inside C++ Object》只提到这种实现方式），并且实际中分析代码，感觉是开始就为要识别类型的类加了一个特定的type_info类，然后主要是由__unDName这个系统函数实现了类型的鉴别。

而__unDName函数嘛，调用了

```asm
.text:004015A4 080         call    Replicator::Replicator(void) ; Call Procedure
.text:004015A9 080         lea     ecx, [ebp+var_3C]       ; Load Effective Address
.text:004015AC 080         call    Replicator::Replicator(void) ; Call Procedure
.text:004015B1 080         mov     eax, [ebp+arg_4]
.text:004015B4 080         lea     ecx, [ebp+var_78]       ; Load Effective Address
.text:004015B7 080         mov     char const * const UnDecorator::name, eax
.text:004015BC 080         mov     char const * const UnDecorator::gName, eax
.text:004015C1 080         mov     eax, [ebp+arg_8]
.text:004015C4 080         mov     char * (*UnDecorator::m_pGetParameter)(long), esi
.text:004015CA 080         mov     int UnDecorator::maxStringLength, eax
.text:004015CF 080         mov     eax, [ebp+arg_0]
.text:004015D2 080         mov     char * UnDecorator::outputString, eax
.text:004015D7 080         lea     eax, [ebp+var_3C]       ; Load Effective Address
.text:004015DA 080         mov     Replicator * UnDecorator::pZNameList, eax
.text:004015DF 080         lea     eax, [ebp+var_78]       ; Load Effective Address
.text:004015E2 080         mov     Replicator * UnDecorator::pArgList, eax
.text:004015E7 080         movzx   eax, [ebp+arg_14]       ; Move with Zero-Extend
.text:004015EB 080         mov     ulong UnDecorator::disableFlags, eax
.text:004015F0 080         call    UnDecorator::operator char *(void) ; Call Procedure
.text:004015F5 080         mov     ecx, offset dword_40F920
.text:004015FA 080         mov     esi, eax
.text:004015FC 080         call    HeapManager::Destructor(void) ; Call Procedure
.text:00401601 080         mov     eax, esi
```

这么多类和函数。。。。。。。。。这些已经超过windows API的范围了，估计是属于VC6编译器内部实现的类了，呵呵，因为Windows内部实现不是主要用C吗？上面用了那么多类，应该不是Windows XP的代码吧。

 

**write by****九天雁翎****(JTianLing) -- www.jtianling.com**