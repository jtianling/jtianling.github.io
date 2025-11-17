---
layout: post
title: "关于容器输出的学习与简化过程"
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
  views: '10'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

在学习C++标准库的过程中，各种容器是很大一块，每次验证自己的结果输出容器的时候除了string 可以简单的cout<<输出以外，其他的都要for()循环用迭代器遍历，比如输出vector<int> vec容器就要这样

```cpp
for(vector<int>::iterator it = vec.begin(); it != vec.end(),++it)
    cout<<*it<<" :;
cout<<endl;
```

很不方便，所以以前就自己编了个重载函数printCon以输出常用的容器

```cpp
void printCon(list<int>::const_iterator,list<int>::const_iterator);  
void printCon(deque<int>::const_iterator,deque<int>::const_iterator);  
void printCon(vector<int>::const_iterator,vector<int>::const_iterator);  
void printCon(vector<string>::const_iterator,vector<string>::const_iterator);

main()

{return 0;}
```

```cpp
void printCon(list<int>::const_iterator first,list<int>::const_iterator last)  
{  
  cout<<endl;  
  for(;first != last;++first)  
  {  
    cout <<*first<<" ";  
  }  
  cout<<endl;  
}  
void printCon(deque<int>::const_iterator first,deque<int>::const_iterator last)  
{  
  cout<<endl;  
  for(;first != last;++first)  
  {  
    cout <<*first<<" ";  
  }  
  cout<<endl;  
}  
void printCon(vector<int>::const_iterator first,vector<int>::const_iterator last)  
{  
  cout<<endl;  
  for(;first != last;++first)  
  {  
    cout <<*first<<" ";  
  }  
  cout<<endl;  
}  
void printCon(vector<string>::const_iterator first,vector<string>::const_iterator last)  
{  
  cout<<endl;  
  for(;first != last;++first)  
  {  
    cout <<*first<<" ";  
  }  
  cout<<endl;  
}
```

使用起来还算方便，也简洁，只要两个迭代器就可以遍历输出容器，而且输出范围内的容器也可以。就是代码比较复杂，假如要适应全部的容器，代码将会复杂的吓人，但我没有学过模版，不知道那样是不是可以使这个函数简单一些，不过学了流迭代器以后，问题得到了解决，上面那个问题，只需要

```cpp
std::ostream_iterator<int> ost_iter(cout," ");  
std::copy(vec.begin(),.vec.end(),ost_iter);
```

就可以得到解决了，真是简单多了啊，终于知道为什么C++要定义输出流迭代器这乍一看没有什么用的东西了。