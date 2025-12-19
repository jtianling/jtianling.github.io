---
layout: post
title: "确定Windows XP到底是UCS-2的还是UTF-16的"
categories:
- "网络技术"
tags: []
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

文章澄清Windows XP使用UTF-16编码，而非普遍认为的UCS-2，并解释了两者区别，纠正了这一常见误解。

<!-- more -->

# 确定Windows XP到底是UCS-2的还是UTF-16的

[**write by****九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)****

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

一般认为Windows下以16bit表示的Unicode并不是UTF-16，而是UCS-2。UCS-2是一种编码格式，同时也是指以一一对应关系的Unicode实现。在UCS-2中只能表示U+0000到U+FFFF的BMP([Basic Multilingual Plane](<http://en.wikipedia.org/wiki/Basic_Multilingual_Plane> "Basic Multilingual Plane") ) Unicode编码范围，属于定长的Unicode实现，而UTF-16是变长的，类似于UTF-8的实现，但是由于其字节长度的增加，所以BMP部分也做到了一一对应，但是其通过两个双字节的组合可以做到表示全部Unicode，表示范围从U+0000 到 U+10FFFF。关于这一点，我在很多地方都看到混淆了，混的我自己都有点不太肯定自己的说法了，还好在[《UTF-16/UCS-2》](<http://en.wikipedia.org/wiki/UTF-16>)中还是区别开了，不然我不知道从哪里去寻找一个正确答案。（哪怕在IBM的相关网页上都将UCS-2作为UTF-16的别名列出）

在[《UTF-16/UCS-2》](<http://en.wikipedia.org/wiki/UTF-16>)文中有以下内容：

UTF-16 is the native internal representation of text in the [Microsoft Windows 2000](<http://en.wikipedia.org/wiki/Windows_2000> "Windows 2000")/[XP](<http://en.wikipedia.org/wiki/Windows_XP> "Windows XP")/[2003](<http://en.wikipedia.org/wiki/Windows_2003> "Windows 2003")/[Vista](<http://en.wikipedia.org/wiki/Windows_Vista> "Windows Vista")/[CE](<http://en.wikipedia.org/wiki/Windows_CE> "Windows CE"); [Qualcomm BREW](<http://en.wikipedia.org/wiki/BREW> "BREW") operating systems; the [Java](<http://en.wikipedia.org/wiki/Java_\(programming_language\)> "Java \(programming language\)") and [.NET](<http://en.wikipedia.org/wiki/.NET_Framework> ".NET Framework") bytecode environments; [Mac OS X](<http://en.wikipedia.org/wiki/Mac_OS_X> "Mac OS X")'s [Cocoa](<http://en.wikipedia.org/wiki/Cocoa_\(API\)> "Cocoa \(API\)") and [Core Foundation](<http://en.wikipedia.org/wiki/Core_Foundation> "Core Foundation") frameworks; and the [Qt](<http://en.wikipedia.org/wiki/Qt_\(toolkit\)> "Qt \(toolkit\)") cross-platform graphical widget toolkit.[[1]](<http://en.wikipedia.org/wiki/UTF-16#cite_note-0>)[[2]](<http://en.wikipedia.org/wiki/UTF-16#cite_note-1>)[_[citation needed](<http://en.wikipedia.org/wiki/Wikipedia:Citation_needed> "Wikipedia:Citation needed")_]

[Symbian OS](<http://en.wikipedia.org/wiki/Symbian_OS> "Symbian OS") used in Nokia S60 handsets and Sony Ericsson UIQ handsets uses UCS-2.

The [Joliet file system](<http://en.wikipedia.org/wiki/Joliet_\(file_system\)> "Joliet \(file system\)"), used in [CD-ROM](<http://en.wikipedia.org/wiki/CD-ROM> "CD-ROM") media, encodes filenames using UCS-2BE (up to 64 Unicode characters per file).

Older [Windows NT](<http://en.wikipedia.org/wiki/Windows_NT> "Windows NT") systems (prior to Windows 2000) only support UCS-2.[[3]](<http://en.wikipedia.org/wiki/UTF-16#cite_note-2>). In Windows XP, no code point above U+FFFF is included in any font delivered with Windows for European languages, possibly with Chinese Windows versions.[_[clarification needed](<http://en.wikipedia.org/wiki/Wikipedia:Please_clarify> "Wikipedia:Please clarify")_]

很明确的说明了Windows 2000以后内核已经是UTF-16的了，这点还真是与平时的感觉相违背，于是可以测试一下。在[UTF-16的编码转换函数（Python实现）](<http://www.jtianling.com/archive/2009/03/01/3946271.aspx>)中我在windows下输出了三个太玄经的字符，“****
