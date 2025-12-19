---
layout: post
title: UCS-2与UTF8之间的选择（2）--Unicode组织提供的C/C++的Unicode编码转换函数
categories:
- "网络技术"
tags:
- C++
- UCS-2
- Unicode
- UTF-8
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '5'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文评测了Unicode组织提供的C/C++转换函数，认为其轻量好用，适合UTF-8与UTF-16互转，并重点解析了其基于指针的高效设计与使用注意。

<!-- more -->

# UCS-2与UTF8之间的选择（2）--Unicode组织提供的C/C++的Unicode编码转换函数



这里我大概搜索到了3个库，一个是Unicode组织自己提供的，一个是IBM做的开源ICU工程中的，一个是开源的UCData 2.9。

但是UCData2.9中并没有UTF-16,通篇都是为UTF-32设计的，属于那种将来可能会用的到的库，因为目前Windows与Linux的内核都还没有UTF-32化，注定假如使用UTF-32将会在两个地方都失去性能优势。

于是剩下的两个选择就很有意思了，一个是Unicode自己提供的那几个简单的转换函数，一个是IBM提供的一个巨无霸的库，一个Unicode的相关库到了10M的确算是很夸张的了，难怪被别人称作蓝色巨人，干什么都是大手笔，就像它出品的软件工程软件一样，哪一个都是出手不凡，一出一个系列，每个都大的要命。感叹。。。。。

从C/C++的库的角度，我就只查看这两个了。

## Unicode组织的函数：（甚至不能称作库）

这些函数很好用，并且自带了测试套件。

在windows中，新建一个空的工程，并将ConvertUTF.h,CVTUTF7.h,CVTUTF7.C,harness.c添加到工程中，编译，运行，既可以运行测试例程，utf7这个我们一般用不上，其实也可以不添加。在我的VS2005 SP1中，运行结果如下：

Three tests of round-trip conversions will be performed.

One test of illegal UTF-32 will be peroformed.

Two illegal result messages are expected; one in test 02A; one in test 03A.

These are for tests of Surrogate conversion.

Begin Test01

******** Test01 succeeded without error. ********

Begin Test02

Test02A for 55296, input 0000d800, output 0000,0000, result 3

!!! Test02A: note expected illegal result for 0x0000D800

******** Test02 succeeded without error. ********

Begin Test03

sourceIllegal   Test03A for 55296 (0xd800); output ; result 3

!!! Test03A: note expected illegal result for 0x0000D800

******** Test03 succeeded without error. ********

Begin Test04

******** Test04 succeeded without error. ********

很显然的4个测试全部通过，没有任何错误。

提供的我们可能需要的函数有：

isLegalUTF8Sequence()—判断一个字符串是否是合法的UTF8字符串

ConvertUTF8toUTF16()—转换UTF8字符串到UTF16

ConvertUTF16toUTF8()—转换UTF16字符串到UTF8

原型：

```c
ConversionResult ConvertUTF8toUTF16 (
       const UTF8** sourceStart, const UTF8* sourceEnd, 
       UTF16** targetStart, UTF16* targetEnd, ConversionFlags flags);
```

```c
ConversionResult ConvertUTF16toUTF8 (
       const UTF16** sourceStart, const UTF16* sourceEnd, 
       UTF8** targetStart, UTF8* targetEnd, ConversionFlags flags);
```

所有的函数采取的结尾判断方式是传递一个结束的指针位置，而不是常见的长度。

其提供的几个宏也很有用：

```c
typedef unsigned long    UTF32; /* at least 32 bits */
typedef unsigned short   UTF16; /* at least 16 bits */
typedef unsigned char    UTF8;  /* typically 8 bits */
typedef unsigned char    Boolean; /* 0 or 1 */
```

Boolean在C++中似乎是不怎么需要.

/* Some fundamental constants */

```c
#define UNI_REPLACEMENT_CHAR (UTF32)0x0000FFFD
#define UNI_MAX_BMP (UTF32)0x0000FFFF
#define UNI_MAX_UTF16 (UTF32)0x0010FFFF
#define UNI_MAX_UTF32 (UTF32)0x7FFFFFFF
#define UNI_MAX_LEGAL_UTF32 (UTF32)0x0010FFFF
```

很有价值的几个宏，除了都强制转换为UTF32比较郁闷，UNI_MAX_BMP，UNI_MAX_UTF16可以用的上。

```c
typedef enum {
    conversionOK,      /* conversion successful */
    sourceExhausted,  /* partial character in source, but hit end */
    targetExhausted,  /* insuff. room in target for conversion */
    sourceIllegal     /* source sequence is illegal/malformed */
} ConversionResult;
```

