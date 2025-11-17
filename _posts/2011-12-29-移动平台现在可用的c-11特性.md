---
layout: post
title: "移动平台现在可用的C++ 11特性"
categories:
- C++
tags:
- C++ 11
- Mobile
status: publish
type: post
published: true
meta:
  views: '1623'
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  _aioseop_title: "移动平台现在可用的C++ 11特性"
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

移动平台特指iOS和Android，并且Android使用的是NDK,因为开发的时候是在Win32平台下，所以还需要考虑VS的支持。

当前(2011-12-21)最新的版本：

Win32： Visual Studio 2010

Android NDK： GCC 4.4.3

iOS: Apple LLVM compiler 3.0（Clang)

  

本文所描述的C++ 11特性仅在上述三个平台，所写的版本号中有效，请先确认这点。

在[apache的WIKI](<http://wiki.apache.org/stdcxx/C%2B%2B0xCompilerSupport>)上有个较为详细的列表。可以看到，现在能用的特性其实不怎么多：

  1. auto
  2. decltype
  3. extern template
  4. long long
  5. New function declaration syntax for deduced return types
  6. Right Angle Brackets
  7. R-Value References
  8. static_assert
  9. Built-in Type Traits

如下图：

[![](http://www.jtianling.com/wp-content/uploads/2011/12/C++0xCompilerSupport-759x1024.png)](<http://www.jtianling.com/wp-content/uploads/2011/12/C++0xCompilerSupport.png>)

上面是整体的描述，具体的各个编译器对C++ 11的支持情况见下面的链接：

Win32：

Visual Studio 2010支持情况：[C++0x Core Language Features In VC10: The Table](<http://blogs.msdn.com/b/vcblog/archive/2010/04/06/c-0x-core-language-features-in-vc10-the-table.aspx>)

[Lambdas, auto, and static_assert: C++0x Features in VC10, Part 1](<http://blogs.msdn.com/b/vcblog/archive/2008/10/28/lambdas-auto-and-static-assert-c-0x-features-in-vc10-part-1.aspx>)

[Rvalue References: C++0x Features in VC10, Part 2](<http://blogs.msdn.com/b/vcblog/archive/2009/02/03/rvalue-references-c-0x-features-in-vc10-part-2.aspx>)

[decltype: C++0x Features in VC10, Part 3](<http://blogs.msdn.com/b/vcblog/archive/2009/04/22/decltype-c-0x-features-in-vc10-part-3.aspx>)

Visual Studio 2011支持情况：[C++11 Features in Visual C++ 11](<http://blogs.msdn.com/b/vcblog/archive/2011/09/12/10209291.aspx>)

Android NDK： GCC 4.4.3

[Status of Experimental C++0x Support in GCC 4.4](<http://gcc.gnu.org/gcc-4.4/cxx0x_status.html>)

[C++0x/C++11 Support in GCC](<http://gcc.gnu.org/projects/cxx0x.html>)

iOS:

Apple LLVM compiler 3.0（Clang)：[C++ and C++'11 Support in Clang](<http://clang.llvm.org/cxx_status.html>)

[The LLVM Compiler Infrastructure](<http://llvm.org/Users.html>)

 

使用方式：

1.Build Options选择Apple LLVM compiler 3.0

2."Apple LLVM compiler 3.0 - Language"中"C++ Language Dialect"选择“C++0x" (

3.”C++ Standard Library"选择libc++(LLVM C++ standard library with C++ '0X support)" (默认为"Compiler Default")

其他有意思的东西：

["libc++" C++ Standard Library](<http://libcxx.llvm.org/>)

[在线试用LLVM编译器](<http://llvm.org/demo/>)

最新修改的原文[所在地址](<http://www.evernote.com/shard/s16/sh/e2a8b580-3ce0-4be6-96b8-8cee9e607468/566be76682b8d26f1d06946c61332708> "移动平台现在可用的C++ 11特性")。

  

原创文章作者保留版权 转载请注明原作者 并给出链接

[**九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com/> "write by 九天雁翎\(JTianLing\) -- www.jtianling.com")
