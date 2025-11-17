---
layout: post
title: "一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（7）习题2.8 随机数组的三种生成算法"
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
- "随机数组"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '8'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

   

#   一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记  
用C++/lua/python/bash的四重实现（7）习题2.8 随机数组的三种生成算法

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

 

<<Data Structures and Algorithm Analysis in C++>>

\--《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第49面， 一随机数组的三种生成算法

这一次没有截图，因为我受不了让bash运行100次的速度，怎么说来着，还是那句话，Bash根本就不适合也不是设计用来描述算法的语言，我根本就是自讨苦吃。用了最多的时间，得到的是最低的效率。。。。。。还有最扭曲的代码。但是因为工作中不用到bash，不常用用还真怕都忘了。。。现在用python的时候就常有这样的感觉，以前看的书就像白看了一样。

相对于bash来说，python的优雅一次一次的深入我心，每一次它都是代码最短的，最最优雅的，很多便捷的语法都是让人用的很痛快，虽然刚开始用的时候由于没有大括号。。。（我用c++习惯了）感觉代码就像悬在空中一样的不可靠。。。呵呵，习惯了以后，怎么看怎么爽。再加上丰富的库，绝了。

 

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
<algorithm>  
  4 #include  
<iterator>  
  5 #include  
<iostream>  
  6 **using**  **namespace**  std;  
  7   
  8 **int**  randInt(**int**  i, **int**  j)  
  9 {  
 10     **if**(i > j)  
 11     {  
 12         **int**  temp = i;  
 13         i  
= j;  
 14         j  
= temp;  
 15     }  
 16   
 17     **return**  rand() % (j-i) + i;  
 18 }  
 19   
 20 **void**  randArr1(**int**  arr[], **int**  n)  
 21 {  
 22     **for**(**int**  i=0; i<n; ++i)  
 23     {  
 24         **while**(true)  
 25         {  
 26             // some thing don't like py  
 27             // because my randInt is create number  
 28             // in [0,n) and py is [0,n]  
 29             **int**  temp = randInt(0, n);  
 30             **int**  j = 0;  
 31             **while**(j < i)  
 32             {  
 33                 **if**(arr[j] == temp)  
 34                 {  
 35                     **break** ;  
 36                 }  
 37                 ++j;  
 38             }  
 39             **if**(j == i)  
 40             {  
 41                 arr[j]  
= temp;  
 42                 **break** ;  
 43             }  
 44         }  
 45     }  
 46 }  
 47   
 48 **void**  randArr2(**int**  a[], **int**  n)  
 49 {  
 50     **bool**  *lpb = **new**  **bool**[n];  
 51     memset(lpb,  
0, n);  
 52   
 53     **for**(**int**  i=0; i<n; ++i)  
 54     {  
 55         **while**(true)  
 56         {  
 57             **int**  temp = randInt(0, n);  
 58             **if**(!lpb[temp])  
 59             {  
 60                 a[i]  
= temp;  
 61                 lpb[temp]  
= true;  
 62                 **break** ;  
 63             }  
 64         }  
 65   
 66     }  
 67   
 68     **delete**  lpb;  
 69     lpb = NULL;  
 70 }  
 71   
 72 **void**  swap(**int** & a, **int** &  
b)  
 73 {  
 74     **int**  temp = a;  
 75     a = b;  
 76     b = temp;  
 77 }  
 78   
 79 // just  
for fun,but I like it.  
 80 // when py  
could have range and bash could have seq  
 81 // why cpp  
