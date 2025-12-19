---
layout: post
title: "黑客调试技术揭秘（Hacker Debugging Uncovered） 学习（1） 最简单的密码保护破解"
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
  views: '14'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文介绍如何使用OllyDbg、IDA Pro和HIEW32等工具，通过分析汇编代码和修改跳转指令来破解简单的密码保护程序。

<!-- more -->

# 黑客调试技术揭秘（Hacker Debugging Uncovered） 学习（1） 最简单的密码保护破解

**_write by_**** _九天雁翎(JTianLing) -- blog.csdn.net/vagrxie_**

源代码：

```cpp
#include "stdafx.h"

#include <iostream>

#include <cstring>

using namespace std;

#define LEGAL_PSW "my.good.password"

int main(int argc, char* argv[])
{
    char lszCharPsw[100]  
= {0};

    cout << "Crackme 00h/nenter passwd:"; 
    cin >>lszCharPsw;
    if(strcmp(LEGAL_PSW, lszCharPsw))
    {
       cout << "wrong password/n";
    }
    else
    {
       cout << "password ok/nhello, legal user!/n";
    }

    return 0;
}
```

我是在VS2005 SP1 Release下编译的，以下的汇编代码都是这个编译器生成的。

对于这么简单的程序，只能是用来熟悉工具了。。。。怎么说以前也是玩过一下的，呵呵。

按以前的传统步骤，先用PEID打开文件看看，哦，VS2005-2008编译的，没有加壳。（纯粹为了说明步骤.....）运行程序输出看结果，wrong password,ok就找这个字符串，用Ollydbg打开，查找参考字符串，就列出了所有的字符串了，连答案都已经出来了，假设此时不知道答案，双击定位到wrong password所在的位置，

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/EntryImages/20090106/T1N1.jpg)  

```asm
00401063     /74 0D         JE      SHORT JustForH.00401072
00401065  |. |A1 60204000   MOV     EAX, DWORD PTR [<&MSVCP80.std::c>
0040106A  |. |68 64214000   PUSH    JustForH.00402164                ;  ASCII "wrong  password",LF
0040106F  |. |50            PUSH    EAX
00401070  |. |EB 0C         JMP     SHORT JustForH.0040107E
00401072  |> /8B0D 60204000 MOV     ECX, DWORD PTR [<&MSVCP80.std::c>;  MSVCP80.std::cout
00401078  |.  68 74214000   PUSH    JustForH.00402174                ;  ASCII "password ok",LF,"hello,  legal user!",LF
```

这个时候，谁都应该知道，这个第一行的JE就是判断完结果的跳转了，判断正确的话就输出了ASCII "password ok",LF,"hello, legal user!",LF，不然继续执行，输出ASCII "wrong password",LF，该怎么改也很明了了。。。。。

晕，用OllyDbg就达不到目的了。现在是来学别的工具的，按照书中的思路来走吧。

使用IDA Pro，直接载入文件，分析完毕，按书中提示，打开数据段(data)，可是这个程序似乎不和书中一样，相关数据存储在(.rdata)中，如下所示，而不是.data中，因为目前对于PE文件格式还不是太熟悉（熟悉PE格式就是我下一步需要做的工作）还不知道出现与书中不一致情况的原因。

```asm
.rdata:0040211C  ; struct _EXCEPTION_POINTERS ExceptionInfo
.rdata:0040211C  ExceptionInfo   _EXCEPTION_POINTERS  <offset dword_403040, offset dword_403098>
.rdata:0040211C                           ; DATA XREF: sub_4013A2+390o
.rdata:00402124  aBadAllocation db 'bad  allocation',0   ; DATA XREF: .data:00403018o
.rdata:00402133                         align 4
.rdata:00402134  aCrackme00hEnte db 'Crackme 00h',0Ah    ;  DATA XREF: sub_401000+32o
.rdata:00402134                         db 'enter passwd:',0
.rdata:0040214E                         align 10h
.rdata:00402150  aMy_good_passwo db 'my.good.password',0 ; DATA XREF: sub_401000+55o
.rdata:00402161                         align 4
.rdata:00402164  aWrongPassword  db 'wrong password',0Ah,0  ; DATA XREF: sub_401000+6Ao
.rdata:00402174  aPasswordOkHell db 'password ok',0Ah    ;  DATA XREF: sub_401000+78o
```

OK,还是找到了wrong password，然后用IDA Pro的交叉引用，OK一样搞定了，一样可以找到wrong number被引用的地址，看到相关的源代码（其实应该说是反汇编代码）：

