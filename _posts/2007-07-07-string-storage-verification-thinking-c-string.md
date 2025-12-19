---
layout: post
title: "和实现有关的相同字符串存储方式检验的思考及c-string字符串"
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
  views: '5'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文探讨了C++中char*指针的地址，解释了指针变量地址(&p)与指向地址(p)的区别，并演示了如何通过类型转换输出真实地址。

<!-- more -->

```cpp
/*Copyright (c) 2007,九天雁翎

* All rights reserved.

* 和实现有关的相同字符串存储方式检验的思考

* 完成日期：2007年7月7日*/

#include "stdafx.h"

#include <iostream>

using namespace std;

int main()
{
    char *p1 = "Hello the world!";
    char *p2 = "Hello the world!";
    if(p1 == p2)
    {
        //ok,We could know it is the same as Bjarne Stroustrup said in VC++2005
        cout << "The same."<<endl;          
    }
    else
    {
        cout << "Not the same."<<endl;
    }
    //But look at this
    cout << &p1 <<'/t' <<&p2 <<endl;
    //the adress output is not the same!
    //Do you want to output it use p1 and p2?
    //Let try;
    cout << p1 <<'/t' << p2 <<endl;
    //We can only get the string.
    //Let reaffirm it
    if(&p1 == &p2)
    {
        cout<<"The same." <<endl;
    }
    else
    {
        cout<<"Not the same." <<endl;
    }
    return 0;
}
```

&p其实得到的是指针的地址，而不是c-string "Hello word!"的地址，而cout又为char* 重载了一个不同与一般指针的输出方式，所以你要输出"Hello world!"，可以通过static_cast<void*>方式，强制转换到void*指针，这样cout就可以输出想要的结果，结果自然和Bjarne Stroustrup说的一样，微软也没有错。

如下:

```cpp
/*Copyright (c) 2007,九天雁翎

* All rights reserved.

* 和实现有关的相同字符串存储方式检验的思考

* 完成日期：2007年7月7日*/

#include "stdafx.h"

#include "myself.h"

#include <iostream>

using namespace std;

int main()
{
    char *p1 = "Hello the world!";
    char *p2 = "Hello the world!";
    if(p1 == p2)
    {
        cout << "The same."<<endl;          
    }
    else
    {
        cout << "Not the same."<<endl;
    }
    //Yes,it is.
    cout << static_cast<void*>(p1) <<'/t' <<static_cast<void*>(p2) <<endl;
    return 0;
}
```
