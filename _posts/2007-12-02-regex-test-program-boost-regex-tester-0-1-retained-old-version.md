---
layout: post
title: "正则表达式测试程序（Boost Regex Tester）0.1(老版保留)"
categories:
- "我的程序"
tags:
- "正则表达式"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '22'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

在昨天我编写了一个制作图书检索的小程序后，真的发现人们说的话太正确了。程序员主要处理的就是两件事，数据库，字符串。在那么一个小程序里，我已经用上了STL的很多特征，而且基本操作起码都在string级别以上，但是还是繁复的要命。所以终于下定决心要学习一下极为有用却堪称天书的正则表达式。在学习的过程中用VS .NET IDE中的搜索实践了一下，发现还是不太方便，而且微软的东西好像不是很保险（主要指规范性上）。并且在C++中要用到正则表达式好像只能用boost库，那么我当然最好是熟悉boost库中的正则表达式的法则啦，干脆，做了一个利用boost实现的测试程序得了。

<!-- more -->

最后发现，正确的使用boost.regex 难度远远比正确使用regex还高，我没有见过设计的这么复杂的类和函数。硬是仔细的看了几遍在线文档才摸清头绪，最终好不容易完成了这个小程序。使用上没有什么好说的，上面输入正则表达式，下面为查找的字符串。另外，对于此boost库还有很多不明白的，比如不知道匹配的字符串在原字符串的位置怎么定位？

正则表达式 /bsss/b 可以匹配 ssss sss 中的最后三个sss，可是我怎么能从regex_search函数返回值中得到这样的结果呢？因为match_results中并没有包含位置信息，只有最后查到的字符串而已。因为这点不明，所以我没有办法把程序做成Windows中查找程序那样的结果表示方式。

编译好的程序和源代码都还是在[http://groups.google.com/group/jiutianfile/files](http://groups.google.com/group/jiutianfile/files)中有下载

程序截图如下：![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/Boost Regex Tester.jpg)
