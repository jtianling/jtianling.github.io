---
layout: post
title: "《Inside C++ Object 》 阅读笔记(2)，看《Inside C++ Object 》的作用"
categories:
- C++
tags:
- C++
- "《Inside C++ Object 》"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '17'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

# 《Inside C++ Object 》 阅读笔记(2)，看《Inside C++ Object 》的作用

 

**_write by_**** _九天雁翎(JTianLing) --  
blog.csdn.net/vagrxie_**

因为你永远也不可能完全弄清楚C++在你背后做了多少工作，所以你永远都会需要sizeof来帮助你确认你的判断。我从刚开始学C++到现在sizeof是用的不断，直到现在读《Inside C++ Object》还是会碰到。简直是无语。呵呵，用了这么多次的sizeof，少说也是有点经验的：）其实还是用宏的奇技淫巧而已，不推荐广泛使用。

《Inside C++ Object》中文版83面的虚继承问题，在我g++版本上跑的结果是

1 ,4,4,4

在VS2005 SP1版本上跑的结果是1,4,4,8。说明g++在编译器的优化上比MS还是走的远一点。。。。MS的优化总是走一些偷懒的奇怪路线：）实打实的东西又不做。。。。。。。从VC5.0到现在好像还是没有进步。。。。（说的严重了，仅仅是这一点吧）

测试代码如下：

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
using namespace std;

class X {};
class Y : public virtual X { };
class Z : public virtual X { };
class A : public virtual Z { };

#define test(_type) TestSize(sizeof(_type), #_type)

void TestSize(int aiSize, string astrType)
{
    cout <<astrType <<"  
: " <<aiSize <<endl;
}


int main(int argc, char* argv[])
{

    test(X);
    test(Y);
    test(Z);
    test(A);

    exit(0);
}
```

 

关于类成员指针的问题：

以下是我的测试源代码：

```cpp
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
using namespace std;

// Plain  
Ol' Data

class CPoint3dPOD
{
public:
    int x;
    int y;
    int z;
};

// Have  
vptr

class CPoint3dVir
{
public:
    virtual ~CPoint3dVir();
    int x;
    int y;
    int z;
};

class CPoint2dSD
{
public:
    ~CPoint2dSD() {}
    int x;
    int y;
};

// single  
Derived

class CPoint3dSD : public CPoint2dSD
{
public:
//  ~CPoint3dSD() {}
    int z;
};

// double

class CPoint1dDD
{
public:
    int x;
};

class CPoint2dDD
{
public:
    int y;
    int z;
};

class CPoint3dDD : public CPoint1dDD,public CPoint2dDD
{

};

class CPoint3dVD : virtual public CPoint1dDD,virtual  
public CPoint2dDD
{

};

#define pt(_t) printf("&CPoint3d"#_t" = %p/n", &CPoint3d##_t)


int main(int , char* argv[])
{
    pt(POD::x);
    pt(POD::y);
    pt(POD::z);

    pt(Vir::x);
    pt(Vir::y);
    pt(Vir::z);

    pt(SD::x);
    pt(SD::y);
    pt(SD::z);

    pt(DD::x);
    pt(DD::y);
    pt(DD::z);

    pt(VD::x);
    pt(VD::y);
    pt(VD::z);

    exit(0);
}
```

 

G++中结果如下

```text
&CPoint3dPOD::x  
= (nil)

&CPoint3dPOD::y  
= 0x4

&CPoint3dPOD::z  
= 0x8

&CPoint3dVir::x  
= 0x4

&CPoint3dVir::y  
= 0x8

&CPoint3dVir::z  
= 0xc

&CPoint3dSD::x  
= (nil)

&CPoint3dSD::y  
= 0x4

&CPoint3dSD::z  
= 0x8

&CPoint3dDD::x  
= (nil)

&CPoint3dDD::y  
= (nil)

&CPoint3dDD::z  
= 0x4

&CPoint3dVD::x  
= (nil)

&CPoint3dVD::y  
= (nil)

&CPoint3dVD::z  
= 0x4
```

 

结果有些有点意外，其一，单继承时有无虚表竟然不影响。多重继承x，y全为0等和书上不一样。

 

其实我在VS2005中可以将测试程序做的更简单。。。。好像g++中不支持宏扩展后的再扩展。。。。不知道是不是VS2005超标准了。。。或者说不符合标准

类定义同上，测试代码如下：

```cpp
#define pt(_x) printf("&"#_x" = %p/n", &##_x)
#define pt3(_x) pt(CPoint3d##_x::x);/
    pt(CPoint3d##_x::y);/
    pt(CPoint3d##_x::z);


int main(int argc, char* argv[])
{

    pt3(POD);
    pt3(Vir);
    pt3(SD);
    pt3(DD);
    pt3(VD);

    exit(0);
}
```

 

结果和g++完全一致，这里就不贴图了。。。因为好像不好copy.

 

最后总结一下看此书的作用，首先的确是对C++有了更多的认识，说到到底是哪些认识可能一下又说不清楚：）

首先这里谈几点以前我忽视了的C++的语法问题吧：

1.       
dynamic_cast转换引用的问题，这点我C++ Primer中虽然有，但是其实一直没有注意到。

2.       
placement new的语法，以前还真不知道。看了此书后知道了，这点对我很带有帮助。。。因为接下来的工作做内存管理的时候正好碰到了，我一点也没有惊讶：）

3.       
直接以类似={a,b,c}的方式为一个类赋初值。。。这个语法我以前一直以为只能在POD的struct下用。。。结果就算这个类有虚函数，也照用不误。

4.       
上述的成员对象的指针的问题。。。。

 

其次，关于几个概念性的知识:

1.       
NRV优化：）

2.       
POD和trivial constructor,deconstructor,copy constructor等的相关概念，及什么时候它们是trivial的，虽然以前有点肤浅的认识，但是看了此书后认识的更加深刻了，并且，因为侯捷的翻译，说时候，懂了这几个单词。。。对我帮助很大，因为最近正在看的《STL 源码剖析》中的前几章，关于trait机制的部分，没有这些知识，估计都看不下去。

3.       
类成员变量，包括继承，多重继承，虚继承等的效率认识

4.       
引用的临时变量生命周期，可以一直维持到引用失效。。。这点我一直没有认识到。这也是我见到的唯一一个引用与指针效果有很大差异的地方。

5.       
异常机制带来的性能消耗及异常抛出对象是复制过的，重新抛出的也是原有对象。

6.       
这点可能对于编程的帮助不是太大，但是确实本书的主题。。。对于C++的对象布局有个整体的认识了。。。呵呵，也许假如可能maybe以后学COM之类的东西有用吧。

 

**_write by_**** _九天雁翎_**** _(JTianLing) --  
blog.csdn.net/vagrxie_**