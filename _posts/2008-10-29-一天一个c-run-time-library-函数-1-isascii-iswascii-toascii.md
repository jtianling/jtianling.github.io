---
layout: post
title: "一天一个C Run-Time Library 函数(1)  __isascii & __iswascii & __toascii"
categories:
- C++
- Linux
tags:
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '19'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

  

## 一天一个C Run-Time Library 函数  __isascii & iswascii & __toascii

 

**_write by 九天雁翎(JTianLing) -- www.jtianling.com_**

**_ _**

## msdn:

Determines whether a particular character is an ASCII character.

**int** **__isascii(**

**    int** _c_

**);**

**int** **iswascii(**

**    wint_t** _c_

**);**

## 测试程序：

#include "stdafx.h"

#include "ctype.h"

#include "locale.h"

#include "stdio.h"

 

void CheckCharAndPrint(char acChar)

{

    if(__isascii(acChar))

    {

       printf("char %c is a ascii char./n",acChar);

    }

    else

    {

        // 此处无法正常输出中文，没有深入研究了

       printf("char %c is not a ascii char./n",acChar);

    }

}

 

void CheckWCharAndPrint(wchar_t awcChar)

{

    if(iswascii(awcChar))

    {

       wprintf(L"wchar %c is a ascii char./n",awcChar);

    }

    else

    {

       setlocale(LC_ALL,"");

       wprintf(L"wchar %c is not a ascii char./n",awcChar);

    }

}

 

 

int _tmain(int argc, _TCHAR* argv[])

{

    char lcC = 'a';

    char lcD = '中';

 

    CheckCharAndPrint(lcC);

    CheckCharAndPrint(lcD);

 

    wchar_t lwcC = L'a';

    wchar_t lwcD = L'中';

 

    CheckWCharAndPrint(lwcC);

    CheckWCharAndPrint(lwcD);

 

    return 0;

}

 

## 说明：

__isascii是一个比较特殊的函数，因为它以两个前置下划线开头。这在C语言中并不多见。（起码我看到的比较少）

此函数应该不属于标准库函数，《TCPL》中，《C语言参考》中并没有描述，但是gcc中有此函数。也就是说linux下也能正常使用此函数。

iswascii这个__isascii函数的宽字节版本，如同很多宽字节版本的函数一样，这个函数属于MS自己扩的，于是。。linux下无法使用此函数，要使用，只能自己实现罗。

** **

## 实现：

MS:

#define __isascii(_Char)   ( (unsigned)(_Char) < 0x80 )

inline int __cdecl iswascii(wint_t _C) {return ((unsigned)(_C) < 0x80); }

gcc:

#define __isascii(c)  (((c) & ~0x7f) == 0)  /* if C is a 7 bit value*/

__isascii都是一个简单的宏。MS的iswascii原理和其__isascii都一样，仅仅是一个内联的函数。

微软的实现是依赖于字符小于128（0x80），这里还做了一次强转，不是太理解，因为实际char可以直接作为整数来比较，也许仅仅是为了屏蔽warning?

gcc的实现是依赖于字符除低七位外无任何其他值。即先将127(0x7f)取反，再与字符位与。实际就是取得字符c除了低七位以外的值。再比较此值是否为零。

想不到一个这样简单的函数，MS,gcc的实现差别都这么大，相对而言MS的实现自然是比较浅显易懂的，但是gcc用这么复杂的实现，应该有更好的效率。

就分析而言，强转+小于操作 运行时间大于 一次取反一次位与一次等于操作。还真不容易知道谁的效率真的更高。那么就测试一下吧。

## 效率测试：

#include "jtianling.h"

#define __isasciims(_Char)   ( (unsigned)(_Char) < 0x80 )

#define __isasciigcc(c)  (((c) & ~0x7f) == 0)  /* if C is a 7 bit value*/

 

const int  DEF_TEST_TIMES = 1000000000;

 

void CheckMS(char ac)

{

    double ldTimeLast = jtianling::GetTime();

    for (int i=0; i<DEF_TEST_TIMES ; ++i)

    {

 

       __isasciims(ac);

 

    }

    double ldTimePast = jtianling::GetTime() - ldTimeLast;

 

    printf("__isasciims %c run %d times cost %lf secs./n", ac, DEF_TEST_TIMES, ldTimePast);

}

 

void Checkgcc(char ac)

{

    double ldTimeLast = jtianling::GetTime();

    for (int i=0; i<DEF_TEST_TIMES ; ++i)

    {

 

       __isasciigcc(ac);

 

    }

    double ldTimePast = jtianling::GetTime() - ldTimeLast;

 

 

    printf("__isasciigcc %c run %d times cost %lf secs./n", ac, DEF_TEST_TIMES, ldTimePast);

}

 

int _tmain(int argc, _TCHAR* argv[])

{

    char lc = 'a';

    char lc2 = '中';

    CheckMS(lc);

    Checkgcc(lc);

    CheckMS(lc);

    Checkgcc(lc2);

 

    return 0;

}

至于GetTime函数的意义，请参考我以前写的库，无非就是获取当前时间，不知道也没有关系。你可以用time(NULL)来替代，只不过精度没有这个函数高而已。

实际的测试结果很让人失望，在测试了几乎无数次以后，MS和gcc的实现效率都几乎相同，在10亿这个级别，gcc也不过有时快0.1秒而已，而且多次运行，还不是太稳定。看来并不是复杂的实现就一定好。。。

 

## 相关函数：

msdn:

Converts characters.

int __toascii(

   int c 

); 

这个函数也是一个双前置下划线的函数，MS,gcc中都有实现。而且在此时，实现都是一样的。

#define __toascii(_Char)   ( (_Char) & 0x7f )

gcc注释到 “mask off high bits.”

这里和gcc中__isascii函数实现的前一部分很像，一个是去除低七位，一个是保留低七位。看了这个以后才知道gcc为什么想到这样实现__isascii了。

 

## 个人想法：

这两个函数在实际中我从来没有用到过，假如不是我工作范围太窄那就是这两个函数的使用性并不强了，的确，我没有事去把一个值转为ascii?是ascii的话就没有意义，不是的话，原来的含义还能保留吗？至于__isascii函数可能还在某些情况下有用吧，只不过我没有用到过，谁有实际中使用此两个函数的代码可以告诉我一下。

 

另外，总结的是，虽然C Runtime库MS也有源码，但是完全没有任何注释。相对而言gcc的注释就算是很丰富和详细了，呵呵，毕竟开源代码就是不一样啊，做来就是给人看的，想想这样分析下去，光是看源代码收获都不会太小。

 

最后。。。。。。。。。。。这样一个最最简单的函数，宏定义的函数。用了我整整一个没有加班的晚上的，晕掉了。当然，有在家里的VS中编程已经不太习惯的因素，但是还是太过了，下次不能这样太过了。。。点到为止就好了，不然这一辈子都分析不完了。

 

**_write by 九天雁翎(JTianLing) -- www.jtianling.com_**
