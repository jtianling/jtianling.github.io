---
layout: post
title: Effective C++ 第3版 Item 26详尽研究 个人认为最后一些内容有待商酌
categories:
- C++
tags:
- C++
- "《Effective C++》"
status: publish
type: post
published: true
meta:
  ratings_users: '0'
  ratings_score: '0'
  ratings_average: '0'
  views: '4'
author:
  login: jtianling
  email: jtianling@gmail.com
  display_name: jtianling
  first_name: ''
  last_name: ''
---

本文通过测试反驳《Effective C++》的观点，指出循环变量在循环外定义通常性能更优，并建议将其作为默认选择，仅简单类型除外。

<!-- more -->

Effective C++ 第3版 Item 26详尽研究 个人认为最后一些内容有待商酌

Postpone variable definitions as long as possible? 真的应该这样？

当然，个人承认前面的一部分都没有错，而且是一贯的很对，很有道理，最后作者提到在循环的问题上应该怎么处理，他提出了两个Aproach.

Approach A: define outside loop – 1 constructor + 1 destructor + n assignments

Approach B: define inside loop – n constructors + n destructors

他的结论是假如你不确定实现A比实现B好，那么就都用B，从这个意义上讲，作者的意思是大部分情况下B都要更好，但是其实呢？经过我的测试，几乎绝大部分情况下，A要更好，而且要好的多，我的结论是，除了单纯的简单内建类型，比如int,bool,double等，其他任何情况，包括这些类型的数组，你都应该使用实现A，下面是详细测试代码。

```cpp
//Create By 九天雁翎（jtianling） Email:jtianling@gmail.com
//博客：blog.jtianling.cn

#include <vector>
#include <string>
#include "jtianling/jtianling.h"

using namespace std;

void ApproachA1(int n);
void ApproachB1(int n);
void ApproachA2(int n);
void ApproachB2(int n);
void ApproachA3(int n);
void ApproachB3(int n);
void ApproachA4(int n);
void ApproachB4(int n);

int main()
{
    const int n = 8;
    vector<jtianling::pfI> pfIVec;
    pfIVec.push_back(ApproachA1);
    pfIVec.push_back(ApproachB1);
    pfIVec.push_back(ApproachA2);
    pfIVec.push_back(ApproachB2);
    pfIVec.push_back(ApproachA3);
    pfIVec.push_back(ApproachB3);
    pfIVec.push_back(ApproachA4);
    pfIVec.push_back(ApproachB4);
    vector<int> iVec;
    iVec.push_back(10);
    for(int i=0; i<n; ++i)
    {
       iVec.push_back(iVec[i]*5);
    }
    jtianling::CompareAlgorithmI(pfIVec, iVec);
}

//比较int x
void ApproachA1(int n)
{
    int x;
    for(int i=0; i<n; ++i)
    {
       x = i;
    }
}

void ApproachB1(int n)
{
    for(int i=0; i<n; ++i)
    {
       int x = i;
    }
}

//比较string
void ApproachA2(int n)
{
    string s;
    for(int i=0; i<n; ++i)
    {
       s = "good";
    }
}

void ApproachB2(int n)
{
    for(int i=0; i<n; ++i)
    {
       string s("good");
    }
}

//比较vector
void ApproachA3(int n)
{
    vector<int> vec(n);
    vector<int> vec2(n,1);
    for(int i=0; i<n; ++i)
    {
       vec[i] = vec2[i];
    }
}

void ApproachB3(int n)
{
    vector<int> vec2(n,1);     //抵消ApproachA3中的一次建构析构.
    for(int i=0; i<n; ++i)
    {
       vector<int> vec(1,i);
    }
}

void ApproachA4(int n)
{
    int *a = new int[n];
    int *b = new int[n];
    for(int i=0; i<n; ++i)
    {
       b[i] = i;
    }
    for(int i=0; i<n; ++i)
    {
       a[i] = b[i];
    }
    delete a;
    delete b;
}

void ApproachB4(int n)
{
    //以下过程抵消ApproachA4相关过程
    int *b = new int[n];
    for(int i=0; i<n; ++i)
    {
       b[i] = i;
    }
    for(int i=0; i<n; ++i)
    {
       int *a = new int();
       delete a;
    }
    delete b;
}
```

测试的一次结果如下：

| parameter |  ApproachA1 |  ApproachB1 |  ApproachA2 |  ApproachB2 |  ApproachA3 |  ApproachB3 |  ApproachA4 |  ApproachB4 |
|---|---|---|---|---|---|---|---|---|
| 10 |  1.60E-06 |  3.86E-07 |  1.51E-06 |  1.29E-06 |  2.77E-06 |  3.01E-06 |  9.12E-07 |  2.41E-06 |
| 50 |  3.66E-07 |  1.66E-06 |  3.57E-06 |  3.89E-06 |  2.49E-06 |  1.16E-05 |  8.42E-07 |  9.81E-06 |
| 250 |  3.71E-07 |  3.36E-07 |  1.43E-05 |  1.77E-05 |  3.68E-06 |  5.36E-05 |  1.25E-06 |  4.66E-05 |
| 1250 |  3.61E-07 |  3.31E-07 |  6.85E-05 |  8.82E-05 |  1.94E-05 |  2.68E-04 |  3.43E-06 |  2.29E-04 |
| 6250 |  3.56E-07 |  3.31E-07 |  3.38E-04 |  4.49E-04 |  8.39E-05 |  1.36E-03 |  3.32E-05 |  1.17E-03 |
| 31250 |  4.31E-07 |  3.46E-07 |  1.69E-03 |  2.18E-03 |  3.28E-04 |  6.74E-03 |  2.13E-04 |  5.90E-03 |
| 156250 |  4.31E-07 |  3.31E-07 |  8.44E-03 |  1.12E-02 |  1.72E-03 |  3.37E-02 |  1.03E-03 |  2.92E-02 |
| 781250 |  4.56E-07 |  3.31E-07 |  4.89E-02 |  5.54E-02 |  9.81E-03 |  1.74E-01 |  6.97E-03 |  1.47E-01 |
| 3906250 |  4.96E-07 |  3.41E-07 |  2.14E-01 |  2.76E-01 |  4.62E-02 |  8.41E-01 |  3.49E-02 |  7.39E-01 |
| Compared time in all: 2.7045e+000 |   |   |   |   |   |   |

可以看到，除了第一个int以外，其他的都是ApproachA要更快，而且我对ApproachB的情况还进行了一定程度的简化，也就是说，我在设定vector也好，new一个数组也好，都是仅仅创建了一个大小为1的，而在实际的应用中，直接vector<int> vec(n),new int[n]的情况也是非常多的，这么说，在相当保守的情况下，也可以把作者的话反过来说，也就是说，假如你真的不知道到底哪个实现更快的话，你应该默认使用ApproachA，实际上，当仅仅是简单类型的时候，你用ApproachB更好。完毕，假如有错误，请更正。
