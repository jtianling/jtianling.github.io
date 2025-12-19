---
layout: post
title: "《数据结构与算法分析-C++描述》List实现的问题，g++太符合标准，以至于有的时候虽然正确，但是却会让你吃惊"
categories:
- "算法"
tags:
- C++
- g++
- List
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

g++因严格遵循C++标准，在模板继承中访问基类成员时需显式使用`this->`，此行为虽正确但常令人意外。

<!-- more -->

# 《数据结构与算法分析-C++描述》List实现的问题，g++太符合标准，以至于有的时候虽然正确，但是却会让你吃惊


<<Data Structures and Algorithm Analysis in C++>>

\--《数据结构与算法分析c++描述》 Mark Allen Weiss著 人民邮电大学出版 中文版第63-71面， 图3-11到3-16，实现的一个用链表实现的列表List类。

原实现大概如下：（我可能修改了一些变量的命名以符合我的习惯）

```cpp
  1 #ifndef __LIST_H__  
  2 #define __LIST_H__  
  3   
  4 **template**  <**typename**  T>  
  5 **class**  CList  
  6 {  
  7 **private** :  
  8     **struct**  CNode  
  9     {  
 10         CNode( **const**  T& aData = T(), CNode *apPrev = NULL, CNode *apNext = NULL)  
 11             : mData(aData),mpPrev(apPrev),mpNext(apNext) { }   
 12         T mData;  
 13         CNode *mpPrev;  
 14         CNode *mpNext;  
 15     };  
 16   
 17 **public** :  
 18     **class**  const_iterator  
 19     {  
 20     **public** :  
 21         // in the book, We have Head and Tail, why we still need  
 22         // to use this constructor? I Don't think we need this.  
 23         const_iterator():mpCurrent(NULL) { }  
 24   
 25         **const**  T& **operator** *() **const**  
 26         {  
 27             **return**  retrieve();  
 28         }  
 29   
 30         const_iterator& **operator** ++()  
 31         {  
 32             mpCurrent = mpCurrent->mpNext;  
 33             **return**  * **this** ;  
 34         }  
 35   
 36         const_iterator **operator** ++(**int**)  
 37         {  
 38             const_iterator lOld = * **this** ;  
 39             ++(* **this**);  
 40             **return**  lOld;  
 41         }  
 42   
 43         **bool**  **operator** == ( **const**  const_iterator& aoOrig) **const**  
 44         {  
 45             **return**  (mpCurrent == aoOrig.mpCurrent);  
 46         }  
 47   
 48         **bool**  **operator**!= (**const**  const_iterator& aoOrig) **const**  
 49         {  
 50             **return**  !(* **this**  == aoOrig);  
 51         }  
 52   
 53     **protected** :  
 54         T& retrieve() **const**  
 55         {  
 56             **return**  mpCurrent->mData;  
 57         }  
 58   
 59         const_iterator(CNode *apCur) : mpCurrent(apCur) { }  
 60   
 61         **friend**  **class**  CList<T>;  
 62   
 63         CNode* mpCurrent;  
 64     };  
 65   
 66     **class**  iterator : **public**  const_iterator  
 67     {  
 68     **public** :  
 69         iterator() { }  
 70   
 71         T& **operator** * ()  
 72         {  
 73             // derived from const_iterator  
 74             // standard C++ need this.....but VS2005 don't need it.  
 75             **return**  **this** ->retrieve();  
 76         }  
 77   
 78         // Anybody tell me why we need this?  
 79         // If we really need this const thing  
 80         // why not use using statement  
 81         **const**  T& **operator** * () **const**  
 82         {  
 83             **return**  const_iterator::**operator** *();  
 84         }  
 85   
 86         **using**  const_iterator::mpCurrent;  
 87         iterator& **operator** ++()  
 88         {  
 89             // standard C++ need this.....but VS2005 don't need it.  
 90             **this** ->mpCurrent = **this** ->mpCurrent->mpNext;  
 91             **return**  * **this** ;  
 92         }  
 93   
 94         iterator **operator** ++(**int**)  
 95         {  
 96             iterator lOld = * **this** ;  
 97             ++(* **this**);  
 98             **return**  lOld;  
 99         }  
100   
101     **protected** :  
102         iterator(CNode *apCur) : const_iterator(apCur) { }  
103   
104         **friend**  **class**  CList<T>;  
105     };  
106   
107 **public** :  
108     CList()  
109     {  
110         init();  
111     }  
112   
113     CList(**const**  CList& aoOrig)  
114     {  
115         init();  
116         * **this**  = aoOrig;  
117     }  
118   
119     ~CList()  
120     {  
121         clear();  
122         **delete**  mpHead;  
123         **delete**  mpTail;  
124     };  
125   
126     **const**  CList& **operator** = (**const**  CList &aoOrig)  
127     {  
128         **if**(**this**  == &aoOrig)  
129         {  
130             **return**  * **this** ;  
131         }  
132   
133         clear();  
134   
135         **for**( const_iterator lit = aoOrig.begin();  
136                 lit != aoOrig.end(); ++lit)  
137         {  
138             push_back(*lit);  
139         }  
140   
141         **return**  * **this** ;  
142     }  
143   
144     **void**  init()  
145     {  
146         miSize = 0;  
147         mpHead = **new**  CNode;  
148         mpTail = **new**  CNode;  
149         mpHead->mpNext = mpTail;  
150         mpTail->mpPrev = mpHead;  
151     }  
152   
153     iterator begin()  
154     {  
155         **return**  iterator(mpHead->mpNext);  
156     }  
157   
158     const_iterator begin() **const**  
159     {  
160         **return**  const_iterator(mpHead->mpNext);  
161     }  
162   
163     iterator end()  
164     {  
165         **return**  iterator(mpTail);  
166     }  
167   
168     const_iterator end() **const**  
169     {  
170         **return**  const_iterator(mpTail);  
171     }  
172   
173     **int**  size() **const**  
174     {  
175         **return**  miSize;  
176     }  
177   
178   
179     **bool**  empty() **const**  
180     {  
181         **return**  (size() == 0);  
182     }  
183   
184     **void**  clear()  
185     {  
186         **while**( !empty())  
187         {  
188             pop_front();  
189         }  
190     }  
191   
192     T& front()  
193     {  
194         **return**  *begin();  
195     }  
196   
197     **const**  T& front() **const**  
198     {  
199         **return**  *begin();  
200     }  
201   
202     T& back()  
203     {  
204         **return**  *--end();  
205     }  
206   
207     **const**  T& back() **const**  
208     {  
209         **return**  *--end();  
210     }  
211   
212     **void**  push_front(**const**  T& aoOrig)  
213     {  
214         insert(begin(), aoOrig);  
215     }  
216   
217     **void**  push_back(**const**  T& aoOrig)  
218     {  
219         insert(end(), aoOrig);  
220     }  
221   
222     **void**  pop_front()  
223     {  
224         erase(begin());  
225     }  
226   
227     **void**  pop_back()  
228     {  
229         erase(--end());  
230     }  
231   
232     iterator insert(iterator aItr, **const**  T& aoOrig)  
233     {  
234         CNode *lpCur = aItr.mpCurrent;  
235         ++miSize;  
236         **return**  iterator( lpCur->mpPrev = lpCur->mpPrev->mpNext = **new**  CNode(aoOrig, lpCur->mpPrev, lpCur));  
237     }  
238   
239     iterator erase(iterator aItr)  
240     {  
241         CNode *lpCur = aItr.mpCurrent;  
242         iterator litRet(lpCur->mpNext);  
243         lpCur->mpPrev->mpNext = lpCur->mpNext;  
244         lpCur->mpNext->mpPrev = lpCur->mpPrev;  
245   
246         **delete**  lpCur;  
247         \--miSize;  
248   
249         **return**  litRet;  
250     }  
251   
252     iterator erase( iterator aitStart, iterator aitEnd)  
253     {  
254         **for**(iterator lit = aitStart; lit != aitEnd; NULL)  
255         {  
256             lit = erase(lit);  
257   
258         }  
259   
260     }  
261   
262   
263 **private** :  
264     **int**  miSize;  
265     CNode *mpHead;  
266     CNode *mpTail;  
267   
268 };  
269   
270   
271   
272   
273   
274   
275   
276   
277 #endif
```

