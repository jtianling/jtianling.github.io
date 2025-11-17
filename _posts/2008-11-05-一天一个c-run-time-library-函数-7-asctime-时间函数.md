---
layout: post
title: "一天一个C Run-Time Library 函数 (7)  asctime（时间函数）"
categories:
- C++
tags:
- asctime
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '2'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

## 一天一个C Run-Time Library 函数 (7)  asctime（时间函数）

write by 九天雁翎(JTianLing) -- www.jtianling.com

 

## msdn:

Convert a **tm** time structure to a character  
string. These functions are deprecated because more secure versions are  
available; see _asctime_s,_  
  
---  
```c
char
*asctime(     const struct tm *_timeptr_ );
```

## 测试程序：

```c
#include <stdio.h>
#include <time.h>

int main( void )
{
    time_t ltNow = time(NULL);
    struct tm* lptmNow = localtime(&ltNow);

    const char* lpszNow = asctime(lptmNow);

    printf("%s",lpszNow);

    return 0;
}
```

 

## 说明：

**asctime****是非常使用的函数，与****time(),localtime****，****gmtime****，****mktime****,ctime****一起构成了****C****语言世界的时间概念。****C****中的格林威治时间体系就是由这几个函数来完成的。****time_t****类型是用来沟通这些函数的桥梁。说明一下，****localtime****在转换的时候是根据本地****locale****来转换的，****gmtime****就是转换标准的格林威治时间，（似乎从结果上来看就是转换成了伦敦时间）。顺便说一下，以****_t****结尾的类型定义虽然你在****Windows****中看到是可能是简单的****int****型，但是即使这样，作为可移植的程序开发，还是应该用原来的类型定义****,****这样碰到不同实现的时候不至于会导致错误，比如****windows****中现在****time_t****现在默认的就是****int64****了。******

**与此类似的类型还有****pid_t,win_t****等******

##  实现：

```c
static _TSCHAR * __cdecl store_dt (
    REG1 _TSCHAR *p,
    REG2 int val
    )
{
    *p++ = (_TSCHAR)(_T('0') + val / 10);
    *p++ = (_TSCHAR)(_T('0') + val % 10);
    return(p);
}

REG2 _TSCHAR *p = buffer;
int day, mon;
int i;
day = tb->tm_wday * 3;     /* index to correct day string */
mon = tb->tm_mon * 3;       /* index to correct month string */

for (i=0; i < 3; i++,p++) {
    *p = *(__dnames + day + i);
    *(p+4) = *(__mnames + mon + i);
}

*p = _T(' ');           /* blank between day and month */

p += 4;

*p++ = _T(' ');
p = store_dt(p, tb->tm_mday);   /* day of the month (1-31) */
*p++ = _T(' ');
p = store_dt(p, tb->tm_hour);   /* hours (0-23) */
*p++ = _T(':');
p = store_dt(p, tb->tm_min);    /* minutes (0-59) */
*p++ = _T(':');
p = store_dt(p, tb->tm_sec);    /* seconds (0-59) */
*p++ = _T(' ');
p = store_dt(p, 19 + (tb->tm_year/100));  /* year (after 1900) */
p = store_dt(p, tb->tm_year%100);
*p++ = _T('/n');
*p = _T('/0');
```

 

MS:

这个实现是我此系列开始写以后看的源代码中最有意思的源代码了。所以不惜编程源代码的分析都要讲一讲。

很有意思的代码，淋漓尽致的体现了C语言指针的灵活。

```c
for (i=0; i < 3; i++,p++) {
    *p = *(__dnames + day + i);
    *(p+4) = *(__mnames + mon + i);
}
```

通过对月和星期的buf,用这个循环完成的6个字符的拷贝更是很让我欣赏：）

通过val/10的加上’0’的asc值的方式完成的默认前置0的赋值也是很有意思的技巧。

```c
*p++ = (_TSCHAR)(_T('0') + val / 10);
*p++ = (_TSCHAR)(_T('0') + val % 10);
```

 

gcc:

仅仅通过一个简单的snprintf来实现，这估计也是大部分人的实现方式。。。。我要是真的准备实现这样一个代码也会这样实现。

 

 

## 效率测试：

很想知道到底哪个会赢。。。。不过太晚了。。。。

 

 
## 相关函数：

gmtime,  localtime,  ctime, time, 

## 个人想法：

**除了宽字节版本不能使用之外，其他函数的使用自然没有任何问题。并且函数名完全一致。对于这么古老和标准的函数假如还能出现问题，估计任何做可移植程序的人都会崩溃的。放心用吧。******

 

write by 九天雁翎(JTianLing) -- www.jtianling.com