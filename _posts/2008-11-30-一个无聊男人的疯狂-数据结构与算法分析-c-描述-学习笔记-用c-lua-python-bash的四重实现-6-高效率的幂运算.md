---
layout: post
title: "一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（6）高效率的幂运算"
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
  views: '10'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

  

#   一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记  
用C++/lua/python/bash的四重实现（6）高效率的幂运算

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

 

<<Data Structures and Algorithm Analysis in C++>>

\--《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第46面，图2-11  
一个高效率的幂运算，应该还算不上最高效率的,但是作为一个递归及O(logn)的例子还是很合适的，因为足够的简单。

bash的实现我发现老是用普通程序语言的思想是不行了，麻烦的要死，于是用命令替换实现了一个b版本，明显效果好的多：）用一个语言就是要用一个语言的特性。

来个截图，惯例。我好像喜欢上了这种一下排4，5个窗口然后照相的方式，呵呵，特有成就感。

从左自右依次是cpp,lua,python,bash,bash（b实现）。

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/EntryImages/20081130/pow.jpg)

write by 九天雁翎(JTianLing)  
\-- www.jtianling.com

以下为实现部分: 

CPP: 

 1  
#include  
<stdio.h>  
 2 #include  
<stdlib.h>  
 3 #include  
<math.h>  
 4   
 5 **bool**  IsEven(**int**  x)  
 6 {  
 7     **return**  (x % 2 ==  
0);  
 8 }  
 9   
10   
11 **long**  MyPow(**long**  x, **int**  n)  
12 {  
13     **if**( 0 ==  
n)  
14         **return**  1;  
15     **if**  ( IsEven(n))  
16         **return**  MyPow( x * x, n / 2);  
17     **else**  
18         **return**  MyPow( x * x, n / 2 ) * x;  
19 }  
20   
21 **int**  main(**int**  argc, **char** *  
argv[])  
22 {  
23     printf("pow(2,2)=%ld/n",MyPow(2,2));  
24     printf("pow(2,3)=%ld/n",MyPow(2,3));  
25     printf("pow(2,4)=%ld/n",MyPow(2,4));  
26     printf("pow(2,5)=%ld/n",MyPow(2,5));  
27     printf("pow(2,6)=%ld/n",MyPow(2,6));  
28   
29     exit(0);  
30 }  
31   

LUA: 

 1  
#!/usr/bin/env  
lua  
 2   
 3   
 4 function isEven(n)  
 5     **return**  n % 2 ==  
0  
 6 end  
 7   
 8 function pow(m,  
n)  
 9     **if**  n == 0 **then**  
10         **return**  1  
11     **end**  
12   
13     **if**  isEven(n) **then**  
14         **return**  pow( m * m, n / 2)  
15     **else**  
16         **return**  pow( m * m, math.floor(n / 2)  
) * m   
17     **end**  
18 end  
19   
20   
21 \-- Test Code  
22 print("pow(2,2)=" .. pow(2,2));  
23 print("pow(2,3)=" .. pow(2,3));  
24 print("pow(2,4)=" .. pow(2,4));  
25 print("pow(2,5)=" .. pow(2,5));  
26 print("pow(2,6)=" .. pow(2,6));  
27   
28   

PYTHON: 

 1  
#!/usr/bin/env  
python  
 2   
 3 **def**  IsEven(n):  
 4     **return**  n % 2 == 0  
 5   
 6 **def**  MyPow(m,n):  
 7     **if**  n == 0:  
 8         **return**  1  
 9   
10     **if**  IsEven(n):  
11         **return**  MyPow(m * m, n / 2)  
12     **else** :  
13         **return**  MyPow(m * m, n // 2) * m  
14   
15   
16 **def**  test():  
17     **print**  "pow(2,2)=" +  
str(MyPow(2,2))  
18     **print**  "pow(2,3)=" +  
str(MyPow(2,3))  
19     **print**  "pow(2,4)=" +  
str(MyPow(2,4))  
20     **print**  "pow(2,5)=" +  
str(MyPow(2,5))  
21     **print**  "pow(2,6)=" +  
str(MyPow(2,6))  
22   
23 **if**  __name__ == '__main__':  
24     test()  
25   

BASH: 

 1  
#!/usr/bin/env  
bash  
 2   
 3 isEven**()**  
 4 {  
 5     **local**  m=$1  
 6     **if**  (( m  
% 2 **==**  0))  
 7     **then**  
 8         **return**  1  
 9     **else**  
10         **return**  0  
11     **fi**  
12 }  
13   
14 pow**()**  
15 {  
16     **local**  m=$1  
17     **local**  n=$2  
18   
19     **if**  (( n  
**==**  0 ))  
20     **then**  
21         **return**  1  
22     **fi**  
23   
24     **local**  m2  
25     **local**  n2  
26     **((**  m2 **=**  m  
* m **))**  
27     **((**  n2 **=**  n  
/ 2 **))**  
28   
29     isEven n  
30     **r=** $?  
31     **if**  (( r  
**==**  1 ))  
32     **then**  
33         pow  
$m2 $n2   
34         **return**  $?  
35     **else**  
36         pow  
$m2 $n2   
37         **local**  r2=$?  
38         (( r2 * **=**  m ))  
39         **return**  $r2  
40     **fi**  
41 }  
42       
43 **echo**  -n  
**"** pow(2,2)=**"**  
44 pow 2 2  
45 **echo**  $?  
46 **echo**  -n  
**"** pow(2,3)=**"**  
47 pow 2 3  
48 **echo**  $?  
49 **echo**  -n  
**"** pow(2,4)=**"**  
50 pow 2 4  
51 **echo**  $?  
52 **echo**  -n  
**"** pow(2,5)=**"**  
53 pow 2 5  
54 **echo**  $?  
55 **echo**  -n  
**"** pow(2,6)=**"**  
56 pow 2 6  
57 **echo**  $?

 

 

BASH(b实现):

 1 #!/usr/bin/env bash  
 2   
 3 isEven**()**  
 4 {  
 5     **local**  m=$1  
 6     **if**  (( m  
% 2 **==**  0))  
 7     **then**  
 8         **echo**  1  
 9     **else**  
10         **echo**  0  
11     **fi**  
12 }  
13   
14 pow**()**  
15 {  
16     **local**  m=$1  
17     **local**  n=$2  
18   
19     **if**  (( n  
**==**  0 ))  
20     **then**  
21         **echo**  1  
22         **exit**  0  
23     **fi**  
24   
25     **local**  m2  
26     **local**  n2  
27     **((**  m2 **=**  m  
* m **))**  
28     **((**  n2 **=**  n  
/ 2 **))**  
29   
30     **r=** `isEven $n`  
31     **if**  (( r  
**==**  1 ))  
32     **then**  
33         **local**  r1=`pow $m2 $n2`  
34         **echo**  $r1  
35     **else**  
36         **local**  r2=`pow $m2 $n2`  
37         (( r2 * **=**  m ))  
38         **echo**  $r2  
39     **fi**  
40 }  
41       
42 **echo**  -n  
**"** pow  
2 2 = **"**  
43 pow 2 2  
44 **echo**  -n  
**"** pow  
2 3 = **"**  
45 pow 2 3  
46 **echo**  -n  
**"** pow  
2 4 = **"**  
47 pow 2 4  
48 **echo**  -n  
**"** pow  
2 5 = **"**  
49 pow 2 5  
50 **echo**  -n  
**"** pow  
2 6 = **"**  
51 pow 2 6

 

 

 

 

 

**_write by_**** _九天雁翎_**** _(JTianLing) -- www.jtianling.com_**

 