需要注意的是iterator的实现部分，iterator和const_iterator是CList的嵌套类，这个没有问题，而CList是个模板类，iterator又继承自const_iterator，这就有问题了，书中原来并没有我这里写的this，那么在g++中会报错，这个原因我一下也没有发现。因为说实话，工作中，学习中，复杂的模板应用用的本来就比较少，平时也常常习惯了VS2005了，而这个特性在VS2005中是不存在的。

直觉告诉我的就是VS不合标准，查过资料以后，发现情况果然是这样。

见 <http://www.redhat.com/docs/manuals/enterprise/RHEL-4-Manual/gcc/c---misunderstandings.html>

RH关于g++的手册中有所描述。

C++ is a complex language and an evolving one, and its standard definition (the ISO C++ standard) was only recently completed. As a result, your C++ compiler may occasionally surprise you, even when its behavior is correct. 

我标记成红色的部分意思是，虽然你的C++编译器的行为是正确的，还是可能让你吃惊：）这就是一个这样的特性。

这里贴一下原来的解释，不翻译了

## 11.9.2. Name lookup, templates, and accessing members of base classes

The C++ standard prescribes that all names that are not dependent on template parameters are bound to their present definitions when parsing a template function or class.[[1]](<http://www.redhat.com/docs/manuals/enterprise/RHEL-4-Manual/gcc/c---misunderstandings.html#FTN.AEN14997>) Only names that are dependent are looked up at the point of instantiation. For example, consider 

```cpp
  void foo(double);
 
 
 
  struct A {
 
 
    template <typename T>
 
 
    void f () {
 
 
      foo (1);        // 1
 
      int i = N;      // 2
 
      T t;
 
      t.bar();        // 3
 
      foo (t);        // 4
 
    }
 
 
 
    static const int N;
 
 
  };  
```

---

Here, the names `foo` and `N` appear in a context that does not depend on the type of `T`. The compiler will thus require that they are defined in the context of use in the template, not only before the point of instantiation, and will here use `::foo(double)` and `A::N`, respectively. In particular, it will convert the integer value to a `double` when passing it to `::foo(double)`. 

Conversely, `bar` and the call to `foo` in the fourth marked line are used in contexts that do depend on the type of `T`, so they are only looked up at the point of instantiation, and you can provide declarations for them after declaring the template, but before instantiating it. In particular, if you instantiate `A::f<int>`, the last line will call an overloaded `::foo(int)` if one was provided, even if after the declaration of `struct A`. 

This distinction between lookup of dependent and non-dependent names is called two-stage (or dependent) name lookup. G++ implements it since version 3.4. 

Two-stage name lookup sometimes leads to situations with behavior different from non-template codes. The most common is probably this: 

```cpp
  template <typename T> struct Base {
    int i;
  };
 
 
  template <typename T> struct Derived : public Base<T> {
    int get_i() { return i; }
  };  
```

---

In `get_i()`, `i` is not used in a dependent context, so the compiler will look for a name declared at the enclosing namespace scope (which is the global scope here). It will not look into the base class, since that is dependent and you may declare specializations of `Base` even after declaring `Derived`, so the compiler can't really know what `i` would refer to. If there is no global variable `i`, then you will get an error message. 

In order to make it clear that you want the member of the base class, you need to defer lookup until instantiation time, at which the base class is known. For this, you need to access `i` in a dependent context, by either using `this->i` (remember that `this` is of type `Derived<T>*`, so is obviously dependent), or using `Base<T>::i`. Alternatively, `Base<T>::i` might be brought into scope by a `using`-declaration.  

Another, similar example involves calling member functions of a base class: 

```cpp
  template <typename T> struct Base {
      int f();
  };
 
 
  template <typename T> struct Derived : Base<T> {
      int g() { return f(); };
  };  
```

---

Again, the call to `f()` is not dependent on template arguments (there are no arguments that depend on the type `T`, and it is also not otherwise specified that the call should be in a dependent context). Thus a global declaration of such a function must be available, since the one in the base class is not visible until instantiation time. The compiler will consequently produce the following error message: 

```text
  x.cc: In member function `int Derived<T>::g()':
  x.cc:6: error: there are no arguments to `f' that depend on a template
     parameter, so a declaration of `f' must be available
  x.cc:6: error: (if you use `-fpermissive', G++ will accept your code, but
     allowing the use of an undeclared name is deprecated)
```

---

To make the code valid either use `this->f()`, or `Base<T>::f()`. Using the `-fpermissive` flag will also let the compiler accept the code, by marking all function calls for which no declaration is visible at the time of definition of the template for later lookup at instantiation time, as if it were a dependent call. We do not recommend using `-fpermissive` to work around invalid code, and it will also only catch cases where functions in base classes are called, not where variables in base classes are used (as in the example above). 

Note that some compilers (including G++ versions prior to 3.4) get these examples wrong and accept above code without an error. Those compilers do not implement two-stage name lookup correctly. 

基本意思是，在模板继承出现的时候，需要在子类中用this来标志从父类中继承过来的成员函数和变量的调用。不然用using声明也行。

其实看过这个问题的解释后，我才想起来，Effective C++也有类似的描述。

Effective C++,3rd,Item 43,Know How to access names in templatized base classes.

只是平时没有出现这个问题，一下子忘记了。回头再看看这一节：）

下面是测试代码：（测试并没有完全覆盖）

```cpp
 1 #include <stdio.h>  
 2 #include <stdlib.h>  
 3 #include <iostream>  
 4 #include <iterator>  
 5 #include <algorithm>  
 6 #include "list.h"  
 7 **using**  **namespace**  std;  
 8   
 9 **int**  main(**int**  argc, **char** * argv[])  
10 {  
11     CList<**int** > loList1;  
12     loList1.push_back(1);  
13     loList1.push_back(2);  
14     loList1.push_back(3);  
15     loList1.push_back(4);  
16     CList<**int** > loList2(loList1);  
17   
18     CList<**int** > loList3;  
19     loList3 = loList2;  
20   
21     **for**(CList<**int** >::iterator lit = loList3.begin();  
22             lit != loList3.end(); ++lit)  
23     {  
24         cout <<*lit <<" ";  
25     }  
26   
27     cout <<endl;  
28   
29   
30     exit(0);  
31 }  
32
```

这里要说明一下的是，我本来想用copy来输出的，所以包含了algorithm和iterator头文件，后来发现CList中的迭代器还没有实现trails,所以不能用。

