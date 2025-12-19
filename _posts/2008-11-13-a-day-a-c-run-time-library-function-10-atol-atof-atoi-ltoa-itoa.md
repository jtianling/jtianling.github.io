---
layout: post
title: "一天一个C Run-Time Library 函数 (10) atol,atof,atoi, ltoa , itoa,"
categories:
- C++
tags:
- atof
- atoi
- atol
- itoa
- ltoa
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

介绍C语言中atoi、atof等字符串与数字转换函数，探讨其用法、替代方案，并分析了因整数类型多样而导致的函数设计问题。

<!-- more -->

## 一天一个C Run-Time Library 函数 (10) atol,atof,atoi, ltoa , itoa,

write by 九天雁翎(JTianLing) -- www.jtianling.com

## msdn:

Convert strings to double (**atof**), integer (**atoi** ,  
_**atoi64**), or long (**atol**).

```c
double atof(
    const char *__string__
);
```

```c
int atoi(
    const char *__string__
);
```

```c
_int64 _atoi64(
    const char *__string__
);
```

```c
long atol(
    const char *__string__
);
```

Converts a long  
integer to a string. These functions are deprecated because more secure  
versions are available; see [_ltoa_s, _ltow_s](<ms-help://MS.MSDNQTR.v80.chs/MS.MSDN.v80/MS.VisualStudio.v80.chs/dv_vccrt/html/d7dc61ea-1ccd-412d-b262-555a58647386.htm>).

---

```cpp
char *_ltoa(   long _value_ ,   char *_str_ ,   int _radix_ );
wchar_t *_ltow(   long _value_ ,   wchar_t *_str_ ,   int _radix_ );
template <size_t size> char *_ltoa(   long _value_ ,   char (&_str_)[size],   int _radix_ ); // C++ only
template <size_t size> wchar_t *_ltow(   long _value_ ,   wchar_t (&_str_)[size],   int _radix_ ); // C++ only
```

Converts a  
long integer to a string. These functions are deprecated because more secure  
versions are available; see [_ltoa_s, _ltow_s](<ms-help://MS.MSDNQTR.v80.chs/MS.MSDN.v80/MS.VisualStudio.v80.chs/dv_vccrt/html/d7dc61ea-1ccd-412d-b262-555a58647386.htm>).

---

```cpp
char *_ltoa(   long _value_ ,   char *_str_ ,   int _radix_ );
wchar_t *_ltow(   long _value_ ,   wchar_t *_str_ ,   int _radix_ );
template <size_t size> char *_ltoa(   long _value_ ,   char (&_str_)[size],   int _radix_ ); // C++ only
template <size_t size> wchar_t *_ltow(   long _value_ ,   wchar_t (&_str_)[size],   int _radix_ ); // C++ only
```

## 测试程序：

原谅我再偷懒一次

## 说明：

**这一族函数的使用就看个人的习惯而异了，我个人使用的不是太多，除了一些不可避免的情况以外。******

**一般来说，****sprintf****可以完成大多数从整数到字符串的转换，转换很多的时候****stringstream****也是我常用并且更喜欢用的。从字符串到整数的方法好像就只能靠这些函数了。******

**记得就前两天看公司的代码，以前有个兄弟特别喜欢用这些函数，连对话框的中各类空间的获取一律都是先获取字符串，然后转换成整数。。。。。可能是不知道有类似****GetDlgItemInt****之类的接口吧。。。。******

## 实现：

MS:

浮点数我没有找到源码。

整数的都通过一个更复杂的函数

```c
static unsigned long __cdecl strtoxl (
        _locale_t plocinfo,
        const char *nptr,
        const char **endptr,
        int ibase,
        int flags
        )
```

来实现。随便看了一眼，就像我个人想实现的话会用的方法一样，从字符串到整数，我应该会通过一个一个字符的计算与'0'字符的ascII值的差，然后相应其位置的乘以10^n，累加到一个整数吧。

整数到字符串可能就是上面方式的反过来。。。。假如不让用sprintf等函数时。（这个我没有看源码了,应该差不多）

gcc:

随便看了一下，也差不多

## 效率测试：

无

## 相关函数：

windows中有一些例如itow等，gcc由于支持C99，C99中的long long类型也有支持，lltoa等。

## 个人想法：

想起一个大牛Lippman说过的话，假如C++抛弃了C那么多的整数类型的话，那么重载函数的负担会小得多。。。。。。。。事实就是这样。

这类函数就是典型的例子。不仅仅是重载麻烦了，并且哪怕一个简单的关于整数的函数，都需要实现很多种，并且在C中需要很多的名字。。。。还好有一定规律。

windows中甚至实现了关于double的此类函数，呵呵，浮点都有两种。

但是，反过来说，当在C++中还有那么多人需要精确的控制自己需要的整数大小，甚至有的时候根本就不是整数，需要的仅仅是一个确定大小的缓存（或空间）时，不同的整数就不可避免。。。。。其实，除非C++将所有的整数全部整合到integer然后将目前用于内存等精细操作的整形放在诸如BYTE，WORD,DWORD中去实现也是不错的选择。。。。当然，很多时候，我们还是需要苛刻的对空间进行要求，对于一个表示类型的变量用unsigned char，对于一个不会大于65535的整数用unsigned short时，（我们公司写游戏和服务器的时候都是这样），这些想法可能永远不会实现。

记得，以前看到mysql的一份文档中，mysql的开发人员甚至以自己的整数类型比较多而感到自豪（也许不是自豪吧），进行了类似这样描述，mysql有丰富的整数类型，这样你可以使用更适合你的整数，在数据很大时，这可以为你省下很大的空间。。。。。。。。。。。the same in C/C++.......................

write by 九天雁翎(JTianLing) -- www.jtianling.com
