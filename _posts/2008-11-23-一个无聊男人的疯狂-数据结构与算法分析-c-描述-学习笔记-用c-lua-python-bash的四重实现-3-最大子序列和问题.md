---
layout: post
title: "一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（3） 最大子序列和问题"
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
  views: '3'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

    

#  一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 用C++/lua/python/bash的四重实现（3）  
最大子序列和问题

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

 

<<Data Structures and Algorithm Analysis in C++>>

\--《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第39-43面，图2-5，2-6,2-7,2-8最大子序列和问题的解

总算有点技术含量了，呵呵，虽然说重复实现一下代码不难（不就是相当于翻译嘛），但是算法4为什么是正确的需要好好理解一下。

以下为实现部分: 

CPP: 

  1  
//  
  2 //  
Maximum contiguous subsequence sum algorithm 1 - 4, worst to best  
  3 //  
From <<Data Structures and Algorithm Analysis in C++>> by Mark  
Allen Weiss  
  4 //  
  5 //  
  6 #include  
<stdio.h>  
  7 #include  
<stdlib.h>  
  8 #include  
<vector>  
  9 **using**  **namespace**  std;  
 10   
 11   
 12   
 13 **int**  maxSubSum1(  
**const**  vector<**int** > &a)  
 14 {  
 15     **int**  maxSum = 0;  
 16   
 17     **for**(**int**  i=0; i<(**int**)a.size();  
++i)  
 18         **for**(**int**  j=i;  
j<(**int**)a.size(); ++j)  
 19         {  
 20             **int**  thisSum = 0;  
 21   
 22             **for**(**int**  k=i;  
k<=j; ++k)  
 23                 thisSum  
+= a[k];  
 24   
 25             **if**(thisSum > maxSum)  
 26                 maxSum  
= thisSum;  
 27         }  
 28     **return**  maxSum;  
 29 }  
 30   
 31 **int**  maxSubSum2(  
**const**  vector<**int** > &a)  
 32 {  
 33     **int**  maxSum = 0;  
 34   
 35     **for**(**int**  i=0; i<(**int**)a.size();  
++i)  
 36     {  
 37         **int**  thisSum = 0;  
 38         **for**(**int**  j=i;  
j<(**int**)a.size(); ++j)  
 39         {  
 40             thisSum  
+= a[j];  
 41   
 42             **if**( thisSum > maxSum)  
 43                 maxSum  
= thisSum;  
 44         }  
 45     }  
 46     **return**  maxSum;  
 47 }  
 48   
 49 **int**  max3(**int**  a, **int**  b,  
**int**  c)  
 50 {  
 51     **return**  ((a < b)?((b < c)?c:b):((a  
< c)?c:a));  
 52 }  
 53   
 54   
 55 **int**  maxSumRec(  
**const**  vector<**int** > &a, **int**  left,  
**int**  right)  
 56 {  
 57     **if**(left == right)  
 58         **if**( a[left] > 0)  
 59             **return**  a[left];  
 60         **else**  
 61             **return**  0;  
 62   
 63     **int**  center = (left + right) / 2;  
 64     **int**  maxLeftSum = maxSumRec(a, left,  
center);  
 65     **int**  maxRightSum = maxSumRec(a, center + 1, right);  
 66   
 67     **int**  maxLeftBorderSum = 0;  
 68     **int**  leftBorderSum = 0;  
 69   
 70     **for**(**int**  i=center;  
i >=left; --i)  
 71     {  
 72         leftBorderSum  
+= a[i];  
 73         **if**(leftBorderSum > maxLeftBorderSum)  
 74             maxLeftBorderSum  
= leftBorderSum;  
 75     }  
 76   
 77     **int**  maxRightBorderSum = 0,rightBorderSum = 0;  
 78     **for**(**int**  j  
= center + 1; j <= right; ++j)  
 79     {  
 80         rightBorderSum  
+= a[j];  
 81         **if**(rightBorderSum > maxRightBorderSum)  
 82             maxRightBorderSum  
= rightBorderSum;  
 83     }  
 84   
 85       
 86     **return**  max3(maxLeftSum, maxRightSum,  
maxLeftBorderSum + maxRightBorderSum);  
 87 }  
 88   
 89 **int**  maxSubSum3(**const**  vector<**int** > &a)  
 90 {  
 91     **return**  maxSumRec(a, 0, a.size() - 1);  
 92 }  
 93   
 94 **int**  maxSubSum4(  
**const**  vector<**int** > &a)  
 95 {  
 96     **int**  maxSum = 0,  
thisSum = 0;  
 97   
 98     **for**( **int**  j  
= 0; j< (**int**)a.size();  
++j)  
 99     {  
100         thisSum  
+= a[j];  
101   
102         **if**(thisSum > maxSum)  
103             maxSum  
= thisSum;  
104         **else**  **if**(thisSum  
< 0)  
105             thisSum

= 0;  
106     }  
107   
108     **return**  maxSum;  
109 }  
110   
111   
112   
113 **int**  main(**int**  argc, **char** *  
argv[])  
114 {  
115     // for easy  
116     **int**  a[] = { -2,  
11, -4, 13, -5, -2};  
117     vector<**int** > lvec(a, a + **sizeof**(a)/**sizeof**(**int**));  
118   
119     printf("maxSubSum1(lvec)):%d/n",maxSubSum1(lvec));  
120     printf("maxSubSum2(lvec)):%d/n",maxSubSum2(lvec));  
121     printf("maxSubSum3(lvec)):%d/n",maxSubSum3(lvec));  
122     printf("maxSubSum4(lvec)):%d/n",maxSubSum4(lvec));  
123   
124   
125     exit(0);  
126 }  
127   

LUA: 

  1  
#!/usr/bin/env  
lua  
  2   
  3   
  4 function maxSubSum1(a)  
  5     assert(type(a) == "table", "Argument  
a must be a number array.")  
  6   
  7     **local**  maxSum = 0  
  8   
  9     **for**  i=1,#a  
**do**  
 10         **for**  j=i,#a    **do**  
 11             **local**  thisSum = 0  
 12             **for**  k=i,j **do**  
 13                 thisSum  
= thisSum + a[k]  
 14             **end**  
 15   
 16             **if**  thisSum > maxSum **then**  
 17                 maxSum  
= thisSum  
 18             **end**  
 19         **end**  
 20     **end**  
 21   
 22     **return**  maxSum  
 23 end  
 24   
 25 function maxSubSum2(a)  
 26     assert(type(a) == "table", "Argument  
a must be a number array.")  
 27   
 28     **local**  maxSum = 0  
 29   
 30     **for**  i=1,#a  
**do**  
 31         **local**  thisSum = 0  
 32   
 33         **for**  j=i,#a **do**  
 34             thisSum  
= thisSum + a[j]  
 35   
 36             **if**(thisSum > maxSum) **then**  
 37                 maxSum  
= thisSum  
 38             **end**  
 39         **end**  
 40     **end**  
 41     **return**  maxSum  
 42 end  
 43   
 44 function max3(n1,  
n2, n3)  
 45     **return**  (n1 > n2 **and**  ((n1 > n3) **and**  n1 **or**  n3)  
**or**  ((n2 > n3) **and**  n2 **or**  n3))  
 46 end  
 47   
 48 \-- require  
math  
 49   
 50 function maxSumRec(a,  
left, right)  
 51     assert(type(a) == "table", "Argument  
a must be a number array.")  
 52     assert(type(left) == "number" **and**  type(right) == "number",  
 53             "Argument left&right  must be number  
arrays.")  
 54   
 55     **if**  left == right **then**  
 56         **if**  a[left] > 0 **then**  
 57             **return**  a[left]  
 58         **else**  
 59             **return**  0  
 60         **end**  
 61     **end**  
 62   
 63     **local**  center = math.floor((left  
\+ right) / 2)  
 64     **local**  maxLeftSum = maxSumRec(a, left,  
center)  
 65     **local**  maxRightSum = maxSumRec(a, center+1, right)  
 66   
 67     **local**  maxLeftBorderSum = 0  
 68     **local**  leftBorderSum = 0  
 69     **for**  i=center,left,-1 **do**  
 70         leftBorderSum  
= leftBorderSum + a[i]  
 71         **if**  leftBorderSum > maxLeftBorderSum **then**  
 72             maxLeftBorderSum  
= leftBorderSum  
 73         **end**  
 74         i  
= i - 1  
 75     **end**  
 76   
 77     **local**  maxRightBorderSum = 0  
 78     **local**  rightBorderSum = 0  
 79     **for**  j=center+1,right  
**do**  
 80         rightBorderSum  
= rightBorderSum + a[j]  
 81         **if**  rightBorderSum > maxRightBorderSum **then**  
 82             maxRightBorderSum  
= rightBorderSum  
 83         **end**  
 84     **end**  
 85   
 86     **return**  max3(maxLeftSum, maxRightSum,  
maxLeftBorderSum + maxRightBorderSum)  
 87 end  
 88   
 89 function maxSubSum3(a)  
 90     assert(type(a) == "table", "Argument  
a must be a number array.")  
 91   
 92     **return**  maxSumRec(a, 1, 6)  
 93   
 94 end  
 95   
 96 function maxSubSum4(a)  
 97     assert(type(a) == "table", "Argument  
a must be a number array.")  
 98   
 99     **local**  maxSum = 0  
100     **local**  thisSum = 0  
101   
102     **for**  i=1,#a  
**do**  
103         thisSum  
= thisSum + a[i]  
104   
105         **if**  thisSum > maxSum **then**  
106             maxSum  
= thisSum  
107         **elseif**  thisSum < 0 **then**  
108             thisSum  
= 0  
109         **end**  
110   
111     **end**  
112   
113     **return**  maxSum  
114   
115 end  
116   
117 \-- Test Code  
118   
119 t = **{** -2, 11, -4, 13, -5, -2 **}**  
120   
121 print("maxSubSum1(t):" .. maxSubSum1(t))  
122 print("maxSubSum2(t):" .. maxSubSum2(t))  
123 print("maxSubSum3(t):" .. maxSubSum3(t))  
124 print("maxSubSum4(t):" .. maxSubSum4(t))  
125   
126   
127   

PYTHON: 

 1  
#!/usr/bin/env  
python  
 2   
 3 # How Short  
and Clean it is I shocked as a CPP Programmer  
 4 **def**  maxSubSum1(a):  
 5     maxSum = 0  
 6   
 7     **for**  i **in**  a:  
 8         **for**  j **in**  a[i:]:  
 9             thisSum  
= 0  
10   
11             **for**  k **in**  a[i:j]:  
12                 thisSum  
+= k  
13   
14             **if**  thisSum > maxSum:  
15                 maxSum  
= thisSum  
16       
17     **return**  maxSum  
18   
19 **def**  maxSubSum2(a):  
20     maxSum = 0  
21   
22     **for**  i **in**  a:  
23         thisSum  
= 0  
24         **for**  j **in**  a[i:]:  
25             thisSum  
+= j  
26   
27             **if**  thisSum > maxSum:  
28                 maxSum  
= thisSum  
29   
30     **return**  maxSum  
31   
32   
33 **def**  max3(n1,  
n2, n3):  
34     **return**  ((n1 **if**  n1  
> n3 **else**  n3) **if**  n1 > n2 **else**  (n2  
**if**  n2 > n3 **else**  n3))  
35   
36 **def**  maxSumRec(a,  
left, right):  
37     **if**  left == right:  
38         **if**   a[left] > 0:  
39             **return**  a[left]  
40         **else** :  
41             **return**  0  
42   
43     center = (left +  
right)//2  
44     maxLeftSum =  
maxSumRec(a, left, center)  
45     maxRightSum =  
maxSumRec(a, center+1, right)  
46   
47     maxLeftBorderSum  
= 0  
48     leftBorderSum = 0  
49     **for**  i **in**  a[center:left:-1]:  
50         leftBorderSum  
+= i  
51         **if**  leftBorderSum > maxLeftBorderSum:  
52             maxLeftBorderSum  
= leftBorderSum  
53   
54     maxRightBorderSum  
= 0  
55     rightBorderSum =  
0  
56     **for**  i **in**  a[center+1:right]:  
57         rightBorderSum  
+= i  
58         **if**  rightBorderSum > maxRightBorderSum:  
59             maxRightBorderSum  
= rightBorderSum  
60       
61     **return**  max3(maxLeftSum,  
maxRightBorderSum, maxLeftBorderSum + maxRightBorderSum)  
62   
63 **def**  maxSubSum3(a):  
64     **return**  maxSumRec(a, 0,  
len(a)-1    )  
65   
66 **def**  maxSubSum4(a):  
67     maxSum = 0  
68     thisSum = 0  
69   
70     **for**  i **in**  a:  
71         thisSum  
+= i  
72   
73         **if**  thisSum > maxSum:  
74             maxSum  
= thisSum  
75         **elif**  thisSum < 0:  
76             thisSum  
= 0  
77   
78     **return**  maxSum  
79               
80 **def**  test():  
81     t = (-2, 11, -4,  
13, -5, -2)   
82   
83     **print**  "maxSubSum1:%d" %  
maxSubSum1(t)  
84     **print**  "maxSubSum2:%d" %  
maxSubSum2(t)  
85     **print**  "maxSubSum3:%d" %  
maxSubSum3(t)  
86     **print**  "maxSubSum4:%d" %  
maxSubSum4(t)  
87   
88 **if**  __name__ == '__main__':  
89     test()  

BASH: 

1 #!/usr/bin/env bash  
2 绕了我吧。。。。。特别是算法二。。复杂的递归用bash来写就是自虐。Bash似乎本来就不是用来描述算法用的，呵呵，以后没有什么事一般就不把bash搬出来了。

 

 

 

**_write by_**** _九天雁翎_**** _(JTianLing) -- www.jtianling.com_**

 
