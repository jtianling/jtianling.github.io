---
layout: post
title: "警惕！C++里面“=”不一定就是等于（赋值）。"
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
  views: '13'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

欢迎转载，但请标明作者 “九天雁翎”，当然，你给出这个帖子的链接更好。

让我们来现在看一个这样的程序：

```cpp
#include   
using namespace std;  
class HasPtr  
{  
public:  
    int *ptr;  
    int val;  
    HasPtr(const int &p,int i):ptr(new int(p)),val(i) { }  
    HasPtr& operator=(const HasPtr &rhs)  
    {  
        ptr = new int;

        *ptr = *rhs.ptr;  
        val =rhs.val;  
        return *this;  
    }  
    ~HasPtr()  
    {  
        delete ptr;  
    }  
};

int main()  
{  
    int ival = 5;  
    HasPtr a(ival,5);  
    HasPtr b = a;  
    cout<<*(a.ptr);  
    return 0;  
}
```

这是看起来是一个没有任何问题的程序，并且在指针的回收处理上非常好，用的是值型指针来处理类里面的指针，在VC(以后都是指VC++.net 2005）中编译也可以通过，在Dev-C++4.9.9.0 中编译运行都没有问题。但是在vc中运行却会出问题。原因在哪里？经我论坛发帖求教，是因为HasPtr b = a; 语句其实并不是赋值，而是调用了构造函数。不信？证明如下：

```cpp
#include <iostream>  
using namespace std;  
class HasPtr  
{  
public:  
    int *ptr;  
    int val;  
    HasPtr(const int &p,int i):ptr(new int(p)),val(i) { }  
    HasPtr(const HasPtr &orig):ptr(new int(*orig.ptr)),val(orig.val)  
    {   
        cout<<"Use me(copy constructor)"<<endl;  
    }  
    HasPtr& operator=(const HasPtr &rhs)  
    {  
        cout <<"Use me(=)"<<endl;  
        *ptr = *rhs.ptr;  
        val =rhs.val;  
        return *this;  
    }  
    ~HasPtr()   
    {  
        delete ptr;  
    }  
};

int main()  
{  
    int ivala = 5;  
    HasPtr a(ivala,5);  
    HasPtr b = a;  
    ivala = 6;  
    cout<<*(a.ptr)<<*(b.ptr)<<endl;  
    return 0;  
}
```

这一点在VC和在dev-c++中都是一样的。你会发现调用的都是copy constructor(复制构造函数），不过据说之所以在dev-c++中没有出错，是因为可怜的dev-c++检测能力太差。。。。。。。。。。。.