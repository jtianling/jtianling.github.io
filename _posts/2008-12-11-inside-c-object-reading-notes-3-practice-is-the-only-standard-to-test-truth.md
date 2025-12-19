---
layout: post
title: "《Inside C++ Object 》 阅读笔记(3)，实践是检验真理的唯一标准"
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
  views: '16'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

作者通过编程实践，发现《Inside C++ Object》书中的翻译存在误导，并验证了C++中带函数的类不能使用列表初始化语法。

<!-- more -->

# 《Inside C++ Object》 阅读笔记(3)，实践是检验真理的唯一标准


在阅读笔记（2）中，我还以为，按《Inside C++ Object》中文版199面（以后页码都以侯捷中文版为准）示例所描述的那样

“直接以类似={a,b,c}的方式为一个类赋初值。。。这个语法我以前一直以为只能在POD的struct下用。。。结果就算这个类有函数，也照用不误。”

今天的实际测试，证明以前我的认识还是对的，当一个结构中有函数的时候（即不是POD）的时候，列表初始化（explicit initializtion list）不可用，无论是VS2005还是g++都会报错。

就我仔细分析了原文后，感觉可能本来lippman仅仅是描述不清，但是被侯捷翻译后就成了完全的错误了。

这里解释一下，原文本来是

Point1 local1 = { 1.0, 1.0, 1.0 };

Point2 local2；

但是侯捷看到并没有Point1,Point2，只有Point，所以就都改成Point了。。。。

变成了

Point local1 = { 1.0, 1.0, 1.0 };

Point local2;

导致了我的误解，其实也是侯捷理解上的错误（lippman描述和使用的也有问题）

lippman的大概意思是以Point1来表示196面定义的POD类型的Point，以Point2来表示198面定义的一个有构造函数，并且成员为似有变量的Point。但是实际上这里也有个问题，按照描述Point2的成员变量都是私有的，不能进行类似

local2._x = 1.0;
local2._y = 1.0;
local2._z = 1.0;

的操作，不过从这3句前面的注释描述，说此3句相当于一个inline扩展来看，原lippman想要写的正确的程序应该如下：

Point1 local1 = { 1.0, 1.0, 1.0 };

Point2 local2(1.0, 1.0, 1.0)；

结合Point2正好有个内联的构造函数，下面三句其实都是lippman的注释：）

这样的解释最符合道理。。。。。。。。。。差点因为侯捷的误导，lippman的笔误导致了认识上的错误，还以为是自己以前认识错了。。。。。

对于引用变量生存期倒是真的有了新的认识，而且，还好，是正确的：）

我测试的时候都写在一起了，源代码如下：
```cpp
#include <stdio.h>

#include <stdlib.h>

#include <string>

#include <iostream>

using namespace std;

class CPoint
{
public:
    CPoint(int aiX = 0, int aiY = 0, int aiZ = 0)
       : miX(aiX), miY(aiY), miZ(aiZ)
    {
       //  miX  
= 0;
       //  miY  
= 0;
       //  miZ  
= 0;
    }

    friend ostream&  
operator<< (ostream&  
aos, const CPoint& aoPoint);
    //private:

public:
    int miX;
    int miY;
    int miZ;
};

struct SPoint
{
    int miX;
    int miY;
    int miZ;
};


ostream& operator<<  
(ostream& aos,  
const CPoint&  
aoPoint)
{
    aos <<"miX: " <<aoPoint.miX <<"/t"
       <<"miY: "  
<<aoPoint.miY  
<<"/t"
       <<"miZ: "  
<<aoPoint.miZ  
<<"/t";

    return aos;
}
int main(int argc, char* argv[])
{
    // reference to temp is valid
    const string  
&str= string("good");

    cout <<str <<endl;

    // pointer to temp is not valid
    const string  
*pstr = &string("good");

    cout <<*pstr <<endl;

    CPoint loPoint(1,2,3);

    // line below this is not allowed
    // if CPoint have any function it is  
not a POD
    //CPoint loPoint = { 1, 2, 3 };

    SPoint lsPoint = { 1, 2, 3};

    //cout <<loPoint <<endl;

    exit(0);
}
```
虽然这边文章有点太考究书本和语法了。。。。。但是其实也再次的给我巩固了一个道理，那就是实践才是检验真理的唯一标准，哪怕侯捷的翻译，lippman的经典著作，一样可能有问题，再经典的书籍，也不能全信，要经过实验，我才能确信。

