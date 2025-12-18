---
layout: post
title: "一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（1） f(x) = 2f(x-1)
  + x^2"
categories:
- C++
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
  views: '4'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

# 一个无聊男人的疯狂数据结构学习（1） f(x) = 2f(x-1) + x^2

write by 九天雁翎(JTianLing) -- www.jtianling.com

 

《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第6面，图1-2，一个递归函数

## C++:

书上已有实现。这里就不贴了，对于没有书的人来说，f(x) = 2f(x-1) + x * x的说明好像也足够了。

 

## lua:

```lua
1 function f(x)  
 2     **if**  (x == 0)  
 3     **then**  
 4         **return**  0;  
 5     **else**  
 6         **return**  2 * f(x -1) + x * x;  
 7     **end**  
 8 end  
 9   
10 \-- Test code  
11 print(f(1))  
12 print(f(2))  
13 print(f(3))  
14 print(f(4))  
15       
```

## python:

```python
1 **def**  f(x):  
 2     'a easy recursive funtion'  
 3     **if**  x == 0:  
 4         **return**  0  
 5     **else** :  
 6         **return**  2 * f(x -1) + x * x  
 7   
 8   
 9 # test code  
10 **print**  f(1)  
11 **print**  f(2)  
12 **print**  f(3)  
13 **print**  f(4)  
14   
```

## bash:

用bash写一个简单的递归竟然也这么难。。。。。。郁闷，这是过了两天自己后来补上的，最后因为vim的上色没有办法直接复制到word和这边，所以通过vim2html的转换后再贴过来：）效果很好啊。

```bash
1 #!/bin/bash  
 2   
 3 function f  
 4 {  
 5     **local**  number=**"** $1**"**  
 6     **if**  **[**  $number **=**  0 **]**  
 7     **then**  
 8         ret=0  
 9     **else**  
10         **let**  **"** decrnum = number - 1**"**  
11         f $decrnum  
12         **let**  **"** ret = $? * 2 + $1 * $1**"**  
13     **fi**  
14   
15     **return**  $ret  
16 }  
17   
18 **for**  i **in**  1 2 3 4  
19 **do**  
20     f i  
21     **echo**  $?  
22 **done**  
23   
```

补充说明一下，这次完全lua,python都是在windows中gvim完成，以后全部放到linux中完成。呵呵，其实作为脚本语言这样移植性非常好的语言来说，主要的区别仅仅是开始第一句linux会多句magic指示，以方便直接在shell中执行而已。主要的目的是以后的vim2html可以通过bash的脚本来一次完成，不需要在windows中通过这么多操作了。：）  

write by 九天雁翎(JTianLing) -- www.jtianling.com