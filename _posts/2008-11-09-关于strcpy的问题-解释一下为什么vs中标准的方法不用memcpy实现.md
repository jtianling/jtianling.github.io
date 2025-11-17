---
layout: post
title: "关于strcpy的问题，解释一下为什么VS中标准的方法不用memcpy实现"
categories:
- C++
tags:
- C++
- memcpy
- strcpy
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '9'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

原文：http://blog.csdn.net/youyouzhishen/archive/2008/11/02/3207836.aspx  

 

  

#include <cstring>

using namespace std;

 

inline char* myStrcpy(char* apszDest, char* apszSrc)

{

    memcpy(apszDest, apszSrc, strlen(apszSrc) + 1);

    return apszDest;

}

 

int _tmain(int argc, _TCHAR* argv[])

{

    char lszSrc[] = "GOD, I'm a test string./n";

    char lszDest[256];

 

    printf("%s",myStrcpy(lszDest, lszSrc));

    printf("%s",strcpy(lszDest, lszSrc));

 

    return 0;

 

}

  

 

 

 

  

 

 

其实strcpy实现成我上面写的那样一样也可以实现strcpy,并且平均效率似乎要更高。这种错觉来自于debug时看到的strcpy的源代码（K&R中，一般的笔试题也广为通用此源代码）

其实到最近才知道，debug时可以看到strcpy的实现，memcpy一般情况下比strcpy那样的实现效率要高，这是很明显的，哪怕字符数量比较小，memcpy起码也不输给strcpy，但是，事实上，在优化后的release汇编代码就能发现，其实strcpy这样常用的函数（虽然是C Runtime Library的函数），但是编译器实际是做了优化的，这些叫做内部函数（中文版VS2005标准译法），直接就通过strcpy生成了汇编代码，所以实现上就没有必要使用memcpy了，见下面的汇编代码。

 

 

    printf("%s",myStrcpy(lszDest, lszSrc));

00401026 8D 44 24 08      lea         eax,[esp+8] 

0040102A A4               movs        byte ptr es:[edi],byte ptr [esi] 

0040102B 8D 50 01         lea         edx,[eax+1] 

0040102E 8B FF            mov         edi,edi 

00401030 8A 08            mov         cl,byte ptr [eax] 

00401032 83 C0 01         add         eax,1 

00401035 84 C9            test        cl,cl 

00401037 75 F7            jne         wmain+30h (401030h) 

00401039 2B C2            sub         eax,edx 

0040103B 83 C0 01         add         eax,1 

0040103E 50               push        eax 

0040103F 8D 44 24 0C      lea         eax,[esp+0Ch] 

00401043 50               push        eax 

00401044 8D 4C 24 2C      lea         ecx,[esp+2Ch] 

00401048 51               push        ecx 

00401049 E8 26 08 00 00   call        memcpy (401874h) 

0040104E 8B 35 A0 20 40 00 mov         esi,dword ptr [__imp__printf (4020A0h)] 

00401054 8D 54 24 30      lea         edx,[esp+30h] 

00401058 52               push        edx 

00401059 68 10 21 40 00   push        offset string "%s" (402110h) 

0040105E FF D6            call        esi 

00401060 83 C4 14         add         esp,14h 

    printf("%s",strcpy(lszDest, lszSrc));

00401063 33 C0            xor         eax,eax 

00401065 8A 4C 04 08      mov         cl,byte ptr [esp+eax+8] 

00401069 88 4C 04 24      mov         byte ptr [esp+eax+24h],cl 

0040106D 83 C0 01         add         eax,1 

00401070 84 C9            test        cl,cl 

00401072 75 F1            jne         wmain+65h (401065h) 

00401074 8D 44 24 24      lea         eax,[esp+24h] 

00401078 50               push        eax 

00401079 68 10 21 40 00   push        offset string "%s" (402110h) 

0040107E FF D6            call        esi 

 

没有见过strcpy的汇编代码前。。。。哪想的到原来这么简单
