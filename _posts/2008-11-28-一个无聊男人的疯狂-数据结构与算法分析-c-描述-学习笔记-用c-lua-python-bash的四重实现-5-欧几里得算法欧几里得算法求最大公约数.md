---
layout: post
title: "一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（5）欧几里得算法欧几里得算法求最大公约数"
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
- "最大公约数"
- "欧几里德算法"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '47'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

  

#   一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记  
用C++/lua/python/bash的四重实现（5）欧几里得算法求最大公约数

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

 

<<Data Structures and Algorithm Analysis in C++>>

\--《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第45面，图2-10欧几里得算法

欧几里得算法求最大公约数好像也比较出名，起码各大算法书籍都喜欢用，可能因为说明简单，却能够说明问题。

这里突然想说一句，当bash老是用C语法部分来完成也就没有那么难的变态了，只是，可能多了一点投机的成分。

再来个截图，下次再截就成惯例了。

从左自右依次是cpp,lua,python,bash。

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/EntryImages/20081128/gcd.jpg)![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/EntryImages/20081128/gcd.jpg)  

write by 九天雁翎(JTianLing)  
\-- www.jtianling.com

以下为实现部分: 

CPP: 

 1  
#include  
<stdio.h>  
 2 #include  
<stdlib.h>  
 3   
 4 **long**  gcd(**long**  m, **long**  n)  
 5 {  
 6     **if**(m < n)  
 7     {  
 8         **long**  temp = m;  
 9         m  
= n;  
10         n  
= temp;  
11     }  
12     **while**( n != 0)  
13     {  
14         **long**  rem = m % n;  
15         m  
= n;  
16         n  
= rem;  
17     }  
18       
19     **return**  m;  
20 }  
21   
22 **int**  main(**int**  argc, **char** *  
argv[])  
23 {  
24     printf("gcd(1989,1590)=%ld/n",gcd(1989,1590));  
25     printf("gcd(1590,1989)=%ld/n",gcd(1590,1989));  
26     exit(0);  
27 }  
28   

LUA: 

 1  
#!/usr/bin/env  
lua  
 2   
 3   
 4 function gcd(m,n)  
 5     **if**  m < n **then**  
 6         m,n  
= n,m  
 7     **end**  
 8   
 9     **while**  n ~= 0 **do**  
10         rem  
= m % n  
11         m  
= n  
12         n  
= rem  
13     **end**  
14   
15     **return**  m  
16 end  
17   
18 \-- Test code  
19 print("gcd(1989,1590)=" .. gcd(1989,1590))  
20 print("gcd(1590,1989)=" .. gcd(1590,1989))  
21   

PYTHON: 

 1  
#!/usr/bin/env  
python  
 2   
 3   
 4 **def**  gcd(m,n):  
 5     **if**  m < n:  
 6         m,n  
= n,m  
 7       
 8     **while**  n != 0:  
 9         rem  
= m % n  
10         m  
= n  
11         n  
= rem  
12   
13     **return**  m  
14   
15 **def**  test():  
16     **print**  "gcd(1989,1590)=" +  
str(gcd(1989,1590))  
17     **print**  "gcd(1590,1989)=" +  
str(gcd(1590,1989))  
18   
19 **if**  __name__ == '__main__':  
20     test()  
21   

BASH: 

 1  
#!/usr/bin/env  
bash  
 2   
 3   
 4 gcd**()**  
 5 {  
 6     m=$1  
 7     n=$2  
 8     **if**  (( m  
**<**  n ))  
 9     **then**  
10         (( temp **=**  m ))  
11         (( m **=**  n ))  
12         (( n **=**  temp ))  
13     **fi**  
14   
15     **while  **(( n  
**!=**  0 ))  
16 **     do**  
17         **((**  rem **=**  m  
% n **))**  
18         **((**  m **=**  n  
**))**  
19         **((**  n **=**  rem  
**))**  
20     **done**  
21   
22     **return**  $m  
23 }  
24   
25   
26 # test code  
27 **echo**  -n  
**"** gcd(1989,1590)=**"**  
28 gcd 1989 1590  
29 **echo**  $?  
30 **echo**  -n  
**"** gcd(1590,1989)=**"**  
31 gcd 1590 1989  
32 **echo**  $?  
33   
34   
35

**_write by_**** _九天雁翎_**** _(JTianLing) -- www.jtianling.com_**

 
