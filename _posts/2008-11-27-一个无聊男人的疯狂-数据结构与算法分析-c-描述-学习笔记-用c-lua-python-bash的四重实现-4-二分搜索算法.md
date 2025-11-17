---
layout: post
title: "一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（4）二分搜索算法"
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
- "二分搜索"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '17'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

  

# 一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（4）二分搜索算法

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

 

<<Data Structures and Algorithm Analysis in C++>>

\--《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第44面，图2-9二分搜索算法

二分搜索是很著名也很实用的算法，在排序中查找的速度从算法分析角度来说已经是最快的了。O(logN)

这里费了点心，将bash都实现了，扭曲啊，扭曲，光是传递一个数组参数都折腾了半天，最后还是通过所谓的间接引用然后用for重新赋值才实现我想要的数组，再次认为bash的算法描述语法混乱不堪。。。。其实bash只有命令调用的语法好用而已（个人见解），但是碰到我这样无聊的人，偏偏要用bash去实现算法。。。那就只能稍微偷点懒了，用了bash的C语言语法部分。

以下4个算法都是一样的，测试时为了统一结果，消除因为cpp,python数组从0开始，lua,bash数组从1开始的问题，测试时，cpp,python从-1开始测试。最后测试完成的结果完全一致，来个有意思的截图：

我编码的时候平铺4个putty窗口，正好占满我的19寸屏：）

从左自右依次是cpp,lua,python,bash。

![](http://p.blog.csdn.net/images/p_blog_csdn_net/vagrxie/EntryImages/20081127/binarySearch.jpg)

以下是源代码：

CPP:  

 1  
#include  
<stdio.h>  
 2 #include  
<stdlib.h>  
 3 #include  
<vector>  
 4 #include  
<iostream>  
 5 **using**  **namespace**  std;  
 6 **template** <**typename**  T>  
 7 **int**  binarySearch(**const**  vector<T> &a, **const**  T &x, **int** & aiTimes)  
 8 {  
 9     **int**  low = 0;  
10     **int**  high = a.size() - 1;  
11   
12     **while**(low <= high)  
13     {  
14         ++aiTimes;  
15         **int**  mid = (low + high) / 2;  
16           
17         **if**(a[mid] < x)  
18         {  
19             low  
= mid + 1;  
20         }  
21         **else**  **if**(a[mid]  
> x)  
22         {  
23             high  
= mid - 1;  
24         }  
25         **else**  
26         {  
27             **return**  mid;  
28         }  
29     }  
30   
31     **return**  -1;  
32 }  
33   
34 **int**  main(**int**  argc, **char** *  
argv[])  
35 {  
36     vector<**int** > lveci;  
37     lveci.resize(100);  
38     **for**(**int**  i  
= 0; i < 100;  
++i)  
39     {  
40         lveci[i]  
= i;  
41     }  
42   
43     **int**  liTimes = 0;  
44     cout <<  
binarySearch(lveci, -1, liTimes);  
45     cout <<"/tcost:" <<liTimes <<endl;  
46     liTimes = 0;  
47     cout << binarySearch(lveci,  
0, liTimes);  
48     cout <<"/tcost:" <<liTimes <<endl;  
49     liTimes = 0;  
50     cout <<  
binarySearch(lveci, 1, liTimes);  
51     cout <<"/tcost:" <<liTimes <<endl;  
52     liTimes = 0;  
53     cout <<  
binarySearch(lveci, 2, liTimes);  
54     cout <<"/tcost:" <<liTimes <<endl;  
55     liTimes = 0;  
56     cout <<  
binarySearch(lveci, 100, liTimes);  
57     cout <<"/tcost:"<<liTimes <<endl;  
58   
59   
60   
61     exit(0);  
62 }  
63   

LUA: 

 1  
#!/usr/bin/env  
lua  
 2 function binarySearch(a,  
v)  
 3     low = 1  
 4     high = #a  
 5   
 6     times = 0  
 7     **while**(low <= high) **do**  
 8         times  
= times + 1  
 9         mid  
= math.floor(( low + high) / 2)  
10         **if**  a[mid] < v  **then**  
11             low  
= mid + 1  
12         **elseif**  a[mid] > v **then**  
13             high  
= mid - 1  
14         **else**  
15             **return**  mid,times  
16         **end**  
17     **end**  
18   
19     **return**  -1,times  
20 end  
21   
22 \-- test code  
23 array = **{}**  
24 **for**  i=1,100 **do**  
25     array[i] = i  
26 **end**  
27   
28 print(binarySearch(array,  
0))  
29 print(binarySearch(array,  
1))  
30 print(binarySearch(array,  
2))  
31 print(binarySearch(array,  
3))  
32 print(binarySearch(array,  
101))  
33   

PYTHON: 

 1  
#!/usr/bin/env  
python  
 2   
 3 **def**  binarySearch(a, v):  
 4     low = 0  
 5     high =  
len(a) - 1  
 6     times = 0  
 7   
 8     **while**  low <= high:  
 9         times  
+= 1  
10         mid  
= (low + high) // 2  
11   
12         **if**  v > a[mid]:  
13             low  
= mid + 1  
14         **elif**  v < a[mid]:  
15             high  
= mid - 1  
16         **else** :  
17             **return**  mid,times  
18       
19     **return**  -1,times  
20   
21 array = range(100)  
22 **print**  binarySearch(array, -1)  
23 **print**  binarySearch(array, 0)  
24 **print**  binarySearch(array, 1)  
25 **print**  binarySearch(array, 2)  
26 **print**  binarySearch(array,  
100)  
27       
28   

BASH: 

 1  
#!/usr/bin/env  
bash  
 2   
 3   
 4 binarySearch**()**  
 5 {  
 6     v=$2  
 7     an=**"** $1[@]**"**  
 8     a=${!an}  
 9     **for**  i **in**  $a  
10     **do**  
11         ar**[** i**]=** $i  
12     **done**  
13     low=1  
14     high=${#ar[*]}  
15     **((**  **times=** 0 **))**  
16   
17     **while  **(( low  
**< =** high ))  
18 **     do**  
19         **((**  ++**times**  **))**  
20         **((**  mid=**(** low+high**)** /2 **))**  
21         #echo -n " mid="$mid  
22         #echo -n " ar[mid]="${ar[mid]}  
23         **if**  (( v  
**>**  ar**[** mid**]**  ))  
24         **then**  
25             (( low **=**  mid \+ 1 ))  
26         **elif**  (( v  
**<**  ar**[** mid**]**  ))  
27         **then**  
28             (( high **=**  mid \- 1 ))  
29         **else**  
30             #echo -e "/nTimes="$times  
31             **return**  $mid  
32         **fi**  
33     **done**  
34   
35     #echo -e "/nTimes="$times  
36     **return**  -1  
37 }  
38   
39 **for**  ((i**=** 1**;**  i**< =** 100**;**  ++i))  
40 **do**  
41     **((**  array**[** i**]**  **=**  i  
**))**  
42 **done**  
43   
44 binarySearch array 0  
45 **echo**  -e  
**"** $?/t$times**"**  
46 binarySearch array 1  
47 **echo**  -e  
**"** $?/t$times**"**  
48 binarySearch array 2  
49 **echo**  -e  
**"** $?/t$times**"**  
50 binarySearch array 3  
51 **echo**  -e  
**"** $?/t$times**"**  
52 binarySearch array 101  
53 **echo**  -e  
**"** $?/t$times**"**  
54   
55 **exit**  0

 

**_write by_**** _九天雁翎_**** _(JTianLing) -- www.jtianling.com_**

 
