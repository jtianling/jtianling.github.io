---
layout: post
title: C++中的虚函数调用原理的反汇编实例分析(2)
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
  views: '15'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

通过反汇编分析，揭示了C++虚函数的调用机制及RTTI在虚表中的存储实现原理。

<!-- more -->



因为昨天的第一节中我其实感觉并没有太透彻的理解其原理，也对VC6的实现是否会继续抱有怀疑态度，所以今天特意用VS2005编译并分析了一下，只能说，从反汇编的角度来看都可以看出微软的进步实在是很大的，有钱嘛：）呵呵，也许Stanley B.Lippman的功劳不是白费的吧。速度上我是没有好好的去测试了，从逻辑上看，可读性都强了很多（呵呵，汇编代码要可读性干什么。。。。。）

为了可读性。。。。我个人就麻烦一点了，以后汇编代码也不是全黑出镜了。。。。我还是用gvim给大家上上色吧。。。。 

## 示例程序：

```cpp
#include

#include

#include

class CTestThisPointer 

{ 

public: 

    CTestThisPointer(int ai):mi(ai) { } 

    virtual int Add(int ai) 

    { 

        mi += ai; 

        return mi; 

    } 

 

private: 

    int mi; 

}; 

 

 

int main() 

{ 

    CTestThisPointer loTest(10); 

    CTestThisPointer *lp = &loTest; 

 

    printf("%d/n",lp->Add(5)); 

    printf("%s/n",typeid(lp).name()); 

    return 0; 

}
```

和在第一节中的源代码是一样的，只是这次我用VS2005最大速度优化release编译 

## 反汇编：

主函数：