```asm
.text:00401063                 jz     short loc_401072
.text:00401065                 mov     eax,  ds:?cout@std@@3V?$basic_ostream@DU?$char_traits@D@std@@@1@A ;  std::basic_ostream<char,std::char_traits<char>> std::cout
.text:0040106A                 push    offset aWrongPassword ; "wrong  password/n"
.text:0040106F                 push    eax
.text:00401070                 jmp     short loc_40107E
.text:00401072 ; 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
.text:00401072
.text:00401072 loc_401072:                             ;  CODE XREF: sub_401000+63j
.text:00401072                 mov     ecx,  ds:?cout@std@@3V?$basic_ostream@DU?$char_traits@D@std@@@1@A ;  std::basic_ostream<char,std::char_traits<char>> std::cout
.text:00401078                 push    offset aPasswordOkHell ; "password  ok/nhello, legal user!/n"
.text:0040107D                 push    ecx
```

一样还是傻子都能看出第一行在干什么，问题基本能够解决了。

其实不按书中所做，IDA Pro中有个string window，其中已经有所有的字符串了，这点和OllyDbg的查找有所引用字符串功能一样。相对而言，两个工具都很好用。但是IDA Pro生成的反汇编代码可读性相对还是更强一些，可能毕竟是用于静态分析用途的，所以对于代码有可能可进行的跳转操作，也是很方便：）

但是，想起谁说的来者OllyDbg就像是SoftIce + IDA Pro。。。。。呵呵，OllyDbg的确简单易用，我可以证明，但是是否是和SoftIce+IDA Pro这样强大嘛，还有待我继续学习，以了解真实情况。

## 继续：

Kris Kasperasky说上面这些都是工具的功能，和我们自己没有关系。。。。的确是，虽然我不是黑客，但是也继续下去了。。。。 

HIEW32。。。。。。。。呵呵，原以为仅仅是一个16进制的编辑器，所以我还想假如不好用我就继续用我的WinHEX(这个可爱的家伙伴随着我很长很长的岁月了，虽然很多人喜欢用UE来做16进制编辑器，但是我在研究一个文件打包格式的时候才真的体会到，UE与WinHex的差距，WinHex就是为编辑16进制为生的。。。。。。参看我以前贴的惨烈的工作环境的图，那就是WinHex伴随我工作的场景。

HIEW32是个命令行工具，打开文件后，一堆乱码。。。。书中实在没有详细讲解怎么用，只好自己研究研究啦，Linux下那么多命令行的工具都不在话下，不怕这一个。和许多有简陋图形界面的命令行工具一样，操作命令都写在最下面，如图，

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/EntryImages/20090106/T1N2.jpg)![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/EntryImages/20090106/T1N2.jpg)  

但是你在尝试直接按数字没有用后，自然就是按F系列了，按F1可以看使用帮助，内容还真不少。。。。。。。。仔细研究一下吧。继续说。

先按F4,选择HEX模式，查找wrong number ASCII值，查到的地址，在我的机器中是。这里用F1中看到的有趣功能Atl-P，抓屏：）

```text
.004020A0:  3C 25 00 00-28 25 00 00-12 25 00 00-04 25 00 00  <%   (%   %   %   
.004020B0:  F8 24 00 00-EC 24 00 00-E4 24 00 00-D6 24 00 00  ?   ?  ?  ?   
.004020C0:  CE 24 00 00-C4 24 00 00-B4 24 00 00-A6 24 00 00  ?   ?  ?  ?   
.004020D0:  90 24 00 00-2A 2A 00 00-40 2A 00 00-00 00 00 00  ?   **  @*       
.004020E0:  00 00 00 00-B1 13 40 00-00 00 00 00-00 00 00 00  ?@          
.004020F0:  72 15 40 00-9F 17 40 00-00 00 00 00-00 00 00 00  r @ ?@          
.00402100:  00 00 00 00-BD 1B 62 49-00 00 00 00-02 00 00 00  ?bI         
.00402110:  67 00 00 00-E8 21 00 00-E8 11 00 00-40 30 40 00  g   ?  ?  @0@  
.00402120:  98 30 40 00-62 61 64 20-61 6C 6C 6F-63 61 74 69  ?@ bad allocati 
.00402130:  6F 6E 00 00-43 72 61 63-6B 6D 65 20-30 30 68 0A  on   Crackme 00h  
.00402140:  65 6E 74 65-72 20 70 61-73 73 77 64-3A 00 00 00  enter passwd:    
.00402150:  6D 79 2E 67-6F 6F 64 2E-70 61 73 73-77 6F 72 64  my.good.password 
.00402160:  00 00 00 00-77 72 6F 6E-67 20 70 61-73 73 77 6F      wrong passwo 
.00402170:  72 64 0A 00-70 61 73 73-77 6F 72 64-20 6F 6B 0A  rd   password ok  
.00402180:  68 65 6C 6C-6F 2C 20 6C-65 67 61 6C-20 75 73 65  hello, legal use 
.00402190:  72 21 0A 00-70 61 75 73 65 00 00 00-00 00 00 00  r!   pause        
.004021A0:  48 00 00 00-00 00 00 00-00 00 00 00-00 00 00 00  H                
.004021B0:  00 00 00 00-00 00 00 00-00 00 00 00-00 00 00 00                   
.004021C0:  00 00 00 00-00 00 00 00-00 00 00 00-00 00 00 00                   
.004021D0:  00 00 00 00-00 00 00 00-00 00 00 00-00 30 40 00               0@  
.004021E0:  50 22 40 00-03 00 00 00-52 53 44 53-0D F5 61 EF  P"@     RSDS 鮝? 
.004021F0:  22 6B C6 4D-9D 15 B2 31-EB B1 74 CB-02 00 00 00  "k芃??氡t?   
```

