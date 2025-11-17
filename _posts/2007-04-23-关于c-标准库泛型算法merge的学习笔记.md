---
layout: post
title: "关于C++标准库泛型算法merge的学习笔记"
categories:
- C++
tags:
- C++
- merge
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

```cpp
#include <vector>
#include <string>
#include <iostream>
#include <list>
#include <algorithm>
#include <iterator>
using namespace std;

int main(int argc, char *argv[])
{
    std::ostream_iterator<int> ost_iter(cout," ");
    list<int> lst1;
    for(int i = 0;i<10;++i)
        lst1.push_back(i);
    list<int> lst2;
    for(int i = 0;i<10;++i)
        lst2.push_front(i);
    merge(lst1.begin(),lst1.end(),lst2.begin(),lst2.end(),ost_iter);
    cout<<endl;
    return 0;
}
```

会发现程序编译成功，但是运行出错，原因在于merge算法应用时必须先排序才行，改成下面这样：

。。。省略预编译与using

```cpp
int main(int argc, char *argv[])
{
    std::ostream_iterator<int> ost_iter(cout," ");
    list<int> lst1;
    for(int i = 0;i<10;++i)
        lst1.push_back(i);
    list<int> lst2;
    for(int i = 0;i<10;++i)
        lst2.push_front(i);
    std::copy(lst1.begin(),lst1.end(),ost_iter);
    cout<<endl;
    std::copy(lst2.begin(),lst2.end(),ost_iter);
    cout<<endl;
    lst1.sort();
    std::copy(lst1.begin(),lst1.end(),ost_iter);
    cout<<endl;
    lst2.sort();
    std::copy(lst2.begin(),lst2.end(),ost_iter);
    cout<<endl;
    merge(lst1.begin(),lst1.end(),lst2.begin(),lst2.end(),ost_iter);
    cout<<endl;
    return 0;
}
```

文件成功，但是两个容器0,1,2,3,4,5,6,7,8,9合并，竟然变成0，0，1，1，2，2。。。。。奇怪吧。另外，lst1.sort()可以去掉，因为它已经是排好序的了，换句话说，merge运行正确的前提是排好序，而不是一定要你先运行sort()。另外merge不仅有合并的意思，还有融入的意思，感觉这里更像是融入，而不是简单的合并，即我理解的合并在后面。当然，假如仅仅是加在后面用insert就可以了，没有必要用merge 而且，假如merge像，那样还需要先排序干什么呢？