```asm
 1 .text:00401010 ; int __cdecl main(int argc, const char **argv, const char *envp)  
 2 .text:00401010 _main           **proc**  **near**                ; CODE XREF: __tmainCRTStartup+10A^Yp  
 3 .text:00401010  
 4 .text:00401010 var_8           = **dword**  **ptr**  -8  
 5 .text:00401010 var_4           = **dword**  **ptr**  -4  
 6 .text:00401010 argc            = **dword**  **ptr**   4  
 7 .text:00401010 argv            = **dword**  **ptr**   8  
 8 .text:00401010 envp            = **dword**  **ptr**   0Ch  
 9 .text:00401010  
10 .text:00401010                 **sub**      esp, 8          ; 此处为临时变量var_8,var_4预留空间，但是因为直接使用esp，  
11 .text:00401010                                         ; 所以我感觉后面的的堆栈有点混乱，比如后面的esp+10h,  
12 .text:00401010                                         ; 这里有个有意思的优化在于5竟然是只有2个字节的使用，  
13 .text:00401010                                         ; 所以esp-8以后，push esi(保存esi)然后又-4=0ch，然后  
14 .text:00401010                                         ; 因为push 5(add参数）然后-2=010h,所以以后的临时变量  
15 .text:00401010                                         ; 不得不先+10h以获取正确的地址，看到下面的汇编代码  
16 .text:00401010                                         ; 应该就好理解了  
17 .text:00401010                                         ;  
18 .text:00401013                 **push**     esi  
19 .text:00401014                 **push**     5               ; 这是Add函数的参数了，这里是先push参数，然后再正确为  
20 .text:00401014                                         ; CTestThisPointer赋值（从构造函数优化而来），再调用  
21 .text:00401014                                         ; Add函数，中间断开了，但是从栈的走向还是可以看出  
22 .text:00401014                                         ; 此处实际是Add函数的参数  
23 .text:00401016                 **lea**      ecx, [esp+10h+var_8] ; 此处也是Add函数的参数，即this指针了  
24 .text:0040101A                 **mov**      [esp+10h+var_8], **offset**  const CTestThisPointer::`vftable'  
25 .text:00401022                 **mov**      [esp+10h+var_4], 0Ah ; 构造函数没有调用，直接优化为赋值操作  
26 .text:0040102A                 **call**     ds:const CTestThisPointer::`vftable' ;  
27 .text:0040102A                                         ; 一个虚函数的调用还是解释call this所在的地址就好了  
28 .text:00401030                 **mov**      esi, ds:__imp__printf  
29 .text:00401036                 **push**     eax  
30 .text:00401037                 **push**     **offset**  aD       ; "%d/n"  
31 .text:0040103C                 **call**     esi ; __imp__printf  
32 .text:0040103E                 **add**      esp, 8          ; 此add esp,8为调整printf函数的栈平衡使用  
33 .text:00401041                 **push**     **offset**  __type_info_root_node ; 此处不明，可能需要多个RTTI对象才能知道  
34 .text:00401041                                         ; 因为就命名上来推测，可能是维护了一个RTTI对象的链表  
35 .text:00401041                                         ; 而因为元素只有一个，所以没有办法肯定了  
36 .text:00401046                 **mov**      ecx, **offset**  CTestThisPointer * `RTTI**  Type**  Descriptor' ; 此处相当于构建一个type_info的类，当时由于优化，没有  
37 .text:00401046                                         ; 使用栈来创建局部变量和使用构造函数等，直接将type_info  
38 .text:00401046                                         ; 的虚表赋值给ecx了，ecx在thiscall调用约定中就是this  
39 .text:00401046                                         ; 指针传递的参数啊，下面就调用了此对象的name成员函数  
40 .text:0040104B                 **call**     ds:type_info::**name**(__type_info_node *)  
41 .text:00401051                 **push**     eax  
42 .text:00401052                 **push**     **offset**  aS       ; "%s/n"  
43 .text:00401057                 **call**     esi ; __imp__printf  
44 .text:00401059                 **add**      esp, 8          ; 此add esp,8也为调整printf函数的栈平衡使用  
45 .text:0040105C                 **xor**      eax, eax  
46 .text:0040105E                 **pop**      esi  
47 .text:0040105F                 **add**      esp, 8          ; 此处才退出函数，CTestThisPointer结束生命周期，用  
48 .text:0040105F                                         ; add esp,8清空临时变量  
49 .text:00401062                 **retn**                     ; 对了，才注意到main函数遵循的也是__cdecl调用约定。。。  
50 .text:00401062 _main           **endp**                     ; 其实自然啦，因为main函数的参数个数也是不定的
```

虚表：

```asm
1 .rdata:00402114                 **dd**  **offset**  const CTestThisPointer::`RTTI Complete Object Locator' ;  
2 .rdata:00402114                                         ; 这就是CTestThisPointer的RTTI信息  
3 .rdata:00402114                                         ; 正好在虚表前，由编译器静态分配，但是动态获取  
4 .rdata:00402114                                         ; this指针的指向还是vtbl的第一个虚函数，此例中  
5 .rdata:00402114                                         ; 即为Add  
6 .rdata:00402118 const CTestThisPointer::`vftable' **dd**  **offset**  CTestThisPointer__Add  
7 .rdata:00402118                                         ; DATA XREF: _main+A^Xo  
8 .rdata:00402118                                         ; _main+1A^Xr 
```

而虚表的前4个字节就是一个指针，指向了表示正确类型的type_info类的子类。

到这里，一切就慢慢符合《inside C++ Object》中描述的虚表了，呵呵，有了lippman,微软总算走上正轨了，慢慢的。。。充满技术性天才的可怜borland也走入了末途。

## 继续，例2：

```cpp
#include

#include

#include

class CTestThisPointer 

{ 

public: 

    CTestThisPointer(int ai):mi(ai) { } 

    virtual int Add(int ai) 

    { 

        mi += ai; 

        return mi; 

    } 

 

    // 纯废的析构函数 

    virtual ~CTestThisPointer() { mi = 0;} 

private: 

    int mi; 

}; 

 

// 无继承关系，仅为分析RTTI 

class CTestBase 

{ 

public: 

    CTestBase(int ai):mi(ai) { } 