couldn't have a seq like this? lol  
 82 **template** <**typename**  T>  
 83 **class**  CFBSeq  
 84 {  
 85 **public** :  
 86     CFBSeq(**const**  T& aValue) : mValue(aValue) {  
}  
 87   
 88     T **operator**()()  
 89     {  
 90         **return**  mValue++;  
 91     }  
 92   
 93 **private** :  
 94     T mValue;  
 95 };  
 96   
 97 **void**  randArr3(**int**  a[], **int**  n)  
 98 {  
 99     generate(a,  
a+n, CFBSeq<**int** >(0));  
100   
101     **for**(**int**  i=1; i<n; ++i)  
102     {  
103         swap(a[i],  
a[randInt(0,i)]);  
104     }  
105   
106 }  
107   
108   
109   
110   
111   
112 **int**  main(**int**  argc, **char** *  
argv[])  
113 {  
114     **const**  **int**  TIMES=100;  
115     srand(time(NULL));  
116     **int**  a[TIMES],b[TIMES],c[TIMES];  
117     randArr1(a,TIMES);  
118     copy(a, a+TIMES,  
ostream_iterator<**int** >(cout," "));  
119     printf("/n");  
120     randArr2(b,TIMES);  
121     copy(b, b+TIMES,  
ostream_iterator<**int** >(cout," "));  
122     printf("/n");  
123     randArr3(c,  
TIMES);  
124     copy(c, c+TIMES,  
ostream_iterator<**int** >(cout," "));  
125   
126   
127   
128     exit(0);  
129 }  
130   

LUA: 

 1  
#!/usr/bin/env  
lua  
 2   
 3 math.randomseed(os.time())  
 4   
 5 function randArr1(a,  
n)  
 6     **for**  i=1,n  
**do**  
 7         **while**  true **do**  
 8             **local**  temp = math.random(1, n)  
 9   
