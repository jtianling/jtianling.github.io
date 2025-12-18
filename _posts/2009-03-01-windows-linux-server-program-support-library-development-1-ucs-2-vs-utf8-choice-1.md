---
layout: post
title: windows/linux服务器程序支持库的开发（1）--UCS-2与UTF8之间的选择（1）
categories:
- "网络技术"
tags:
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
  views: '16'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

# windows/linux服务器程序支持库的开发（1）--UCS-2与UTF8之间的选择（1）

 

[**write by****九天雁翎(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)****

[**讨论新闻组及文件**](<http://groups.google.com/group/jiutianfile/>)

总体计划见：

#  [工作之外的学习/开发计划(1) -- windows/linux服务器程序支持库的开发](<http://www.jtianling.com/archive/2008/09/29/2998733.aspx>)

 

此为序篇。

 

## 首先纠正几个名词

作为常常在windows下开发的人员，一般将windows下的Unicode实现直接称为Unicode，（比如我在前面就一直是这样做的），而把其他的Unicode实现称为更加具体的名称，比如UTF-8,UTF-16等，但是既然这里要讨论各种Unicode的实现，所以，还是得好好的区分一下，这里，将windows下的Unicode实现正名为UTF-16，但是遗憾的是，我发现Windows下的字符串处理函数实际仅仅是支持UCS-2的(在Window XP下测试结果)，所以从编程的角度来讲，我们还是只能使用UCS-2，见文章《[确定Windows XP到底是UCS-2的还是UTF-16的](<http://www.jtianling.com/archive/2009/03/01/3947054.aspx>)》，所以，这里都不混淆的情况下都以UCS-2代替。

       以一个字符对应一个Unicode编码，并且要表达全部的Unicode编码，连普通的两个字节的wchar_t都不够，所以，现在有了新的UTF-32,gcc中wchar_t也默认已经是32位的了，顺应的就是这种潮流，毕竟，在现在，硬盘内存都当白菜卖了，相对而言，不在乎那么点空间，最最重要的是编程方便，还有速度。

关于此部分内容参看[《UTF-16/UCS-2》](<http://en.wikipedia.org/wiki/UTF-16>)。

关于Unicode的编码范围的内容参看[《Mapping of Unicode character planes》](<http://en.wikipedia.org/wiki/Basic_Multilingual_Plane>)。

 

名字缩写注释：

**通用字符集****(Universal Character Set, UCS)**

**统一码转换格式（****Unicode Transformation Format****，****UTF****）******

** **

 

## 其次，讲讲Unicode

假如初次接触，那么要了解清楚Unicode还不是那么简单的事情，这是实话。当年语言编码混乱的时代，一种语言的软件不能正常的在另外语言的操作系统上显示，编多语言的程序是件非常痛苦的事情，编写一个可以在不同操作系统上都显示正确字符的软件那是高难度的事情。当时呼吁统一编码的呼声很高，原以为Unicode一出，将来的程序员将是无比幸福，甚至都不会了解什么叫编码，什么叫代码页（Codepage），因为已经不用考虑了。

但是，事实是残酷的，当Unicode比较普及了以后，由于历史的原因，光是Unicode本身的实现的种类过多，导致的各个操作系统不兼容的问题，都能够让程序员苦恼痛苦不已，比如，现在要做的UTF-8与UCS-2之间的选择。可能无论哪个初学windows的人都会迷惑于其A,W的函数结尾，初学MFC编程的人都会为其中大量的_T()使用感到莫名其妙，这些，其实都是历史原因，为了当时一代程序员的理想，用一套源码，实现ASCII和UCS-2两套编码兼容。

由于Windows的内核都已经是UTF-16化了，所以实际的开发中，即使不用到除英语以外的语言，使用Unicode其实都是有益的，起码对于现在的速度比内存更重要的时候，一般是有益的，因为使用UCS-2最多是字符多占用了一倍的内存，而使用ASCII实际是影响了所有字符串有关的API函数调用的速度。对于现实中几乎完全不可能去使用ASCII编译程序的中国程序员，还是按照老美们为了他们的习惯去规定的_T()模式，至今，我还感叹不已，毕竟，计算机的教育水平，国外和国内的话语权不是一个量级的，个人也是几乎看着“洋书”成长的，啃过英文原版技术书籍，而且哪怕是中文版的MSDN其实也是英文居多，所以，我们竟然会有这样符合老美们特殊国情的编程习惯-_-!

       闲话少说，关于Unicode的起源发展，我在一篇《[UTF-8和Unicode的FAQ](<http://www.linuxforum.net/books/UTF-8-Unicode.html>)》文档中见到过。这里是其英文版《[UTF-8 and Unicode FAQ for Unix/Linux](<http://www.cl.cam.ac.uk/~mgk25/unicode.html>)》。

在Unicode组织的官方主页上 [http://unicode.org/](<http://unicode.org/>) 的顶头，有这么一段话：

Welcome! The [Unicode Consortium](<http://www.unicode.org/consortium/consort.html>) enables people around the world to use computers in any language. [Our members](<http://www.unicode.org/consortium/memblogo.html>) develop the [Unicode Standard](<http://www.unicode.org/standard/standard.html>), [Unicode Locales (CLDR)](<http://www.unicode.org/cldr/>), and other standards. These [specifications](<http://www.unicode.org/faq/specifications.html>) form the foundation for software internationalization in all major operating systems, search engines, applications, and the Web.

他们一点也不夸张，Unicode正是所有主要操作系统，搜索引擎，应用程序和网页的软件国际化的基础。这里我突然想起以前给lua for windows提交的那个库中的bug时，lua for windows的作者竟然回了两个中文字“关心”给我^^（虽然我不知道什么意思），见《[真高兴啊。。。。实际的为开源事业做了点点贡献：），很久前指出的一个lua stdlib的bug得到确认](<http://www.jtianling.com/archive/2008/10/27/3153533.aspx>)》这在以前是不可想象的，因为在以前，英文的操作系统中要输出并显示个中文谈何容易啊。

这里我引用MS的话来说明一下Unicode的威力：

 “采用支持 Unicode 的单源代码库使开发时间得以缩短，Unicode 为 Microsoft 带来的好处是显而易见的。就 Windows® 2000 来说，在发布英文产品后需要花费几个月的时间来准备其本地化版本。而对于 Windows XP，这一周期已缩短为几周时间。”—MS《[通过 Unicode 5.0 将您的应用程序应用到全球](<http://msdn.microsoft.com/zh-cn/magazine/cc163490.aspx>)》

这就是Unicode的威力，为程序员节省的时间是从几个月到几周这个量级。

 

## 候选的UTF-8/UCS-2

现在开发软件用Unicode，当然是没有疑问了。在windows下面直接用UCS-2估计也没有疑问。但是考虑的可移植的时候，问题就来了，目前Linux的内核Unicode实现都是UTF-8的，并且gcc新版的wchar_t已经是新标准的4字节了，这样就算同样的宽字符接口，可能也不一定和windows的wchar_t兼容，要用同一套代码可能还得设置-fshort-wchar的编译选项，看看这样的mannul说明，就知道这样做不是什么长久之计（我们公司一直这样做）：

```text
-fshort-wchar

Override the underlying type for wchar_t to be short unsigned int           instead of the default for the target.  This option is useful for building programs to run under WINE.

Warning: the -fshort-wchar switch causes GCC to generate code that is not inary compatible with code generated without that switch. Use it to conform to a non-default application binary interface.
```

这样个人感觉也不是什么长久之记，其实还不如用UTF8方便，用UTF8的坏处很明显，那就是处理的函数少一些，而且，字符的长度不一，不如UNICODE好处理。

这里真是个两难的选择，我需要好好研究研究，以后暂时遵循这个规则，之所以说暂时，原因很简单，我个人认为，将来UTF-32才是主流的编码方式，并且UTF-32也是以后唯一需要的编码方式。

 

## 首先，从理论上分析各自的优点缺点：

UTF8:

优点：

1.UCS 字符 U+0000 到 U+007F (ASCII) 被编码为字节 0x00 到 0x7F (ASCII 兼容)。 这意味着只包含 7 位 ASCII 字符的文件在 ASCII 和 UTF-8 两种编码方式下是一样的。意味着完美兼容ASCII。--《UTF-8 and Unicode FAQ》

2.Linux的内核是UTF88的，意味着在Linux下使用UTF8有得天独厚的优势。而且不仅仅是Linux，大量的开源计划（由于大部分开源计划都是围绕着Linux走的），包括网页，XML等也都是原生UTF-8的，可参考源程序范例更多。

3.由于其单字节编码的方式，不用考虑大头小头的字节序问题。

4.以英文为主的数据在存储时，占用的空间较小。

 

缺点：

1.  大量的组合字符（即用两个以上字节来表示一个字符），使得字符串的处理很不方便。有着和任何变长编码一样的痛苦。并且因为这个原因，当字符超出ASCII范围时，原有的C/C++字符串函数运行结果都不会是你想要的。

2.  以非ASCII字符为主的数据在存储时，占用空间较大。

 

 

UCS-2：

优点：

1.统一定长编码，都是两个字节对应一个字符，所以对于字符串的处理非常方便。没有变长的痛苦。大量的宽字节C/C++函数都可以直接使用。

2.Windows的内核是UTF-16的，但是由于UCS-2仅仅是UTF-16的一个子集，所以在Windows下使用UCS-2，有得天独厚的优势。另外，从资料上看，使用UTF-16/UCS-2的操作系统阵营比使用UTF-8的更加庞大。见《[UTF-16/UCS-2](<http://en.wikipedia.org/wiki/UTF-16>)

》的“Use in major operating systems and environments”一节，带来的好处是，在与不同语言/平台的程序（毕竟我要写的是网络程序）进行通信时，会更加方便。

 

缺点：

1.在 Unix 下使用 UCS-2 (或 UCS-4) 会导致非常严重的问题. 用这些编码的字符串会包含一些特殊的字符, 比如 '/0' 或 '/', 它们在 文件名和其他 C 库函数参数里都有特别的含义. 另外, 大多数使用 ASCII 文件的 UNIX 下的工具, 如果不进行重大修改是无法读取 16 位的字符的. 基于这些原因, 在文件名, 文本文件, 环境变量等地方, **UCS-2** 不适合作为 **Unicode** 的外部编码. --《UTF-8 and Unicode FAQ》，实际其意思就是原有的C语言字符串函数将完全失效，哪怕你用的就是ASCII字符也是这样。

 

## 计划：

上述的比较仅仅是理论上的，并且似乎难决高下，以下将具体的分别在Linux，Windows不同的环境下尝试使用UCS-2和UTF-8，以做出决定。

大概会尝试的有：

C/C++ 中使用，Python中使用，Lua中使用，正则表达式的使用。

 

## 题外话：

之所以花这么多时间来研究这个问题，出于很多原因，有人说，编程的主要时间是花在进行字符串的处理上了，而现在这样的选择，将会决定以后我大部分时间是否是会更长，还是更短，是更容易，还是更难的问题。而且，对程序的效率，空间占用，肯定也是有影响的。对于初学者来说，一般用ANSI学习就完了，到了真实的使用，这些问题的考虑，甚至比可以想象的还要重要。

对于这个话题，著名开源计划Samba的发起人**Andrew Tridgell** ，曾经在为Samba适应Windows的UCS-2时，提出了一个移植计划，一步一步的将Samba的内核从UTF-8移植到UCS-2.  《[utf8 vs ucs2](<http://lists.samba.org/archive/samba-technical/2001-May/014068.html>)》，颇有味道：）对于同样致力于跨平台程序编写的我，也是指导意义很多。毕竟作为一个不准备在Windows下运行，而是仅仅需要与Windows进行通行的一个程序，最后都需要将内核全面的UCS-2化，而我的程序是不仅仅是需要与Windows下程序通信，并且还需要能够在Windows下运行的，是不是更应该用UCS-2呢？有待研究。另外，我还找到了一个在UNIX/Linux下使用UCS-2的范例：）开源就是好啊。

而我公司使用的是UCS-2，主要是因为客户端是肯定跑在Windows下而且是肯定不需要跑到Linux下的，而作为网络游戏，自然以客户端的效率为主，所以服务器多了一下无谓的字符转换操作也接受了。

UCS-2还是UTF-8，需要继续研究...................................

 

 

参考：

[UTF-8, UTF-16, UTF-32 & BOM](<http://unicode.org/faq/utf_bom.html>)

[UTF-16/UCS-2](<http://en.wikipedia.org/wiki/UTF-16>)

[Unicode详解](<http://tech.idv2.com/2008/02/21/unicode-intro/> "永久链接: Unicode详解")—想当棒的中文讲解

 

 

[**write by****九天雁翎****(JTianLing) -- www.jtianling.com**](<http://www.jtianling.com>)