    virtual int Add(int ai) 

    { 

        mi += ai; 

        mi += ai; 

        return mi; 

    } 

 

    // 纯废的析构函数 

    ~CTestBase() { mi = 0;} 

private: 

    int mi; 

}; 

 

    
int main() 

{ 

    CTestThisPointer loTest(10); 

    CTestThisPointer *lp = &loTest; 

 

    printf("%d/n",lp->Add(5)); 

    printf("%s/n",typeid(lp).name()); 

 

 

 

    CTestBase loTestBase(20); 

    CTestBase* lpTestBase = &loTestBase; 

 

    printf("%s/n",typeid(CTestBase).name()); 

    printf("%s/n",typeid(loTestBase).name()); 

    printf("%s/n",typeid(lpTestBase).name()); 

    return 0; 

}
```

## 反汇编代码：

不重复注释重复内容 

主程序：

```asm
.text:00401070 ; int __cdecl main(int argc, const char **argv, const char *envp)  
.text:00401070 _main           **proc**  **near**                ; CODE XREF: __tmainCRTStartup+10A^Yp  
.text:00401070  
.text:00401070 var_1C          = **dword**  **ptr**  -1Ch  
.text:00401070 var_18          = **dword**  **ptr**  -18h  
.text:00401070 var_14          = **dword**  **ptr**  -14h  
.text:00401070 var_10          = **dword**  **ptr**  -10h  
.text:00401070 var_C           = **dword**  **ptr**  -0Ch  
.text:00401070 var_4           = **dword**  **ptr**  -4  
.text:00401070 argc            = **dword**  **ptr**   4  
.text:00401070 argv            = **dword**  **ptr**   8  
.text:00401070 envp            = **dword**  **ptr**   0Ch  
.text:00401070  
.text:00401070                 **push**     0FFFFFFFFh  
.text:00401072                 **push**     **offset**  loc_401A50 ; 因为程序足够大了。。。。MS自动的加入了SEH异常处理  
.text:00401077                 **mov**      eax, large fs:0 ; SEH的TEB(thread Environment Block)总是在FS:0上  
.text:0040107D                 **push**     eax  
.text:0040107E                 **sub**      esp, 10h  
.text:00401081                 **push**     esi  
.text:00401082                 **push**     edi  
.text:00401083                 **mov**      eax, __security_cookie  
.text:00401088                 **xor**      eax, esp  
.text:0040108A                 **push**     eax  
.text:0040108B                 **lea**      eax, [esp+28h+var_C]  
.text:0040108F                 **mov**      large fs:0, eax ; 之前的代码都是在初始化TEB结构。。。。。。。  
.text:00401095                 **mov**      [esp+28h+var_1C], **offset**  const CTestThisPointer::`vftable'  
.text:0040109D                 **mov**      [esp+28h+var_18], 0Ah  
.text:004010A5                 **push**     5  
.text:004010A7                 **lea**      ecx, [esp+2Ch+var_1C]  
.text:004010AB                 **mov**      [esp+2Ch+var_4], 0  
.text:004010B3                 **call**     ds:const CTestThisPointer::`vftable'  
.text:004010B9                 **mov**      esi, ds:__imp__printf  
.text:004010BF                 **push**     eax  
.text:004010C0                 **push**     **offset**  aD       ; "%d/n"  
.text:004010C5                 **call**     esi ; __imp__printf  
.text:004010C7                 **mov**      edi, ds:type_info::**name**(__type_info_node *)  
.text:004010CD                 **add**      esp, 8  
.text:004010D0                 **push**     **offset**  __type_info_root_node  
.text:004010D5                 **mov**      ecx, **offset**  CTestThisPointer * `RTTI**  Type**  Descriptor'  
.text:004010DA                 **call**     edi ; type_info::name(__type_info_node *)  
.text:004010DC                 **push**     eax  
.text:004010DD                 **push**     **offset**  aS       ; "%s/n"  
.text:004010E2                 **call**     esi ; __imp__printf  
.text:004010E4                 **add**      esp, 8  
.text:004010E7                 **mov**      [esp+28h+var_14], **offset**  const CTestBase::`vftable'  
.text:004010EF                 **mov**      [esp+28h+var_10], 14h  
.text:004010F7                 **push**     **offset**  __type_info_root_node  
.text:004010FC                 **mov**      ecx, **offset**  CTestBase `RTTI**  Type**  Descriptor'  
.text:00401101                 **mov**      **byte**  **ptr**  [esp+2Ch+var_4], 1  
.text:00401106                 **call**     edi ; type_info::name(__type_info_node *)  
.text:00401108                 **push**     eax  
.text:00401109                 **push**     **offset**  aS       ; "%s/n"  
.text:0040110E                 **call**     esi ; __imp__printf  
.text:00401110                 **add**      esp, 8  
.text:00401113                 **push**     **offset**  __type_info_root_node  
.text:00401118                 **mov**      ecx, **offset**  CTestBase `RTTI**  Type**  Descriptor'  
.text:0040111D                 **call**     edi ; type_info::name(__type_info_node *)  
.text:0040111F                 **push**     eax  
.text:00401120                 **push**     **offset**  aS       ; "%s/n"  
.text:00401125                 **call**     esi ; __imp__printf  
.text:00401127                 **add**      esp, 8  
.text:0040112A                 **push**     **offset**  __type_info_root_node  
.text:0040112F                 **mov**      ecx, **offset**  CTestBase * `RTTI**  Type**  Descriptor'  
.text:00401134                 **call**     edi ; type_info::name(__type_info_node *)  
.text:00401136                 **push**     eax  
.text:00401137                 **push**     **offset**  aS       ; "%s/n"  
.text:0040113C                 **call**     esi ; __imp__printf  
.text:0040113E                 **add**      esp, 8  
.text:00401141                 **xor**      eax, eax  
.text:00401143                 **mov**      ecx, [esp+28h+var_C]  
.text:00401147                 **mov**      large fs:0, ecx  
.text:0040114E                 **pop**      ecx  
.text:0040114F                 **pop**      edi  
.text:00401150                 **pop**      esi  
.text:00401151                 **add**      esp, 1Ch  
.text:00401154                 **retn**  
.text:00401154 _main           **endp**  
.text:00401154  
.text:00401154 ; ---------------------------------------------------------------------------
```