这是上述那几个函数的返回值，英文注释解释的很清楚了。

```c
typedef enum {
    strictConversion = 0,
    lenientConversion
} ConversionFlags;
```

这是那几个函数的第五参数，一个表示严格转换，一个表示宽容的转换

排除harness.c，不编译，添加ConvertUTF.c，自己制作一个测试：

```cpp
// Unicode.cpp : 定义控制台应用程序的入口点。
//
#include <stdio.h>
#include <tchar.h>
#include <windows.h>
#include "ConvertUTF.h"

int _tmain(int argc, _TCHAR* argv[])
{
    ConversionResult result = sourceIllegal;
    UTF16 utf16_buf[8] = {0};
    utf16_buf[0] = 0xd834;
    utf16_buf[1] = 0xdf00;
    utf16_buf[2] = 0xd834;
    utf16_buf[3] = 0xdf01;
    utf16_buf[4] = 0xd834;
    utf16_buf[5] = 0xdf02;
    utf16_buf[6] = 0;
    utf16_buf[7] = 0;
    UTF16 *utf16Start = utf16_buf;
    UTF8 utf8_buf[16] = {0};
    UTF8* utf8Start = utf8_buf;

    MessageBoxW(NULL, (LPWSTR)utf16_buf, L"Before trans", MB_OK);
    result = ConvertUTF16toUTF8((const UTF16 **) &utf16Start, &(utf16_buf[6]), &utf8Start, &(utf8_buf[16]), strictConversion);
    switch (result) {
       default: fprintf(stderr, "Test02B fatal error: result %d for input %08x/n", result, utf16_buf[0]); exit(1);
       case conversionOK: break;
       case sourceExhausted: printf("sourceExhausted/t"); exit(0);
       case targetExhausted: printf("targetExhausted/t"); exit(0);
       case sourceIllegal: printf("sourceIllegal/t"); exit(0);
    }

    // 清空缓存，以确定以后的值的确是转换得来
    ZeroMemory(utf16_buf, sizeof(utf16_buf));

    // 由于转换中利用了这两个start，所以需要重新为start定位,并且保存住End值
    UTF8* utf8End = utf8Start;
    utf8Start = utf8_buf;
    utf16Start = utf16_buf;

    result = ConvertUTF8toUTF16((const UTF8 **) &utf8Start, utf8End, &utf16Start, &(utf16_buf[6]), strictConversion);
    switch (result) {
       default: fprintf(stderr, "Test02B fatal error: result %d for input %08x/n", result, utf16_buf[0]); exit(1);
       case conversionOK: break;
       case sourceExhausted: printf("sourceExhausted/t"); exit(0);
       case targetExhausted: printf("targetExhausted/t"); exit(0);
       case sourceIllegal: printf("sourceIllegal/t"); exit(0);
    }

    MessageBoxW(NULL, (LPWSTR)utf16_buf, L"After Trans", MB_OK);

    return 0;
}
```

利用的还是以前的太玄经字符，经测试，两次的MessageBox显示均正常，唯一需要注意的是由于转换函数的第1，3个参数都是以指针的指针为参数，并且跟进实现中可以发现，实现中利用了此指针的偏转来完成长度的判断，并且利用此值作为结束的返回，好处自然是还是以指针作为结束的返回了，坏处就是你需要重新利用的时候需要重新定位。如上述源代码及中间的注释所示，这可能也就是这些函数唯一需要注意的地方了，因为和平时对长度的判断不同。

至于为什么要这样做，可能是出于效率的考虑，就像C语言中以NULL为字符串的结束标志而不是在字符串前加一个长度一样，虽然此点因为容易导致严重的越界问题而被人诟病，但是实际上，这样比记长度能够更加有效率的处理字符串是很多人没有发现的。

当以某个值为结束标志（比如C 语言中的NULL）时，遍历只需要偏移起始指针，并在循环每次做一个判断，大概如下形式，这样每次循环只需要一次的比较，一次的++。

```cpp
for(; p != NULL; ++p) 
{ 
    // 此处可以直接处理*p了
}
```

假如是长度呢？

可能需要如下形式，一方面需要额外的一个临时变量，一方面对字符串中值的调用效率也更加低了。而这些消耗在以'/0'结尾时就不存在。

```cpp
for(int i = 0; i < END; ++i)
{
       // p[i]或者p+i的处理方式
}
```

这点也很好解释，为什么到了C++中迭代器还是喜欢用类似的形式：）

```cpp
for(lit = container.begin(); lit != container.end(); ++lit) 
{
 // 直接使用 *lit
}
```

这在效率至上的世界中，很好理解。

