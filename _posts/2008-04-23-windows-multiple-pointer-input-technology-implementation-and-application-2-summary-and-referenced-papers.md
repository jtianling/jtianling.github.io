---
layout: post
title: Windows中多指针输入技术的实现与应用（2摘要及参考论文）
categories:
- "我的程序"
tags:
- Windows
- "多鼠标"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '3'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---


# Windows中多指针输入技术的实现与应用

## 摘 要

多指针设备输入在很多情况下有很大的优势。但是微软的Windows本身并不支持此技术，让程序在Windows下支持多个指针设备，并且控制各自独立的光标就成了软件设计者问题。本文介绍了目前可行的，底层和利用框架软件实现的两大类方法。在底层实现中，详细讲述了利用RawInput技术实现多鼠标输入的原理。在框架软件实现中，详细讲述了一种多鼠标输入框架软件Single Display Groupware Toolkit的实现原理。并对各种方法进行了简单描述和总的对比，其中开发过滤式鼠标驱动的方法主要用来开发框架级程序；RawInput技术因为优点明显，被各层次的软件所利用；CPNmouse库是对通用多指针输入软件开发很好的尝试，但是并不是太成功；MultiPoint SDK虽然由微软推出，可是目前并不成熟；Single Display Groupware Toolkit综合了以上各技术的很多优点，缺点比较少，软件相对成熟，使用比较简单。本文推荐实现Windows中多指针输入技术的方法为使用Single Display Groupware Toolkit。最后简单介绍了Single Display Groupware的具体使用方法。因为Single Display Groupware Toolkit在MFC中使用不是那么方便，所以最后讨论一下在MFC中怎么自己实现和利用此技术，然后给出两个实例研究。

<!-- more -->

**关键词：**计算机；Windows；SDG；多指针设备；多鼠标

# implementation and application of multiple pointing devices inputing in the Windows

## Abstract

There are comparative advantages of multiple pointing input devices in many conditions. But Microsoft Windows does not natively support this technique, so programmers have to control independent mice and cursors themselves. In this paper, I described two kinds of general solutions, included implementation from bottom level and applying the framworks. And I described how to use RawInput and represented how Single Display Groupware Toolkit works in detail. In this paper, I compared five solutions. Developing filter mouse drive mainly used by the framework software; Because of RawInput technique's distinct advantages, this technique is used by various layers software; CPNmouse library is a good attempt to implement, but it is not all succeed; Though MultiPoint SDK developed by Microsoft, it is not mature; Single Display Groupware Toolkit integrated many advantages of the technique I mentioned before, and less shortcomings, more mature than them. And it is very easy to use, so I recommended the Single Display Groupware Toolkit in this paper to implement multiple pointing devices inputing in the Windows. In the end of this paper, I presented how to use it.

**Key Words:** computer;Windows;SDG;multiple pointing devices;multiple mice

因为在网上发布此文，所以为了方便网上阅读，我更改了论文的格式，添加了一些后来加入的信息，另外，首先就加入参考的文章，方便查阅，而且因为要修改和添加我没有办法一次将所有文章都发上来，先发参考文献也有助于感兴趣的朋友自己先去学习。参考文献的标注格式是按照湖南大学的论文标准做的，应该很好懂。

# 参考文献

[1] A. Silberschatz,P.Galvin,G.Gagne.操作系统概念[M].北京:高等教育出版社, 2002：3-4.

[2] 邓天卓.指针设备史.[EB/OL]. http://it.sohu.com/20041010/n222409012.shtml, 2004-10-10.

[3] B. B. Bederson,J. Stewart, A.Druin. Single Display Groupware：A Model for Co-present Collaboration [R]. Pittsburgh, PA, USA: HCIL Technical Report No. 98-14.1998.

[4] K. Jensen.Coloured Petri Nets.Basic Concepts,Analysis Methods and Practical Use.Volume 1, Basic Concepts.[M].Springer-Verlag,1992.

[5] U. S. Pawar, J. Pal, K. Toyama.Multiple Mice for Computers in Education in Developing Countries.[DB/OL]. http://tier.cs.berkeley.edu/docs/ict4d06/multiple_mice-jp.pdf.

[6] E. A. Bier,S. Freeman. MMM: A User Interface Architecture for Shared Editors on a Single Screen.[A]. Proceedings of the 4th annual ACM symposium on User interface software and technology.[C]. Hilton Head, South Carolina, United States: ACM Press New York, NY, USA,1991: 79-86.

[7] P.Hutterer,B. H. Thomas. Groupware Support in the Windowing System.[R]. Australia: Wearable Computer Laboratory School of Computer and Information Science,University of South Australia.

[8] R.Wash. With Windows MultiPoint, Youths in Developing-World Classrooms Learn 21st-Century Skills.[DB/OL]. http://www.microsoft.com/presspass/features/2006/dec06/12-14MultiPoint.mspx, 2006-12-4.

[9] M. Westergaard. Supporting Multiple Pointing Devices in Microsoft Windows.[R]. Aarhus:Department of Computer Science, University of Aarhus.2002.

[10] E.Tse,S. Greenberg.Rapidly prototyping Single Display Groupware through the SDGToolkit. [A].Proceedings of the Fifth Conference on Australasian User interface - Volume 28.[C].Dunedin, New Zealand: Cockburn, Ed. ACM International Conference Proceeding.101-110.2004.

[11] E. Tse,S. Greenberg.SDGToolkit: A Toolkit for Rapidly Prototyping Single Display Groupware.[R].Calgary, Alberta, Canada:Department of Computer Science University of Calgary.2002

[12] E.Tse.The Single Display Groupware Toolkit.[D].CALGARY, ALBERTA.2004
