---
layout: post
title: "一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（2） IntCell类"
categories:
- Lua
- Python
- "算法"
tags:
- Bash
- C++
- Lua
- Python
- "《数据结构与算法分析-C++描述》"
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

  

# 一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（2）  
IntCell类

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

 

《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第8面，图1-5，一个最最简单的类

刚开始都是太简单没有技术含量的东西，这样也好，不至于把我吓到，毕竟lua学了已经4个月了，python学了已经2个月了都没有怎么用，而sh虽然最近才学，但是实践的也是这么少。。。。。唯一已经不用思考语法的就是C++了吧。。。呵呵C++和汉语一样都是我的“母语”，虽然全世界人都说他复杂，但是用了这么久也就习惯了。

python就像英语，本身语法比较简单，但是学的比较晚，（相对于汉语/C++），所以暂时不能完全体会它的好处，但是学的时间越久你就会越喜欢：）最最让人郁闷的是词汇（库）丰富的让你想哭，要掌握全太难了。呵呵平时虽然看的多，却说/写的少。

lua就像是日语吧，虽然学过，知道其基本的发音（语法），但是却从来不说（不写代码），最多丢几句（写几段）最最简单的东西。

bash就像是韩语，想去学，但是看着头晕，奇形怪状的字符（语法）让人不得其要领。

  
以下为实现部分: 

CPP:   
书上已有实现。

  
  

LUA: 

 1  
#!/usr/bin/env  
lua  
 2   
 3 IntCell = **{**  storedValue = 0 **}**  
 4   
 5 function IntCell:new(orig)  
 6     **if**  type(orig)  
== "number"  
 7     **then**  
 8         o  
= **{}**  
 9         o.storedValue  
= orig  
10     **else**  
11         o  
= orig **or**  **{}**  
12     **end**  
13     setmetatable(o, self)  
14     self.__index =  
self  
15     **return**  o  
16 end  
17   
18 function IntCell:read()  
19     **return**  self.storedValue  
20 end  
21   
22 function IntCell:write(x)  
23     self.storedValue

= x  
24 end  
25   
26 \-- test code  
27 \-- new IntCel  
and read and write  
28 a = IntCell:new()  
29 print ("a:" .. (a:read()))  
30 a:write(10)  
31 print ("a:" .. (a:read()))  
32   
33 \-- create  
IntCell from a  
34 b = IntCell:new(a)  
35 print ("b:" .. (b:read()))  
36   
37 \-- create  
IntCell from a number  
38 c = IntCell:new(100)  
39 print ("c:" .. (c:read()))  

PYTHON: 

 1  
#!/usr/bin/env  
python  
 2   
 3 **class**  IntCell(object):  
 4     **def**  __init__(self,  
orig = 0):  
 5         self.storedValue  
= orig   
 6     **def**  read(self):  
 7         **return**  self.storedValue  
 8     **def**  write(self,x):  
 9         self.storedValue  
= x   
10   
11 # Test Code  
12 **def**  Test():  
13     a = IntCell()  
14     **print**  "a:" +  
str(a.read())  
15     a.write(10)  
16     **print**  "a:" +  
str(a.read())  
17   
18     b = IntCell(100)  
19     **print**  "b:" +  
str(b.read())  
20   
21 **if**  __name__ == '__main__':  
22     Test();  
23   
24           
25   

BASH: 

1 没有类的概念。。。也没有办法像lua一样模拟出来（就我所知）

 **_write by_**** _九天雁翎(JTianLing)  
\-- www.jtianling.com_**

 
