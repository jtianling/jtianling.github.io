---
layout: post
title: "关于STL容器输出的更进一步简化，便于平时学习使用"
categories:
- C++
tags:
- C++
- STL
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '5'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

以前我在实际学习过程中因为没有好的容器输出方法而苦恼，目前知道的最简单的方法也可能就是如下方式了：

copy(container.begin(),container.end(),ostream(cout," ");

当然，其实也不是怎么太复杂，只是最开始不怎么知道。到今天，已经知道可以一行代码就输出容器了，我还优化什么啊？看了就知道了。

```cpp
//以容器为输入的简化函数，第二参数为前置的string，默认为空
template <class T>
void printCon(const T &orig,const std::string str ="")
{
    std::cout <<str;
    typename T::const_iterator it;
    for(it = orig.begin();it != orig.end(); ++it)
        std::cout << *it <<" ";
    cout<<endl;
}
```

```cpp
//重载的容器输出函数，以迭代器为输入，方便输出容器的一部份甚至数组，
//第三参数为前置的string，默认为空
template <class T>
void printCon(T itBegin, T itEnd, const std::string str ="")
{
    std::cout <<str;
    for( NULL; itBegin != itEnd; ++itBegin)
        std::cout << *itBegin <<" ";
    cout<<endl;
}
```

竟然是要简单，所以当然应该提供只需要一个容器参数就可以输出的方法，但是却还想要保留输出范围的能力，怎么办呢？重载。。。。

另外，输出的时候前面一般加说明，这里以一个默认为空的参数加进来，这样更加方便了，另外，我用const std::string而不用const char*是为了应用范围更广泛，因为有char* 到 string的默认构造函数，可以自动转换，反之则不行，不知道这样有没有副作用，高手提醒之。还有，因为常用，我把它放到myself名字空间下。这里未与列出。