贴出来仅仅是为了完整性，其实已经没有什么新意了，无非就是多一些，唯一有价值提起的就是SEH机制的加入，这又是另外一个话题了，在此不详述了，可以查阅相关书籍，推荐的有《windows核心编程》和《加密与解密》相关章节，虽然内容都并不是很多。 

虚表。。。这才是符合主题的部分：

```asm
.rdata:00402124                 **dd**  **offset**  const CTestThisPointer::`RTTI Complete Object Locator'  
.rdata:00402128 const CTestThisPointer::`vftable' **dd**  **offset**  CTestThisPointer__Add  
.rdata:00402128                                         ; DATA XREF: CTestThisPointer___CTestThisPointer^Xo  
.rdata:00402128                                         ; CTestThisPointer___scalar_deleting_destructor_+8^Xo ...  
.rdata:0040212C                 **dd**  **offset**  CTestThisPointer___scalar_deleting_destructor_ ;  
.rdata:0040212C                                         ; 哈雷卤鸭。。。。。好吃吗？-_-!果然虚表果然扩张了，  
.rdata:0040212C                                         ; 顺序排列的函数分别是Add,和destructor  
.rdata:00402130                 **dd**  **offset**  const CTestBase::`RTTI Complete Object Locator'  
.rdata:00402134 const CTestBase::`vftable' **dd**  **offset**  CTestBase__Add  
.rdata:00402134                                         ; DATA XREF: CTestBase___CTestBase^Xo  
.rdata:00402134                                         ; _main+77^Xo  
.rdata:00402134                                         ;  
.rdata:00402134                                         ; 此处也可以看出来，在虚表前的一个4字节结构，的确是  
.rdata:00402134                                         ; RTTI使用的。。。。只是this指针直接指向的是虚表
```

