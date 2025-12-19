---
layout: post
title: "队列(queue)的链表(list)实现及循环数组(circular array)实现 C++实现"
categories:
- "算法"
tags:
- C++
- List
- Queue
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '12'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

文章提供了队列的两种C++实现：链表实现和循环数组实现，并附有完整的代码和测试。

<!-- more -->



<<Data Structures and Algorithm Analysis in C++>>

--《数据结构b与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第78-81面，堆栈的应用(1) 队列(queue)的链表(list)实现及循环数组(circular array) C++实现，需要注意的是，仅仅为了说明问题，没有详细探究代码的健壮，比如，我没有加入错误检测，这点在循环数组的实现是非常容易出现的。并且为了说明问题，我用了一个很小的数组来实现，以完成真正的从尾部到头部的跳转。

另外说明的是，书中队列应用一节我实在想不到有什么可以用代码简单实现的，所以都不写了。

详细情况见代码：

```cpp
queue.h

  1 #ifndef __QUEUE_H__  
  2 #define  
__QUEUE_H__  
  3 #include  <list>  
  4 #include  <vector>  
  5 **using**  **namespace**  std;  
  6   
  7 **template** <**typename**  T>  
  8 **class**  CQueueSimple  
  9 {  
 10 **public** :  
 11     **bool**  empty() **const**  
 12     {  
 13         **return**  moList.empty();  
 14     }  
 15      
 16     **size_t**  size() **const**  
 17     {  
 18         **return**  moList.size();  
 19     }  
 20   
 21     **void**  pop()  
 22     {  
 23         **if**(moList.empty())  
 24         {  
 25             **throw**  -1;  
 26         }  
 27   
 28         moList.pop_front();  
 29     }  
 30   
 31     T&  front()  
 32     {  
 33         **return**  moList.front();  
 34     }  
 35   
 36     **const**  T& front() **const**  
 37     {  
 38         **return**  moList.front();  
 39     }  
 40   
 41   
 42     T&  back()  
 43     {  
 44         **return**  moList.back();  
 45     }  
 46   
 47     **const**  T& back() **const**  
 48     {  
 49         **return**  moList.back();  
 50     }  
 51   
 52     **void**  push(**const**  T&  aItem)  
 53     {  
 54         moList.push_back(aItem);  
 55     }  
 56   
 57 **private** :  
 58     list<T>  moList;  
 59 };  
 60   
 61 //  implement a queue with circular array  
 62 // there  is no error check.  
 63 **template** <**typename**  T, **size_t**  ArraySize>  
 64 **class**  CQueueCir  
 65 {  
 66 **public** :  
 67     CQueueCir()  
 68     {  
 69         // init to zero  
 70         memset(maData,  0, ArraySize * **sizeof**(T)  );  
 71         mpFront  = mpBack = maData + ArraySize/2;  
 72     }  
 73   
 74   
 75     **bool**  empty() **const**  
 76     {  
 77         **return**  !(mpBack - mpFront);  
 78     }  
 79      
 80     **size_t**  size() **const**  
 81     {  
 82         **return**  (mpBack - mpFront);  
 83     }  
 84   
 85     **void**  pop()  
 86     {  
 87         **if**(empty())  
 88         {  
 89             **throw**  -1;  
 90         }  
 91   
 92         ++mpFront;  
 93         RollToHead(&mpFront);  
 94     }  
 95   
 96     T& front()  
 97     {  
 98         **return**  *mpFront;  
 99     }  
100   
101     **const**  T& front() **const**  
102     {  
103         **return**  *mpFront;  
104     }  
105   
106   
107     T& back()  
108     {  
109         **return**  *(mpBack-1);  
110     }  
111   
112     **const**  T& back() **const**  
113     {  
114         **return**  *(mpBack-1);  
115     }  
116   
117     **void**  push(**const**  T&  aItem)  
118     {  
119         *mpBack++  = aItem;  
120         RollToHead(&mpBack);  
121     }  
122   
123   
124 **private** :  
125     **void**  RollToHead(T** ap)  
126     {  
127         **if**(**size_t**(*ap  \- maData) >= ArraySize)  
128         {  
129             *ap  = maData;  
130         }  
131     }  
132   
133     T  maData[ArraySize];  
134     
135     // Hold the important position  
136     T* mpFront;  
137     T* mpBack;  
138 };  
139   
140 #endif
```

测试代码：

```cpp
 1 #include <stdio.h>  
 2 #include  <stdlib.h>  
 3 #include  <iostream>   
 4 #include  "Queue.h"  
 5   
 6 #define  OUT(queue) /  
 7     cout  <<"front: " <<queue.front() <<",back: " <<queue.back()  <<",size: " <<queue.size() <<endl  
 8   
 9 **template** <**typename**  Queue>  
10 **void**  test(Queue&  aoQueue)  
11 {  
12     aoQueue.push(1);  
13     OUT(aoQueue);  
14   
15     aoQueue.push(2);  
16     OUT(aoQueue);  
17   
18     aoQueue.push(3);  
19     OUT(aoQueue);  
20   
21     aoQueue.pop();  
22     OUT(aoQueue);  
23   
24     aoQueue.pop();  
25     OUT(aoQueue);  
26   
27     aoQueue.push(4);  
28     OUT(aoQueue);  
29 }  
30   
31 **int**  main(**int**  argc, **char** *  argv[])  
32 {  
33     CQueueSimple<**int** > liQ;  
34     test(liQ);  
35     cout  <<endl;  
36   
37     CQueueCir<**int** , 3>  liQCir;  
38     test(liQCir);  
39   
40     exit(0);  
41 }  
42
```

