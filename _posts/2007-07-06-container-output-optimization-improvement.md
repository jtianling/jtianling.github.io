---
layout: post
title: "关于容器输出的进一步优化"
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
  views: '3'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

作者改进了C++容器输出函数，通过使用迭代器参数，使其能兼容普通数组，更符合标准库习惯，输出指定范围也更加灵活。

<!-- more -->

以前我讨论过了在自己学习过程中经常要用到的一个特性，就是容器的输出问题，总感觉不是太方便，在学习过程中用的又非常多，我曾经在《 _学了模板再来看容器输出的简化》_ 中已经把他处理的很简单了，不过最近看了 TC++PL受了点启发，又将程序进一步改进，主要的好处是更符合标准库容器的使用习惯，以首尾两个迭代器为输入，而且对普通的数组也可以使用，这样最大的方便之处在于可以接受一个范围的输出了。不过比起以前那种直接传递容器的引用来说，普通的输出整个容器使用上还是复杂一点。

原程序如下：

```cpp
template <typename T>
void printCon(T begin, T last)  //改进后
{
    for(; begin != last; ++begin)
        cout<<*begin<<" ";
    cout<<endl;
}
```

一个使用的例子：

```cpp
using namespace std;

int main()
{
    char cstr[4] = {'a', 'b', 'c', 'd'};
    vector<char> cvec(5, 'a');
    //I put printCon in the namespace of myself
    myself::printCon(cstr, cstr+4);
    myself::printCon(cvec.begin(), cvec.end() );
    return 0;
}
```
