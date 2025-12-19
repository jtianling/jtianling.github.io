---
layout: post
title: "看《C++ STL》发现的关于异常说明的问题"
categories:
- C++
tags:
- C++
- "《C++ STL》"
- "异常"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '11'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---


今天开翻《C++ STL》一书，就发现一个问题，那就是目前的编译器好像尚不支持C++的异常说明，源代码如下：

<!-- more -->

```cpp
#include "stdafx.h"

#include <iostream>

#include <string>

using namespace std;

 

class c1

{

public:

    c1()

    {

       c1str = "error 1";

    }

    string c1str;

};

class c2

{

public:

    c2()

    {

       c2str = "error 2";

    }

    string c2str;

};

 

void fn() throw (c1)

{

    cout<<"have problem"<<endl;

    throw c2();

}

 

int main()

{

    try

    {

       fn();

    }

    catch (const c2& err)

    {

        cout << err.c2str<<endl;

    }       

    cout <<"Done"<<endl;

    return 0;

}
```

在VS 2005中异常说明会得出警告： warning C4290: 忽略C++ 异常规范，但指示函数不是__declspec(nothrow)

警告MSDN中的原文解释如下：

#### 警告消息

忽略 C++ 异常规范，但指示函数不是 __declspec(nothrow)

使用异常规范声明函数，Visual C++ 接受但并不实现此规范。包含在编译期间被忽略的异常规范的代码可能需要重新编译和链接，以便在支持异常规范的未来版本中重用。

有关更多信息，请参见 Exception Specifications。

使用 warning 杂注可避免出现此警告：

意思大概就是异常说明VS 2005仅仅是接受，而并没有实现，也就是相当于没有这个功能，但是不报错。此源代码在Dev 4.9.9.0可以得出正确结果。提示程序在运行时被非正常终结，并且仅仅只输出have problem;而VS 2005把所有的东西都输出了。据说VS 2005已经非常符合标准了，就我的学习过程的确是这样，今天看来，还尚有为尽之处，不过，但是也没有人说它完全符合标准，好像也就97%多吧。

将此事进一步研究，发现如下代码：

```cpp
#include <iostream>

#include <string>

using namespace std;

 

class c1

{

public:

    c1()

    {

       c1str = "error 1";

    }

    string c1str;

};

class c2

{

public:

    c2()

    {

       c2str = "error 2";

    }

    string c2str;

};

 

void fn() throw (c1,bad_exception)

{

    cout<<"have problem"<<endl;

    throw c2();

}

 

int main()

{

    try

    {

       fn();

    }

    catch (const c2 &err)

    {

       cout << err.c2str <<endl;

    }

    catch (const bad_except  ion&)

    {

        cout << "catch bad_exception"<<endl;

    }

    catch (...)

    {

        cout << "catch another exception"<<endl;

    }                

    cout <<"Done"<<endl;

    return 0;

}
```

当然在VS中还是只能捕捉到异常c2，而在DEV中奇怪的是确还是中断了，按《C++ STL》书中的说法，此时应该捕捉到异常bad_exception才对，另外，有一点想说的是，《C++ Primer》一书第4版中我没有找到关于bad_exception的介绍，而其它类型的异常倒还是有。再另外，我在VS 2005的exception头文件的源代码中的确发现了bad_exception异常，其注释为base of all bad exceptions。在DEV中源代码注释为f an %exception is thrown which is not listed in a function's %exception specification, one of these may be thrown.和This declaration is not useless，如此，就不是异常的捕捉代码有问题，而是的确程序没有正常抛出了。则我，书，和DEV三者中必有一错，希望高人指出。
