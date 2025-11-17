---
layout: post
title: "一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记 习题2.8 随机数组的三种生成算法（补） 将bash的实现翻译成比较纯正的bash风格"
categories:
- "算法"
tags:
- Bash
- "《数据结构与算法分析-C++描述》"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '9'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

#   一个无聊男人的疯狂《数据结构与算法分析-C++描述》学习笔记  
用（7）习题2.8 随机数组的三种生成算法补 将bash的实现翻译成比较纯正的bash风格  

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

 

<<Data Structures and Algorithm Analysis in C++>>

\--《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第49面， 一随机数组的三种生成算法

由于偷懒我最近老是喜欢用bash从C语言（其实好像是csh)中引进的语法，所以感觉都不是那么纯粹的bash风格（但是其实bash的风格我本来就不 喜欢），老是学了不用，有一天写bash都当C语言在写就完了。今天加班比较晚，就不搞什么新内容了，将2.8的bash实现翻译成了比较纯粹的bash 风格。。。。对于没有接触过Bash的人来说更加接近天书了，enjoy it......(I hope you can)

```bash
1 #!/usr/bin/env bash
2
3 # just for
a range rand....let me die....
4 # what I had said? bash is not a
good
5 # language
for describing algorithms
6 randInt**()**
7 {
8     **local**  a=$1
9     **local**  b=$2
10
11     **if**  **[**  **"** $a**"**  **-gt**  **"** $b**"**  **]**
12     **then**
13         **local**  temp=$a
14         a=$b
15         b=$temp
16     **fi**
17
18     **local**  mi=$(($b-$a+1))
19     **local**  **r=** $((RANDOM%${mi}+${a}))
20     **echo**  -n $r
21 }
22
23 randArr1**()**
24 {
25 # only one
argument because I hate the
26 # bash's
indirect reference
27 # you can
reference the (4) binarySearch to
28 # see what I
said
29     **local**  n=$1
30     **for**  i **in**  `seq $n`
31     **do**
32         **while  true**
33 **         do**
34             temp=`randInt 1 $n`
35             j=1
36             **while  [** **"** $j**"**  **-lt**  **"** $i**"**  **]**
37 **             do**
38                 **if**  **[**  ${a[j]} **-eq**  **"** $temp**"**  **]**
39                 **then**
40                     **break**
41                 **fi**
42                 j=$(($j+1))
43             **done**
44             **if**  **[**  **"** $j**"**  **-eq**  **"** $i**"**  **]**
45             **then**
46                 a**[** j**]=** $temp
47                 **break**
48             **fi**
49         **done**
50     **done**
51
52     **echo**  ${a[*]}
53 }
54
55 randArr2**()**
56 {
57     **local**  n=$1
58     # used for bool array
59     **for**  i **in**  `seq $n`
60     **do**
61         **while  true**
62 **         do**
63             **local**  temp=`randInt 1 $n`
64             **if**  **[**  **-z**  ${b[temp]} **]**
65             **then**
66                 a**[** i**]=** $temp
67                 b**[** temp**]=** true
68                 **break**
69             **fi**
70         **done**
71     **done**
72
73     **echo**  ${a[*]}
74 }
75
76 randArr3**()**
77 {
78     **local**  n=$1
79     **for**  i **in**  `seq $n`
80     **do**
81         a**[** i**]=** $i
82     **done**
83     **for**  i **in**  `seq $n`
84     **do**
85         **local**  temp=`randInt 1 $n`
86         t=${a[i]}
87         a**[** i**]=** ${a[temp]}
88         a**[** temp**]=** $t
89     **done**
90
91     **echo**  ${a[*]}
92 }
93
94 # so slow that I
can't bear it run 100 times
95 randArr1 10
96 randArr2 10
97 randArr3 10
98
```

 

 

**_write by_**** _九天雁翎_**** _(JTianLing) -- www.jtianling.com_**