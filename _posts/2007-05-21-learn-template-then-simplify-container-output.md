---
layout: post
title: "学了模板再来看容器输出的简化"
categories:
- C++
tags:
- C++
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '2'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

以前提到了在学习C++标准库的过程中《 _  关于容器输出的学习与简化过程_ 》，当时没有学习一点模版的东西，所以怎么弄都还是比较复杂，学到模版的第一件事，我就是想用它来简化容器的输出，当然，实现后，我也体会到了模版的强大和泛型编程方式的优点（这样说似乎是太大了，不过可以管中窥豹嘛），下面看一个用模版实现的容器输出：

```cpp
template <class T>
void printCon(const T &orig)
{
 for(T::const_iterator it = orig.begin();it != orig.end();++it)
  cout<<*it<<" ";
 cout<<endl;
}
```

简单几行，就可以输出一切容器。。。。而且还包括你自己实现的带类似成员的自定义类，其功能强大，不言而喻！难怪在看到C++的模版技术后，JAVA也引进了这一强大技术(似乎是在JDK1.5以后）。这样就太短了，可是也没有什么其它好说的了。看看使用吧。

```cpp
#include<iostream>
#include<vector>
#include<string>
using namespace std;
int main()
{
vector<string> svec;
svec.push_back("ABC");
svec.push_back("BCD");
printCon(svec);
vector<int> ivec;
ivec.push_back(100);
ivec.push_back(10);
printCon(ivec);
}
```

一经定义，反复使用：）简直就是一劳永逸嘛。。。。虽然话是说C能实现C++的一切功能，但是。。。。要实现这样的容器输出该需要多少行代码啊。。。。。（#·￥%#……#￥……，C中根本就没有这样的容器，不需要实现这样的输出.......................晕）