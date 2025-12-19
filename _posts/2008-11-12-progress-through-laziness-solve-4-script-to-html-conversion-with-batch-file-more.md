---
layout: post
title: "人类是在偷懒中进步的,用一个windows批处理解决4个脚本到html的转换+更多"
categories:
- "未分类"
tags:
- HTML
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

作者利用Windows批处理脚本，将多种代码文件自动转换为带语法高亮的HTML，把繁琐工作简化为一键操作。

<!-- more -->

## 人类是在偷懒中进步的,用一个windows批处理解决一切


相当的郁闷啊，本来写了很多东西了，一步一步分析我是怎么偷懒的。。。结果因为误点了firefox的一个按钮，什么东西都没有了，血的教训啊，我再也不在线写东西了。

首先，鉴于没有现成的很好的方法来为我的lua,python,bash脚本色彩鲜艳一点，并且缩进也很符合要求，我本来是想在ubuntu下面用一个脚本来通过vim2html实现所有我想要的功能，结果发现vim在控制台下生成的东西颜色都不太好。毕竟那里是颜色深的低为主的世界。（别说gvim，我没有装X11，更没有在编译vim的时候加上GUI选项）。

于是只好放到windows中来做了，就昨天的效果，虽然操作麻烦了点，其实效果还是很不错的：）

既然学了那么多脚本技术，批处理更是不再话下了吧，虽然没有系统学过，搞了几篇教程就上了。

解决一次转换4个文件的方法很简单，脚本如下：

```bat
set CPP= cpp/dsaa%1.cpp
set LUA= lua/dsaa%1.lua
set PY= py/dsaa%1.py
set SH= sh/dsaa%1.sh
rem 没有用start是为了保证一个一个执行
gvim -c ":syntax on|:colo 
default|:TOhtml" -c ":w|:qa" %CPP%
gvim -c ":syntax on|:colo 
default|:TOhtml" -c ":w|:qa" %LUA%
gvim -c ":syntax on|:colo 
default|:TOhtml" -c ":w|:qa" %PY%
gvim -c ":syntax on|:colo 
default|:TOhtml" -c ":w|:qa" %SH%
```

目的是达到了，但是。。。。我还是需要一个一个粘贴复制到文章中。。。我还是懒的做啊。。。。生成一个文件多好啊，直接将所有生成的文件重定向输出到一个文件中就得了（还好bat也有重定向）

```bat
set OB= dsaa%1.html

echo CPP: >> %OB%
echo LUA: >> %OB%
echo PYTHON: >> %OB%
echo BASH: >> %OB%
```

作为一个懒的出奇的人。。。。我还是不满意，每个代码中间没有说明文字啊。。。到时候这样肯定不行，还得手工添加？我才懒的做呢。。。。于是新的偷懒方式诞生了，每个代码段前加上标题说明啊。直接加上文字，可以实现，没有问题，效果不好。（我是有追求的懒人）

首先这竟然是分段的说明，起码也算个小标题，需要写大点吧。没错，既然是html文件，嵌入html格式的东西指定大小就得了啊，说起来简单实现起来难。因为echo没有办法支持带<的东西，用了""号是没有问题，但是又污染了生成的文件。最后通过很扭曲的方式完成了。看了完整的脚本后你就知道了：

```bat
1 set CPP= cpp/dsaa%1.cpp
2 set LUA= lua/dsaa%1.lua
3 set PY= py/dsaa%1.py
4 set SH= sh/dsaa%1.sh
5 set OB= dsaa%1.html
6 rem 以下的两个变量我本来想要减少输入的，但是竟然不好用,用了""界定就影响html，不用windows不准
7 rem 直接在echo后面输入也不行，于是用同名的相同内容的文件代替了
8 set HEAD= "<html>
<br><br><br><font size="+3">"
9 set TAIL= "<font><br><br>
</html>"
10
11 rem 没有用start是为了保证一个一个执行
12 gvim -c ":syntax
on|:colo default|:TOhtml" -c ":w|:qa" %CPP%
13 gvim -c ":syntax
on|:colo default|:TOhtml" -c ":w|:qa" %LUA%
14 gvim -c ":syntax
on|:colo default|:TOhtml" -c ":w|:qa" %PY%
15 gvim -c ":syntax
on|:colo default|:TOhtml" -c ":w|:qa" %SH%
16
17 rem 所有部分的头
18 type head
>>%OB%
19 type allhead
>%OB%
20 type tail  >> %OB%
21
22 rem cpp部分
23 type head
>>%OB%
24 echo CPP: >> %OB%
25 type tail  >> %OB%
26 type %CPP%.html  >> %OB%
27
28 rem lua部分
29 type head  >> %OB%
30 echo LUA: >> %OB%
31 type tail  >> %OB%
32 type %LUA%.html  >> %OB%
33
34 rem python部分
35 type head  >> %OB%
36 echo PYTHON: >> %OB%
37 type tail  >> %OB%
38 type %PY%.html  >> %OB%
39
40 rem bash部分
41 type head  >> %OB%
42 echo BASH: >> %OB%
43 type tail  >> %OB%
44 type %SH%.html  >> %OB%
```

最后，以前可能需要多次用gvim打开文件，并且改变颜色（因为我默认的是desert，是黑色背景的，不改不行，我也不希望平时就用default），然后输入:TOhtml转换，然后保存退出，然后开始下一个。。。。。。全部转换完后再一个一个复制到文章中。。。。

现在仅仅需要在控制台输入dsaa xxx，然后一次复制到文章的末尾就全部搞定了：）呵呵，懒人的办法啊。。。。想起以前某人说过：人类是在偷懒中进步的。。。深有体会，但是偷懒不是懒得睡觉，而且去想偷懒的好办法。。。做一个新时代的有追求的懂得偷懒的好青年：）

效果也贴一下，除了cpp文件，就是昨天的文章各个代码，效果不错吧：）呵呵

write by 九天雁翎(JTianLing)  
-- www.jtianling.com

以下为实现部分: 

CPP: 

```cpp
1
#ifndef
__JT_MATRIX_H__
2 #define
__JT_MATRIX_H__
3
4
5 **class**  CJTMatrix
6 {
7 **public** :
8     CJTMatrix();
9     CJTMatric(CJTMatrix
*
10     ~CJTMatrix();
11
12     Transpose();
13
14 };
15
16
17
18
19
20
21
22
23
24
25
26 #endif
```

LUA: 

```lua
1
function f(x)
2     **if**  (x == 0)
3     **then**
4         **return**  0;
5     **else**
6         **return**  2 *
f(x -1) + x * x;
7     **end**
8 end
9
10 -- Test code
11 print(f(1))
12 print(f(2))
13 print(f(3))
14 print(f(4))
15
```

PYTHON: 

```python
1
**def**  f(x):
2     'a easy recursive funtion'
3     **if**  x == 0:
4         **return**  0
5     **else** :
6         **return**  2 * f(x -1) + x * x
7
8
9 # test code
10 **print**  f(1)
11 **print**  f(2)
12 **print**  f(3)
13 **print**  f(4)
14
```

BASH: 

```bash
1
#!/bin/bash
2
3 function f
4 {
5     **local**  number=" $1"
6     **if**  **[**  $number **=**  0 **]**
7     **then**
8         ret=0
9     **else**
10         **let**  " decrnum = number - 1"
11         f
$decrnum
12         **let**  " ret = $? * 2 + $1 * $1"
13     **fi**
14
15     **return**  $ret
16 }
17
18 **for**  i **in**  1 2 3 4
19 **do**
20     f i
21     **echo**  $?
22 **done**
23
```