10             **local**  j = 1  
11             **while**  j < i **do**  
12                 **if**  a[j] == temp **then**    
13                     **break**  
14                 **end**  
15                 \-- Again damed that There is no ++  
16                 \-- and even no composite operator += !  
17                 \-- No one knows that is more concision  
18                 \-- and more effective?  
19                 j  
= j + 1  
20             **end**  
21   
22             **if**  j == i **then**  
23                 a[i]  
= temp  
24                 **break**  
25             **end**  
26   
27         **end**  
28     **end**  
29 end  
30   
31   
32 function randArr2(a,  
n)  
33     \-- use nil as false as a lua's special hack  
34     **local**  bt = **{}**  
35     **for**  i=1,n  
**do**  
36         **while**  true **do**  
37             **local**  temp = math.random(1,n)  
38             **if**  **not**  bt[temp]  
**then**  
39                 a[i]  
= temp  
40                 bt[temp]  
= true  
41                 **break**  
42             **end**  
43         **end**  
44     **end**  
45 end  
46   
47 function randArr3(a,  
n)  
48     **for**  i=1,n  
**do**  
49         a[i]  
= i  
50     **end**  
51       
52     **for**  i=1,n  
**do**  
53         **local**  temp = math.random(1,n)  
54         \-- one of the most things i like in lua&py  
55         a[i],a[temp]  
= a[temp],a[i]   
56     **end**  
57 end  
58   
59   
60   
61 \-- Test Code  
62   
63 times = 100  
64 t = **{}**  
65 randArr1(t, times)  
66 **for**  i,v **in**  ipairs(t)  
**do**  
67     io.write(v .. "  
")  
68 **end**  
69   
70   
71 t2 = **{}**  
72 randArr2(t2, times)  
73 **for**  i,v **in**  ipairs(t2)  
**do**  
74     io.write(v .. "  
")  
75 **end**  
76   
77   
78 t3 = **{}**  
79 randArr3(t3, times)  
80 **for**  i,v **in**  ipairs(t3)  
**do**  
81     io.write(v .. "  
")  
82 **end**  
83   
84   
85   

PYTHON: 

 1  
#!/usr/bin/env  
python  
 2 from random  
import randint  
 3   
 4 **def**  randArr1(a,n):  
 5     **for**  i **in**  range(n):  
 6         **while**  True:  
 7             temp  
= randint(0, n-1)  
 8   
 9             **for**  j **in**  range(i):  
10                 **if**  a[j] == temp:  
11                     **break** ;  
12             # another one of the things I like in py(for else)  
13             **else** :  
14                 a.append(temp)  
15                 **break** ;  
16   
17 **def**  randArr2(a,n):  
18 #surely it is  
not need be a dict but dict is faster then list  
19     bd = {}  
20     **for**  i **in**  range(n):  
21         **while**  True:  
22             temp  
= randint(0, n-1)  
23             **if**  temp **not**  **in**  tl:  
24                 a.append(temp)  
25                 tl[temp]  
= True  
26                 **break**  
27   
28 **def**  randArr3(a,n):  
29      a = range(n)  
30      **for**  i **in**  range(n):  
31           
temp = randint(0, n-1)  
32           
# like in lua  
33           
a[i],a[temp] = a[temp],a[i]  
34   
35 **def**  test():  
36     times = 100  
37     l = []  
38     randArr1(l,  
times)  
39   
40     **print**  l  
41     l2 = []  
42     randArr1(l2,  
times)  
43     **print**  l2  
44   
45     l2 = []  
46     randArr1(l2,  
times)  
47     **print**  l2  
48   
49   
50   
51 **if**  __name__ == '__main__':  
52     test()  

BASH: 

  1  
#!/usr/bin/env  
bash  
  2   
  3   
  4 #  
just for a range rand....let me die....  
  5 #  
what I had said? bash is not a good  
  6 #  
language for describing algorithms  
  7 randInt**()**  
  8 {  
  9     **local**  a=$1  
 10     **local**  b=$2  
 11   
 12     **if**  (( a  
**>**  b ))  
 13     **then**  
 14         **local**  temp  
 15         (( temp **=**  a ))  
 16         (( a **=**  b ))  
 17         (( b **=**  temp ))  
 18     **fi**  
 19   
 20     **local**  mi  
 21     **((**  mi **=**  b  
\- a + 1**))**  
 22     **local**  **r=** $((RANDOM%${mi}+${a}))  
 23     **echo**  -n $r  
 24 }  
 25   
 26 randArr1**()**  
 27 {  
 28 # only one  
argument because I hate the  
 29 # bash's  
indirect reference  
 30 # you can  
reference the (4) binarySearch to  
 31 # see what  
I said  
 32     **local**  n=$1  
 33     **declare**  -a a  
 34     **for**  (( i**=** 1**;**  i**< =**n**;**  ++i ))   
 35     **do**  
 36         **while  true**  
 37 **         do**  
 38             temp=`randInt 1 $n`  
 39             j=1  
 40             **while  **(( j**<** i ))  
 41 **             do**  
 42                 **if**  (( a**[** j**]**  **==**  temp ))  
 43                 **then**  
 44                     **break**  
 45                 **fi**  
 46                 **((**  ++j **))**  
 47             **done**  
 48             **if**  (( j  
**==**  i ))  
 49             **then**  
 50                 (( a**[** j**]**  **=**  temp ))  
 51                 **break**  
 52             **fi**  
 53         **done**  
 54     **done**  
 55   
 56     **echo**  ${a[*]}  
 57 }  
 58   
 59 randArr2**()**  
 60 {  
 61     **local**  n=$1  
 62     **declare**  -a a  
 63     # used for bool array  
 64     **declare**  -a b  
 65     **for**  (( i**=** 1**;**  i**< =**n**;**  ++i ))  
 66     **do**  
 67         **while  true**  
 68 **         do**  
 69             **local**  temp=`randInt 1 $n`  
 70             **if**  **[**  **-z**  ${b[temp]} **]**  
 71             **then**  
 72                 (( a**[** i**]**  **=**  temp ))  
 73                 (( b**[** temp**]**  **=**  true ))  
 74                 **break**  
 75             **fi**  
 76         **done**  
 77     **done**  
 78   
 79     **echo**  ${a[*]}  
 80 }  
 81   
 82 randArr3**()**  
 83 {  
 84     **local**  n=$1  
 85     **for**  (( i**=** 1**;**  i**< =**n**;**  ++i ))  
 86     **do**  
 87         **((**  a**[** i**]**  **=**  i  
**))**  
 88     **done**  
 89     **for**  (( i**=** 1**;**  i**< =**n**;**  ++i ))  
 90     **do**  
 91         **local**  temp=`randInt 1 $n`  
 92         **((**  t **=**  a**[** i**]**  **))**  
 93         **((**  a**[** i**]**  **=**  a**[** temp**]**  **))**  
 94         **((**  a**[** temp**]**  **=**  t  
**))**  
 95     **done**  
 96   
 97     **echo**  ${a[*]}  
 98 }  
 99   
100   
101 # so slow that  
I can't bear it run 100 times  
102 randArr1 10  
103 randArr2 10  
104 randArr3 10  
105

 

 

 

**_write by_**** _九天雁翎_**** _(JTianLing) -- www.jtianling.com_**

 