以下是__type_info_node的链表。。。。。。。。。,没有上色了。。。

```asm
.rdata:00402274 dd offset CTestBase::`RTTI Class Hierarchy Descriptor' 

.rdata:00402278 const CTestThisPointer::`RTTI Complete Object Locator' db 0 

.rdata:00402278 ; DATA XREF: .rdata:00402124o 

.rdata:00402279 db 0 

.rdata:0040227A db 0 

.rdata:0040227B db 0 

.rdata:0040227C db 0 

.rdata:0040227D db 0 

.rdata:0040227E db 0 

.rdata:0040227F db 0 

.rdata:00402280 db 0 

.rdata:00402281 db 0 

.rdata:00402282 db 0 

.rdata:00402283 db 0 

.rdata:00402284 dd offset CTestThisPointer `RTTI Type Descriptor' 

.rdata:00402288 dd offset CTestThisPointer::`RTTI Class Hierarchy Descriptor' 

.rdata:0040228C CTestThisPointer::`RTTI Class Hierarchy Descriptor' db 0 

.rdata:0040228C ; DATA XREF: .rdata:00402288o 

.rdata:0040228C ; .rdata:004022BCo 

.rdata:0040228D db 0 

.rdata:0040228E db 0 

.rdata:0040228F db 0 

.rdata:00402290 db 0 

.rdata:00402291 db 0 

.rdata:00402292 db 0 

.rdata:00402293 db 0 

.rdata:00402294 db 1 

.rdata:00402295 db 0 

.rdata:00402296 db 0 

.rdata:00402297 db 0 

.rdata:00402298 dd offset CTestThisPointer::`RTTI Base Class Array' 

.rdata:0040229C CTestThisPointer::`RTTI Base Class Array' dd offset CTestThisPointer::`RTTI Base Class Descriptor at (0,-1,0,64)' 

.rdata:0040229C ; DATA XREF: .rdata:00402298o 
```

__type_info_node的链表。。。。可以在VS2005的头文件中找到依据：

```cpp
struct __type_info_node { 

void *memPtr; 

__type_info_node* next; 

}; 

extern __type_info_node __type_info_root_node; 
```

呵呵，不就是这个吗？ 

最后，在VS2005的头文件中可以看到type_info类的声明和反汇编代码上看到的完全一致。。。。 

```cpp
class type_info { 

public: 

virtual ~type_info(); 

_CRTIMP_PURE bool __CLR_OR_THIS_CALL operator==(const type_info& rhs) const; 

_CRTIMP_PURE bool __CLR_OR_THIS_CALL operator!=(const type_info& rhs) const; 

_CRTIMP_PURE int __CLR_OR_THIS_CALL before(const type_info& rhs) const; 

_CRTIMP_PURE const char* __CLR_OR_THIS_CALL name(__type_info_node* __ptype_info_node = &__type_info_root_node) const; 

_CRTIMP_PURE const char* __CLR_OR_THIS_CALL raw_name() const; 

private: 

void *_m_data; 

char _m_d_name[1]; 

__CLR_OR_THIS_CALL type_info(const type_info& rhs); 

type_info& __CLR_OR_THIS_CALL operator=(const type_info& rhs); 

_CRTIMP_PURE static const char *__CLRCALL_OR_CDECL _Name_base(const type_info *,__type_info_node* __ptype_info_node); 

_CRTIMP_PURE static void __CLRCALL_OR_CDECL _Type_info_dtor(type_info *); 

}; 
```

至此。。。。C++中虚函数调用的机制差不多可以知道了。。。。顺便还搞定了RTTI....加上继承不过就是换个虚表的问题了。虚表的结构又不会变。。。。。不深究了，生命是有限的。。。。。 