记下地址00402160，按F5 0 enter跳转到文件头，再搜寻哪个地方使用到了这个字符串的地址，搜寻的时候因为0x86是小头机，搜寻60 21 40 00，搜到后，按F4 切入Decode模式，这是HIEW比WinHex强大的地方了。。。。WinHex不带反汇编功能。。。。不过我奇怪的是。。作者最终还是用到了工具来反汇编，然后理解。。。仅仅因为自己多搜寻了两下地址。。。这就体现了技术了？-_-!

```asm
.00401047:  50                         push        eax
.00401048:  FF1558204000               call        ??$?5DU?$char_traits@D@std@
.0040104E:  83C410                     add         esp,010 ;" "
.00401051:  8D7C2408                   lea         edi,[esp][08]
.00401055:  BE50214000                 mov         esi,000402150 ;'my.good.pas
.0040105A:  B911000000                 mov         ecx,000000011  \---  (2)
.0040105F:  33D2                       xor         edx,edx
.00401061:  F3A6                       repe        cmpsb
.00401063:  740D                       je          .000401072  \---  (3)
.00401065:  A160204000                 mov         eax,std::cout ;MSVCP80
**.0040106A: 6864214000                    push        000402164  \---  (4)        **
.0040106F: 50                         push        eax
.00401070: EB0C                       jmps        .00040107E  \---  (5)
.00401072: 8B0D60204000               mov         ecx,std::cout ;MSVCP80
.00401078: 6874214000                 push        000402174  \---  (6)
.0040107D: 51                         push        ecx
.0040107E: E85D010000                 call       .0004011E0  \---  (7)
.00401083: 83C408                     add         esp,008 ;" "
.00401086: 6894214000                 push        000402194 ;'pause'
.0040108B: FF15D0204000               call        system ;MSVCR80
.00401091: 8B4C2478                   mov         ecx,[esp][78]
.00401095: 83C404                     add         esp,004 ;" "
.00401098: 5F                         pop         edi
```

粗体显示的就是我们搜寻到的那一行，到了这里，看看前两行，什么都知道了。

将

这里说下在HIEW中的改法，按F3进入编辑模式，直接将00401063这行改为第二排那样，按F9 Update，再按F10退出，再运行，就发现怎么都是正确的了。

```asm
.00401063:  740D                       je          .000401072  \---  (3)
.00401063:  EB0D                       jmps        .000401072  \---  (3)
```

这里的修改有个不方便的地方就是，假如在编辑模式中直接按Enter或F2进入Asm输入方式的修改，会破坏整个程序，因为HIEW不会将jmps 000401072改为near的相对偏移跳转方式的汇编代码（即EB0D），而是直接将jmps 000401072翻译为绝对地址的跳转方式，因为代码的数量远远的大于了原来的两个字节（光是地址就需要4个），所以导致程序破坏了。这里要说明的是，OllyDbg就要强大的多，它会进行这样适当的转换，并且还可以自动的在你将长代码改为短代码时为你用NOP填充。其实最简单的办法就是找到原有代码的合适位置，然后修改成代码长度一样的代码，这在插入代码很短的时候（比如一个简单的jmp）时很有用。在书中仅仅描述了怎么在原地修改的办法。其实常用的办法还包括一种简单的代码注入方式，即将某条指令换成跳转语句，跳转到某个空地方，将我们要执行的代码放在那里，以前我甚至试过动态调试的时候，直接输入指令执行：）这样可是很好很强大的啊。

原地修改嘛，起码得给自己的语句腾出位置，但是不伤害其他的原有语句。比如改成下面这样：

```asm
0040105F   . /EB 11         JMP     SHORT JustForH.00401072
```

这样就绕过了检测了，一样可以达到目的。。。。太晚了，今天就到这里吧，其实好像除了IDA Pro，HIEW最基本的用法，什么都没有学会。

**_write by_**** _九天雁翎_**** _(JTianLing) -- blog.csdn.net/vagrxie_**
